#Requires -Version 7.1.3
#Requires -Modules @{ ModuleName="GuestConfiguration"; ModuleVersion = "4.5.0" }
#Requires -Modules @{ ModuleName="PSDesiredStateConfiguration"; ModuleVersion = "2.0.7" }

try {
  #Generate mofs
  . .\configurations\Config_via_Configuration_Management.ps1
  . .\configurations\Config_via_Policy.ps1
  . .\configurations\Install_Package_via_Chocolatey.ps1

  #Rename mofs
  Rename-Item .\Config_via_Configuration_Management\localhost.mof -NewName "Config_via_Configuration_Management.mof"
  Rename-Item .\Config_via_Policy\localhost.mof -NewName "Config_via_Policy.mof"
  Rename-Item .\Install_Package_via_Chocolatey\localhost.mof -NewName "Install_Package_via_Chocolatey.mof"

  #Package mofs
  New-GuestConfigurationPackage -Name "Config_via_Configuration_Management" -Configuration .\Config_via_Configuration_Management\Config_via_Configuration_Management.mof -Type AuditAndSet -Force $true
  New-GuestConfigurationPackage -Name "Config_via_Policy" -Configuration .\Config_via_Policy\Config_via_Policy.mof -Type AuditAndSet -Force $true
  New-GuestConfigurationPackage -Name "Install_Package_via_Chocolatey" -Configuration .\Install_Package_via_Chocolatey\Install_Package_via_Chocolatey.mof -Type AuditAndSet -Force $true

  # Remove module folder from Install_Package_via_Chocolatey.zip
  Expand-Archive -Path .\Install_Package_via_Chocolatey.zip -DestinationPath .\Install_Package_via_Chocolatey_Staging -Force
  Remove-Item -Path .\Install_Package_via_Chocolatey_Staging\Modules\PackageManagement -Recurse -Force
  Compress-Archive -Path .\Install_Package_via_Chocolatey_Staging\* -DestinationPath .\Install_Package_via_Chocolatey.zip -Force
  Remove-Item -Path .\Install_Package_via_Chocolatey_Staging -Recurse -Force
}

catch {
  throw $_.ErrorDetails.Message
}

finally {
  #Cleanup mofs
  Remove-Item .\Config_via_Configuration_Management -Recurse -Force
  Remove-Item .\Config_via_Policy -Recurse -Force
  Remove-Item .\Install_Package_via_Chocolatey -Recurse -Force
}

