# azure-automanage-example

This example showcases the usage of Azure Automanage Machine Configuration using Terraform. It applies 2 configurations to an example VM: one using Azure Policy and one using VM Guest Configuration Management.

This example is based on the [Azure Automanage Machine Configuration documentation](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/).

## Requirements

The following requirements are needed on the machine/agent executing the terraform scripts:

- [Powershell 7.1.3](https://github.com/PowerShell/PowerShell/releases/tag/v7.1.3) or higher
- Powershell Module: [Guest Configuration 4.5.0](https://www.powershellgallery.com/packages/GuestConfiguration/4.5.0) or higher
- Powershell Module: [PSDesiredStateConfiguration 2.0.7](https://www.powershellgallery.com/packages/PSDesiredStateConfiguration/2.0.7) or higher
- Powershell Module: [PackageManagement 1.4.7](https://www.powershellgallery.com/packages/PackageManagement/1.4.7) exactly!
  
## Usage

- Run `Create-ExampleDscArtifacts.ps1` to create the DSC artifacts.
- Setup `provider.tf` to your environment and/or preferences.
- Apply the configuration with `terraform apply`.

## Validating the configuration

Both the Azure Policy and the VM Guest Configuration Management configuration can be validated in the Azure Portal. The following steps describe how to validate the configuration. Additionally, both methods can be validated using the [Guest Configuration](https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.Compute%2FvirtualMachines%2Fproviders%2FguestConfigurationAssignments) blade in the Azure Portal.

### Azure Policy

To validate the Azure Policy configuration, navigate to the Azure Portal and open the Azure Policy blade. Select the policy you created and click on the `Assignments` tab. Here you should see the policy assignment. If you click on the assignment you can see the compliance state of the policy. If you click on the `View compliance details` button you can see the compliance state of the individual resources. If the resource is in a non-compliant state, you can remediate it by clicking on the `Remediate` button.

### On the VM

To validate that the DSC config has actually been applied, log on to the VM and open the `Environment Variables`-window: `Control Panel > System and Security > System > Advanced system settings > Environment Variables`. In the `System variables`-section you should see a variable named `MC_ENV_CONFIG_MANAGEMENT` and a variable named `MC_ENV_POLICY`. These variables have been set by the DSC configuration.

## Notes

For generating the policy file I used the PowerShell snippet below, as described in the [Azure Automanage Machine Configuration documentation](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/how-to-create-policy-definition#create-an-azure-policy-definition/). However as of the latest version I have been using ([4.5.0]((https://www.powershellgallery.com/packages/GuestConfiguration/4.5.0))) I found that the parameter `PolicyVersion` does not behave properly. It is not possible to provide a version value formatted like `1.0.0` here. Instead it expects it to be formatted like `'1.0.0'`. This however has the side effect that in the generated `json`-file the version is translated to this string: `"version": "True"`. This is not a valid version and will cause the policy to fail. To fix this, I manually edited the `json`-file and changed the version to the correct value. As this module is currently closed source I have not found a way to report this issue.

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

### Chocolatey & Guest Configuration

The default Chocolatey DSC Resource (cChoco) is currently not compatible with PowerShell 7 which is required for anything using Azure Machine Configuration. A workaround is to use ChocolateyGet as package provider and install Chocolatey packages that way.

I have added a [sample configuration](./configurations/Install_Package_via_Chocolatey.ps1) showcasing this workaround.

However, there is a very nasty bug in the `GuestConfiguration`-extension that causes a conflict between different versions of the `PackageManagement`-module on a target system. When you build your configuration with the `Import-DscResource -Name PackageManagement, PackageManagementSource` statement, the `PackageManagement`-module will be included in the configuration zip and the `GuestConfiguration`-extension will try to import this at runtime. However since `PackageMangement` is already included in the `GuestConfiguration`-extension this causes a conflict and the configuration will fail. As you cannot build the configuration without the `Import-DscResource`-statement you cannot resolve this issue in a clean way.

Additionally, the version of the `PackageManagement`-module on the the machine compiling the guest configurations (via `New-GuestConfigurationPackage`) needs to match the version shipped with the `GuestConfiguration`-extension, which is `1.4.7` at the time of writing.

To solve this I had to manually delete the module file from the configuration zip after it was created. There is additional code in the `Create-ExampleDscArtifacts.ps1`-script that does this. This is a very ugly workaround and I have not found a better way to solve this issue.

See the following links for more information:

- [ChocolateyGet](https://github.com/Jianyunt/ChocolateyGet)
- [Open cChoco issue regarding Azure Machine Configuration on github](https://github.com/chocolatey/cChoco/issues/173)
