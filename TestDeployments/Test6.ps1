#
# Note: VNet must be created before running this script
#

[CmdletBinding()]
Param(
  [string]$storageAccountName = $(Read-Host -prompt "Specify storage account name"),
  [string]$adminUser = $(Read-Host -prompt "Specify admin user name"),
  [string]$adminPassword = $(Read-Host -prompt "Specify admin password")
  )
  
#
# Two VMs in two subnets
#
$cloudServiceName = "resize-test6"
$availabilitySet = "AS1"
$VNet = "resize6-VNet"
$image = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-Datacenter-20151120-en.us-127GB.vhd"
$location = "West US"
$vmsize = "Small"
$storageContainer = "http://" + $storageAccountName + ".blob.core.windows.net/test6/"


$vmName = "resize-vm6-1"
$osDiskURL = $storageContainer + $cloudServiceName + "-" + $vmName
$subnet = "subnet-1"

$vmconfig = New-AzureVMConfig -Name $vmName -InstanceSize $vmsize -ImageName $image -MediaLocation $osDiskURL -AvailabilitySetName $availabilitySet
Add-AzureProvisioningConfig -VM $vmConfig -Windows -AdminUsername $adminUser -Password $adminPassword 
Set-AzureSubnet -SubnetNames $subnet -VM $vmconfig
New-AzureVM -ServiceName $cloudServiceName -VMs $vmconfig -VNetName $VNet -Location $location 


$vmName = "resize-vm6-2"
$osDiskURL = $storageContainer + $cloudServiceName + "-" + $vmName
$subnet = "subnet-2"

$vmconfig = New-AzureVMConfig -Name $vmName -InstanceSize $vmsize -ImageName $image -MediaLocation $osDiskURL -AvailabilitySetName $availabilitySet
Add-AzureProvisioningConfig -VM $vmConfig -Windows -AdminUsername $adminUser -Password $adminPassword 
Set-AzureSubnet -SubnetNames $subnet -VM $vmconfig
New-AzureVM -ServiceName $cloudServiceName -VMs $vmconfig