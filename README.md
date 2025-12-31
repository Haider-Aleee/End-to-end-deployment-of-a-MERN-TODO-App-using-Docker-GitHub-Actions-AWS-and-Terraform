# ❤️ MERN Stack Todo App 📋

A simple yet powerful full-stack todo application built with the MERN stack. Organize your tasks efficiently with a clean and responsive user interface.


## 🚀 About the Project

This is a full-stack Todo application that allows users to create, read, update, and delete (CRUD) tasks. It's built with the MERN stack (MongoDB, Express.js, React.js, Node.js) to provide a seamless and fast user experience.

## 🛠️ Tech Stack

**Client (Frontend):**

- **React.js**: A JavaScript library for building the user interface.
- **HTML, CSS**: For structuring and styling the application.
- **TailwindCSS**: A utility-first CSS framework for rapid UI development.

**Server (Backend):**

- **Node.js**: A JavaScript runtime environment.
- **Express.js**: A web application framework for building the RESTful API.
- **Mongoose**: An object data modeling (ODM) library for MongoDB.

**Database:**

- **MongoDB**: A NoSQL database for storing todos.

## 🌱 Project Structure

The repository is organized into two main folders to separate the frontend and backend concerns.

```bash
/MERN-Todo

├── client/                      # Frontend React application
│   ├── public/
│   ├── src/                     # Source code
│   │   └── App.jsx
│   ├── .env                     # Environment variables
│   ├── index.css                # Global styles
│   ├── index.html               # HTML entry point
│   └── index.jsx                # React entry point
│
└── server/                      # Backend Node.js and Express.js application
│   ├── controllers/             # Request handling logic
│   ├── models/                  # Mongoose schemas
│   ├── node_modules/
│   ├── routes/                  # API route definitions
│   ├── .env                     # Environment variables
│   └── index.js                 # Server entry point
│
└── README.md                    # Project documentation
```

## 🎻 Prerequisites

Before getting started with the Practicing Projects, you should have a basic understanding of `MongoDB, Express.js, React.js, Node.js, HTML, CSS, TailwindCSS and JavaScript.`

## 🔥 Getting Started

### Prerequisites

- Node.js (v18 or higher)
- MongoDB Atlas account (or local MongoDB)
- Docker and Docker Compose (for containerized deployment)
- AWS Account (for production deployment)

### Clone this Repository

```bash
git clone https://github.com/chetannada/MERN-Todo.git
cd MERN-Todo
```

## 🚀 Running Locally

### Option 1: Run with npm (Development)

1. **Install dependencies:**

```bash
# Install server dependencies
cd server
npm install

# Install client dependencies
cd ../client
npm install
```

2. **Set up environment variables:**

Create `.env` files:

**server/.env:**
```env
MONGODB_ATLAS_CONNECTION=your_mongodb_connection_string
PORT=8000
```

**client/.env:**
```env
VITE_API_BASE_URL=http://localhost:8000/api
```

3. **Run the application:**

```bash
# Terminal 1 - Start server (from server directory)
cd server
npm run start

# Terminal 2 - Start client (from client directory)
cd client
npm run dev
```

- Client: `http://localhost:3000`
- Server: `http://localhost:8000`

### Option 2: Run with Docker Compose

1. **Set up environment variables:**

Create a `.env` file in the root directory:

```env
MONGODB_ATLAS_CONNECTION=your_mongodb_connection_string
PORT=8000
VITE_API_BASE_URL=http://localhost:8000/api
```

2. **Run with Docker Compose:**

```bash
docker compose up --build
```

This will start:
- Server on `http://localhost:8000`
- Client on `http://localhost:3000`
- MongoDB (optional, if not using Atlas) on `localhost:27017`

To stop:
```bash
docker compose down
```

## ☁️ Production Deployment on AWS EC2

### Prerequisites

- AWS CLI configured
- Terraform installed
- EC2 key pair created in AWS

### Step 1: Set up Terraform

1. **Update terraform variables:**

Edit `terraform/terraform.tfvars`:

```hcl
region         = "us-east-2"
vpc_cidr_block = "10.0.0.0/16"
my_ip          = "YOUR_IP_ADDRESS"
instance_type  = "t3.micro"
key_pair_public_key_path = "./your-key.pub"
key_pair_name  = "todo-instance-key-pair"
```

2. **Use the automation script (recommended):**

We provide a simple bash script to manage Terraform commands:

```bash
cd terraform
./terraform.sh init      # or ./terraform.sh i
./terraform.sh plan      # or ./terraform.sh p
./terraform.sh apply     # or ./terraform.sh a
./terraform.sh output    # or ./terraform.sh o
```

**Available commands:**
- `init` (or `i`) - Initialize Terraform
- `plan` (or `p`) - Create execution plan
- `apply` (or `a`) - Apply changes
- `destroy` (or `d`) - Destroy infrastructure
- `output` (or `o`) - Show outputs
- `validate` (or `v`) - Validate configuration
- `fmt` (or `f`) - Format code
- `refresh` (or `r`) - Refresh state

**Or use Terraform directly:**

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

3. **Get the EC2 public IP:**

```bash
./terraform.sh output
# or
terraform output todo_server_ip
```

### Step 2: Configure GitHub Secrets

Add these secrets to your GitHub repository (Settings → Secrets):

- `AWS_ACCESS_KEY_ID`: Your AWS access key
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret key
- `EC2_SSH_PRIVATE_KEY`: Your EC2 private key (content of `.pem` file)
- `EC2_INSTANCE_IP`: EC2 public IP (optional, workflow can get from Terraform)
- `MONGODB_ATLAS_CONNECTION`: MongoDB connection string
- `VITE_API_BASE_URL`: API URL for client (e.g., `http://EC2_IP:8000/api`)

### Step 3: Deploy via GitHub Actions

The CI/CD pipeline will:

1. Run tests on push to main/master branch
2. Build Docker images
3. Push images to Amazon ECR
4. Deploy to EC2 instance

**Manual trigger:** Go to Actions tab → "CI/CD Pipeline" → "Run workflow"

### Step 4: Access the Application

After deployment, access the app at:

- **Client:** `http://<EC2_PUBLIC_IP>:3000`
- **Server API:** `http://<EC2_PUBLIC_IP>:8000`

Get the IP address:
```bash
cd terraform
terraform output todo_server_ip
```

## 🧪 Running Tests

Run unit tests for the server:

```bash
cd server
npm test
```

Run tests in watch mode:

```bash
npm run test:watch
```

## 📝 Environment Variables Reference

### Server

| Variable | Description | Default |
|----------|-------------|---------|
| `MONGODB_ATLAS_CONNECTION` | MongoDB connection string | Required |
| `PORT` | Server port | 8000 |

### Client

| Variable | Description | Default |
|----------|-------------|---------|
| `VITE_API_BASE_URL` | Backend API base URL | `http://localhost:8000/api` |

## 🏗️ Infrastructure

The infrastructure is managed with Terraform and includes:

- VPC with public subnets
- EC2 instance with IAM role for ECR access
- ECR repositories for client and server images
- Security groups for HTTP/HTTPS and SSH access

To destroy infrastructure:

```bash
cd terraform
./terraform.sh destroy    # or ./terraform.sh d
# or
terraform destroy
```

## ✏️ Contributing

This is an Open-Source repository, and contributions are always welcome! If you find an issue, please create a new issue under the "Issues" section. To contribute code, fork the repository and submit a pull request. Your contributions will help make this a valuable resource for the community!