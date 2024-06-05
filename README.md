# eks_cluster
Build a fully functional EKS cluster with HCL

## VPC Module
- Main VPC CIDR block 172.30.30.0/24
    ### Public Subnets
    - Public subnet 01 -> 172.30.30.0/28
    - Public subnet 02 -> 172.30.30.16/28
    - Internet facing LB subnet 01 -> 172.30.30.32/28
    - Internet facing LB subnet 02 -> 172.30.30.48/28

    ### Private Subnets
    - EKS control plane subnet 01 -> 172.30.30.64/28
    - EKS control plane subnet 02 -> 172.30.30.80/28
    - Internal LB subnet 01 -> 172.30.30.96/28
    - Internal LB subnet 02 -> 172.30.30.112/28
    - Transit Gateway subnet 01 -> 172.30.30.128/28
    - Transit Gateway subnet 02 -> 172.30.30.144/28
    - Private NAT subnet 01 -> 172.30.30.160/28
    - Private NAT subnet 02 -> 172.30.30.176/28
    - EFS subnet 01 -> 172.30.30.192/28
    - EFS subnet 02 -> 172.30.30.208/28
    - Utility subnet 01 -> 172.30.30.224/28
    - Utility subnet 02 -> 172.30.30.240/28

- DB CIDR block 172.30.35.0/27
    - DB subnet 01 - 172.30.35.0/28
    - DB subnet 02 - 172.30.35.16/28

- POD CIDR block 100.98.90.0/23
    - Node Group subnet 01 -> 100.98.90.0/24
    - Node Group subnet 02 -> 100.98.91.0/24