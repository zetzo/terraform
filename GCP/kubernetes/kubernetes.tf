# Set the provider and project
provider "google" {
  version = "2.23.0"
  project = "my-project"
  region  = "europe-central2"
}

# Create a Compute Engine instance with Kubernetes installed and running
resource "google_compute_instance" "k8s_node" {
  name         = "k8s-node"
  machine_type = "n1-standard-1"
  zone         = "europe-central2-a "

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  metadata = {
    "k8s-minion" = "true"
  }

  # Install Kubernetes and start the kubelet service
  metadata_startup_script = <<EOF
    # Install Kubernetes
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl

    # Start the kubelet service
    sudo systemctl enable kubelet
    sudo systemctl start kubelet
EOF
}
