# Digital Ocean API Token
variable "do_token" {}

# Bootstrap token for kubeadm init/join
variable "k8s_bootstrap_token" {}

# A local admin user account so we can disable root login
variable "local_user" {}