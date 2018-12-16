################################################################
##
## RemovefromAD.ps1
## Created By    : Nick Clark
## Owner         : NickClark.biz
## Date          : Dec 2018
##
## Copyright © 2016 NickClark.biz
## This software is proprietarily created and maintained by NickClark.biz for its sole use.
## You may NOT redistribute copies of this code.
## There is NO WARRANTY, to the extent permitted by law.
##
################################################################

function RemovefromAD
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
          #Remove System from AD
		  Write-Host "Removing " $($fileLine.SERVER) "From AD!" -ForegroundColor red
		  
		  $removefromAD = Remove-ADComputer -Server dataintensity.com -Identity $($fileLine.SERVER)
		  
		  if ($removefromAD -ne $null)
				{
					Write-Host $($fileLine.SERVER) "removed successful" -ForegroundColor Green
				} #end if
		  else
				{
				    Write-Host "Problem removing server form AD" -ForegroundColor red
				} #end else
		} //end foreach loop

} #End Function
