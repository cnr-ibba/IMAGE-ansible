
variable "DOMAIN" {
  type = string
}

variable "ADDRESS" {
  type = string
}

variable "SUBDOMAINS" {
  type = list(string)
  default = ["test", "injecttest", "apitest"]
}

resource "digitalocean_record" "wp5image" {
  # Get the domain from our data source
  domain = var.DOMAIN

  # An A record is an IPv4 name record. Like www.digitalocean.com
  type   = "A"

  # Note the use of toset to convert the var.SUBDOMAINS list into a set,
  # as for_each only supports sets and maps when used on a resource.
  for_each = toset(var.SUBDOMAINS)

  # Set the name for the subdomain
  name   = each.value

  # Point the record at the IP address of our login droplet
  value  = var.ADDRESS

  # The Time-to-Live for this record is 30 seconds. Then the cache invalidates
  ttl    = 300
}
