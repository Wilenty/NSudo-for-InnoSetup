#define MyAppName "NSudoDM"
#define MyAppVersion "1.0"
#define MyAppPublisher "© Wilenty"
#define MyAppURL "https://wilenty.wixsite.com/SoftwareByWilenty/inno-setup-xp-ee-script-studio-port"
#define MyAppExeName "MyProg.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{B98E18DA-80C3-4D80-A900-E9189EF9908B}
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
PrivilegesRequired=admin

[files]
#Define NSudoDM_dll="DM.dll"
#Define NSudoDM_path="{app}"
Source: "NSudoDM.dll"; DestDir: "{#NSudoDM_path}"; DestName: "{#NSudoDM_dll}"; Flags: IgnoreVersion

[code]
Var
  NSudoDM: Longint;

Function InitializeSetup(): Boolean;
  Var
    Err: Integer;
    NSudoDM_dll: String;
  begin
    Result := True;
    If IsAdminLoggedOn then
    begin
      NSudoDM_dll := '{#NSudoDM_dll}';
      If IsUninstaller then
        NSudoDM_dll := AddBackslash('{#NSudoDM_path}') + NSudoDM_dll
      else
      begin
        ExtractTemporaryFile(NSudoDM_dll);
        NSudoDM_dll := AddBackslash('{tmp}') + NSudoDM_dll;
      end;
      NSudoDM_dll := ExpandConstant(NSudoDM_dll);
      If FileExists(NSudoDM_dll) then
        NSudoDM := LoadDLL(NSudoDM_dll, Err);
    end;
end;
Function InitializeUninstall(): Boolean;
  begin
    Result := InitializeSetup();
end;

// Example, that it works only for the current installer, any other instances will be with normal rights (current user access rights).
Function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo, MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
  Var
    RegKeys: TArrayOfString;
    Int: Integer;
    ErrorCode: Integer;
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
// end of example.

Procedure DeinitializeSetup();
  begin
    If NSudoDM <> 0 then
      FreeDLL(NSudoDM);
end;
procedure DeinitializeUninstall();
  begin
    DeinitializeSetup();
end;
