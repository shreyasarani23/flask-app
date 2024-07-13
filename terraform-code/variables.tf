variable "project_id" {
  type        = string
  description = "Google Cloud project name"
  default     = "test-project"
}

variable "region" {
  type        = string
  description = "Default Google Cloud region"
  default     = "asia-south1"
}

variable "environment" {
  type        = string
  description = "Environment Name"
  default     = "test"
}

variable "zone" {
  type        = string
  description = "Default Google Cloud Zone"
  default     = "asia-south1-a"
}
variable "zonea" {
  type        = string
  description = "Default Google Cloud Zone"
  default     = "asia-south1-a"
}

variable "zoneb" {
  type        = string
  description = "Default Google Cloud Zone"
  default     = "asia-south1-b"
}

variable "zonec" {
  type        = string
  description = "Default Google Cloud Zone"
  default     = "asia-south1-c"
}