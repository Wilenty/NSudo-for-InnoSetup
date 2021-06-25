#define MyAppName "NSudoAPI-CMD"
#define MyAppVersion "1.0"
#define MyAppPublisher "© Wilenty"
#define MyAppURL "https://wilenty.wixsite.com/SoftwareByWilenty/inno-setup-xp-ee-script-studio-port"
#define MyAppExeName "MyProg.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{86A26F1B-3872-4973-8589-63BF5B683895}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppCopyright={#MyAppPublisher}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultGroupName={#MyAppName}
OutputBaseFilename={#MyAppName} {#MyAppVersion}
CreateAppDir=False
Uninstallable=no
DisableFinishedPage=True
PrivilegesRequired=lowest

#include "NSudoAPI.isi"

[code]
Function InitializeSetup(): Boolean;
{  Var
    ErrorCode: Integer;}
  begin
    if IsAdminLoggedOn then
    begin
      If NSudoCreateProcess(UM_SYSTEM, PM_DEFAULT, ML_MEDIUM_PLUS, PPC_NORMAL, SWM_DEFAULT, 0, True, 'cmd.exe /c whoami /user&pause', GetTempDir) <> 0 then
        MsgBox( 'NSudoCreateProcess FAILED!', mbInformation, MB_OK );
    end
    else
    begin
//      Exec(ExpandConstant('{cmd}'), '/c whoami /user&pause', GetTempDir, SW_SHOWNORMAL, ewWaitUntilIdle, ErrorCode);
      MsgBox('Please right click on me, then: run as Administrator!'#13#10#9#9'Bye, bye...', mbError, MB_OK);
    end;
end;
