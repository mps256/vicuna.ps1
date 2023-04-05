# Print a message to the console
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

# Download ggml-vicuna-13b-4bit.bin
try {
    Invoke-WebRequest -Uri "https://huggingface.co/eachadea/ggml-vicuna-13b-4bit/blob/main/ggml-vicuna-13b-4bit.bin" -OutFile "$folderPath\ggml-vicuna-13b-4bit.bin"
    Write-Host "Downloaded ggml-vicuna-13b-4bit.bin to: $folderPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to download ggml-vicuna-13b-4bit.bin" -ForegroundColor Red
}

# Download llama.cpp
try {
    Invoke-WebRequest -Uri "https://github.com/ggerganov/llama.cpp/releases/download/v1.1.3/llama-master-1.1.3-bin-win-avx-x64.zip" -OutFile "$folderPath\llama.zip"
    Write-Host "Downloaded llama.cpp to: $folderPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to download llama.cpp" -ForegroundColor Red
}

# Extract the contents of llama.zip
try {
    Expand-Archive -Path "$folderPath\llama.zip" -DestinationPath "$folderPath"
    Write-Host "Extracted llama.cpp contents to: $folderPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to extract llama.cpp" -ForegroundColor Red
}

# Create a batch file to run VICUNA
try {
    Set-Content -Path "$folderPath\VICUNA.bat" -Value "@echo off`n$folderPath\llama-master-1.1.3-bin-win-avx-x64\llama.exe -b $folderPath\ggml-vicuna-13b-4bit.bin -n 1 -w 256 -h 256"
    Write-Host "Created VICUNA batch file at: $folderPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to create VICUNA batch file" -ForegroundColor Red
}

# Create a shortcut on the desktop
try {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$([Environment]::GetFolderPath('Desktop'))\VICUNA.lnk")
    $Shortcut.TargetPath = "$folderPath\VICUNA.bat"
    $Shortcut.Save()
    Write-Host "Created desktop shortcut for VICUNA at: $([Environment]::GetFolderPath('Desktop'))\VICUNA.lnk" -ForegroundColor Green
} catch {
    Write-Host "Failed to create desktop shortcut for VICUNA" -ForegroundColor Red
}

# Run the batch file
try {
    Start-Process -FilePath "$folderPath\VICUNA.bat"
    Write-Host "Started VICUNA batch file" -ForegroundColor Green
} catch
