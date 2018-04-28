# Terraform - DigitalOcean Docker Remote API firewall rule set

Terraform module to configure a set of firewall rules on DigitalOcean for limiting access to an exposed Docker Remote API. It creates inbound rules and outbound rules.

[![CircleCI](https://circleci.com/gh/thojkooi/terraform-digitalocean-firewall-docker-api/tree/master.svg?style=svg)](https://circleci.com/gh/thojkooi/terraform-digitalocean-firewall-rules-docker-api/tree/master)

- [Requirements](#requirements)
- [Usage](#usage)
- [Firewall rules](#firewall-rules)

---

## Requirements

- Terraform >= v0.11.7
- Digitalocean account / API token with write access

## Usage

Basic usage example:

```hcl

provider "digitalocean" {
}

resource "digitalocean_tag" "docker_api" {
    name = "Docker Remote API"
}

resource "digitalocean_tag" "access_docker_api" {
    name = "Access to docker Remote API"
}

module "default-firewall" {
    source  = "thojkooi/firewall-docker-api/digitalocean"
    version = "0.1.0"
    prefix  = "dev"

    # Droplets exposing the Docker Remote API
    tags    = ["${digitalocean_tag.docker_api.id}"]

    # Droplets allowed to access the exposed Docker Remote API
    api_access_tags = ["${digitalocean_tag.access_docker_api.id}"]

    # Limit access from all addresses to the docker remote api
    api_access_from_adresses = []

    # Specific droplets that can access the api
    api_access_droplet_ids = []

    # load balancer uids that may access the api port
    api_access_load_balancer_uids = []
}
```

## Firewall rules

Inbound firewall rules:

Port       | Description                       | Source | Applied to
---------- | --------------------------------- | ------- | ------------
`2376/TCP` | Inbound traffic | `api_access_tags`, `api_access_droplet_ids`, `api_access_from_adresses`, `api_access_load_balancer_uids` | `droplet_ids`, `tags`

Outbound firewall rules:

Port       | Description                       | Destination | Applied to
---------- | --------------------------------- | ------- | ------------
`2376/TCP` | Outbound traffic | `droplet_ids`, `tags` | `api_access_tags`, `api_access_droplet_ids`

> The outbound rule is only created if either `api_access_tags` or `api_access_droplet_ids` is set to a non-empty value.

## Variables

Variable | Default | Description
-------- | ------- | -----------
prefix   |       | Prefix applied to firewall rule names (Required)
droplet_ids | `[]` | List of droplet ids to which the inbound rule sets will be applied
tags | `[]` | List of tag ids, any droplet matching these tags will have the inbound rule set applied
remote_api_port | `2376` | TCP port on which the Docker Remote API may be reached
api_access_tags | `[]` | List of droplet tags from which Docker Remote API access is allowed
api_access_droplet_ids | `[]` | List of droplet ids from which Docker Remote API access is allowed
api_access_from_adresses | `["0.0.0.0/0", "::/0"]` | An array of strings containing the IPv4 addresses, IPv6 addresses, IPv4 CIDRs, and/or IPv6 CIDRs from which Docker Remote API access is allowed
api_access_load_balancer_uids | `[]` | An array containing the IDs of the Load Balancers from which Docker Remote API access is allowed
