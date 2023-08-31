# azure-automanage-example

This example showcases the usage of Azure Automanage DSC using Terraform. It applies 2 configurations to an example VM: one using Azure Policy and one using VM Guest Configuration Management.

## Requirements

The following requirements are needed on the machine/agent executing the terraform scripts:

- [Powershell 7.1.3](https://github.com/PowerShell/PowerShell/releases/tag/v7.1.3) or higher
- Powershell Module: [Guest Configuration 4.5.0](https://www.powershellgallery.com/packages/GuestConfiguration/4.5.0) or higher
- Powershell Module: [PSDesiredStateConfiguration 2.0.7](https://www.powershellgallery.com/packages/PSDesiredStateConfiguration/2.0.7) or higher
  
## Usage

- Run `Create-ExampleDscArtifacts.ps1` to create the DSC artifacts. Requires administrator privileges!
- Setup `provider.tf` to your environment and/or preferences.
- Apply the configuration with `terraform apply`.
