variable "sns_topic" {
  description = "name of sns topic"
  type        = string
  default     = ""
}

variable "environment_prefix" {
  description = "prefix of environment"
  type        = string
  default     = "poc-std-log"
}

variable "region" {
  description = "region of project"
  type        = string
  default     = "ap-southeast-1"
}

variable "api_key" {
  description = "api key of data dog"
  type        = string
}

variable "jar_file" {
  description = "source of lambda code"
  default     = "demo-aws-stepfunction-1.0.0-SNAPSHOT.jar"
}

variable "zip_file" {
  description = "source of lambda code"
  default     = "demo-aws-stepfunction-1.0.0-SNAPSHOT.zip"
}