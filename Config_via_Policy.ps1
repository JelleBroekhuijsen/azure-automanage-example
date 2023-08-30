Configuration Config_via_Policy
{
    Import-DscResource -Name 'Environment' -ModuleName 'PSDscResources'
    Environment MachineConfigurationExample {
      Name   = 'MC_ENV_POLICY'
      Value  = 'This was set by Jelle using machine configuration via Azure Policy'
      Ensure = 'Present'
      Target = @('Process', 'Machine')
    }   
}

Config_via_Policy