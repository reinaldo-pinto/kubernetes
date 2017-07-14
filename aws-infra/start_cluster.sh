#!/bin/bash -x

# export variables

export SSH_KEY_PATH="~/.ssh/id_rsa.pub"
export KOPS_STATE_STORE="s3://$VAR_PROJECT-kubernetes-devops-teste"
export NAME=k8testedevops.$VAR_PROJECT.cloud
export VPC_ID="vpc-a4e46ec1"
export NETWORK_CIDR=172.30.0.0/16
export ZONES=us-west-1a 
#sa-east-1b
export MASTER_ZONES=us-west-1a
#sa-east-1b
export NODE_SIZE="t2.micro"
export MASTER_SIZE="m3.medium"
export DNS_ZONE=$VAR_PROJECT.cloud
export OFFICE_IP="187.61.6.5/32"
export MASTER_SG="sg-08db3a6e"
export NODE_SG="sg-08db3a6e"
export K8_VERSION="1.7.0"
#export K8_VERSION="v1.6.4"
#    --networking weave --zones=$ZONES --network-cidr $NETWORK_CIDR \

function delete(){
    echo "Running function delete"
    kops delete cluster --name=$NAME --yes
}

function create(){
    echo "Running function create"
    kops create cluster --name=$NAME  --ssh-public-key=$SSH_KEY_PATH \
     --networking weave --zones=$ZONES \
     --vpc $VPC_ID --master-zones $MASTER_ZONES --node-size $NODE_SIZE \
     --kubernetes-version=$K8_VERSION --master-size $MASTER_SIZE \
    --dns-zone $DNS_ZONE --node-count 2  --cloud aws \
    --admin-access=$OFFICE_IP \
    --master-security-groups=$MASTER_SG --node-security-groups=$NODE_SG --yes
#    --yes
#    --out log_criacao_cluster_$NAME --yes

}

function main(){

    echo "Running script"
    case "$option" in
        create)
            create
            ;;
        delete)
            delete
            ;;
        *)
            echo "Usage: $0 {create|delete}"
            exit 1
    esac
}
option=$1
main

