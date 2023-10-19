Configuration Install_Package_via_Chocolatey
{
	Import-DscResource -Name PackageManagement, PackageManagementSource -ModuleName @{ModuleName='PackageManagement';RequiredVersion='1.4.7'}
  
	PackageManagement ChocolateyGet {
		Name   = 'ChocolateyGet'
		Source = 'PSGallery'
	}

	PackageManagement vscode {
		Name         = 'vscode'
		RequiredVersion = 'latest'
		ProviderName = 'ChocolateyGet'
		DependsOn    = '[PackageManagement]ChocolateyGet'
		Ensure       = 'Present'
	}
}

Install_Package_via_Chocolatey