locals {
    nexus_user_data = <<-EOF
#!/bin/bash

sudo hostnamectl set-hostname Nexus
EOF
}