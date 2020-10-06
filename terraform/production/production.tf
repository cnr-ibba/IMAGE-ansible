
# create subdomains for wp5image.eu domain
module "wp5image_domains" {
  source  = "../modules/domains"
  DOMAIN  = data.digitalocean_domain.wp5image.name
  ADDRESS = var.IP_ADDRESS
  SUBDOMAINS = var.SUBDOMAINS
}

# create subdomains for image2020genebank.eu domain
module "image2020genebank_domains" {
  source  = "../modules/domains"
  DOMAIN  = data.digitalocean_domain.image2020genebank.name
  ADDRESS = var.IP_ADDRESS
  SUBDOMAINS = var.SUBDOMAINS
}
