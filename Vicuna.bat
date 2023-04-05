@ECHO OFF

REM Calculate the number of threads in the CPU
SET /A THREADS=%NUMBER_OF_PROCESSORS%

REM Set the title of the console window
title llama.cpp (at) vicuna

REM Start an infinite loop
:start
    REM Run the main program with the calculated number of threads and other options
    C:\VICUNA\main.exe -i --interactive-first -r "### Human:" -t %THREADS% --temp 0 -c 2048 -n -1 --ignore-eos --repeat_penalty 1.2 --instruct -m C:\VICUNA\ggml-vicuna-13b-4bit.bin
    
    REM Pause the script and wait for a key to be pressed
    pause
    
    REM Go back to the start of the loop
    goto start
