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
# Multiple VMs w/ Reserved VIP and Static DataCenter IP
#
$cloudServiceName = "resize-test3"
$reservedIP = "resize-test3-reserved1"
$availabilitySet = "AS1"
$VNet = "resize3-VNet"
$subnet = "subnet-1"
$image = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-Datacenter-20151120-en.us-127GB.vhd"
$location = "West US"
$vmsize = "Small"
$storageContainer = "http://" + $storageAccountName + ".blob.core.windows.net/test3/"

$vmName = "resize-vm1"
$ipaddress = "10.0.0.51"
$osDiskURL = $storageContainer + $cloudServiceName + "-" + $vmName

$vmconfig = New-AzureVMConfig -Name $vmName -InstanceSize $vmsize -ImageName $image -MediaLocation $osDiskURL -AvailabilitySetName $availabilitySet
Add-AzureProvisioningConfig -VM $vmConfig -Windows -AdminUsername $adminUser -Password $adminPassword 
Set-AzureSubnet -SubnetNames $subnet -VM $vmconfig
Set-AzureStaticVNetIP -IPAddress $ipaddress -VM $vmconfig
New-AzureVM -ServiceName $cloudServiceName -VMs $vmconfig -VNetName $VNet -Location $location -ReservedIPName $reservedIP


$vmName = "resize-vm2"
$ipaddress = "10.0.0.52"
$osDiskURL = $storageContainer + $cloudServiceName + "-" + $vmName

$vmconfig = New-AzureVMConfig -Name $vmName -InstanceSize $vmsize -ImageName $image -MediaLocation $osDiskURL -AvailabilitySetName $availabilitySet
Add-AzureProvisioningConfig -VM $vmConfig -Windows -AdminUsername $adminUser -Password $adminPassword 
Set-AzureSubnet -SubnetNames $subnet -VM $vmconfig
Set-AzureStaticVNetIP -IPAddress $ipaddress -VM $vmconfig
New-AzureVM -ServiceName $cloudServiceName -VMs $vmconfig