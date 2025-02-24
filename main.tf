locals {
  kubernetes_cluster = {
    name     = "cluster"
    gateway  = "192.168.11.1"
    cidr     = 24
    endpoint = "192.168.11.111"
  }

  virtual_machines = {
    "k8s-control-plane-1" = {
      host_node      = "pve01"
      machine_type   = "controlplane"
      ip             = "192.168.11.111"
      cpu            = 2
      ram_dedicated  = 2048
      os_disk_size   = 10
      data_disk_size = 30
      datastore_id   = "local-lvm"
      bridge         = "vmbr0"
    }
    "k8s-control-plane-2" = {
      host_node      = "pve02"
      machine_type   = "controlplane"
      ip             = "192.168.11.112"
      cpu            = 2
      ram_dedicated  = 2048
      os_disk_size   = 10
      data_disk_size = 30
      datastore_id   = "local-lvm"
      bridge         = "vmbr0"
    }
    "k8s-control-plane-3" = {
      host_node      = "pve03"
      machine_type   = "controlplane"
      ip             = "192.168.11.113"
      cpu            = 2
      ram_dedicated  = 2048
      os_disk_size   = 10
      data_disk_size = 30
      datastore_id   = "local-lvm"
      bridge         = "vmbr0"
    }

    "k8s-worker-1" = {
      host_node      = "pve01"
      machine_type   = "worker"
      ip             = "192.168.11.211"
      cpu            = 2
      ram_dedicated  = 8192
      os_disk_size   = 10
      data_disk_size = 100
      datastore_id   = "local-lvm"
      bridge         = "vmbr0"
    }

    "k8s-worker-2" = {
      host_node      = "pve02"
      machine_type   = "worker"
      ip             = "192.168.11.212"
      cpu            = 2
      ram_dedicated  = 8192
      os_disk_size   = 10
      data_disk_size = 100
      datastore_id   = "local-lvm"
      bridge         = "vmbr0"
    }

    "k8s-worker-3" = {
      host_node      = "pve03"
      machine_type   = "worker"
      ip             = "192.168.11.213"
      cpu            = 2
      ram_dedicated  = 8192
      os_disk_size   = 10
      data_disk_size = 100
      datastore_id   = "local-lvm"
      bridge         = "vmbr0"
    }
  }
}

module "virtual_machine" {
  source = "./modules/virtual-machine"

  virtual_machines   = local.virtual_machines
  kubernetes_cluster = local.kubernetes_cluster
}

module "kubernetes" {
  source = "./modules/kubernetes"

  depends_on                        = [module.virtual_machine]
  kubernetes_cluster                = local.kubernetes_cluster
  kubernetes_nodes                  = local.virtual_machines
  enable_talos_cluster_health_check = true
}
