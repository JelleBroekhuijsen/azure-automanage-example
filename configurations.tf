resource "null_resource" "compile-mof-cm" {
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = ". .\\Config_via_Configuration_Management.ps1; Rename-Item -Path .\\Config_via_Configuration_Management\\localhost.mof -NewName Config_via_Configuration_Management.mof"
  }
}

resource "null_resource" "compile-mof-policy" {
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = ". .\\Config_via_Policy.ps1; Rename-Item -Path .\\Config_via_Policy\\localhost.mof -NewName Config_via_Policy.mof"
  }
}

resource "null_resource" "package-mof-cm" {
  provisioner "local-exec" {
    interpreter = [ "pwsh", "-Command" ]
    command = "New-GuestConfigurationPackage -Name Config_via_Configuration_Management -Configuration .\\Config_via_Configuration_Management\\Config_via_Configuration_Management.mof -Type AuditAndSet -Force $True"
  }
  depends_on = [ null_resource.compile-mof-cm ]
}

resource "null_resource" "package-mof-policy" {
  provisioner "local-exec" {
    interpreter = [ "pwsh", "-Command" ]
    command = "New-GuestConfigurationPackage -Name Config_via_Policy -Configuration .\\Config_via_Policy\\Config_via_Policy.mof -Type AuditAndSet -Force $True"
  }
  depends_on = [ null_resource.compile-mof-policy ]
}