# Automatic installation script for Vicuna (CPU-only)

![VICUNA CPU Script](https://aeiljuispo.cloudimg.io/v7/https://s3.amazonaws.com/moonup/production/uploads/62d35f3ceaf3858ce253ab7a/uZ2jFNAjXfdBo6c6Yojmg.jpeg?w=200&h=200&f=face)

This is a PowerShell script that automates the process of setting up and running VICUNA on a CPU (without a graphics card) using the llama.cpp library and a pre-trained ggml-vicuna-13b-4bit.bin model. The script downloads and extracts the required files, creates a batch file to run VICUNA, and creates a desktop shortcut to launch the batch file.

- Linux and macOS scripts are currently being developed and will be available in the near future.

## Requirements

- Windows operating system
- PowerShell

**Note:** The script requires a minimum of 16GB of RAM, and 32GB+ is recommended.

## Automatic installation (Recommended)
1. `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
2. `irm bit.ly/autovicuna | iex`

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
Special thanks to [SpreadSheetWarrior](https://www.youtube.com/@SpreadSheetWarrior) for their tutorial on running VICUNA on CPU.

## Acknowledgment
We would like to thank Xinyang Geng, Hao Liu, and Eric Wallace from BAIR; Xuecheng Li, and Tianyi Zhang from Stanford Alpaca team for their insightful discussion and feedback. BAIR will have another blog post soon for a concurrent effort on their chatbot, Koala.
