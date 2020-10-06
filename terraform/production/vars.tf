
variable "DO_TOKEN" {}

variable "ENV" {
  type    = string
  default = "production"
}

variable "SUBDOMAINS" {
  type = list(string)
  default = ["test", "injecttest", "apitest"]
}

variable "IP_ADDRESS" {
  type = string
}
