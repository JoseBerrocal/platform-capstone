resource "kubernetes_storage_class_v1" "managed_csi" {
  metadata {
    name = "managed-csi-platform"

    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner    = "disk.csi.azure.com"
  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true

  parameters = {
    skuName = "StandardSSD_LRS"
  }

  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
}