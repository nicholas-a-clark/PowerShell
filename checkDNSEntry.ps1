##
## removeDNSEntires.ps1
## Created By    : Nick Clark
## Owner         : NickClark.biz
## Date          : Oct 2018
##
## Copyright © 2016 NickClark.biz
## This software is proprietarily created and maintained by NickClark.biz for its sole use.
## You may NOT redistribute copies of this code.
## There is NO WARRANTY, to the extent permitted by law.
##

function checkDNSEntry
{

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
		 Get-DnsServerResourceRecord -ZoneName $($fileLine.DOMAIN) -Name $($fileLine.HOSTNAME) -ComputerName $($fileLine.DNSSERVER)
		} #end for loop
		
} #end checkDNSEntry function

