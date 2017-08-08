# Azure Resize Cloud Service

This script is designed to assist in resizing VMs which cannot be resized through standard commands. Azure Service Management (ASM) VMs, which are also called classic VMs, can be resized to a limited set of sizes based on the physical hardware supporting the VM. To change the VM size to a size not supported by the current hosting hardware requires the VM deployment to be deleted and then recreated. This script performs the action to delete and recreate the VM deployment.

If there are multiple VMs in a Cloud Service, this script will resize all VMs in the selected deployment.

This script is designed to only be used when the VM cannot be resized through the standard resize action. If it is possible to change the VM size using the standard resize options, then please use the standard resize command available through the Azure portal, Azure PowerShell or Azure command line interface (Azure CLI). Furthermore, this script requires the caller to specify flags to allow actions which will cause changes in the configuration of the VM deployment.

## Parameters
Parameter	| Type | Description
:----- | :------: | ------
CloudService | String	| Name of Cloud Service to be resized
NewSize	| String | New VM size for all VMs in the Cloud Service
OutputFile | String | Output file to contain all details of the execution
AllowServiceVipChange	| Switch | Allow VIP (Internet IP address for cloud service) to change through the resize operation. To maintain the VIP the cloud service must be using a reserved IP address.
AllowVMPublicIPChange | Switch | Allow the public IP address of a VM to change. Public IP addresses cannot use a static IP address for classic VMs so this switch must be set if the deployment contains any VMs that have a public IP address configured on it.
AllowVNetIPChange | Switch | Allow the VNet IP address of VMs to change. This must be set if any VM does not have a static VNet IP address configured on it.
AllowRemovalOfAffinityGroup | Switch | Allow the cloud service to be deleted and created if it is initially configured to use an affinity group. The affinity group must be removed to enable the VM deployment to be moved to new physical hardware that supports the requested VM size.


## Notable error messages
Error message	| Explanation
:----- | :------
VMs in the cloud service (Service Name) can be resized to (New Size) through standard resize operations. |This script will not resize a VM that can be resized through the standard resize operations. Please use the standard operations to resize the VM.
The size (New Size) is not a valid VM size in the current region. |Some sizes are not available in all regions. Please select a different VM size.
This script does not support cloud services with custom DNS configuration. | This is a limitation of the initial script. Community support for this action is welcome.
This script does not support cloud services with Reverse FQDN configured. |	This is a limitation of the initial script. Community support for this action is welcome.
The VM: (VM Name) has more data disks than are supported on the selected VM size. | Different VM sizes support a different number of data disks (typically two data disks per vCPU). The selected VM size does not support enough data disks for one or more of the VMs in the current deployment
One of the original VMs is using premium storage, and the selected size is not a DS or GS size. | If any VM is using premium storage, then the new VM size must also support premium storage.
The VM: (VM Name) is currently in a Provisioning state. Please wait for provisioning to complete before attempting to resize the VM. |	VMs in the provisioning state should not be shutdown. Therefore, the script will block any attempt to resize a VM that is in the provisioning state.
This script does not support changing the size of VMs that have multiple NICs. | This is a limitation of the initial script. Community support for this action is welcome.
This script does not support changing the size of VMs use network security groups. | This is a limitation of the initial script. Community support for this action is welcome.
