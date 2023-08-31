#Requires -RunAsAdministrator
#Requires -Version 7.1.3
#Requires -Modules @{ ModuleName="GuestConfiguration"; ModuleVersion = "4.5.0"}
#Requires -Modules @{ ModuleName="PSDesiredStateConfiguration"; ModuleVersion = "2.0.7"}

#Generate mofs
. .\configurations\Config_via_Configuration_Management.ps1
. .\configurations\Config_via_Policy.ps1

#Rename mofs
Rename-Item .\Config_via_Configuration_Management\localhost.mof -NewName "Config_via_Configuration_Management.mof"
Rename-Item .\Config_via_Policy\localhost.mof -NewName "Config_via_Policy.mof"

#Package mofs
New-GuestConfigurationPackage -Name "Config_via_Configuration_Management" -Configuration .\Config_via_Configuration_Management\Config_via_Configuration_Management.mof -Type AuditAndSet -Force $true
New-GuestConfigurationPackage -Name "Config_via_Policy" -Configuration .\Config_via_Policy\Config_via_Policy.mof -Type AuditAndSet -Force $true

#Cleanup mofs
Remove-Item .\Config_via_Configuration_Management -Recurse -Force
Remove-Item .\Config_via_Policy -Recurse -Force