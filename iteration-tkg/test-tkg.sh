#!/bin/bash

# This script pulls a TKG release down from a URL (change it as needed).
# After pulling it then creates a small payload with ovas, kubectl, tkg-client
# That script can then be used to test tanzu on NSX using the conventions in this folder.

version=v1.1.0-rc.1+vmware.1
release=vmware-tanzu-kubernetes-grid-${version}
client=tanzu_tkg-cli-${version}
k8s=1.18.1
haproxy=1.2.4
node=1.18.1
vmware=vmware.1
build=35999326

if [ ! -f ${release}.tar.gz ]; then
	wget http://build-squid.eng.vmware.com/build/mts/release/sb-${build}/publish/lin64/tkg_release/${release}.tar.gz
else
        echo "found release ! copying..."
        cp $release release.tar.gz
fi


job=`date "+%M_%Y_%d_%s"`
echo "Creating job dir: $job"
mkdir $job

pushd $job
        tar -xvf ../release.tar.gz
        mkdir payload
        find ./ | grep ova >> ./payload/buildinfo.txt
        cp $release/haproxy-v${haproxy}+vmware.1/images/photon-3-haproxy-v${haproxy}+${vmware}.ova ./payload/haproxy.ova
        cp $release/node-v${node}+vmware.1/images/photon-3-kube-v${node}+${vmware}.ova ./payload/k8s.ova
        gunzip $release/$client/executables/tkg-linux-amd64-${version}.gz
        cp $release/$client/executables/tkg-linux-amd64-${version} ./payload/tkg-client
        gunzip $release/kubernetes-v${k8s}+${vmware}/executables/kubectl-linux-v${k8s}+${vmware}.gz
        cp $release/kubernetes-v${k8s}+${vmware}/executables/kubectl-linux-v${k8s}+${vmware} ./payload/kubectl
        ls -altrh ./payload
popd

echo "All contents are in $job/payload/"

cat << EOF > envvars.txt
export VSPHERE_SERVER='vxlan-vm-111-55.nimbus-tb.eng.vmware.com' # (required) The vCenter server IP or FQDN
export VSPHERE_SERVER="192.168.111.151"
export VSPHERE_USERNAME='administrator@vsphere.local'      # (required) The username used to access the remote vSphere endpoint
export VSPHERE_PASSWORD='Admin!23'                         # (required) The password used to access the remote vSphere endpoint
export VSPHERE_DATACENTER='kubo-dc'                          # (required) The vSphere datacenter to deploy the management cluster on
export VSPHERE_DATASTORE='iscsi-ds-0'               # (required) The vSphere datastore to deploy the management cluster on
export VSPHERE_NETWORK='workload_segment1'    # 3 wasnt working!!!...  (required) The VM network to deploy the management cluster on
export VSPHERE_RESOURCE_POOL='az-0'               # (required) The vSphere resource pool for your VMs
export VSPHERE_FOLDER=""                            # (optional) The VM folder for your VMs, defaults to the root vSphere folder if not set.
export VSPHERE_DISK_GIB='50'                               # (optional) The VM Disk size in GB, defaults to 20 if not set
export VSPHERE_NUM_CPUS='2'                                # (optional) The # of CPUs for control plane nodes in your management cluster, defaults to 2 if not set
export VSPHERE_MEM_MIB='2048'                              # (optional) The memory (in MiB) for control plane nodes in your management cluster, defaults to 2048 if not set
export SSH_AUTHORIZED_KEY='ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6VfBKd6hqd5h7k5f+AtjJSV1hdW5u9/3uAolK3SD2/5GD9+rn+FMSdbtkeaKuuVJPi2HjnsVMO+r8WcuyN5ZSYHywiSoh4S7PamAxra1CLISsFHPYFlGrtdHC70wnoT7+/wAJk2D3CYkCNMWIxs5eR0cefDOytipBfDplhkJByyrcnXuhI8St3XJzpjlXu454diJOxfsk6axanWLOr/WZFmUi1U6V4gRE7XtKG9WFUm1bmNgkgd7lehKzi+isTjnI+b4tnD0yIzKFcsgIvLdGJTI6Lluj33CeBHIocwu0LbvowTyYSqhP6DzGhGuKfK9rMnJh/ll0Bnu1xf/ok0NSQ== Jpeerindex@doolittle-5.local'

# Kubernetes configs
export SERVICE_CIDR='100.64.0.0/13'       # (optional) The service CIDR of the management cluster, defaults to "100.64.0.0/13"
export CLUSTER_CIDR='100.96.0.0/11'       # (optional) The cluster CIDR of the management cluster, defaults to "100.96.0.0/11"

export SERVICE_DOMAIN='cluster.local'     # (optional) The k8s service domain of the management cluster, defaults to "cluster.local"

# TKG
export VSPHERE_HAPROXY_TEMPLATE="haproxy"
export VSPHERE_TEMPLATE="k8s"

export VSPHERE_SSH_AUTHORIZED_KEY="$SSH_AUTHORIZED_KEY"
export GOVC_URL="$VSPHERE_SERVER"

# vCenter credentials
export GOVC_USERNAME="$VSPHERE_USERNAME"
export GOVC_PASSWORD="$VSPHERE_PASSWORD"
export GOVC_INSECURE=true
EOF

echo "1) first upload the haproxy.ova and k8s.ova into vsphere"
echo "2) the env var script you can use is in envvars.txt, from there, run source envvars.txt && tkg init --infra=vsphere --plan=dev"
