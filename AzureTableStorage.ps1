################################################################################
## Source: Linux Acadamey "Using Microsoft Azure Database Services"
## Author: Landon Fowler
## Purpose: PowerShell script for creating and working with Azure Table Storage
## Date Updated: 04/30/2020
################################################################################


# Install the AzTable module
Install-Module AzTable

# Sign in to Azure
Add-AzAccount

# Set the region
$location = "westus"

# Set the resource group
$resourceGroup = "DBServices"

# Create the storage account
$storageAccountName = "awesomecompany"
$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroup `
  -Name $storageAccountName `
  -Location $location `
  -SkuName Standard_LRS `
  -Kind Storage

# Obtain the storage account context
$ctx = $storageAccount.Context

# Create the table
$tableName = "people"
New-AzStorageTable –Name $tableName –Context $ctx

# List tables
Get-AzStorageTable –Context $ctx | select Name

# Reference your table
$storageTable = Get-AzStorageTable –Name $tableName –Context $ctx

# Reference the CloudTable property of your table
$cloudTable = (Get-AzStorageTable –Name $tableName –Context $ctx).CloudTable

# Add entities
Add-AzTableRow `
    -table $cloudTable `
    -partitionKey "Staff" `
    -rowKey ("1111") -property @{"FullName"="Stosh Oldham";"FieldOfStudy"="Linux"}

Add-AzTableRow `
    -table $cloudTable `
    -partitionKey "Students" `
    -rowKey ("9999") -property @{"FullName"="Myles Young";"FieldOfStudy"="Big Data"}

# Query for the students
Get-AzTableRow -table $cloudTable -partitionKey "Students" | ft