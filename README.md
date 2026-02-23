### Production-Grade Deployment of MEMOS on AWS ECS Fargate ###
<!-- Project badges -->
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-blue)
![Terraform](https://img.shields.io/badge/IaC-Terraform-purple)
![Docker](https://img.shields.io/badge/Container-Docker-blue)
![AWS ECS](https://img.shields.io/badge/AWS-ECS-orange)

## Overview
This project delivers a production-grade, end-to-end deployment of a privacy-focused memo application on Amazon Web Services using Amazon ECS Fargate. It utilises Docker for containerisation, Terraform for infrastructure as code, and GitHub Actions to automate both infrastructure provisioning and application delivery.
The solution is designed to be secure, scalable, and production-ready, incorporating HTTPS encryption, persistent storage, and a fully automated CI/CD pipeline to ensure consistent and repeatable deployments.

## Table of Contents
- Overview
- Architecture
- Repository Structure
- Reproduction Steps
- Build and Push Docker Image
- AWS (Clickops)
- Infrastructure (Terraform)
- CI/CD Pipelines
- Challenges & Lessons Learned

## Architecture

<img src="images/architecture-diagram.png">

Key Components: 
- Production-ready deployment of the Memos application on AWS
- Multi-AZ architecture for high availability and resilience
- HTTPS by default using ACM-managed certificates
- Application Load Balancer routing traffic to ECS Fargate tasks
- Private subnets with NAT gateways for secure outbound traffic
- Persistent data storage through Amazon EFS
- Automated CI/CD pipelines handling image builds and infrastructure updates
- Fully modular Terraform code, easy to extend and reuse
- Domain and DNS management through Route 53

## 📁 Repository Structure

```bash
.
├── .github/
│   └── workflows/
│       ├── docker-build.yml
│       ├── tf-apply.yml
│       └── tf-destroy.yml
│
├── app/
│   └── Dockerfile
│
├── images/
│
├── terraform/
│   ├── modules/
│   │   ├── acm
│   │   ├── alb
│   │   ├── ecr
│   │   ├── ecs
│   │   ├── efs
│   │   ├── route53
│   │   ├── sg
│   │   └── vpc
│   │
│   ├── backend.tf
│   ├── locals.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars
│   └── variables.tf
│
├── .gitignore
└── README.md

```

##  Reproduction Steps 

# Prerequisites
- AWS Account + CLI configured
- Terraform >= 1.6.0
- Docker Desktop
- GitHub account
- Registered Domain

#  Application and Local Validation

**1. Clone the repository:**
```bash
git clone https://github.com/LibaanEsse/memos.git
cd Memos
```
**2. Build the Docker image:**
**Note: Docker Desktop must be running and you must be logged in**
```bash
docker build -t memos-app:local -f docker/Dockerfile .
```

**3. Run the container:**
```bash
docker run -d -p 5230:5230 --name memos memos-app:local
```

**4. Access the application:**
```bash
http://localhost:5230 
```
##  Build and Push Docker Image
``` bash
aws ecr get-login-password --region eu-west-2 \
  | docker login --username AWS --password-stdin <ECR_REPO_URL>

docker build -t memos .
docker tag memos:latest <ECR_REPO_URL>:latest
docker push <ECR_REPO_URL>:latest
```
## AWS (Clickops)
- Created ECR repository and pushed initial image
- Built infrastructure manually in AWS Console to understand services
- Deployed VPC, subnets, security groups, ALB, ECS cluster
- Configured ACM certificate and Route 53 DNS records
- Tested full flow end-to-end

All manual AWS configuration has been removed to ensure the environment is fully reproducible through Terraform.

##  Infrastructure (Terraform)
 created the the setup using modular Terraform.
From the terraform/ directory:
```
terraform init
terraform plan
terraform apply
```
---

- Verified infrastructure using the ALB DNS with HTTPS endpoint:
```bash
curl <ALB DNS>
curl https://<DOMAIN>
curl https://<DOMAIN>/health
```





