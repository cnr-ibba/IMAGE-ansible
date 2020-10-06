
data "digitalocean_ssh_key" "stretch" {
  name = "paolo@stretch-desktop"
}

data "digitalocean_ssh_key" "desktop" {
  name = "paolo@desktop"
}

data "digitalocean_ssh_key" "debian" {
  name = "paolo@debian"
}

data "digitalocean_domain" "domain" {
  name = var.DOMAIN_NAME
}
