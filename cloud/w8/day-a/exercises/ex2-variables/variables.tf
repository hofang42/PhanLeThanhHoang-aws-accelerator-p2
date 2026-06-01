# ========================================
# DEFAULT VALUES FOR VARIABLES
# ========================================

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}
