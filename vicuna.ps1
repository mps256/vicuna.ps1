# Clear the console
Clear-Host

# Define the ASCII art with green and yellow color
$art = @'
                                                              || 
        ''         by mps256 aka mps who?                    '||  
\\  //  ||  .|'', '||  ||` `||''|,   '''|.     '||''|, (''''  ||  
 \\//   ||  ||     ||  ||   ||  ||  .|''||      ||  ||  `'')  ||  
  \/   .||. `|..'  `|..'|. .||  ||. `|..||. ..  ||..|' `...' .||. 
Enjoy chatting with your new AI friend, courtesy|of vicuna.ps1!|               
'@

Write-Host $art -ForegroundColor Yellow
Write-Host "`n[#] This Uncensored Edition is like the wild west of chatbots - no rules, no limits, just you and your AI amigo!" -ForegroundColor Blue

# Set the folder path where the files will be downloaded
$folderPath = "C:\VICUNA"

# Check if the folder already exists, and create it if it doesn't
if(!(Test-Path -Path $folderPath)){
    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

# Function to display options and get user's choice for model
function Get-UserChoice {
    Write-Host "`n[#] Please choose the model you want to download:`n" -ForegroundColor Magenta
    Write-Host "[1] ggml-vicuna-7b-4bit  (6GB+  RAM - 'Cause size does matter!)" -ForegroundColor Green
    Write-Host "[2] ggml-vicuna-13b-4bit (10GB+ RAM - For those who like to go big or go home!)" -ForegroundColor Red
    $choice = Read-Host "`nEnter the number of your choice (1 or 2)"
    while ($choice -ne "1" -and $choice -ne "2") {
        Write-Host "`n[!] Invalid choice, please enter 1 or 2." -ForegroundColor Red
        $choice = Read-Host "`nEnter the number of your choice (1 or 2)"
    }
    return $choice
}

# Get the user's choice for the model
$choice = Get-UserChoice

# Set the URL and filename for the selected model
$binFileName = ""
$binFileUrl = ""
if ($choice -eq "1") {
    $binFileName = "ggml-vicuna-7b-4bit.bin"
    $binFileUrl = "https://huggingface.co/eachadea/ggml-vicuna-7b-4bit/resolve/main/ggml-vicuna-7b-4bit-rev1.bin"
} else {
    $binFileName = "ggml-vicuna-13b-4bit.bin"
    $binFileUrl = "https://huggingface.co/eachadea/ggml-vicuna-13b-4bit/resolve/main/ggml-vicuna-13b-4bit-rev1.bin"
}

# Define the SHA256 hash values for the binary files
$hashes = @{
    "ggml-vicuna-7b-4bit.bin" = "75e43fc771e20d72bd0e9a9aea3c8b12a08c8967e1f1e0bcaa8705f5d70e4841"
    "ggml-vicuna-13b-4bit.bin" = "1297c03140a795f1e62728c8de29548a79e9d00a32721d63d2dbad3aa98c74ed"
}

# Check if the binary file already exists and matches the hash, or download it if necessary
$binFilePath = "$folderPath\$binFileName"
if (Test-Path -Path $binFilePath) {
    $hash = Get-FileHash -Path $binFilePath -Algorithm SHA256 | Select-Object -ExpandProperty Hash
    if ($hash -eq $hashes[$binFileName]) {
        Write-Host "`n[-] $binFileName already exists in $folderPath and matches the expected hash`n" -ForegroundColor Yellow
    } else {
        Write-Host "`n[!] $binFileName already exists in $folderPath but does not match the expected hash" -ForegroundColor Red
        Write-Host "`n[#] Downloading $binFileName again..." -ForegroundColor Magenta
        try {
            $curl = Start-Process -FilePath "curl.exe" -ArgumentList ("-L", $binFileUrl, "--progress-bar", "--output", "$binFilePath") -PassThru -Wait -NoNewWindow
            if ($curl.ExitCode -eq 0) {
                Write-Host "    `n[#] Downloaded $binFileName to: $folderPath" -ForegroundColor Green
            } else {
                Write-Host "    `n[!] Failed to download $binFileName" -ForegroundColor Red
            }
        } catch {
            Write-Host "    `n[!]Failed to download $binFileName" -ForegroundColor Red
        }
    }
} else {
    try {
        $curl = Start-Process -FilePath "curl.exe" -ArgumentList ("-L", $binFileUrl, "--progress-bar", "--output", "$binFilePath") -PassThru -Wait -NoNewWindow
        if ($curl.ExitCode -eq 0) {
            Write-Host "[@] Downloaded $binFileName to: $folderPath" -ForegroundColor Green
        } else {
            Write-Host "Failed to download $binFileName" -ForegroundColor Red
        }
    } catch {
        Write-Host "Failed to download $binFileName" -ForegroundColor Red
    }
}

# Get the latest release of llama.cpp from Github API
$latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/ggerganov/llama.cpp/releases/latest"

# Define the supported AVX versions
$avxVersions = @("avx-x64", "avx2-x64", "avx512-x64")

# Display the available AVX versions and prompt the user to choose one
Write-Host "`n[#] Pick your CPU AVX extension (AVX Recommended for most mortals)`n" -ForegroundColor Magenta
for ($i = 0; $i -lt $avxVersions.Length; $i++) {
    Write-Host "$($i + 1). $($avxVersions[$i])" -ForegroundColor Cyan
}
$avxVersionChoice = Read-Host "`nEnter the number of your choice (1-$($avxVersions.Length))"
while ($avxVersionChoice -lt 1 -or $avxVersionChoice -gt $avxVersions.Length) {
    Write-Host "`n[!] Invalid choice, please enter a number between 1 and $($avxVersions.Length)." -ForegroundColor Red
    $avxVersionChoice = Read-Host "Enter the number of your choice (1-$($avxVersions.Length))"
}
$avxVersion = $avxVersions[$avxVersionChoice - 1]

# Determine the URL and filename for the chosen version of llama.cpp
$llamaVersionUrl = ($latestRelease.assets | Where-Object { $_.name -like "*-$avxVersion.zip" }).browser_download_url
$llamaVersionFilename = "llama-$($latestRelease.tag_name)-$avxVersion.zip"

# Download llama.cpp
$llamaVersionExtractPath = "$folderPath\llama.cpp"
if(Test-Path -Path "$folderPath\$llamaVersionFilename") {
    Write-Host "`n[-] $llamaVersionFilename already exists in $folderPath`n" -ForegroundColor Yellow
} else {
    try {
        Invoke-WebRequest -Uri $llamaVersionUrl -OutFile "$folderPath\$llamaVersionFilename"
        Write-Host "`n[#] Downloaded llama.cpp ($($latestRelease.tag_name)) ($avxVersion) to: $folderPath" -ForegroundColor Green
    } catch {
        Write-Host "`n[!] Failed to download llama.cpp ($($latestRelease.tag_name)) ($avxVersion)"
        Exit
    }
}

# Extract the contents of llama.zip
if(Test-Path -Path "$llamaVersionExtractPath\main.exe") {
    Write-Host "`n[-] llama.cpp ($($latestRelease.tag_name)) ($avxVersion) and its contents are already extracted to: $llamaVersionExtractPath" -ForegroundColor Yellow
} else {
    try {
        Expand-Archive -Path "$folderPath\$llamaVersionFilename" -DestinationPath $llamaVersionExtractPath -Force
        Write-Host "`n[#] Extracted llama.cpp ($($latestRelease.tag_name)) ($avxVersion) contents to: $llamaVersionExtractPath" -ForegroundColor Green
    } catch {
        Write-Host "`n[!] Failed to extract llama.cpp ($($latestRelease.tag_name)) ($avxVersion) contents" -ForegroundColor Red
        Exit
    }
}

# Define the contents of the VICUNA batch file
if ($choice -eq "1") {
    $modelSize = "7b"
} else {
    $modelSize = "13b"
}

$vicunaBatchFile = @"
@ECHO OFF

REM Calculate the number of threads in the CPU
SET /A THREADS=%NUMBER_OF_PROCESSORS%

REM Set the title of the console window
title llama.cpp (at) vicuna by mps256

REM Start an infinite loop
:start
    REM Run the main program with the calculated number of threads and other options
    C:\VICUNA\llama.cpp\main.exe -i --interactive-first -r "### Human:" -t %THREADS% --temp 0 --color -c 2048 -n -1 --ignore-eos --repeat_penalty 1.2 --instruct -m C:\VICUNA\ggml-vicuna-$modelSize-4bit.bin
    
    REM Pause the script and wait for a key to be pressed
    pause
    
    REM Go back to the start of the loop
    goto start
"@

# Save the VICUNA batch file to disk
$vicunaBatchFilePath = "$folderPath\VicunaLauncher.bat"
$vicunaBatchFile | Out-File -Encoding ascii -FilePath $vicunaBatchFilePath

# Display a message on the console
Write-Host "`n[#] Created VicunaLauncher.bat at: $vicunaBatchFilePath" -ForegroundColor Green

# Download the icon file
$iconFileUrl = "https://raw.githubusercontent.com/mps256/autovicuna/main/icon.ico"
$iconFilePath = "$folderPath\icon.ico"
Invoke-WebRequest -Uri $iconFileUrl -OutFile $iconFilePath

# Apply the icon to the shortcut
$shortcutLocation = "$([Environment]::GetFolderPath('Desktop'))\Vicuna Launcher.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutLocation)
$Shortcut.TargetPath = "$folderPath\VicunaLauncher.bat"
$shortcut.IconLocation = $iconFilePath
$shortcut.Save()

Write-Host "`n[#] Everything is done! You can now use Vicuna by running 'Vicuna Launcher' on your desktop." -ForegroundColor Magenta
