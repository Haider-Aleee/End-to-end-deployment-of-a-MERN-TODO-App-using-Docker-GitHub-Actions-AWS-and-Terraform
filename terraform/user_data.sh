#!/bin/bash
set -e

# Update system
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg

# Install Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker ubuntu

# Wait for IAM instance profile to be attached
sleep 10

# Login to ECR
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Create directory for docker-compose
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app

# Create docker-compose file (will be populated by deployment script or can use template)
# For now, create a simple one that pulls from ECR
cat > docker-compose.yml << 'EOF'
version: "3.9"

services:
  server:
    image: ${ECR_SERVER_IMAGE}
    environment: 
      - MONGODB_ATLAS_CONNECTION=${MONGODB_ATLAS_CONNECTION}
      - PORT=8000
    ports:
      - "8000:8000"
    restart: unless-stopped

  client:
    image: ${ECR_CLIENT_IMAGE}
    ports:
      - "3000:3000"
    restart: unless-stopped
    depends_on:
      - server
EOF

# Create deployment script
cat > deploy.sh << 'DEPLOYEOF'
#!/bin/bash
set -e

REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Login to ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Pull latest images
docker compose pull

# Stop and remove old containers
docker compose down || true

# Start containers
docker compose up -d

# Clean up old images
docker image prune -af --filter "until=24h"
DEPLOYEOF

chmod +x /home/ubuntu/app/deploy.sh

# Note: Actual deployment will be triggered by CI/CD pipeline or manually
# The deploy.sh script expects ECR_SERVER_IMAGE and ECR_CLIENT_IMAGE env vars to be set