
$Servers = @("aaa","bbb")
foreach($item in $Servers){
$target = "\\" + $item
$file = "MicrosoftEdgeEnterpriseX64.msi"
$source = "C:\Source\" + $file
$destination =  $target + "\C$\Source\"
$exec =  $destination + $file

Write-Host "Pre Install Check Remote Status"
$PreCheck = Test-Path "$target\c$\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$Version = ""
if($PreCheck -eq $true){
 # " $item installed"
$Version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo("$target\c$\Program Files (x86)\Microsoft\Edge\Application\msedge.exe").FileVersion
}else{
 # "$item not installed"
}


if($Version -eq "89.0.774.57"){
   Write-Host -ForegroundColor DarkGreen "$item ; Installed ; ver-$Version"
   }else{

   If (-not (Test-Path $destination)) {
   New-Item -ItemType Directory -Path $destination -Force
   } 
   Copy-Item $source -Destination  $destination -Force


   $result = Invoke-Command -computername $item -ScriptBlock {(Start-Process "msiexec" -ArgumentList "/i C:\Source\MicrosoftEdgeEnterpriseX64.msi /quiet /norestart" -Wait -Passthru).ExitCode}
   #C:\temp\PsExec64.exe -accepteula $target cmd /c "msiexec.exe /i C:\Source\$file /quiet /norestart" 


    $PreCheck = Test-Path "$target\c$\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    if($PreCheck -eq $true){
    $Version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo("$target\c$\Program Files (x86)\Microsoft\Edge\Application\msedge.exe").FileVersion
    }else{

    }

   
     if($Version -eq "89.0.774.57"){
     Write-Host -ForegroundColor Green "$item ; OK"
     }else{
     Write-Host -ForegroundColor red "$item ; Alarm"
     }
   }
}


