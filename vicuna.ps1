# Print a message to the console
Write-Host "Welcome to AutoVicuna! :)" -ForegroundColor Yellow
Write-Host "Creating the VICUNA folder on C:\" -ForegroundColor Green

# Set the folder path where the files will be downloaded
$folderPath = "C:\VICUNA"

# Check if the folder already exists, and create it if it doesn't
if(!(Test-Path -Path $folderPath)){
    New-Item -ItemType Directory -Path $folderPath | Out-Null
    Write-Host "Created folder: $folderPath" -ForegroundColor Green
} else {
    Write-Host "Folder already exists: $folderPath" -ForegroundColor Yellow
}

# Check if ggml-vicuna-13b-4bit.bin exists, and download it if it doesn't
$binFilePath = "$folderPath\ggml-vicuna-13b-4bit.bin"
if (Test-Path -Path $binFilePath) {
    Write-Host "ggml-vicuna-13b-4bit.bin already exists in $folderPath" -ForegroundColor Yellow
} else {
    try {
        $curl = Start-Process -FilePath "curl.exe" -ArgumentList ("-L", "https://huggingface.co/eachadea/ggml-vicuna-13b-4bit/resolve/21f7ca7aa5ca344f18f7d1d56c14c7d210f17d52/ggml-vicuna-13b-4bit.bin", "-o", "$binFilePath") -PassThru -Wait
        if ($curl.ExitCode -eq 0) {
            Write-Host "Downloaded ggml-vicuna-13b-4bit.bin to: $folderPath" -ForegroundColor Green
        } else {
            Write-Host "Failed to download ggml-vicuna-13b-4bit.bin" -ForegroundColor Red
        }
    } catch {
        Write-Host "Failed to download ggml-vicuna-13b-4bit.bin" -ForegroundColor Red
    }
}

# Check if llama.zip and its contents are already downloaded
if((Test-Path -Path "$folderPath\llama.zip") -and (Test-Path -Path "$folderPath\test-tokenizer-0.exe")) {
    Write-Host "llama.zip and its contents are already downloaded to: $folderPath" -ForegroundColor Yellow
} else {
    # Download llama.cpp
    try {
        Invoke-WebRequest -Uri "https://github.com/ggerganov/llama.cpp/releases/download/master-cd7fa95/llama-master-cd7fa95-bin-win-avx-x64.zip" -OutFile "$folderPath\llama.zip"
        Write-Host "Downloaded llama.zip to: $folderPath" -ForegroundColor Green
    } catch {
        Write-Host "Failed to download llama.zip" -ForegroundColor Red
    }

    # Extract the contents of llama.zip
    try {
        Expand-Archive -Path "$folderPath\llama.zip" -DestinationPath "$folderPath" -Force
        Write-Host "Extracted llama.cpp contents to: $folderPath" -ForegroundColor Green
    } catch {
        Write-Host "Failed to extract llama.cpp" -ForegroundColor Red
    }
}

# Download the Vicuna.bat file
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mps256/autovicuna/main/Vicuna.bat" -OutFile "$folderPath\Vicuna.bat"
    Write-Host "Downloaded Vicuna.bat to: $folderPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to download Vicuna.bat" -ForegroundColor Red
}

# Download icon file
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mps256/autovicuna/main/icon.ico" -OutFile "$folderPath\icon.ico"
    Write-Host "Downloaded icon file to: $folderPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to download icon file" -ForegroundColor Red
}

# Create a shortcut on the desktop with icon
try {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$([Environment]::GetFolderPath('Desktop'))\VICUNA.lnk")
    $Shortcut.TargetPath = "$folderPath\VICUNA.bat"
    $Shortcut.IconLocation = "$folderPath\icon.ico"
    $Shortcut.Save()
    Write-Host "Created desktop shortcut for VICUNA at: $([Environment]::GetFolderPath('Desktop'))\VICUNA.lnk" -ForegroundColor Green
} catch {
    Write-Host "Failed to create desktop shortcut for VICUNA" -ForegroundColor Red
}

Write-Host "Everything's done! Open up 'Vicuna' in your desktop!" -ForegroundColor Cyan
