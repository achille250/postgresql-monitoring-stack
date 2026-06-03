1. Add the Grafana repository:
sudo nano /etc/yum.repos.d/grafana.repo

Add the following content to the file:
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key

2. Install Grafana:
sudo yum install grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

if you have a firewall enabled
sudo firewall-cmd --permanent --zone=public --add-port=3000/tcp
sudo firewall-cmd --reload


3. Access Grafana:
http://your_server_ip:3000
Username: admin
Password: admin

To check the version
 grafana-server -v