Param([string]$sourceURI = $(Read-Host -prompt "Specify the full URL to the source blob"),
      [string]$storageId = $(Read-Host -prompt "Specify the full storage account ARM-ID"),
      [string]$location  = $(Read-Host -prompt "Specify the source location"),
      [string]$imageName = $(Read-Host -prompt "Specify the image name"))


$RGName="Images"
$location = $location.Replace(' ','')
$snapName=$imageName+$location+"-snap"
$imageNameRegional=$imageName+$location

$subscriptions=Get-AzureRmSubscription

foreach ($sub in $subscriptions){
    
    #
    # Make the current subscription active
    #
    Select-AzureRmSubscription -SubscriptionName $sub.Name


    #
    # Create a snapshot from the remote blob
    #
    write-host "Creating Snapshot"
    $snapshotConfig = New-AzureRmSnapshotConfig -AccountType StandardLRS `
                                                -OsType Windows `
                                                -Location $location `
                                                -CreateOption Import `
                                                -SourceUri $sourceURI `
                                                -StorageAccountId $storageId 

    $snap = New-AzureRmSnapshot -ResourceGroupName $RGName `
                                -SnapshotName $snapName `
                                -Snapshot $snapshotConfig 
                              
                                
    
    #
    # Create an image from the snapshot
    #
    write-host "Creating Image from Snapshot"
    $imageConfig = New-AzureRmImageConfig -Location $location 

    Set-AzureRmImageOsDisk -Image $imageConfig `
                           -OsType Windows `
                           -OsState Generalized `
                           -SnapshotId $snap.Id 

    New-AzureRmImage -ResourceGroupName $RGName `
                     -ImageName $imageNameRegional `
                     -Image $imageConfig 

}

foreach ($sub in $subscriptions){

    #
    # Make the current subscription active
    #
    Select-AzureRmSubscription -SubscriptionName $sub.Name

    #
    # Cleanup snapshot
    #
    write-host "Deleting Snapshot"
    Remove-AzureRmSnapshot -ResourceGroupName $RGName -SnapshotName $snapName -force
}
