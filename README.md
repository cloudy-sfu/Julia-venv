# Julia config

![](https://shields.io/badge/dependencies-Julia-purple)
![](https://shields.io/badge/dependencies-Powershell_7-navy)
![](https://shields.io/badge/OS-Windows_10_64--bit-navy)

## Usage

### Build & run

To run a Julia script or open Julia interactive dialog, run `build_run.ps1` followed by arguments in Windows PowerShell 5.1.

This program uses [Powershell style arguments](https://gist.github.com/cloudy-sfu/dce5106496125096092c7a7cc7846f7b).

Arguments:

| Name        | Description                                                 | Required?                                         |
| ----------- | ----------------------------------------------------------- | ------------------------------------------------- |
| `-script`   | The relative path of any Julia script in the Julia project. | *Optional*  default: enter interactive Julia REPL |
| `-base_dir` | The root folder of Julia project.                           | *Optional*  default: the current folder           |
| `-julia_path` | The absolute path to the `julia.exe` executable.            | *Optional*  default: auto-detects installation    |

It is recommended to copy `build_run.ps1` to Julia project. Therefore `base_dir` is current directory, `script` is the relative path to program's root folder, and `base_dir` can be left blank.

Behaviors:

1. The files `Manifest.toml` and `Project.toml` will be automatically generated in `base_dir` . 
2. It will use the provided `-julia_path`, or automatically search Julia instances in `$env:LOCALAPPDATA\Programs` (`$env:` means environment variables). If an instance is not found, the terminal will hint and require the user to manually input the absolute path of Julia.
3. If multiple Julia are installed in the default folder, the latest version will be used.

To run the script in active tab in Visual Studio Code, 

1. Copy the following files to corresponding address relative to the Julia program's root folder.
    ```
    .vscode/tasks.json
    build_run.ps1
    ```
2. Press `Ctrl + Shift + P` and find "Tasks: Run Build Task", choose this action.

### Pluto

To open Pluto notebook in `base_dir`, run `pluto.ps1` followed by arguments in Windows PowerShell 5.1.

*If Pluto is not installed, this script will automatically install it.*

This program uses [Powershell style arguments](https://gist.github.com/cloudy-sfu/dce5106496125096092c7a7cc7846f7b).

Arguments:

| Name        | Description                       | Required?                               |
| ----------- | --------------------------------- | --------------------------------------- |
| `-base_dir` | The root folder of Julia project. | *Optional*  default: the current folder |
| `-julia_path` | The absolute path to the `julia.exe` executable.            | *Optional*  default: auto-detects installation    |

In the Pluto home page, the dropdown of "Open a notebook" list files in `base_dir`.

To clear the "My work" list, open the F12 console in browser and run the following command.

```javascript
localStorage.clear()
```

