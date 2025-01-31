# Automated System Inventory Script (CSV Database)

# Define the CSV file path
$CsvFile = "$env:USERPROFILE\Desktop\SystemInventory.csv"


# Function to Collect System Information
function Collect-Inventory {
    Write-Output "Collecting system information..."

    # Get System Information
    $ComputerName = $env:COMPUTERNAME
    $OS = (Get-CimInstance Win32_OperatingSystem).Caption
    $CPU = (Get-CimInstance Win32_Processor).Name
    $RAM = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
    $DiskSpace = [math]::Round((Get-PSDrive -Name C).Free / 1GB, 2)
    $IP = (Test-Connection -ComputerName $ComputerName -Count 1).IPv4Address.IPAddressToString

    # Create a System Inventory Object
    $SystemData = [PSCustomObject]@{
        ComputerName = $ComputerName
        OS = $OS
        CPU = $CPU
        RAM_GB = $RAM
        FreeDisk_GB = $DiskSpace
        IP_Address = $IP
        Timestamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
    }

    # Save to CSV (Append if exists, create new if not)
    if (Test-Path $CsvFile) {
        $SystemData | Export-Csv -Path $CsvFile -Append -NoTypeInformation
    } else {
        $SystemData | Export-Csv -Path $CsvFile -NoTypeInformation
    }

    Write-Output "System inventory collected successfully!"
}

# Function to View Inventory Records
function View-Inventory {
    if (-not (Test-Path $CsvFile)) {
        Write-Output "No inventory records found!"
        return
    }
    Write-Output "System Inventory Records:"
    Import-Csv -Path $CsvFile | Format-Table -AutoSize
}

# Function to Search for a Specific Computer
function Search-Inventory {
    if (-not (Test-Path $CsvFile)) {
        Write-Output "No inventory records found!"
        return
    }
    $searchTerm = Read-Host "Enter Computer Name or IP Address"
    $result = Import-Csv -Path $CsvFile | Where-Object { $_.ComputerName -like "*$searchTerm*" -or $_.IP_Address -like "*$searchTerm*" }

    if ($result) {
        Write-Output "Search Results:"
        $result | Format-Table -AutoSize
    } else {
        Write-Output "No matching records found!"
    }
}

# Main Menu Function
function Show-Menu {
    Clear-Host
    Write-Output "===== Automated System Inventory ====="
    Write-Output "1. Collect System Inventory"
    Write-Output "2. View All Inventory Records"
    Write-Output "3. Search for a Computer"
    Write-Output "4. Exit"
}

# Main Script Loop
do {
    Show-Menu
    $choice = Read-Host "Select an option"

    switch ($choice) {
        1 { Collect-Inventory }
        2 { View-Inventory }
        3 { Search-Inventory }
        4 { Write-Output "Exiting..."; exit }
        default { Write-Output "Invalid option, please try again." }
    }

    Pause  # Wait for user before looping again
} while ($true)

