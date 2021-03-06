unit fufrmCheques;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Buttons, QuickRpt, ComCtrls, StdCtrls, XPMan, Mask,
  udmCheques, ufrmcheques, ExtCtrls, DBCtrls, Grids, DBGrids, DB, ShellApi,
  SqlExpr;

const WM_NOTIFYICON = WM_USER+333;

type
  TfrmPrincipal = class(TForm)
    ActionList1: TActionList;
    acImprimir: TAction;
    XPManifest1: TXPManifest;
    acClose: TAction;
    tClose: TTimer;
    tCheques: TTimer;
    btOK: TButton;
    Label1: TLabel;
    procedure SetearValores;
    procedure FormCreate(Sender: TObject);
    procedure acCloseExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tCloseTimer(Sender: TObject);
    procedure tChequesTimer(Sender: TObject);
    procedure CMClickIcon(var msg: TMessage); message WM_NOTIFYICON;
    procedure btOKClick(Sender: TObject);
  private
    tnid: TNotifyIconData;
    HMainIcon: HICON;
    FdmCheques: TdmCheques;
    Ffrmcheques: tfrmImprimirCheque;
    procedure SetdmCheques(const Value: TdmCheques);
    procedure Setfrmcheques(const Value: tfrmImprimirCheque);
    function ConvertirFechaaString(ADate: string): string;
    procedure Close;
    { Private declarations }
  public
    { Public declarations }
    procedure ShowForm(FormClass: TFormClass; var Reference);
    property dmCheques: TdmCheques read FdmCheques write SetdmCheques;
    property frmcheques: tfrmImprimirCheque read Ffrmcheques write Setfrmcheques;
  end;

var
  frmPrincipal: TfrmPrincipal;
implementation

{$R *.dfm}

procedure TfrmPrincipal.acCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.btOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.Close;
begin
  if Assigned(frmcheques) then
    frmcheques.Visible := False;

  Hide;
end;

procedure TfrmPrincipal.CMClickIcon(var msg: TMessage);
begin
  if msg.lparam = WM_LBUTTONDBLCLK then Show;
end;

function TfrmPrincipal.ConvertirFechaaString(ADate: string): string;
var
  NDia,
  NMes,
  NAnio: string;
  Meses: array[0..11] of string;
begin
  Meses[0] := 'Enero';
  Meses[1] := 'Febrero';
  Meses[2] := 'Marzo';
  Meses[3] := 'Abril';
  Meses[4] := 'Mayo';
  Meses[5] := 'Junio';
  Meses[6] := 'Julio';
  Meses[7] := 'Agosto';
  Meses[8] := 'Septiembre';
  Meses[9] := 'Octubre';
  Meses[10] := 'Noviembre';
  Meses[11] := 'Diciembre';

  NDia := Copy(ADate, 9, 2);
  NMes := Copy(ADate, 6, 2);
  Nanio := Copy(ADate, 0, 4);

  Result :=  Ndia + ' de ' + Meses[StrToInt(NMes) - 1] + ' del ' + Nanio;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
  Close;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  frmPrincipal.Height := 125;
  frmPrincipal.Width := 320;

  HMainIcon                := LoadIcon(MainInstance, 'MAINICON');

  Shell_NotifyIcon(NIM_DELETE, @tnid);

  tnid.cbSize              := sizeof(TNotifyIconData);
  tnid.Wnd                 := handle;
  tnid.uID                 := 123;
  tnid.uFlags              := NIF_MESSAGE or NIF_ICON or NIF_TIP;
  tnid.uCallbackMessage    := WM_NOTIFYICON;
  tnid.hIcon               := HMainIcon;
  tnid.szTip               := 'Print check tool';

  Shell_NotifyIcon(NIM_ADD, @tnid);
  Application.ShowMainForm := False;


  if not Assigned(dmCheques) then
    dmCheques := TdmCheques.Create(nil);

  try
    SetearValores;
  except on E: Exception do
    // Nada.
  end;

  Sleep(1000);
  tCheques.Enabled := True;
end;

procedure TfrmPrincipal.SetdmCheques(const Value: TdmCheques);
begin
  FdmCheques := Value;
end;

procedure TfrmPrincipal.SetearValores;
var
  Impreso: boolean;
begin
  dmCheques.cdsCheque.Close;
  dmCheques.cdsCheque.Open;


  if dmCheques.cdsCheque.RecordCount > 0 then
  begin
  if not Assigned(frmcheques) then
    Application.CreateForm(TfrmImprimirCheque,ffrmcheques);
  end;

  if Assigned(frmcheques) then
  begin
    frmcheques.WindowState := wsMinimized;
    frmcheques.Visible := False;
  end;

  dmCheques.cdsCheque.First;
  while not dmCheques.cdsCheque.Eof do
  begin
    try
      try
        if (dmCheques.cdsChequeprinted.AsInteger = 0) then
        begin
          Impreso := False;
          frmcheques.qrlLugar.Caption := dmCheques.cdsChequeplace.AsString
            + ', ' + ConvertirFechaaString(dmCheques.cdsChequedate.AsString);


          frmcheques.Moneda := 'Q';
          frmcheques.Valor := dmCheques.cdsChequevalue.AsString;
          frmcheques.Nombre := dmCheques.cdsChequename.AsString;
          frmcheques.Negociable := dmCheques.cdsChequenegotiable.AsString;
          frmcheques.Autorizacion := '';
          frmcheques.Concepto := dmCheques.cdsChequedescription.AsString;
          frmcheques.Documento := dmCheques.cdsChequedocument.AsString;
          try
            frmcheques.qrCheque.ShowProgress := True;
            frmcheques.qrCheque.Print;
            frmcheques.qrCheque.FreeOnRelease;
            Impreso := True;
          except on E: Exception do
            // Si es error de impresión que no diga o haga nada.
          end;
          if Impreso then
          begin
            dmCheques.cdsCheque.Edit;
            dmCheques.cdsChequeprinted.AsInteger := 1;
            dmCheques.cdsCheque.Post;
            dmCheques.cdsCheque.ApplyUpdates(-1);
          end;
          Sleep(10000);
          Application.ProcessMessages;
        end;
      except on E: Exception do
        ShowMessage('The document could not be printed: ' +
          dmCheques.cdsChequedocument.AsString + ' Error: ' + e.Message);
      end;
    finally
      dmCheques.cdsCheque.Next;
      frmcheques.Visible := False;
    end
  end;
  if Assigned(frmcheques) then
  begin
    frmcheques.WindowState := wsMinimized;
    frmcheques.Visible := False;
  end;

end;

procedure TfrmPrincipal.Setfrmcheques(const Value: tfrmImprimirCheque);
begin
  Ffrmcheques := Value;
end;

procedure TfrmPrincipal.ShowForm(FormClass: TFormClass; var Reference);
begin
  if not Assigned(TForm(Reference)) then
    Application.CreateForm(FormClass,Reference);
  TForm(Reference).Show;
  TForm(Reference).WindowState := wsNormal;
  TForm(Reference).BringToFront;
end;

procedure TfrmPrincipal.tChequesTimer(Sender: TObject);
begin
  try
    SetearValores;
  except on E: Exception do
    begin
      frmcheques.FreeOnRelease;
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TfrmPrincipal.tCloseTimer(Sender: TObject);
begin
  Close;
end;

end.
