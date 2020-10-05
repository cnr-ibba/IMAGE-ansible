
variable "ENV" {
  type = string
}

variable "DROPLET_IDS" {
  type = list
}

resource "digitalocean_firewall" "wp5image" {
  # Human friendly name of the firewall
  name = "${var.ENV}-wp5image"

  # Droplets to apply the firewall to
  droplet_ids = var.DROPLET_IDS

  #--------------------------------------------------------------------------#
  # Rules to allow only ssh both inbound from the public internet and only   #
  # allow outbout ssh traffic into the VPC network. Also allow ping just for #
  # ease of use inside the VPC as well.                                      #
  #--------------------------------------------------------------------------#
  inbound_rule {
    protocol = "tcp"
    port_range = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol = "tcp"
    port_range = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol = "tcp"
    port_range = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "tcp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "udp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

}
