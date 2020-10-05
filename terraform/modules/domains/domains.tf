
variable "DOMAIN" {
  type = string
}

variable "ADDRESS" {
  type = string
}

resource "digitalocean_record" "wp5image" {
  # Get the domain from our data source
  domain = var.DOMAIN

  # An A record is an IPv4 name record. Like www.digitalocean.com
  type   = "A"

  # Set the name to login-name-region
  name   = "test"

  # Point the record at the IP address of our login droplet
  value  = var.ADDRESS

  # The Time-to-Live for this record is 30 seconds. Then the cache invalidates
  ttl    = 300
}
