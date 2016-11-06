#define AppName "The Spelling Bee"
#define AppExeName "SpellingBee.exe"
#define SourcePath "C:\Users\Tim\Documents\STLScatterjam2016\export\windows\cpp\bin"
;#define AppVersion GetFileVersion(AddBackslash(SourcePath) + AppExeName)
#define AppVersion "1.0.0.0"
#define AppPublisher "Too Many Tims"

[Setup]
AppID={{14A0320E-E91F-4945-864D-79EF96A23D84}
OutputDir=C:\Users\Tim\Documents\STLScatterjam2016\Setups
AppName={#AppName}
AppPublisher={#AppPublisher}
AppVersion={#AppVersion}
SourceDir={#SourcePath}
DefaultDirName={pf}\{#AppName}
DefaultGroupName={#AppName}
AllowNoIcons=yes
OutputBaseFilename={#AppName}-Install


[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#AppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#SourcePath}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs


[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: desktopicon



[Run]
Filename: "{app}\{#AppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(AppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

