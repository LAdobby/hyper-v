# Stop the script immediately if an error occurs
set -e

echo "--- Setting up Docker official repository ---"

# 1. Install required packages
echo "[1/4] Installing required packages..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# 2. Add Docker GPG key
echo "[2/4] Adding Docker's GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 3. Set up Docker repository
echo "[3/4] Adding Docker repository to Apt sources list..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "--- Starting Docker Engine installation ---"

# 4. Install Docker packages
echo "[4/4] Installing Docker Engine related packages..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker devdobby

echo "--- Installation Verification ---"

# 5. Run hello-world image
echo "Running hello-world container to verify Docker installation..."
sudo docker run hello-world

echo ""
echo "✅ Docker installation and verification completed successfully."
echo "You can now run Docker commands without 'sudo'."

