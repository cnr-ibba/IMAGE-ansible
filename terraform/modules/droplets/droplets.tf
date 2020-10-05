
variable "IMAGE" {
  type = string
  default = "ubuntu-18-04-x64"
}

variable "ENV" {
  type = string
}

variable "REGION" {
  type = string
  default = "fra1"
}

variable "SIZE" {
  type = string
}

variable "SSH_KEYS" {
  type = list
}

# Create a new Web Droplet. Using variables and conditional to determine image name
resource "digitalocean_droplet" "wp5image" {
  image  = var.IMAGE
  name   = var.ENV == "production" ? "wp5image" : "wp5image-test"
  region = var.REGION
  size   = var.SIZE

  # The ssh keys to put on the server so we can access it. Read in through a
  # data source
  ssh_keys = var.SSH_KEYS
}

output "wp5image_address" {
  value       = digitalocean_droplet.wp5image.ipv4_address
  description = "The private IP address of the main server instance."
}

output "wp5image_id" {
  value       = digitalocean_droplet.wp5image.id
  description = "The ID the main server instance."
}
