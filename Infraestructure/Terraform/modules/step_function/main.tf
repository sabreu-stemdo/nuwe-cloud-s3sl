resource "aws_iam_role" "step_function_role" {
  name = "${var.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "states.${var.region}.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "step_function_policy" {
  name   = "${var.name}-policy"
  role   = aws_iam_role.step_function_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "lambda:InvokeFunction"
        Resource = var.lambda_arns
      }
    ]
  })
}

resource "aws_sfn_state_machine" "step_function" {
  name     = var.name
  role_arn = aws_iam_role.step_function_role.arn
  definition = var.state_machine_definition
}
