[CmdletBinding()]
Param(
  [string]$storageAccountName = $(Read-Host -prompt "Specify storage account name"),
  [string]$adminUser = $(Read-Host -prompt "Specify admin user name"),
  [string]$adminPassword = $(Read-Host -prompt "Specify admin password")
  )
  
#
# Multiple VMs in a stopped-deallocated and stopped state
#
$cloudServiceName = "resize-test10"
$image = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-Datacenter-20151120-en.us-127GB.vhd"
$location = "North Central US"
$vmsize = "Small"
$storageContainer = "http://" + $storageAccountName + ".blob.core.windows.net/test10/"


$vmName = "resize-vm10-1"
$osDiskURL = $storageContainer + $cloudServiceName + "-" + $vmName

$vmconfig = New-AzureVMConfig -Name $vmName -InstanceSize $vmsize -ImageName $image -MediaLocation $osDiskURL 
Add-AzureProvisioningConfig -VM $vmConfig -Windows -AdminUsername $adminUser -Password $adminPassword 
New-AzureVM -ServiceName $cloudServiceName -VMs $vmconfig -VNetName $VNet -location $location

