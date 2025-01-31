# PowerShell-System-Inventory

Step 1: Define Requirements
This script will:
✅ Collect system information (CPU, RAM, Disk, OS, Installed Software).
✅ Store the data in a CSV file (acting as a simple database).
✅ Allow users to view saved system records.
✅ Allow users to search for a specific machine’s details.

📌 Step 2: Understanding Key PowerShell Cmdlets
Get-ComputerInfo → Fetches system details.
Get-CimInstance → Retrieves hardware information.
Get-PSDrive → Checks disk usage.
Get-WmiObject → Retrieves installed software list.
Export-Csv → Saves collected data in a CSV file.
Import-Csv → Loads data back for searching/viewing.

Step 3: Explanation of the Code
1️⃣ Collect System Inventory
$ComputerName = $env:COMPUTERNAME → Gets the current machine name.
Get-CimInstance Win32_OperatingSystem → Retrieves OS details.
Get-CimInstance Win32_Processor → Gets the processor type.
Get-CimInstance Win32_ComputerSystem → Retrieves total RAM (converted to GB).
Get-PSDrive -Name C → Fetches free disk space in GB.
Test-Connection -ComputerName $ComputerName -Count 1 → Finds the local IP address.
Export-Csv → Saves system details into SystemInventory.csv.
2️⃣ View All Inventory Records
Import-Csv -Path $CsvFile | Format-Table → Displays all records in table format.
3️⃣ Search for a Computer
User inputs a search term (computer name or IP address).
Where-Object { $_.ComputerName -like "*$searchTerm*" } → Finds matching records.
4️⃣ Main Menu
Uses a do {} loop to keep showing the menu.
switch ($choice) {} handles user selection.
Pause waits before looping back.
