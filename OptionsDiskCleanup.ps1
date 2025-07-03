# Ensure the console is clear at start for a clean menu presentation
Clear-Host

# ASCII Art Banner
Write-Host @"
                                                                                                                       
                              S T A R T I N G   A D V A N C E D   D I S K   C L E A N U P   P R O C E S S . . .                         
                                  

"@ -ForegroundColor Cyan

# --- Function to clean a specified path ---
function Remove-PathContents {
    param (
        [string]$Path,
        [string]$Description
    )

    Write-Host "`n--- Cleaning $Description at $Path ---" -ForegroundColor Cyan
    if (Test-Path $Path) {
        Get-ChildItem -LiteralPath $Path -Force | ForEach-Object {
            Write-Host "Attempting to delete: $($_.FullName)" -ForegroundColor DarkGray
            try {
                Remove-Item -LiteralPath $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "Deleted: $($_.FullName)" -ForegroundColor DarkGray
            }
            catch {
                Write-Host "Skipped (Folder/file In use during deletion): $($_.FullName) - $($_.Exception.Message)" -ForegroundColor Yellow
            }
        }
        Write-Host "$Description cleanup completed." -ForegroundColor Green
    }
    else {
        Write-Host "$Description directory not found: $Path" -ForegroundColor Red
    }
}

#---Define path for cleanup categories--
 
# 1. Temporary Internet Files
$tempInternetFilesPath = Join-Path ([Environment]::GetFolderPath("LocalApplicationData")) "Microsoft\Windows\INetCache"

# 2. DirectX Shader Cache
$directXShaderCachePath = Join-Path ([Environment]::GetFolderPath("LocalApplicationData")) "D3DSCache"

# 3. Delivery Optimization Files (Windows Update Cache)
$deliveryOptimizationPath = "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization"

# 4. User Temporary Files (%TEMP%)
$userTempPath = $env:TEMP

# 5. System Temporary Files (C:\Windows\Temp)
$systemTempPath = "C:\Windows\Temp"

# 6. Thumbnails Cache
# This targets the database files directly within the Explorer cache folder.
$thumbnailsCachePath = Join-Path ([Environment]::GetFolderPath("LocalApplicationData")) "Microsoft\Windows\Explorer"
$thumbnailDBPattern = "ThumbCache_*.db" # Pattern to match thumbnail database files

# --- Individual Cleanup Functions ---
function Clear-TemporaryInternetFiles {
    Remove-PathContents -Path $tempInternetFilesPath -Description "Temporary Internet Files (IE/Legacy Edge Cache)"
}

function Clear-DirectXShaderCache {
    Remove-PathContents -Path $directXShaderCachePath -Description "DirectX Shader Cache"
}

function Clear-DeliveryOptimizationFiles {
    Remove-PathContents -Path $deliveryOptimizationPath -Description "Delivery Optimization Files (Windows Update Cache)"
}

function Clear-UserTemporaryFiles {
    Remove-PathContents -Path $userTempPath -Description "User Temporary Files (%TEMP%)"
}

function Clear-SystemTemporaryFiles {
    Remove-PathContents -Path $systemTempPath -Description "System Temporary Files (C:\Windows\Temp)"
}

function Clear-ThumbnailsCache {
    Write-Host "`n--- Cleaning Thumbnails Cache ---" -ForegroundColor Cyan
    if (Test-Path $thumbnailsCachePath) {
        Get-ChildItem -Path $thumbnailsCachePath -Include $thumbnailDBPattern -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            Write-Host "Attempting to delete thumbnail cache file: $($_.FullName)" -ForegroundColor DarkGray
            try {
                Remove-Item -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue
                Write-Host "Deleted: $($_.FullName)" -ForegroundColor DarkGray
            }
            catch {
                Write-Host "Skipped (File In use during deletion): $($_.FullName) - $($_.Exception.Message)" -ForegroundColor Yellow
            }
        }
        Write-Host "Thumbnails cache cleanup completed." -ForegroundColor Green
    }
    else {
        Write-Host "Thumbnails cache directory not found: $thumbnailsCachePath" -ForegroundColor Red
    }
}

function Clear-RecycleBin {
    Write-Host "`n--- Emptying Recycle Bin ---" -ForegroundColor Cyan
    $confirmRecycleBin = Read-Host "Are you sure you want to clear the Recycle Bin? (Y/N)"

    if ($confirmRecycleBin -eq 'Y' -or $confirmRecycleBin -eq 'y') {
        try {
            Microsoft.PowerShell.Management\Clear-RecycleBin -Force -Confirm:$false -ErrorAction SilentlyContinue
            Write-Host "Recycle Bin emptied successfully." -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to empty Recycle Bin: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Recycle Bin clearing cancelled." -ForegroundColor Yellow
    }
}

# --- Main Menu Loop ---
$choice = ""
while ($choice -ne '0') {
    Write-Host @"
                                                                                                                       
                                                         W E L C O M E   T O                        
                                             A D V A N C E D   D I S K   C L E A N E R  !

                                  <<====================[[MENU]]===============================>>
                                   ||      Advanced Disk Cleanup Options                      ||
                                  <<===========================================================>>
                                   ||    [1] Clean Temporary Internet Files                   ||
                                   ||    [2] Clean DirectX Shader Cache                       ||
                                   ||    [3] Clean Delivery Optimization Files                ||
                                   ||    [4] Clean User Temporary Files (%TEMP%)              ||
                                   ||    [5] Clean System Temporary Files (C:\Windows\Temp)   ||
                                   ||    [6] Clean Thumbnails Cache                           ||
                                   ||    [7] Empty Recycle Bin (with confirmation)            ||
                                   ||    [A] Clean All listed Options                         ||
                                   ||    [0] Exit                                             ||
                                  <<===========================================================>>


"@ -ForegroundColor Yellow

    $choice = (Read-Host "Choose a menu option [1-7, A, 0]").ToUpper().Trim()
    Write-Host "`n"

    switch ($choice) {
        "1" {
            Clear-TemporaryInternetFiles
        }
        "2" {
            Clear-DirectXShaderCache
        }
        "3" {
            Clear-DeliveryOptimizationFiles
        }
        "4" {
            Clear-UserTemporaryFiles
        }
        "5" {
            Clear-SystemTemporaryFiles
        }
        "6" {
            Clear-ThumbnailsCache
        }
        "7" {
            Clear-RecycleBin
        }
        "A" {
            Write-Host "Performing ALL selected cleanup tasks..." -ForegroundColor Magenta
            Clear-TemporaryInternetFiles
            Clear-DirectXShaderCache
            Clear-DeliveryOptimizationFiles
            Clear-UserTemporaryFiles
            Clear-SystemTemporaryFiles
            Clear-ThumbnailsCache
            Clear-RecycleBin
            Write-Host "`nAll selected cleanup tasks completed." -ForegroundColor Green
        }
        "0" {
            Write-Host "Exiting Disk Cleanup. Goodbye!" -ForegroundColor Red
        }
        default {
            Write-Host "Invalid Choice. Please select a valid option." -ForegroundColor Red
        }
    }
    if ($choice -ne '0') {
        # Pause after each action (except exit) to allow user to read output
        Write-Host "`nPress any key to return to the menu..." -ForegroundColor White
        $null = Read-Host
        Clear-Host # Clear screen before showing menu again
    }
}