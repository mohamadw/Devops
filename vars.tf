variable "accessKey" {
  type        = string
  description = "plz The access key of your aws user."
}

variable "secretKey" {

  type        = string
  description = "plz The secret key of your aws user"
}

variable "instance_count" {
  default = "2"
}

variable "instance_tags" {
  type = list
  default = ["webserver-1", "webserver-2"]
}

variable "instance_type" {
  default = "t2.micro"
}

# variable "image_id" {
#   type        = string
#   description = "The id of the machine image (AMI) to use for the server."

#   validation {
#     condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
#     error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
#   }
# }

variable "region" {
  default = "eu-west-1"
}