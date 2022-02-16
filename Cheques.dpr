program Cheques;

uses
  Forms,
  fufrmCheques in 'fufrmCheques.pas' {frmPrincipal},
  ufrmcheques in 'ufrmcheques.pas' {frmImprimirCheque},
  SysUtils,
  Dialogs,
  types,
  Windows,
  uFACEConst,
  udmCheques in 'udmCheques.pas' {dmCheques: TDataModule};

{$R *.res}

function fParams(AParam: string): string;
begin
  Result := StringReplace(AParam, '"', '', [rfReplaceAll]);
end;

begin
  Application.Initialize;
  Application.Title := 'Impresión de cheques';
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
//  Application.FreeOnRelease;
//  Application.Terminate;
//  Exit;
end.
