[CmdletBinding()]
Param(
  [string]$storageAccountName = $(Read-Host -prompt "Specify storage account name"),
  [string]$adminUser = $(Read-Host -prompt "Specify admin user name"),
  [string]$adminPassword = $(Read-Host -prompt "Specify admin password")
  )
  
#
# Multiple VMs in a stopped-deallocated and stopped state
#
$cloudServiceName = "resize-test8"
$availabilitySet = "AS1"
$image = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-Datacenter-20151120-en.us-127GB.vhd"
$location = "West US"
$vmsize = "Small"
$storageContainer = "http://" + $storageAccountName + ".blob.core.windows.net/test8/"



$vmName = "resize-vm8-1"
$osDiskURL = $storageContainer + $cloudServiceName + "-" + $vmName

$vmconfig = New-AzureVMConfig -Name $vmName -InstanceSize $vmsize -ImageName $image -MediaLocation $osDiskURL -AvailabilitySetName $availabilitySet
Add-AzureProvisioningConfig -VM $vmConfig -Windows -AdminUsername $adminUser -Password $adminPassword 
New-AzureVM -ServiceName $cloudServiceName -VMs $vmconfig -VNetName $VNet -Location $location 


$vmName = "resize-vm8-2"
$osDiskURL = $storageContainer + $cloudServiceName + "-" + $vmName

$vmconfig = New-AzureVMConfig -Name $vmName -InstanceSize $vmsize -ImageName $image -MediaLocation $osDiskURL -AvailabilitySetName $availabilitySet
Add-AzureProvisioningConfig -VM $vmConfig -Windows -AdminUsername $adminUser -Password $adminPassword 
New-AzureVM -ServiceName $cloudServiceName -VMs $vmconfig


#
# Stop VMs after they have came to ReadyRole state
#
$vmName = "resize-vm8-1"

$vm = Get-AzureVM -ServiceName $cloudServiceName -Name $vmName
while ($vm.InstanceStatus -notlike "ReadyRole") {
    write-host "Waiting for" $vmName "to become ReadyRole. Current Status:" $vm.InstanceStatus
    sleep -Seconds 20
    $vm = Get-AzureVM -ServiceName $cloudServiceName -Name $vmName
}
Stop-AzureVM -Name $vmName -ServiceName $cloudServiceName -StayProvisioned


$vmName = "resize-vm8-2"

$vm = Get-AzureVM -ServiceName $cloudServiceName -Name $vmName
while ($vm.InstanceStatus -notlike "ReadyRole") {
    write-host "Waiting for" $vmName "to become ReadyRole. Current Status:" $vm.InstanceStatus
    sleep -Seconds 20
    $vm = Get-AzureVM -ServiceName $cloudServiceName -Name $vmName
}
Stop-AzureVM -Name $vmName -ServiceName $cloudServiceName 