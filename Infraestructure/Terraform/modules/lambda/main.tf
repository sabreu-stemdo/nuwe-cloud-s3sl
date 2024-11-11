resource "aws_iam_role" "lambda_exec_role" {
  name_prefix  = "${var.function_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_s3_access" {
  name_prefix = "${var.function_name}-s3-access-policy"
  role        = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for bucket_arn in var.s3_bucket_arns : {
        Effect = "Allow"
        Action = var.s3_permissions
        Resource = [
          bucket_arn,
          "${bucket_arn}/*"
        ]
      }
    ]
  })
}


resource "aws_lambda_function" "lambda" {
  filename      = var.filename
  function_name = var.function_name
  role         = aws_iam_role.lambda_exec_role.arn
  handler       = var.handler
  runtime       = var.runtime

}

