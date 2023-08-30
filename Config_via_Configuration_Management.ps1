Configuration Config_via_Configuration_Management
{
  Import-DscResource -Name 'Environment' -ModuleName 'PSDscResources'
  Environment MachineConfigurationExample {
    Name   = 'MC_ENV_CONFIG_MANAGEMENT'
    Value  = 'This was set by Jelle using machine configuration via Configuration Management'
    Ensure = 'Present'
    Target = @('Process', 'Machine')
  }   
}

Config_via_Configuration_Management