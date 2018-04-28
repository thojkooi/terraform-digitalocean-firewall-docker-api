resource "digitalocean_firewall" "inbound-docker-remote-api-access" {
  name        = "${var.prefix}-inbound-docker-remote-api-access-fw"
  droplet_ids = ["${var.droplet_ids}"]
  tags        = ["${var.tags}"]

  inbound_rule = [
    {
      protocol                  = "tcp"
      port_range                = "${var.remote_api_port}"
      source_tags               = ["${var.api_access_tags}"]
      source_droplet_ids        = ["${var.api_access_droplet_ids}"]
      source_addresses          = ["${var.api_access_from_adresses}"]
      source_load_balancer_uids = ["${var.api_access_load_balancer_uids}"]
    },
  ]
}

# Create the outbound rule to allow droplets that have inbound access
#  to sent outboud traffic to the droplets exposing the API.
resource "digitalocean_firewall" "outbound-docker-remote-api-access" {
  name        = "${var.prefix}-outbound-docker-remote-api-access-fw"
  droplet_ids = ["${var.api_access_droplet_ids}"]
  tags        = ["${var.api_access_tags}"]

  outbound_rule = [
    {
      protocol                = "tcp"
      port_range              = "${var.remote_api_port}"
      destination_tags        = ["${var.tags}"]
      destination_droplet_ids = ["${var.droplet_ids}"]

      # Include the api load balancers with this as well; this will allow for creating a load balancer
      #  in front of the Docker Remote API, and have it accessed by the droplets in `api_access_droplet_ids` and `api_access_tags`.
      #  Those droplets already have direct access as well
      #  destination_load_balancer_uids = ["${var.api_access_load_balancer_uids}"]
    },
  ]
}
