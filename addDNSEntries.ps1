################################################################
##
## removeDNSEntires.ps1
## Created By    : Nick Clark
## Owner         : NickClark.biz
## Date          : March 2018
##
## Copyright © 2016 NickClark.biz
## This software is proprietarily created and maintained by NickClark.biz for its sole use.
## You may NOT redistribute copies of this code.
## There is NO WARRANTY, to the extent permitted by law.
##
################################################################

function addDNSEntries
{
   #Get input from user
	#$dnsServer = Read-Host 'What DNS server would you like to use?' 
	#$zoneName = Read-Host 'What DNS zone are you adding to'
	Write-Host "Please select your CSV for input!." -ForegroundColor red -BackgroundColor white
		Add-Type -AssemblyName System.Windows.Forms
		  $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
			Multiselect = $false # Multiple files can be chosen
			Filter = "csv files (*.csv)|*.csv|All files (*.*)|*.*"# Text file filter
			
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
	  
	foreach ($fileLine in $fileInput)
		{
		  #Add DNS Record A
		  Add-DnsServerResourceRecordA -Name $($fileLine.HOSTNAME) -ComputerName $($fileLine.DNSSERVER) -ZoneName $($fileLine.DOMAIN) -AllowUpdateAny -IPv4Address $($fileLine.IP) -TimeToLive 01:00:00 -Confirm -CreatePtr
		  #ADD PTR Record
		   add-DnsServerResourceRecordPtr -Name $($fileLine.HOSTNAME) -ComputerName $($fileLine.DNSSERVER) -ZoneName $($fileLine.ZONE) -AllowUpdateAny -TimeToLive 01:00:00 -AgeRecord -PtrDomainName $($fileLine.DOMAIN)
		  get-DnsServerResourceRecord -ZoneName $($fileLine.DOMAIN) -ComputerName $($fileLine.DNSSERVER) -Name $($fileLine.HOSTNAME)
		 
		} #end for loop

} #End Function

function removeDNSEntries
{
	#Get input from user
	$dnsServer = Read-Host 'What DNS server would you like to use?' 
	$zoneName = Read-Host 'What DNS zone are you removing from'
		Add-Type -AssemblyName System.Windows.Forms
		  $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
			Multiselect = $false # Multiple files can be chosen
			Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*"# Text file filter
			
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

	$fileInput = Get-Content $file
	
	foreach ($line in $fileInput)
		{
		  Remove-DnsServerResourceRecord -ComputerName $dnsServer -ZoneName $zoneName -RRType "A" -Name $line
		} #end for loop

} #end function
