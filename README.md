![VICUNA CPU Script](https://aeiljuispo.cloudimg.io/v7/https://s3.amazonaws.com/moonup/production/uploads/62d35f3ceaf3858ce253ab7a/uZ2jFNAjXfdBo6c6Yojmg.jpeg?w=200&h=200&f=face)

# Automatic installation script for Vicuna (CPU-only)

 Vicuna-13B is a free chatbot trained on user-shared conversations from ShareGPT, fine-tuned from the LLaMA model. It outperformed other models like OpenAI ChatGPT, Google Bard, LLaMA, and Stanford Alpaca in more than 90% of cases. 



* This is a PowerShell script that automates the process of setting up and running VICUNA on a CPU (without a graphics card) using the llama.cpp library and a pre-trained ggml-vicuna-13b-4bit.bin model. The script downloads and extracts the required files, creates a batch file to run VICUNA, and creates a desktop shortcut to launch the batch file.

* ChatGPT 4 note below:
![GPT4 Response](https://i.imgur.com/DEmSt3g.png)

- Linux and macOS scripts are currently being developed and will be available in the near future.

## Requirements

- Windows operating system
- PowerShell

**Note:** The script requires a minimum of 10GB of RAM (slow), and 32GB+ (medium to fast speeds) is recommended.

 `speed = 2 * log2(ram_gb / 10) + 1`

            |       Speed
            |   Slow   Medium    Fast 
         -----------------------------
            |         
        3   |          
            |          
        2   |        * 
            |    *     
        1   | *        
            |_____________________________
                 10GB      32GB+       RAM

- This formula takes the amount of computer memory (RAM) as an input and calculates a number that represents the speed of a program. The more RAM you have, the faster the program will run.

## Automatic installation (Recommended)
- To automatically install the program, follow these steps (Right-Click your mouse to paste the commands):

1. Press `Windows` + `R`, type `powershell`, and hit enter.
2. Type `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`, press Y, and hit enter.
3. Type `irm bit.ly/autovicuna | iex` and hit enter.

## Manual installation (Optional)
1. Download the `vicuna-cpu.ps1` script to your computer.
2. Open PowerShell and navigate to the directory where the script is saved.
3. Run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` to allow remote scripts.
4. Run the script using the command `.\vicuna-cpu.ps1`.
5. Follow the on-screen instructions to complete the setup process.
6. Once setup is complete, double-click the "VICUNA" shortcut on your desktop to run VICUNA.

## Planned Features

- Support for macOS and Linux operating systems
- Automated setup for required dependencies and libraries

## Troubleshooting

If you encounter any issues while running the script, please check the following:

- Ensure that your computer meets the minimum RAM requirements.
- Check that PowerShell is running as an administrator.
- Ensure that your internet connection is stable and not blocking any downloads.
- Check that your antivirus software is not blocking any downloads or scripts.

If you continue to experience issues, please contact the developer for assistance.

# Credits

This is a joint effort with collaborators from multiple institutions, including UC Berkeley, CMU, Stanford, UC San Diego, and MBZUAI.

Students (alphabetical order):
Wei-Lin Chiang, Zhuohan Li, Zi Lin, Ying Sheng, Zhanghao Wu, Hao Zhang, Lianmin Zheng, Siyuan Zhuang, Yonghao Zhuang

Advisors (alphabetical order):
Joseph E. Gonzalez, Ion Stoica, Eric P. Xing
[LMSYS](https://vicuna.lmsys.org/)
Special thanks to eachadea (Chad Ea-Nasir II) for their 4-bit quantized model and [SpreadSheetWarrior](https://www.youtube.com/@SpreadSheetWarrior) for their tutorial on running VICUNA on CPU.

## Acknowledgment
We would like to thank Xinyang Geng, Hao Liu, and Eric Wallace from BAIR; Xuecheng Li, and Tianyi Zhang from Stanford Alpaca team for their insightful discussion and feedback. BAIR will have another blog post soon for a concurrent effort on their chatbot, Koala.
