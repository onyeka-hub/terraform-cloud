variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "account_no" {
  type = number
}

variable "efs-subnet-1" {
  
}

variable "efs-subnet-2" {
  
}

variable "efs-sg" {
  
}