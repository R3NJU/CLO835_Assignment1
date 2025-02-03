# **CLO835 Assignment1: Docker Container Deployment on AWS using Terraform and GitHub Actions**

## **Overview**
This repository contains the infrastructure and automation scripts for deploying a **Flask web application** with a **MySQL database** on **AWS EC2** using **Terraform, Docker, Amazon ECR, and GitHub Actions**. This project was completed as part of **CLO835: Portable Technologies in Cloud**, a course in the **Cloud Architecture & Administration (CAA) program**.

## **Deployment Instructions**

### **1. Infrastructure Deployment**
- Navigate to the repository and ensure the Terraform workflow is triggered when changes are merged into the `main` branch.
- The Terraform workflow provisions the following AWS resources:
  - **EC2 Instance** with IAM Role `LabInstanceProfile`.
  - **Security Group** allowing:
    - SSH access via AWS Console (EC2 Instance Connect).
    - TCP traffic on **ports 8081, 8082, and 8083** for the Flask application.
  - **Amazon ECR Repositories** for storing Docker images.
  - **S3 Bucket** to store the Terraform state file.

### **2. Connecting to the EC2 Instance**
- Navigate to the **AWS EC2 Console**.
- Select the deployed **EC2 instance**.
- Click **"Connect"**, then use **EC2 Instance Connect** (browser-based SSH).

### **3. Logging into Amazon ECR**
```bash
export ECR=<aws_account_id>.dkr.ecr.us-east-1.amazonaws.com
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR
```

### **4. Running the MySQL Container**
```bash
docker run --net my-nw --net-alias my_db --name my_db -d -e MYSQL_ROOT_PASSWORD=pw $ECR/clo835-assignment1-sql:v0.1
```

### **5. Running Flask WebApp Containers**
```bash
export DBHOST=10.0.0.2

docker run --net my-nw --net-alias blue_app --name blue_app -d -p 8081:8080 -e DBHOST=$DBHOST -e DBPORT=3306 -e DBUSER=root -e DBPWD=pw -e APP_COLOR="blue" $ECR/clo835-assignment1-flask:v0.1

docker run --net my-nw --net-alias pink_app --name pink_app -d -p 8082:8080 -e DBHOST=$DBHOST -e DBPORT=3306 -e DBUSER=root -e DBPWD=pw -e APP_COLOR="pink" $ECR/clo835-assignment1-flask:v0.1

docker run --net my-nw --net-alias lime_app --name lime_app -d -p 8083:8080 -e DBHOST=$DBHOST -e DBPORT=3306 -e DBUSER=root -e DBPWD=pw -e APP_COLOR="lime" $ECR/clo835-assignment1-flask:v0.1
```

### **6. Verifying the Deployment**
#### **Accessing the Web Applications**
- Open a web browser and visit the EC2 instance’s **public IP address**:
  - `http://<EC2_Public_IP>:8081` (Blue App)
  - `http://<EC2_Public_IP>:8082` (Pink App)
  - `http://<EC2_Public_IP>:8083` (Lime App)

#### **Testing Inter-Container Communication**
```bash
docker exec -it blue_app sh
ping pink_app
ping lime_app
```
