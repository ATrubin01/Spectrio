### VPC variables ###

variable "vpc_cidr" {
  type    = string
  default = "10.88.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "spectrio-project-vpc"
}

### Internet Gateway variables ###

variable "igw_name" {
  type    = string
  default = "spectrio-project-internet-gateway"
}

### Public Route Table variables ###

variable "pub_rt_name" {
  type    = string
  default = "spectrio-project-public-route-table"
}

### Private Route Table variables ###

variable "priv_rt_name" {
  type    = string
  default = "spectrio-project-private-route-table"
}

### Public Subnet variables ###

variable "public_subnet_object" {
  type = map(object({
    cidr = string,
    az   = string,
    name = string

  }))
  default = {
    "pub_sub_1" = {
      cidr = "10.88.0.0/20",
      az   = "us-east-1a",
      name = "public-subnet-1"
    },
    "pub_sub_2" = {
      cidr = "10.88.16.0/20",
      az   = "us-east-1b",
      name = "public-subnet-2"
    }
  }
}

### Private subnet variables ###

variable "private_subnet_object" {
  type = map(object({
    cidr = string,
    az   = string,
    name = string

  }))
  default = {
    "priv_sub_1" = {
      cidr = "10.88.128.0/20"
      az   = "us-east-1a",
      name = "private-subnet-1"
    },
    "priv_sub_2" = {
      cidr = "10.88.144.0/20",
      az   = "us-east-1b",
      name = "private-subnet-2"
    }
  }
}

### Tag variables ###

variable "eks_cluster_name" {
  type    = string
  default = "spectrio-cluster-staging"
}


