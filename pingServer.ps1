################################################################
##
## pingServer.ps1
## Created By    : Nick Clark
## Owner         : Nick Clark
## Date          : March 2018
##
## Copyright © 2018 Nick Clark
## This software is proprietarily created and maintained by Nick Clark for its sole use.
## You may NOT redistribute copies of this code.
## There is NO WARRANTY, to the extent permitted by law.
##
################################################################

function pingServer($filePath)
{
    if (!$filePath) 
        { 
        Write-Host "You need to enter filepath for servers to check"
        } #end if

    $fileContents = Get-Content $filePath
    
        foreach ($computer in $fileContents)
            {
              if (Test-Connection -ComputerName $computer -Count 1 -ErrorAction SilentlyContinue)
              {
                   $host.ui.RawUI.ForegroundColor = "Green"
                   Write-Host "$computer, UP"
              }
          else
             {
                $host.ui.RawUI.ForegroundColor = "Red"
                Write-Host "$computer, DOWN"
             }

            } #end for loop

} #end function pingServer