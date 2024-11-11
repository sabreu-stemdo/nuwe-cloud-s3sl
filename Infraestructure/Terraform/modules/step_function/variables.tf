variable "name" {
  description = "Name of the Step Function"
  type        = string
}

variable "lambda_arns" {
  description = "List of ARNs for the Lambda functions to be executed in the Step Function"
  type        = list(string)
}

variable "state_machine_definition" {
  description = "Definition of the Step Function in JSON format"
  type        = string
}

variable "region" {
  description = "Region for the Step Function"
  type        = string
  default     = "us-east-1"
}