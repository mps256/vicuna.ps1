# Clears everything
Clear-Host

# Define the ASCII art with green and yellow color
$art = @'
[1;32m                ___                   
      /\        | |                  
     /  \  _   _| |_ ___             
    / /\ \| | | | __/ _ \            
   / ____ \ |_| | || (_) |           
  /_/    \_\__,_|\__\___/            
 [1;33m \ \    / (_)                       
   \ \  / / _  ___ _   _ _ __   __ _ 
    \ \/ / | |/ __| | | | '_ \ / _` |
     \  /  | | (__| |_| | | | | (_| |
      \/   |_|\___|\__,_|_| |_|\__,_|
                                    
'@

# Save the console foreground and background colors
$fgColor = $host.ui.RawUI.ForegroundColor
$bgColor = $host.ui.RawUI.BackgroundColor

# Set the console foreground color to green, background color to black and write the ASCII art to the console
$host.ui.RawUI.ForegroundColor = 'Cyan'
$host.ui.RawUI.BackgroundColor = 'Black'
Write-Host $art

# Print a message to the console
Write-Host "[#] Welcome to AutoVicuna, an automated installer for Vicuna`n" -ForegroundColor Magenta

Write-Host "[+] Creating the VICUNA folder on C:\" -ForegroundColor Green

# Set the folder path where the files will be downloaded
$folderPath = "C:\VICUNA"

# Check if the folder already exists, and create it if it doesn't
if(!(Test-Path -Path $folderPath)){
    New-Item -ItemType Directory -Path $folderPath | Out-Null
    Write-Host "`n[+] Created folder: $folderPath" -ForegroundColor Green
} else {
    Write-Host "`n[!] Folder already exists: $folderPath" -ForegroundColor Yellow
}

# Function to display options and get user's choice
function Get-UserChoice {
    Write-Host "`nPlease choose the model you want to download:" -ForegroundColor Cyan
    Write-Host "`n1. ggml-vicuna-7b-4bit  (6GB+  RAM - Recommended for most users)" -ForegroundColor Yellow
    Write-Host "2. ggml-vicuna-13b-4bit (10GB+ RAM - For mid and high end PCs)" -ForegroundColor Yellow

    $choice = Read-Host "`nEnter the number of your choice (1 or 2)"
    while ($choice -ne "1" -and $choice -ne "2") {
        Write-Host "`n[-] Invalid choice, please enter 1 or 2." -ForegroundColor Red
        $choice = Read-Host "`nEnter the number of your choice (1 or 2)"
    }
    return $choice
}

$choice = Get-UserChoice

# Download the selected model
$binFileName = ""
$binFileUrl = ""
if ($choice -eq "1") {
    $binFileName = "ggml-vicuna-7b-4bit.bin"
    $binFileUrl = "https://huggingface.co/eachadea/ggml-vicuna-7b-4bit/resolve/main/ggml-vicuna-7b-4bit-rev1.bin"
} else {
    $binFileName = "ggml-vicuna-13b-4bit.bin"
    $binFileUrl = "https://huggingface.co/eachadea/ggml-vicuna-13b-4bit/resolve/main/ggml-vicuna-13b-4bit-rev1.bin"
}

$binFilePath = "$folderPath\$binFileName"
if (Test-Path -Path $binFilePath) {
    Write-Host "`n[!] $binFileName already exists in $folderPath" -ForegroundColor Yellow
} else {
    try {
        $curl = Start-Process -FilePath "curl.exe" -ArgumentList ("-L", $binFileUrl, "-o", "$binFilePath") -PassThru -Wait
        if ($curl.ExitCode -eq 0) {
            Write-Host "Downloaded $binFileName to: $folderPath" -ForegroundColor Green
        } else {
            Write-Host "Failed to download $binFileName" -ForegroundColor Red
        }
    } catch {
        Write-Host "Failed to download $binFileName" -ForegroundColor Red
    }
}

# Get the latest release of llama.cpp
$latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/ggerganov/llama.cpp/releases/latest"
$latestTag = $latestRelease.tag_name
$latestReleaseDate = [datetime]::Parse($latestRelease.published_at).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")

# Define the supported AVX versions
$avxVersions = @(
    "avx-x64",
    "avx2-x64",
    "avx512-x64"
)

# Display the available AVX versions
Write-Host "`nPlease choose the AVX version to download (AVX recommended for most users):`n" -ForegroundColor Cyan
for ($i = 0; $i -lt $avxVersions.Length; $i++) {
    Write-Host "$($i + 1). $($avxVersions[$i])" -ForegroundColor Yellow
}

# Prompt the user to choose the AVX version
$avxVersionChoice = Read-Host "`nEnter the number of your choice (1-$($avxVersions.Length))"
while ($avxVersionChoice -lt 1 -or $avxVersionChoice -gt $avxVersions.Length) {
    Write-Host "[-] Invalid choice, please enter a number between 1 and $($avxVersions.Length)." -ForegroundColor Red
    $avxVersionChoice = Read-Host "Enter the number of your choice (1-$($avxVersions.Length))"
}
$avxVersion = $avxVersions[$avxVersionChoice - 1]

# Determine the URL and filename for the chosen version of llama.cpp
$llamaVersionUrl = ($latestRelease.assets | Where-Object { $_.name -like "*-$avxVersion.zip" }).browser_download_url
$llamaVersionFilename = "llama-$latestTag-$avxVersion.zip"

# Check if llama.zip and its contents are already downloaded
if((Test-Path -Path "$folderPath\$llamaVersionFilename") -and (Test-Path -Path "$folderPath\llama-$latestTag-$avxVersion\test-tokenizer-0.exe")) {
    Write-Host "`n[!] llama.cpp ($latestTag) ($avxVersion) and its contents are already downloaded to: $folderPath`n" -ForegroundColor Yellow
} else {
    # Download llama.cpp
    try {
        Invoke-WebRequest -Uri $llamaVersionUrl -OutFile "$folderPath\$llamaVersionFilename"
        Write-Host "`n[+] Downloaded llama.cpp ($latestTag) ($avxVersion) to: $folderPath`n" -ForegroundColor Green
    } catch {
        Write-Host "[!] Failed to download llama.cpp ($latestTag) ($avxVersion)" -ForegroundColor Red
        Exit
    }
}

# Display the latest tag and release date of llama.cpp
Write-Host "[#] Latest version of llama.cpp: $latestTag" -ForegroundColor Magenta
Write-Host "[#] Released on: $latestReleaseDate" -ForegroundColor Magenta

# Extract the contents of llama.zip
$llamaVersionExtractPath = "$folderPath\llama-master-$latestTag-$llamaVersionChoice-x64"
if((Test-Path -Path $llamaVersionExtractPath) -and (Test-Path -Path "$llamaVersionExtractPath\test-tokenizer-0.exe")) {
    Write-Host "`n[!] llama.cpp ($latestTag) ($llamaVersionChoice) and its contents are already extracted to: $llamaVersionExtractPath" -ForegroundColor Yellow
} else {
    try {
        Expand-Archive -Path "$folderPath\$llamaVersionFilename" -DestinationPath $llamaVersionExtractPath -Force
        Write-Host "`n[+] Extracted llama.cpp ($latestTag) ($llamaVersionChoice) contents to: $llamaVersionExtractPath" -ForegroundColor Green
    } catch {
        Write-Host "`n[!] Failed to extract llama.cpp ($latestTag) ($llamaVersionChoice) contents" -ForegroundColor Red
        Exit
    }
}

# Download the Vicuna.bat file
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mps256/autovicuna/main/Vicuna.bat" -OutFile "$folderPath\Vicuna.bat"
    Write-Host "`n[+] Downloaded Vicuna.bat to: $folderPath" -ForegroundColor Green
} catch {
    Write-Host "`n[!] Failed to download Vicuna.bat" -ForegroundColor Red
}

# Download icon file
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mps256/autovicuna/main/icon.ico" -OutFile "$folderPath\icon.ico"
    Write-Host "`n[+] Downloaded icon file to: $folderPath" -ForegroundColor Green
} catch {
    Write-Host "`n[!] Failed to download icon file" -ForegroundColor Red
}

# Create a shortcut on the desktop with icon
try {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$([Environment]::GetFolderPath('Desktop'))\VICUNA.lnk")
    $Shortcut.TargetPath = "$folderPath\VICUNA.bat"
    $Shortcut.IconLocation = "$folderPath\icon.ico"
    $Shortcut.Save()
    Write-Host "`n[+] Created desktop shortcut for VICUNA at: $([Environment]::GetFolderPath('Desktop'))\VICUNA.lnk" -ForegroundColor Green
} catch {
    Write-Host "`n[!] Failed to create desktop shortcut for VICUNA" -ForegroundColor Red
}

Write-Host "`n[#] Everything's done! Open up 'Vicuna' in your desktop!" -ForegroundColor Magenta

# Set console foreground and background colors to their original state
$host.ui.RawUI.ForegroundColor = $host.ui.RawUI.ForegroundColor
$host.ui.RawUI.BackgroundColor = $host.ui.RawUI.BackgroundColor
