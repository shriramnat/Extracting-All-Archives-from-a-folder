<#function Expand-AllZipsInFolder 
{#>
param
(
[Parameter(Mandatory=$true)]
[string]  $Source, 
[string] $Destination = $Source,
[switch] $UseSameOutputFolder = $false
)
    # Check for Valid Source
    if (! (Test-Path $Source -PathType Container)) {
        Write-Host "The provided Source is invalid!" -ForegroundColor Red -BackgroundColor Yellow
        throw 
    }
        
    # Check if Destination exists, if not create the destination folder
    if (! (Test-Path $Destination -PathType Container)) {
        try {
            Write-Host "Creating Destination Directory: $Destination" -ForegroundColor Yellow
            New-Item -Path $Destination -ItemType Directory | Out-Null
        }
        catch {
            # Throw if unable to create destination directory
            Write-Host "Unable to Create destination directory!" -ForegroundColor Red -BackgroundColor Yellow
            throw
        }
    }

    # Get all zip files in the Source directory
    $zips = get-childItem -Path $Source -Filter *.zip
    Write-Host ("Found {0} zip files" -f $zips.Count) -ForegroundColor Yellow

    # Iterate through the list and extract all zip files to their own sub-directories within the destination directory
    foreach ($zip in $zips)
    {
        if(! $useSameOutputFolder) { $tempFolderName = [io.path]::GetFileNameWithoutExtension($zip)} else { $tempFolderName = "OutputFolder"}

        $DirToBeCreated = "{0}\{1}" -f $Destination.TrimEnd("\"), $tempFolderName
        try
        {
                if(! (Test-Path $DirToBeCreated)) {
                    Write-Host "Creating Destination Directory: $DirToBeCreated" -ForegroundColor Yellow
                    New-Item -Path $DirToBeCreated -ItemType Directory | Out-Null
                }

                Write-Host ("Extracting {0} to {1}" -f $zip.Name, $DirToBeCreated) -ForegroundColor Yellow
                Expand-Archive -Path $zip.FullName -DestinationPath $DirToBeCreated -Force
        }
        catch
        {
            # Throw if the folder cannot be created to extract the zip
            if (! @(Test-Path $DirToBeCreated)) {
                Write-Host "Unable to Create Folder $DirToBeCreated" -ForegroundColor Red
            }
            else {
            # Throw if unable to extract the zip
            Write-Host "Unable to extract Archive $tempFolderName" -ForegroundColor Red
            }
        }   
    }
<#
.SYNOPSIS

Extracts all Zip files within a specified folder.

.DESCRIPTION

Extracts all Zip files within a specified folder. You can optionally specify a Destination folder to extract all the files. By default, the cmdlet will create separate folders per zip file. Use the -UseSameOutputFolder flag to extract all the zips to the same output folder.

.EXAMPLE

C:\PS> Expand-AllZipsInFolder -Source F:\Downloads\test\

.EXAMPLE

C:\PS> Expand-AllZipsInFolder -Source F:\Downloads\test\ -Destination F:\Downloads\test\test2

.EXAMPLE

C:\PS> Expand-AllZipsInFolder -Source F:\Downloads\test\ -UseSameOutputFolder

#>
