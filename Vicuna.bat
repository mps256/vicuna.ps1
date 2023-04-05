title llama.cpp (at) vicuna
:start
main -i --interactive-first -r "### Human:" -t 8 --temp 0 -c 2048 -n -1 --ignore-eos --repeat_penalty 1.2 --instruct -m ggml-vicuna-13b-4bit.bin
pause
goto start
