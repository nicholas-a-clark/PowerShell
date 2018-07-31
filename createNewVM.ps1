################################################################
##
## createNewVM.ps1
## Created By    : Nick Clark
## Owner         : NickClark.biz
## Date          : July 2018
##
## Copyright © 2016 NickClark.biz
## This software is proprietarily created and maintained by NickClark.biz for its sole use.
## You may NOT redistribute copies of this code.
## There is NO WARRANTY, to the extent permitted by law.
##
################################################################

function createNewVM
{
	$diUsername = Read-Host 'Please enter in your Active Directory user account' 
	$diPassword = Read-Host 'Please enter in your Password' 
	$diCluster  = Read-Host 'Please enter the cluster you wish to build this in' 

	Add-Type -AssemblyName System.Windows.Forms
		$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
			Multiselect = $false # Multiple files can be chosen
			Filter = "CSV (*.csv)| *.csv" #Filter to only show CSV
			
	} #End Add-Type for form

	[void]$FileBrowser.ShowDialog()

	$file = $FileBrowser.FileName;

	If($FileBrowser.FileNames -like "*\*") {
		#Do something 
		$FileBrowser.FileName #Lists selected files (optional)
	}

	else 
		{
			Write-Host "Canceled by user"
		} #end else

	$fileInput = Import-CSV $file
	
	foreach ($vm in $fileInput)
		{
			$vmName = $($vm.Name)
			Write-host "VM being deployed :" $vmName
	
			Write-Host "From Template :" $($vm.Template)
	
			New-VM –Name $vmName –ResourcePool $diCluster -VM $($vm.Template) -RunAsync -Confirm:$False
	
			$VMS = get-VM | %{ write-host .; $_}
		
			$Windows_Cust = New-OSCustomizationSpec -Name $($vm.Name) -FullName "Administrator" -AdminPassword "P@88w0rd" -TimeZone "035" -OrgName 
"Test" -Domain "dataintensity.com" -DomainUsername $diUsername -DomainPassword $diPassword –DnsServer “172.18.4.110","172.18.4.111" -DnsSuffix "dataintensity.com" 
–NamingScheme VM –OSType Windows
		
			# Apply the customization first check that the template does not exist
			Write-host $vmName
			
				if (Get-OSCustomizationSpec -Name $($vm.Name))
					{
						Remove-OSCustomizationSpec $($vm.Name)
					}
				else
					{
						Set-VM –VM $vmName –OSCustomizationSpec $Windows_Cust –Confirm:$False
					}

			Start-VM -VM $vmName
			
		} #end for loop
		
} #end function createNewVM
