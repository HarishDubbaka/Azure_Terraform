nsg_rules = {
  http = {
    priority               = 100
    destination_port_range = "80"
    description            = "Allow HTTP"
  }

  ssh = {
    priority               = 110
    destination_port_range = "22"
    description            = "Allow SSH"
  }
}
