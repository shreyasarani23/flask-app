# Message HTTP API Service

This document explains the components of the HTTP API service for serving messages, how to set up the Python application, how to run it, and what each component does.


## Components

### 1. Application (Python Flask)

#### `app.py`
This is the main application file for the HTTP API service. It includes endpoints to create messages, get messages by account ID, and search for messages by various filters.

#### `requirements.txt`
Lists all the dependencies required to run the Flask application.



### 2. Docker

#### `Dockerfile`
Defines the Docker image for the Flask application with security standards in mind.

### 3. Kubernetes

#### `kubernetes/deployment.yaml`
Deployment spec for the Flask application with 0 downtime deployments and sidecars for logging.

#### `kubernetes/service.yaml`
Service spec to expose the Flask application within the Kubernetes cluster.

#### `kubernetes/ingress.yaml`
Ingress spec to expose the Flask application to the internet.

#### `kubernetes/hpa.yaml`
Horizontal Pod Autoscaler spec to handle scaling of the Flask application.

#### `kubernetes/network-policy.yaml`
Network policy spec to secure the communication within the Kubernetes cluster.

#### `kubernetes/service-account.yaml`
Service account with appropriate IAM role and policies attached for security.

#### `kubernetes/prometheus-monitoring.yaml`
Spec to monitor the service with Prometheus and alert manager.

#### `kubernetes/fluentd.yaml`
Spec to gather logs and send them to a common log management tool.

#### `kubernetes/statefulset-db.yaml`
StatefulSet spec to deploy the database with persistent storage.

#### `kubernetes/storage.yaml`
Storage spec to define persistent volume claims for the database.

### 4. Terraform

#### `terraform/main.tf`
Terraform configuration to set up a Kubernetes cluster on AWS.

#### `terraform/variables.tf`
Defines the variables used in the Terraform configuration.

#### `terraform/outputs.tf`
Defines the outputs of the Terraform configuration.

### 5. CI/CD

#### `bitbucket-pipelines.yml`
Bitbucket pipeline configuration to build, test, and deploy the Flask application using Docker and Kubernetes.

## Setup and Run the Application

### Prerequisites
- Python 3.9
- Docker
- Kubernetes cluster
- Terraform
- Bitbucket account
- GCP/AWS
- Mysql

### Steps to run locally

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd <repository-directory>
2. ** Set virtual Environment
   ```bash
   python -m venv venv
   source venv/bin/activate
3. ** Install the required dependencies
   ```bash
   pip install -r requirements.txt
   python app.py

### Steps to run as a docker

4. ** Create 
   ```bash
   docker volume create mysql_data
   docker compose up
   
