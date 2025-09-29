if [ -z "$SUDO_USER" ]; then
    echo "error: This script must be run with sudo (e.g., 'sudo ./script_name.sh')."
    exit 1
fi

sudo apt install openssh-server

echo "Ubuntu Server Setup with XFCE..."

read -p "New SSH port (ex: 2222): " NEW_SSH_PORT
read -p "New Remote Desktop (xrdp) port (ex: 33890): " NEW_XRDP_PORT

if [[ -z "$NEW_SSH_PORT" || -z "$NEW_XRDP_PORT" ]]; then
    echo "Error: Port numbers must be provided."
    exit 1
fi

echo "Installing XFCE desktop environment and xrdp..."
sudo apt update
sudo apt install -y xfce4 xfce4-goodies xrdp

# Create .xsession file in the home directory of the user who ran this script
echo "xfce4-session" | sudo tee /home/$SUDO_USER/.xsession

echo "Changing SSH port to $NEW_SSH_PORT..."
# Handle both commented and uncommented 'Port 22' lines
sudo sed -i -E "s/^#?Port 22/Port $NEW_SSH_PORT/" /etc/ssh/sshd_config
sudo systemctl restart ssh

echo "Changing xrdp port to $NEW_XRDP_PORT..."
sudo sed -i "s/port=3389/port=$NEW_XRDP_PORT/" /etc/xrdp/xrdp.ini
sudo adduser xrdp ssl-cert
sudo systemctl restart xrdp

echo "Setting up firewall rules..."
sudo ufw allow $NEW_SSH_PORT/tcp
sudo ufw allow $NEW_XRDP_PORT/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable 

echo "All settings have been completed!"
echo "-----------------------------------------"
echo "SSH access: ssh $SUDO_USER@your_server_ip -p $NEW_SSH_PORT"
echo "Remote Desktop access: your_server_ip:$NEW_XRDP_PORT"
echo "It is recommended to reboot the server to apply all changes reliably."
