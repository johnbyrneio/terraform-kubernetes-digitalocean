provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_droplet" "k8s-master" {
    image  = "centos-7-x64"
    name   = "k8s-master"
    region = "nyc1"
    size   = "s-1vcpu-1gb"
    ssh_keys = ["47:46:ea:aa:43:6c:1d:e8:a9:3d:b6:9d:d9:64:da:fb"]
    private_networking = true

    provisioner "file" {
        source      = "scripts/k8s-master.sh"
        destination = "/tmp/k8s-master.sh"
    }

    provisioner "remote-exec" {
        script = "scripts/k8s-base.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/k8s-master.sh",
            "export MASTER_IP=${digitalocean_droplet.k8s-master.ipv4_address_private}",
            "export BOOTSTRAP_TOKEN=${var.k8s_bootstrap_token}",
            "/tmp/k8s-master.sh"
        ]
    }

    provisioner "file" {
        source      = "scripts/ssh-harden.sh"
        destination = "/tmp/ssh-harden.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/ssh-harden.sh",
            "export LOCAL_USER=${var.local_user}",
            "/tmp/ssh-harden.sh"
        ]
    }
}

resource "digitalocean_droplet" "k8s-worker-01" {
    image  = "centos-7-x64"
    name   = "k8s-worker-01"
    region = "nyc1"
    size   = "s-1vcpu-3gb"
    ssh_keys = ["47:46:ea:aa:43:6c:1d:e8:a9:3d:b6:9d:d9:64:da:fb"]
    private_networking = true

    provisioner "file" {
        source      = "scripts/k8s-worker.sh"
        destination = "/tmp/k8s-worker.sh"
    }

    provisioner "remote-exec" {
        script = "scripts/k8s-base.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/k8s-worker.sh",
            "export PRIVATE_IP=${digitalocean_droplet.k8s-worker-01.ipv4_address_private}",
            "export MASTER_IP=${digitalocean_droplet.k8s-master.ipv4_address_private}",
            "export BOOTSTRAP_TOKEN=${var.k8s_bootstrap_token}",
            "/tmp/k8s-worker.sh"
        ]
    }

    provisioner "file" {
        source      = "scripts/ssh-harden.sh"
        destination = "/tmp/ssh-harden.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/ssh-harden.sh",
            "export LOCAL_USER=${var.local_user}",
            "/tmp/ssh-harden.sh"
        ]
    }
}

resource "digitalocean_droplet" "k8s-worker-02" {
    image  = "centos-7-x64"
    name   = "k8s-worker-02"
    region = "nyc1"
    size   = "s-1vcpu-3gb"
    ssh_keys = ["47:46:ea:aa:43:6c:1d:e8:a9:3d:b6:9d:d9:64:da:fb"]
    private_networking = true

    provisioner "file" {
        source      = "scripts/k8s-worker.sh"
        destination = "/tmp/k8s-worker.sh"
    }

    provisioner "remote-exec" {
        script = "scripts/k8s-base.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/k8s-worker.sh",
            "export PRIVATE_IP=${digitalocean_droplet.k8s-worker-02.ipv4_address_private}",
            "export MASTER_IP=${digitalocean_droplet.k8s-master.ipv4_address_private}",
            "export BOOTSTRAP_TOKEN=${var.k8s_bootstrap_token}",
            "/tmp/k8s-worker.sh"
        ]
    }

    provisioner "file" {
        source      = "scripts/ssh-harden.sh"
        destination = "/tmp/ssh-harden.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/ssh-harden.sh",
            "export LOCAL_USER=${var.local_user}",
            "/tmp/ssh-harden.sh"
        ]
    }
}