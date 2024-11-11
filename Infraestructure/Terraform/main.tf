provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  s3_use_path_style           = false
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4566"
    apigatewayv2   = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    events         = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://s3.localhost.localstack.cloud:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}


module "input-bucket" {
  source = "./modules/bucket"
  bucket_name = "input-bucket"
}

module "output-bucket" {
  source = "./modules/bucket"
  bucket_name = "output-bucket"
}

module "ProcessCSVFunction" {
  source = "./modules/lambda"
  function_name = "ProcessCSVFunction"
  handler       = "ProcessCSVFunction.transform_negative_values_to_zero"
  runtime       = "python3.10"
  filename      = "../lambda/ProcessCSVFunction/ProcessCSVFunction.zip"
    s3_bucket_arns = [
    module.input-bucket.bucket_arn
  ]
}

module "AddColumnFunction" {
  source = "./modules/lambda"
  function_name = "AddColumnFunction"
  handler       = "AddColumnFunction.add_age_group_column"
  runtime       = "python3.10"
  filename      = "../lambda/AddColumnFunction/AddColumnFunction.zip"
    s3_bucket_arns = [
    module.input-bucket.bucket_arn
  ]
}

module "SaveToS3Function" {
  source = "./modules/lambda"
  function_name = "SaveToS3Function"
  handler       = "SaveToS3Function.copy_file_between_buckets"
  runtime       = "python3.10"
  filename      = "../lambda/SaveToS3Function/SaveToS3Function.zip"
    s3_bucket_arns = [
    module.input-bucket.bucket_arn,
    module.output-bucket.bucket_arn,
  ]
}

module "step_function" {
  source = "./modules/step_function"
  name    = "CSVProcessingWorkflow"
  region  = "us-east-1"


  lambda_arns = [
    module.ProcessCSVFunction.lambda_arn,
    module.AddColumnFunction.lambda_arn,
    module.SaveToS3Function.lambda_arn,
  ]

  state_machine_definition = jsonencode({
    Comment: "Flujo de Lambdas para procesar CSV",
    StartAt: "ProcessCSV",
    States: {
      ProcessCSV: {
        Type: "Task",
        Resource: module.ProcessCSVFunction.lambda_arn,
        Next: "AddColumn",
      },
      AddColumn: {
        Type: "Task",
        Resource: module.AddColumnFunction.lambda_arn,
        Next: "SaveToS3",
      },
      SaveToS3: {
        Type: "Task",
        Resource: module.SaveToS3Function.lambda_arn,
        End: true
      }
   
    }
  })
}


