terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
  required_version = ">= 0.13"
}


# Droplet
variable "droplet_name" {
  type = string
}
variable "ssh_keys" {
  type = list(number)
  default = []
}
variable "image" {
  default = "docker-20-04"
  type = string
}
variable "region" {
  default = "fra1"
  type = string
}
variable "size" {
  default = "s-1vcpu-2gb"
  type = string
}
variable "user_data" {
  default = null
  type = string
}
variable "tags" {
  default = []
  type = list(string)
}
variable "vpc_uuid" {
  default = null
}

# Record
variable "zone_id" {}
variable "record_name" {
  type = string
}

resource "digitalocean_droplet" "main" {
  image     = var.image
  name      = var.droplet_name
  region    = var.region
  size      = var.size
  ssh_keys  = var.ssh_keys
  user_data = var.user_data
  tags      = var.tags
  vpc_uuid  = var.vpc_uuid
}

resource "cloudflare_record" "main" {
  zone_id = var.zone_id
  name    = var.record_name
  value   = digitalocean_droplet.main.ipv4_address
  type    = "A"
  proxied = false
}

output "droplet" {
  value = digitalocean_droplet.main
}

output "record" {
  value = cloudflare_record.main
}
