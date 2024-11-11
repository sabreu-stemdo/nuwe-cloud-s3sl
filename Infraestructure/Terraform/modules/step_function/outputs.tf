output "step_function_arn" {
  description = "ARN of the Step Function"
  value       = aws_sfn_state_machine.step_function.arn
}
