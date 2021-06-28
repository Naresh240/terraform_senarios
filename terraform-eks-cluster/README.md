# terraform-eks-cluster
# Install kubectl
    curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    mkdir -p $HOME/bin
    cp ./kubectl $HOME/bin/kubectl
    export PATH=$HOME/bin:$PATH
    echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
    source $HOME/.bashrc
    kubectl version --short --client
# Use below commands to create eks-cluaster
    aws configure
    terraform init
    terraform plan
    terraform apply
# Update config file you want to connect to cluster
    aws eks --region us-east-1 update-kubeconfig --name eksdemo
# Check nodes of the cluster
    kubectl get nodes
