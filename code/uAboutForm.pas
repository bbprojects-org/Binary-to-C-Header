{ ==============================================================================

  ABOUT FORM

    Standard 'about the application' form, showing versions used to build it.


  LICENSE:

    Copyright (C) 2024  Robert C Beveridge

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or any
    later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

  =============================================================================}

unit uAboutForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  // Units required for GetAppInfo
  fileinfo,
  winpeimagereader, {for reading exe info, Windows}
  elfreader,        {for reading ELF executables, Linux}
  machoreader       {for reading MACH-O executables, MacOS};

type

  { TAboutForm }

  TAboutForm = class(TForm)
    btnOk: TButton;
    Image1: TImage;
    lblAppVersion: TLabel;
    lblCopyright: TLabel;
    lblBuildVersion: TLabel;
    lblHeading: TLabel;
    lblDescription: TLabel;
    lblLazarusVersion: TLabel;
    lblFreePascalVersion: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    function GetAppInfo: string;
  public

  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.lfm}

const
  MONTHS: array[1..12] of string
    = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');


{ CREATE }

procedure TAboutForm.FormCreate(Sender: TObject);
var
  A: TStringArray;
  thisDate, thisYear: string;
begin
  thisDate := {$I %DATE%};
  A := thisDate.Split('/');
  thisDate := Format('%d %s %s', [StrToInt(A[2]), MONTHS[StrToInt(A[1])], A[0]]);
  thisYear := A[0];
  A := GetAppInfo.Split('.');
  lblAppVersion.Caption := Format('Version %s.%s (Build %s)', [A[0], A[1], A[3]]);
  lblCopyright.Caption := Format('Copyright (C) %s  Robert C Beveridge', [thisYear]);
  lblLazarusVersion.Caption := 'Lazarus: ' + LCLVersion;
  lblFreePascalVersion.Caption := 'Free Pascal: ' + {$I %FPCVERSION%};
end;


{ GET APP VERSION }

{ Based on code from:
  https://wiki.freepascal.org/Show_Application_Title,_Version,_and_Company

  Displays file version info for
  - Windows PE executables
  - Linux ELF executables (compiled by Lazarus)
  - OSX MACH-O executables (compiled by Lazarus)
  Runs on Windows, Linux, OSX...
}

function TAboutForm.GetAppInfo: string;
var
  FileVerInfo: TFileVersionInfo;
begin
  FileVerInfo := TFileVersionInfo.Create(nil);
  try
    FileVerInfo.ReadFileInfo;
    Result := FileVerInfo.VersionStrings.Values['FileVersion'];
    // FileVerInfo.VersionStrings.Values['CompanyName'];
    // FileVerInfo.VersionStrings.Values['FileDescription'];
    // FileVerInfo.VersionStrings.Values['InternalName'];
    // FileVerInfo.VersionStrings.Values['LegalCopyright'];
    // FileVerInfo.VersionStrings.Values['OriginalFileName'];
    // FileVerInfo.VersionStrings.Values['ProductName'];
    // FileVerInfo.VersionStrings.Values['ProductVersion'];
  finally
    FileVerInfo.Free;
  end;
end;


end.

