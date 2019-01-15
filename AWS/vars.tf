# Webserver Port variable

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

variable "creds_file" {
  description = "The file with AWS access credentials"
  default     = ""
}

variable "cred_profile" {
  description = "The credentials profile to use"
  default     = "default"
}

variable "region" {
  description = "The AWS region to use"
  default     = "us-east-1"
}
