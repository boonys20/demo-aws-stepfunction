output "step-function-main-workflow" {
  value = aws_sfn_state_machine.main-workflow.name
}