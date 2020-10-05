
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

# retrieves output from a inner module
output "droplet_address" {
  value       = module.droplets.wp5image_address
  description = "get droplet ip address"
}
