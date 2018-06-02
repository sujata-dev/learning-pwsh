param (
    [Parameter(Mandatory=$true)]
    [string] $ServiceName,
    [string] $Action,
    [string] $Path
)

#Checks if ServiceName exists and provides ServiceStatus
function CheckServiceStatus ($ServiceName)
{
    if (Get-Service $ServiceName -ErrorAction SilentlyContinue)
    {
        $ServiceStatus = (Get-Service -Name $ServiceName).Status
        Write-Host $ServiceName "-" $ServiceStatus
    }
    else
    {
        Write-Host "$ServiceName not found"
    }
}

function StartService ($ServiceName)
{
    Write-Host $ServiceName "Preparing to start $ServiceName"
    Get-Service -Name $ServiceName | Start-Service -ErrorAction SilentlyContinue
    CheckServiceStatus $ServiceName
    Write-Host $ServiceName "Installed"
}

function StopService ($ServiceName)
{
    if ((Get-Service -Name $ServiceName).Status -ne 'Stopped')
    {
        Write-Host "Preparing to stop $ServiceName"
        Get-Service -Name $ServiceName | Stop-Service -ErrorAction SilentlyContinue
        CheckServiceStatus $ServiceName
    }
    Write-Host $ServiceName "Stopped, now uninstalling..."
    $service = Get-WmiObject -Class Win32_Service -Filter "Name='$ServiceName'"
    $service.delete()
    Write-Host $ServiceName "Uninstalled"
}

# Checks if service exists
if (Get-Service $ServiceName -ErrorAction SilentlyContinue)
{
    # Condition if user wants to stop a service
    if ($Action -eq 'stop')
    {
        if (((Get-Service -Name $ServiceName).Status -eq 'Running') -or ((Get-Service -Name $ServiceName).Status -eq 'Stopped'))
        {
            StopService $ServiceName
        }
        else
        {
            Write-Host $ServiceName "-" $ServiceStatus
        }
    }

    #Condition if user wants to start a service
    elseif ($Action -eq 'start')
    {
        if ((Get-Service -Name $ServiceName).Status -eq 'Running')
        {
            Write-Host $ServiceName "already running!"
        }
        elseif ((Get-Service -Name $ServiceName).Status -eq 'Stopped')
        {
            StartService $ServiceName
        }
        else
        {
            Write-Host $ServiceName "-" $ServiceStatus
        }
    }

    # Condition if user wants to restart a service
    elseif ($Action -eq 'restart')
    {
        if ((Get-Service -Name $ServiceName).Status -eq 'Running')
        {
            StopService $ServiceName
        }
        StartService $ServiceName
    }

    # Condition if action is anything other than stop, start, restart
    else
    {
        Write-Host "Action parameter is missing or invalid, enter stop, start or restart"
    }
}

# Condition if provided ServiceName is invalid
else
{
    Write-Host "$ServiceName not found, prepared to install it"
    if ($Path)
    {
        New-Service -Name "$ServiceName" -BinaryPathName "$Path -k netsvcs"
        Write-Host "$ServiceName Installed"
        StartService $ServiceName
        Write-Host "$ServiceName Started"
    }
    else
    {
        Write-Host "$ServiceName cannot be installed, path null or invalid"
    }
}
