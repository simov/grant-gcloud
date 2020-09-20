
variable "grant" {}
variable "callback" {}
variable "lambda" {}
variable "account" {}
variable "region" {}
variable "project" {}
variable "bucket" {}
variable "example" {}
variable "firebase_path" {}
variable "firebase_auth" {}

# -----------------------------------------------------------------------------

locals {
  callback = (
    var.example == "transport-querystring" ||
    var.example == "transport-session"
  ) ? 1 : 0
}
