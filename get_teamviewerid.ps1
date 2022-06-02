#channing babb - 6/2/2022

#check if they have administrative permissions
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isAdmin -eq "True") {
    # get user input
    $ComputerName = Read-Host -Prompt 'Enter the computer name'
    $Online = Test-Connection -BufferSize 32 -Count 1 -ComputerName $ComputerName -Quiet

    #check if computer is online
    if ($Online -eq "True") {
        # get user that is logged in
        $LoggedIn = (Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $ComputerName).Username
        $ResultPRE = $LoggedIn.replace("AD\", '')
        $Result = $ResultPRE.replace("\s+",'')

        # get teamviewer id from their logs
        # $Content = Get-Content -tail 20 \\$ComputerName\c$\Users\$Result\AppData\Roaming\TeamViewer\TeamViewer15_Logfile.log 
        $Content = Get-Content \\$ComputerName\c$\Users\$Result\AppData\Roaming\TeamViewer\TeamViewer15_Logfile.log -raw
        $Content1 = $Content | out-string
        $Content2 = $Content1.Substring($Content1.IndexOf("DyngateID: "), $Content1.IndexOf("DyngateID: ") + 15)
        $Content3 = $Content2.Substring(11, $Content2.IndexOf(','))
        $Content4 = $Content3.Substring(0, 9)
        Write-Output $Content4
        $eorr = Read-Host "Press 'O' + enter to quit, anything else and enter to quit"
        If ($eorr.toLower() -eq "O") {
             & 'C:\Program Files\TeamViewer\TeamViewer.exe' --id $Content4
            Exit;
        } Else {
            Exit;
        }
    } else {
        Write-Output "Computer is offline"
        $eorr = Read-Host "Press enter to quit"
        If ($eorr.toLower() -eq "R") {
            Exit;
        } Else {
            Exit;
        }
    }
} else {
    Write-Output "Run this program as administrator"
    $eorr = Read-Host "Press enter to quit"
    If ($eorr.toLower() -eq "R") {
        Exit;
    } Else {
        Exit;
    }
}