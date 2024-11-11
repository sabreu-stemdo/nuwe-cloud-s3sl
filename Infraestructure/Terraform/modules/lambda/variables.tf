variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "handler" {
  description = "The function entrypoint in your code"
  type        = string
}

variable "runtime" {
  description = "The runtime environment for the Lambda function"
  type        = string
  default     = "python3.10"
}

variable "filename" {
  description = "The path to the deployment package zip file"
  type        = string
}

variable "environment_variables" {
  description = "Key-value map of environment variables"
  type        = map(string)
  default     = {}
}


variable "s3_bucket_arns" {
  description = "Lista de ARNs de buckets a los que la Lambda necesita acceso"
  type        = list(string)
}

variable "s3_permissions" {
  description = "Acciones permitidas en los buckets S3"
  type        = list(string)
  default     = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
}