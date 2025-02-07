# Install required dependencies

# Update package list
apt-get update

# Install required packages
apt-get install -y curl

# Install k3s
SERVER_URL="https://$1:6443"
NETINT="enp0s8"
HOSTNAME="$(hostname)"
TOKEN_FILE="/home/vagrant/shared/token"

if [ ! -f /etc/rancher/k3s/k3s.yaml ]; then
	if [[ "$HOSTNAME" == "rsabbahS" ]]; then
		curl -sfL https://get.k3s.io | sh -s - server \
			--node-ip $1 \
			--flannel-iface "$NETINT" 
		cp /var/lib/rancher/k3s/server/node-token "$TOKEN_FILE"
	else
		while [ ! -f "$TOKEN_FILE" ]; do
			sleep 2
		done
		curl -sfL https://get.k3s.io | sh -s - agent \
			--server "$SERVER_URL" \
			--token-file "$TOKEN_FILE" \
			--flannel-iface "$NETINT"
	fi
fi
