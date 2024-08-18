EKS Cluster Setup and Configuration
Overview
This project involves setting up an Amazon EKS (Elastic Kubernetes Service) cluster with specific configurations. The cluster is designed to include various add-ons such as VPC CNI, Kube-Proxy, CoreDNS, and EBS CSI Controller. It also includes node groups, an ingress controller, and a cluster autoscaler. Below are the detailed steps, challenges encountered, and solutions implemented during this setup.

Prerequisites
AWS CLI installed and configured.
Terraform installed for infrastructure as code.
kubectl installed for Kubernetes management.
Helm installed for package management in Kubernetes.
Instructions
1. VPC Setup
CIDR Block: 10.88.0.0/16
Subnets:
Two public subnets
Two private subnets
Purpose: The VPC is the foundational network layer for the EKS cluster, providing networking for pods and services within the cluster.
2. EKS Cluster Creation
Version: 1.30
Add-Ons: VPC CNI, Kube-Proxy, CoreDNS, EBS CSI Controller
Node Groups:
Node Group 01:
Instance Type: t3.medium
Min Instances: 2
Node Group 02:
Instance Type: t3.small
Min Instances: 1
Taints: app:podinfo:NOSCHEDULE
Challenges:
Add-On Creation Issues: The initial setup of the VPC CNI, Kube-Proxy, and CoreDNS add-ons encountered issues where the add-ons were stuck in the "Creating" state. This was resolved by ensuring that the required IAM roles and policies were correctly configured, specifically for the aws-node service account.
3. IAM Role Setup
Roles: Created and attached policies for the EKS cluster and the add-ons.
OIDC Provider: Ensured that the cluster had an OIDC provider configured to support IAM Roles for Service Accounts (IRSA).
ConfigMap: Configured the aws-auth ConfigMap to map the IAM roles to Kubernetes system roles, allowing the nodes and services to function correctly.
Challenges:
Authorization Issues: Authorization issues with the aws-node daemonset were fixed by correctly configuring the aws-auth ConfigMap.
4. Ingress Controller
Controller: Nginx Ingress Controller
Installation Method: Helm
Purpose: The ingress controller was installed to manage inbound traffic to the services running within the Kubernetes cluster.
5. Cluster Autoscaler
Setup: Configured and deployed the Cluster Autoscaler to automatically adjust the size of the node group based on the current load and resource requirements.
Verification: Successfully triggered the autoscaler by deploying a load that required additional nodes, which the autoscaler then provisioned.
Challenges:
IAM Permissions: Ensured the correct IAM permissions and proper configuration of the autoscaler to interact with the EKS cluster.
6. Storage Class Modification
Default Storage Class: Changed from gp2 to gp3.
Configuration:
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
Purpose: The storage class modification was necessary to optimize storage costs and performance. The Retain reclaim policy ensures that persistent volumes are not automatically deleted when the persistent volume claims are removed, and WaitForFirstConsumer delays volume binding until a pod is scheduled, ensuring optimal placement.
Workflow Pipeline Logic
Overview:
The GitHub Actions workflow is designed to manage Terraform deployments based on branch names. Notable features include:

Dynamic Environment Setup: The environment stage (production, staging, or dev) is automatically determined based on the branch name (e.g., main, staging, dev).
AWS Credentials Management: The workflow assumes an IAM role using AWS OIDC to securely manage AWS resources.
Terraform Backend Configuration: The Terraform state is stored in an S3 bucket with a DynamoDB table used for state locking.
Automated Terraform Plan and Apply: The workflow generates and applies Terraform plans for infrastructure management.
Helm for Ingress Controller: The Nginx Ingress Controller is installed and managed via Helm, ensuring proper traffic routing within the cluster.
Conclusion
This project provided valuable experience in setting up and managing an Amazon EKS cluster with specific configurations and challenges. The issues encountered during the setup process, particularly with IAM roles, service accounts, and add-on configurations, were resolved through careful troubleshooting and reconfiguration. The successful deployment of the ingress controller, autoscaler, and storage class modifications further enhanced the cluster's capabilities and ensured its readiness for production workloads.



