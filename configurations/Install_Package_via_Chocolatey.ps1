Configuration Install_Package_via_Chocolatey
{
	Import-DscResource -Name PackageManagement, PackageManagementSource
  
	PackageManagement ChocolateyGet {
		Name   = 'ChocolateyGet'
		Source = 'PSGallery'
	}

	PackageManagement vscode {
		Name         = 'vscode'
		ProviderName = 'ChocolateyGet'
		DependsOn    = '[PackageManagement]ChocolateyGet'
	}
}

Install_Package_via_Chocolatey