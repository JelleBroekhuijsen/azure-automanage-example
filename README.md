# azure-automanage-example

This example showcases the usage of Azure Automanage Machine Configuration using Terraform. It applies 2 configurations to an example VM: one using Azure Policy and one using VM Guest Configuration Management.

This example is based on the [Azure Automanage Machine Configuration documentation](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/).

## Requirements

The following requirements are needed on the machine/agent executing the terraform scripts:

- [Powershell 7.1.3](https://github.com/PowerShell/PowerShell/releases/tag/v7.1.3) or higher
- Powershell Module: [Guest Configuration 4.5.0](https://www.powershellgallery.com/packages/GuestConfiguration/4.5.0) or higher
- Powershell Module: [PSDesiredStateConfiguration 2.0.7](https://www.powershellgallery.com/packages/PSDesiredStateConfiguration/2.0.7) or higher
  
## Usage

- Run `Create-ExampleDscArtifacts.ps1` to create the DSC artifacts.
- Setup `provider.tf` to your environment and/or preferences.
- Apply the configuration with `terraform apply`.

## Validating the configuration

Both the Azure Policy and the VM Guest Configuration Management configuration can be validated in the Azure Portal. The following steps describe how to validate the configuration. Additionally, both methods can be validated using the [Guest Configuration](https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.Compute%2FvirtualMachines%2Fproviders%2FguestConfigurationAssignments) blade in the Azure Portal.

### Azure Policy

To validate the Azure Policy configuration, navigate to the Azure Portal and open the Azure Policy blade. Select the policy you created and click on the `Assignments` tab. Here you should see the policy assignment. If you click on the assignment you can see the compliance state of the policy. If you click on the `View compliance details` button you can see the compliance state of the individual resources. If the resource is in a non-compliant state, you can remediate it by clicking on the `Remediate` button.

### VM Guest Configuration Management

To validate the VM Guest Configuration Management configuration, navigate to the Azure Portal and open the VM blade. Select the VM you created and click on the `Configuration Management` tab. Here you should see the configuration assignment. 

## Notes

For generating the policy file I used the PowerShell snippet below, as described in the [Azure Automanage Machine Configuration documentation](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/how-to-create-policy-definition#create-an-azure-policy-definition/). However as of the latest version I have been using ([4.5.0]((https://www.powershellgallery.com/packages/GuestConfiguration/4.5.0))) I found that the parameter `PolicyVersion` does not behave properly. It is not possible to provide an versions value formatted like `1.0.0` here. Instead it expects it to be formatted like `'1.0.0'`. This however has the side effect that in the generated `json`-file the version is translated to this string: `"version": "True"`. This is not a valid version and will cause the policy to fail. To fix this, I manually edited the `json`-file and changed the version to the correct value. As this module is currently closed source I have not found a way to report this issue.

```PowerShell
$PolicyConfig      = @{
  PolicyId      = New-Guid
  ContentUri    = "https://examplestyefc.blob.core.windows.net/examplecontainer/Config_via_Configuration_Management.zip"
  DisplayName   = 'Example Automanage Configuration Management Policy'
  Description   = 'Example Automanage Configuration Management Policy'
  Path          = './policy-template'
  Platform      = 'Windows'
  PolicyVersion = '1.0.0'
  Mode          = 'ApplyAndAutoCorrect'
}

New-GuestConfigurationPolicy @PolicyConfig
```
