; This is a simple innosetup script to create an installer
; out of the example Java application

#include "env.iss"
#ifndef Version
  #define Version = '0.0.0';
#endif
#define MyAppName "example-app"
#define MyAppGroupName "example-app"
#define MyAppPublisher "Arius"
#define MyAppPublisherURL "https://github.com/phasza"
#define SourceRootDirectory "..\..\bin\example-app"
#define IcoResource "example.ico"

[Setup]
AppID=ExampleAppID
AppName={#MyAppName}
AppVersion={#Version}
AppVerName={#MyAppName} {#Version}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppPublisherURL}
VersionInfoVersion={#Version}
DefaultGroupName={#MyAppGroupName}

Compression=lzma2
SolidCompression=yes

; Installer behavior
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
ChangesEnvironment=yes
DisableDirPage=auto
DisableProgramGroupPage=auto
PrivilegesRequired=lowest
WizardStyle=modern
DefaultDirName={localappdata}\{#MyAppName}
UninstallDisplayIcon={app}\{#IcoResource}

; Generated installer exe will be located here under the given name
OutputDir="..\..\bin\example-app-installer"
OutputBaseFilename={#MyAppName}-{#Version}-win

[Files]
Source: "{#SourceRootDirectory}\bin\*"; DestDir: "{app}\bin"
Source: "{#SourceRootDirectory}\lib\*"; DestDir: "{app}\lib"
Source: "{#IcoResource}"; DestDir: "{app}"

; We want the installer to automatically append the executable location to the user PATH env var
; and to automatically remove it after uninstalling the application
;
; EnvAddPath from "env.iss" is called on the PostInstall step to add the "app"\bin folder to the PATH
;
; EnvRemovePath is called on PostUninstall step to remove the "app"\bin from PATH
[Code]
procedure CurStepChanged(CurStep: TSetupStep);
begin
    if CurStep = ssPostInstall 
     then EnvAddPath(ExpandConstant('{app}') +'\bin');
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
    if CurUninstallStep = usPostUninstall
    then EnvRemovePath(ExpandConstant('{app}') +'\bin');
end;
