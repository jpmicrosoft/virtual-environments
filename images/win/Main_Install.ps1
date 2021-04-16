        # "root_folder": "C:",
        # "toolset_json_path": "{{env `TEMP`}}\\toolset.json",
        # "image_folder": "C:\\image",
        # "imagedata_file": "C:\\imagedata.json",
        # "helper_script_folder": "C:\\Program Files\\WindowsPowerShell\\Modules\\",
        # "psmodules_root_folder": "C:\\Modules",
        # "agent_tools_directory": "C:\\hostedtoolcache\\windows",
        # "install_user": "installer",
        # "install_password": null,
        # "capture_name_prefix": "packer",
        # "image_version": "dev",
        # "image_os": "win19"

powershell -ExecutionPolicy Unrestricted ; $helper_script_folder = "C:\Program Files\WindowsPowerShell\Modules\"; Set-location -Path C:\ ; md deploytemp -Force; Set-location -Path C:\ ; md image -Force ; Set-location -Path C:\ ; md Modules -Force; Set-location -Path C:\ ; md hostedtoolcache\windows  -Force; $ImageHelpers = Get-ChildItem -Path C:\Packages\\Plugins\Microsoft.Compute.CustomScriptExtension -Include ImageHelpers.zip -File -Recurse; $Extractit = $ImageHelpers.DirectoryName + '\ImageHelpers.zip'; Expand-Archive -Path $Extractit -DestinationPath $helper_script_folder -Force; $SoftwareReport = Get-ChildItem -Path C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension -Include SoftwareReport.zip -File -Recurse; $Extractit = $SoftwareReport.DirectoryName + '\SoftwareReport.zip'; Expand-Archive -Path $Extractit -DestinationPath C:\image -Force; $postgeneration = Get-ChildItem -Path C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension -Include postgeneration.zip -File -Recurse; $Extractit = $postgeneration.DirectoryName + '\postgeneration.zip'; Expand-Archive -Path $Extractit -DestinationPath C:\ -Force; $Tests = Get-ChildItem -Path C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension -Include Tests.zip -File -Recurse; $Extractit = $Tests.DirectoryName + '\Tests.zip'; Expand-Archive -Path $Extractit -DestinationPath C:\image -Force; # $Installers = Get-ChildItem -Path C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension -Include Installers.zip -File -Recurse; $Extractit = $Installers.DirectoryName + '\Installers.zip'; Set-location -Path C:\ ; md Installers -Force ;Expand-Archive -Path $Extractit -DestinationPath C:\Installers -Force;


        {
            "type": "file",
            "source": "{{template_dir}}/toolsets/toolset-2019.json",
            "destination": "{{user `toolset_json_path`}}"
        },

        {
            "type": "powershell",
            "environment_vars": [
                "IMAGE_VERSION={{user `image_version`}}",
                "IMAGE_OS={{user `image_os`}}",
                "AGENT_TOOLSDIRECTORY={{user `agent_tools_directory`}}",
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}",
                "PSMODULES_ROOT_FOLDER={{user `psmodules_root_folder`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-PowerShellModules.ps1",
                "{{ template_dir }}/scripts/Installers/Initialize-VM.ps1",
                "{{ template_dir }}/scripts/Installers/Install-WebPlatformInstaller.ps1"
            ],
            "execution_policy": "unrestricted"
        },
        {
            "type": "powershell",
            "elevated_user": "SYSTEM",
            "elevated_password": "",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Windows2019/Install-WSL.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Update-DotnetTLS.ps1",
                "{{ template_dir }}/scripts/Installers/Install-ContainersFeature.ps1"
            ]
        },
        {
            "type": "windows-restart",
            "restart_timeout": "10m"
        },
        {
            "type": "powershell",
            "environment_vars": [
                "IMAGE_VERSION={{user `image_version`}}",
                "IMAGEDATA_FILE={{user `imagedata_file`}}",
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Update-ImageData.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Docker.ps1",
                "{{ template_dir }}/scripts/Installers/Install-PowershellCore.ps1"
            ]
        },
        {
            "type": "windows-restart",
            "restart_timeout": "10m"
        },
        {
            "type": "powershell",
            "valid_exit_codes": [
                0,
                3010
            ],
            "environment_vars": [
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Update-DockerImages.ps1",
                "{{ template_dir }}/scripts/Installers/Install-KubernetesTools.ps1",
                "{{ template_dir }}/scripts/Installers/Install-VS.ps1",
                "{{ template_dir }}/scripts/Installers/Install-NET48.ps1"
            ],
            "elevated_user": "{{user `install_user`}}",
            "elevated_password": "{{user `install_password`}}"
        },
        {
            "type": "powershell",
            "environment_vars": [
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-Nuget.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Wix.ps1",
                "{{ template_dir }}/scripts/Installers/Install-WDK.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Vsix.ps1",
                "{{ template_dir }}/scripts/Installers/Install-AzureCli.ps1",
                "{{ template_dir }}/scripts/Installers/Install-AzureDevOpsCli.ps1",
                "{{ template_dir }}/scripts/Installers/Install-AzCopy.ps1",
                "{{ template_dir }}/scripts/Installers/Install-AzureDevSpacesCli.ps1",
                "{{ template_dir }}/scripts/Installers/Install-NodeLts.ps1",
                "{{ template_dir }}/scripts/Installers/Install-7zip.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Packer.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Pulumi.ps1",
                "{{ template_dir }}/scripts/Installers/Install-JavaTools.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-ServiceFabricSDK.ps1"
            ],
            "execution_policy": "remotesigned"
        },
        {
            "type": "windows-restart",
            "restart_timeout": "10m"
        },
        {
            "type": "windows-shell",
            "inline": [
                "wmic product where \"name like '%%microsoft azure powershell%%'\" call uninstall /nointeractive"
            ]
        },
        {
            "type": "powershell",
            "environment_vars": [
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}",
                "ROOT_FOLDER={{user `root_folder`}}",
                "PSMODULES_ROOT_FOLDER={{user `psmodules_root_folder`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-Ruby.ps1",
                "{{ template_dir }}/scripts/Installers/Install-PyPy.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Toolset.ps1",
                "{{ template_dir }}/scripts/Installers/Configure-Toolset.ps1",
                "{{ template_dir }}/scripts/Installers/Update-AndroidSDK.ps1",
                "{{ template_dir }}/scripts/Installers/Install-AzureModules.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Pipx.ps1",
                "{{ template_dir }}/scripts/Installers/Install-PipxPackages.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-OpenSSL.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Perl.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Git.ps1",
                "{{ template_dir }}/scripts/Installers/Install-GitHub-CLI.ps1",
                "{{ template_dir }}/scripts/Installers/Install-PHP.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Rust.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Julia.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Sbt.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Svn.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Chrome.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Edge.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Firefox.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Selenium.ps1",
                "{{ template_dir }}/scripts/Installers/Install-IEWebDriver.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Apache.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Nginx.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Enable-DeveloperMode.ps1"
            ],
            "elevated_user": "{{user `install_user`}}",
            "elevated_password": "{{user `install_password`}}"
        },
        {
            "type": "powershell",
            "elevated_user": "SYSTEM",
            "elevated_password": "",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-Msys2.ps1"
            ]
        },
        {
            "type": "powershell",
            "environment_vars": [
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-VSWhere.ps1",
                "{{ template_dir }}/scripts/Installers/Install-WinAppDriver.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Cmake.ps1",
                "{{ template_dir }}/scripts/Installers/Install-R.ps1",
                "{{ template_dir }}/scripts/Installers/Install-AWS.ps1",
                "{{ template_dir }}/scripts/Installers/Install-DACFx.ps1",
                "{{ template_dir }}/scripts/Installers/Install-MysqlCli.ps1",
                "{{ template_dir }}/scripts/Installers/Install-SQLPowerShellTools.ps1",
                "{{ template_dir }}/scripts/Installers/Install-DotnetSDK.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Mingw64.ps1",
                "{{ template_dir }}/scripts/Installers/Install-TypeScript.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Haskell.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Stack.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Miniconda.ps1",
                "{{ template_dir }}/scripts/Installers/Install-AzureCosmosDbEmulator.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Mercurial.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Jq.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Zstd.ps1",
                "{{ template_dir }}/scripts/Installers/Install-InnoSetup.ps1",
                "{{ template_dir }}/scripts/Installers/Install-GitVersion.ps1",
                "{{ template_dir }}/scripts/Installers/Install-NSIS.ps1",
                "{{ template_dir }}/scripts/Installers/Install-CloudFoundryCli.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Vcpkg.ps1",
                "{{ template_dir }}/scripts/Installers/Install-PostgreSQL.ps1",
                "{{ template_dir }}/scripts/Installers/Install-Bazel.ps1",
                "{{ template_dir }}/scripts/Installers/Install-AliyunCli.ps1",
                "{{ template_dir }}/scripts/Installers/Install-RootCA.ps1",
                "{{ template_dir }}/scripts/Installers/Install-MongoDB.ps1",
                "{{ template_dir }}/scripts/Installers/Install-GoogleCloudSDK.ps1",
                "{{ template_dir }}/scripts/Installers/Install-CodeQLBundle.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-BizTalkBuildComponent.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Install-WindowsUpdates.ps1",
                "{{ template_dir }}/scripts/Installers/Configure-DynamicPort.ps1",
                "{{ template_dir }}/scripts/Installers/Configure-GDIProcessHandleQuota.ps1",
                "{{ template_dir }}/scripts/Installers/Configure-Shell.ps1"
            ],
            "elevated_user": "{{user `install_user`}}",
            "elevated_password": "{{user `install_password`}}"
        },
        {
            "type": "windows-restart",
            "restart_timeout": "30m"
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Tests/RunAll-Tests.ps1"
            ],
            "environment_vars": [
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}",
                "PSMODULES_ROOT_FOLDER={{user `psmodules_root_folder`}}",
                "ROOT_FOLDER={{user `root_folder`}}"
            ]
        },
        {
            "type": "powershell",
            "inline": [
                "pwsh -File '{{user `image_folder`}}\\SoftwareReport\\SoftwareReport.Generator.ps1'"
            ],
            "environment_vars": [
                "IMAGE_VERSION={{user `image_version`}}",
                "TOOLSET_JSON_PATH={{user `toolset_json_path`}}"
            ]
        },
        {
            "type": "file",
            "source": "C:\\InstalledSoftware.md",
            "destination": "{{ template_dir }}/Windows2019-Readme.md",
            "direction": "download"
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Finalize-VM.ps1"
            ]
        },
        {
            "type": "windows-restart",
            "restart_timeout": "10m"
        },
        {
            "type": "powershell",
            "environment_vars": [
                "RUN_SCAN_ANTIVIRUS={{user `run_scan_antivirus`}}"
            ],
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Run-Antivirus.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Configure-Antivirus.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Disable-JITDebugger.ps1"
            ]
        },
        {
            "type": "powershell",
            "scripts": [
                "{{ template_dir }}/scripts/Installers/Run-NGen.ps1"
            ]
        },
        {
            "type": "powershell",
            "inline": [
                "if( Test-Path $Env:SystemRoot\\System32\\Sysprep\\unattend.xml ){ rm $Env:SystemRoot\\System32\\Sysprep\\unattend.xml -Force}",
                "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit",
                "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
            ]
        }
    ]
}
