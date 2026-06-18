# AWS Terraform Modules

Production-grade Terraform modules for AWS — used in fintech platforms serving 10M+ users.

## Modules
| Module | Description |
|--------|-------------|
| [vpc](./modules/vpc) | Multi-AZ VPC, public/private subnets, NAT gateways |
| [eks](./modules/eks) | EKS cluster with managed node groups and IRSA |
| [iam](./modules/iam) | IAM roles, policies, OIDC for IRSA |

## Quick Start
```hcl
module "vpc" {
  source      = "./modules/vpc"
  environment = "prod"
  cidr_block  = "10.0.0.0/16"
  azs         = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}
module "eks" {
  source       = "./modules/eks"
  cluster_name = "prod-cluster"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
}
```
## Requirements
- Terraform >= 1.5
- AWS Provider >= 5.0