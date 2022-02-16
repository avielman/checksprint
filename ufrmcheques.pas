unit ufrmcheques;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QuickRpt, QRCtrls, ExtCtrls, StdCtrls, udmCheques;

type
  TfrmImprimirCheque = class(TForm)
    qrCheque: TQuickRep;
    QRBand1: TQRBand;
    qrlLugar: TQRLabel;
    qrlNombre: TQRLabel;
    qrlValorLetras: TQRLabel;
    qrlNegociable: TQRLabel;
    qrlConcepto: TQRLabel;
    qrlValor: TQRLabel;
    qrlDocumento: TQRLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure qrlNegociablePrint(sender: TObject; var Value: string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qrlDocumentoPrint(sender: TObject; var Value: string);
    procedure qrlLugarPrint(sender: TObject; var Value: string);
  private
    FValor: string;
    FValor_En_Letras: string;
    FAutorizacion: string;
    FDocumento: string;
    FNegociable: string;
    FConcepto: string;
    FNombre: string;
    FMoneda: string;
    FFecha: string;
    FdmCheques: TdmCheques;
    FfrmImprimirCheque: TfrmImprimirCheque;
    procedure SetAutorizacion(const Value: string);
    procedure SetConcepto(const Value: string);
    procedure SetDocumento(const Value: string);
    procedure SetNegociable(const Value: string);
    procedure SetValor(const Value: string);
    procedure SetValor_En_Letras(const Value: string);
    { Private declarations }
    procedure SetNombre(const Value: string);
    procedure SetMoneda(const Value: string);
    procedure SetFecha(const Value: string);
    procedure SetdmCheques(const Value: TdmCheques);
    procedure SetfrmImprimirCheque(const Value: TfrmImprimirCheque);
  public
    { Public declarations }
    procedure Print;
    procedure Preview;
    property Negociable: string read FNegociable write SetNegociable;
    property Fecha: string read FFecha write SetFecha;
    property Nombre: string read FNombre write SetNombre;
    property Valor: string read FValor write SetValor;
    property Valor_En_Letras: string read FValor_En_Letras write SetValor_En_Letras;
    property Autorizacion: string read FAutorizacion write SetAutorizacion;
    property Concepto: string read FConcepto write SetConcepto;
    property Documento: string read FDocumento write SetDocumento;
    property Moneda: string read FMoneda write SetMoneda;
    property frmImprimirCheque: TfrmImprimirCheque read FfrmImprimirCheque write SetfrmImprimirCheque;
    property dmCheques: TdmCheques read FdmCheques write SetdmCheques;
  end;

implementation

{$R *.dfm}

{ TForm1 }

procedure TfrmImprimirCheque.Button1Click(Sender: TObject);
begin
  Print;
end;

procedure TfrmImprimirCheque.Button2Click(Sender: TObject);
begin
  Preview;
end;

procedure TfrmImprimirCheque.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmImprimirCheque := nil;
  Action := caFree;
end;

procedure TfrmImprimirCheque.FormCreate(Sender: TObject);
begin
  try
    if Assigned(dmCheques) then
      dmcheques := Tdmcheques.Create(Self);
  finally
    // No hace o nice nada.
  end;
end;

procedure TfrmImprimirCheque.Preview;
begin
  qrCheque.ShowProgress := True;
  qrcheque.PrinterSettings.PrinterIndex := -1;
  qrCheque.Preview;
end;

procedure TfrmImprimirCheque.Print;
begin
  qrCheque.ShowProgress := True;
  qrcheque.PrinterSettings.PrinterIndex := -1;
  qrCheque.Print;
end;

procedure TfrmImprimirCheque.qrlDocumentoPrint(sender: TObject;
  var Value: string);
begin
  Value := '';
end;

procedure TfrmImprimirCheque.qrlLugarPrint(sender: TObject; var Value: string);
begin
  Value := UpperCase(Value);
end;

procedure TfrmImprimirCheque.qrlNegociablePrint(sender: TObject;
  var Value: string);
begin
//
end;

procedure TfrmImprimirCheque.SetAutorizacion(const Value: string);
begin
  fAutorizacion := Value;
end;

procedure TfrmImprimirCheque.SetConcepto(const Value: string);
begin
  FConcepto := Value;
  qrlConcepto.Caption := Value;
end;

procedure TfrmImprimirCheque.SetdmCheques(const Value: TdmCheques);
begin
  FdmCheques := Value;
end;

procedure TfrmImprimirCheque.SetDocumento(const Value: string);
begin
  fDocumento := Value;
  qrlDocumento.Caption := Value;
end;

procedure TfrmImprimirCheque.SetFecha(const Value: string);
begin
  FFecha := Value;
  qrlLugar.Caption := fFecha;
end;

procedure TfrmImprimirCheque.SetfrmImprimirCheque(
  const Value: TfrmImprimirCheque);
begin
  FfrmImprimirCheque := Value;
end;

procedure TfrmImprimirCheque.SetMoneda(const Value: string);
begin
  FMoneda := Value;
end;

procedure TfrmImprimirCheque.SetNegociable(const Value: string);
begin
  qrlNegociable.Caption := Value;
end;

procedure TfrmImprimirCheque.SetNombre(const Value: string);
begin
  qrlNombre.Caption := Value;
end;

procedure TfrmImprimirCheque.SetValor(const Value: string);
begin
  FValor := Value;
  qrlValor.Caption := FormatFloat('###,##0.00', StrToFloat(dmcheques.QuitaComas(FValor)));
  Valor_En_Letras := dmcheques.InWords(StrToFloatDef(dmcheques.QuitaComas(FValor), 0.00), Moneda);
end;

procedure TfrmImprimirCheque.SetValor_En_Letras(const Value: string);
begin
  FValor_En_Letras := Value;
  qrlValorLetras.Caption := Value;
end;

end.
