
module "droplets" {
  source = "../modules/droplets"
  ENV    = var.ENV
  SIZE   = var.SIZE
  SSH_KEYS = [
    data.digitalocean_ssh_key.stretch.id,
    data.digitalocean_ssh_key.desktop.id,
    data.digitalocean_ssh_key.debian.id,
  ]
}

module "firewalls" {
  source      = "../modules/firewalls"
  ENV         = var.ENV
  DROPLET_IDS = [module.droplets.wp5image_id]
}

module "domains" {
  source  = "../modules/domains"
  DOMAIN  = data.digitalocean_domain.domain.name
  ADDRESS = module.droplets.wp5image_address
  SUBDOMAINS = var.SUBDOMAINS
}

# retrieves output from a inner module
output "droplet_address" {
  value       = module.droplets.wp5image_address
  description = "get droplet ip address"
}
