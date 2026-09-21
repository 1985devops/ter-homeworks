output "vms_fqdn" {
  value = [module.test-vm.fqdn, module.example-vm.fqdn]
}

