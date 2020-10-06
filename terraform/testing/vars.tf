
variable "DO_TOKEN" {}

variable "ENV" {
  type    = string
  default = "testing"
}

variable "SIZE" {
  type    = string
  default = "s-1vcpu-1gb"
}

variable "DOMAIN_NAME" {
  type    = string
  default = "paolocozzi.cloud"
}

variable "SUBDOMAINS" {
  type = list(string)
  default = ["test", "injecttest", "apitest"]
}
