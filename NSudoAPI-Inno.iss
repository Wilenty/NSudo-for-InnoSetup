#define MyAppName "NSudoAPI-Inno"
#define MyAppVersion "1.0"
#define MyAppPublisher "© Wilenty"
#define MyAppURL "https://wilenty.wixsite.com/SoftwareByWilenty/inno-setup-xp-ee-script-studio-port"
#define MyAppExeName "MyProg.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{D4B4FD6A-4B66-4CEE-B734-19DB56838C5F}
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
  var
    Params: String;
    Int: Integer;
  begin
    Result := True;
    EnableFsRedirection(False);
    if IsAdminLoggedOn then
    begin
      For Int := 0 to ParamCount do
        Params := Params + '"' + ParamStr(Int) + '" ';
      If NSudoCreateProcess(UM_SYSTEM, PM_DEFAULT, ML_MEDIUM_PLUS, PPC_NORMAL, SWM_DEFAULT, -1, True, Params, GetTempDir) = 0 then
        Result := False;
    end
    else
    begin
      MsgBox('Please right click on me, then: run as Administrator!'#13#10#9#9'Bye, bye...', mbError, MB_OK);
      Result := False;
    end;
end;

Function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo, MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
  Var
    RegKeys: TArrayOfString;
    Int: Integer;
  begin
    If RegGetSubkeyNames(HKLM, 'SAM\SAM\Domains\Builtin\Aliases\Names', RegKeys) then
    begin
      Result := 'Reg keys of HKEY_LOCAL_MACHINE\SAM\SAM\Domains\Builtin\Aliases\Names:' + NewLine;
      For Int := 0 To GetArrayLength(RegKeys)-1 do
        Result := Result + RegKeys[Int] + NewLine;
    end;
end;

Procedure CurPageChanged(CurPageID: Integer);
  var
    ErrorCode: Integer;
  begin
    If CurPageID = wpReady then
    begin
      WizardForm.Show;
      Exec(ExpandConstant('{cmd}'), '/c whoami /user&pause', GetTempDir, SW_SHOWNORMAL, ewWaitUntilTerminated, ErrorCode);
    end;
end;
