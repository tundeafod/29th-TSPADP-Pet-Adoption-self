locals {
    nexus_user_data = <<-EOF
#!/bin/bash
sudo apt update -y
sudo apt install wget -y
sudo apt update && sudo apt install openjdk-8-jre-headless -y
cd /opt
sudo wget https://download.sonatype.com/nexus/3/nexus-3.65.0-02-unix.tar.gz
sudo tar -xvf nexus-3.65.0-02-unix.tar.gz
sudo mv nexus-3.65.0-02 nexus
sudo adduser nexus
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work
sudo cat <<EOT> /opt/nexus/bin/nexus.rc
run_as_user="nexus"
EOT
sed -i '2s/-Xms2703m/-Xms512m/' /opt/nexus/bin/nexus.vmoptions
sed -i '3s/-Xmx2703m/-Xmx512m/' /opt/nexus/bin/nexus.vmoptions
sed -i '4s/-XX:MaxDirectMemorySize=2703m/-XX:MaxDirectMemorySize=512m/' /opt/nexus/bin/nexus.vmoptions
sudo touch /etc/systemd/system/nexus.service
sudo cat <<EOT> /etc/systemd/system/nexus.service
[Unit]
Description=nexus service
After=network.target
[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOT
sudo chkconfig nexus on
sudo systemctl enable nexus
sudo systemctl stop nexus
sudo systemctl start nexus 
# curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY="${var.nr-key}" NEW_RELIC_ACCOUNT_ID="${var.nr-acc-id}" NEW_RELIC_REGION="${var.nr-region}" /usr/local/bin/newrelic install -y
sudo hostnamectl set-hostname Nexus
EOF
}