data "aws_eks_cluster_auth" "authentication" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.authentication.token
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.authentication.token
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
  }
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "1.30.1"  # Adjust version as per your Kubernetes version

  set {
    name  = "autoDiscovery.enabled"
    value = "true"
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "cloudProvider"
    value = "aws"
  }

  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "sslCertPath"
    value = "/etc/ssl/certs/ca-bundle.crt"
  }

  set {
    name  = "extraArgs.balance-similar-node-groups"
    value = "true"
  }

  set {
    name  = "extraArgs.skip-nodes-with-system-pods"
    value = "false"
  }

    set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::468457242339:role/AUTOSCALER_IAM_ROLE_ARN"
  }
}
