unit udmCheques;

interface

uses
  SysUtils, Classes, DBXpress, WideStrings, FMTBcd, ADODB, DBTables, SqlExpr,
  DB, Provider, DBClient;

type
  TdmCheques = class(TDataModule)
    sqlcServer: TSQLConnection;
    cdsCheque: TClientDataSet;
    dsCheques: TDataSource;
    dspCheques: TDataSetProvider;
    sqlqCheques: TSQLQuery;
    sqlqChequesidchecks: TIntegerField;
    sqlqChequesplace: TStringField;
    sqlqChequesdate: TWideStringField;
    sqlqChequesvalue: TFMTBCDField;
    sqlqChequesname: TStringField;
    sqlqChequesdescription: TStringField;
    sqlqChequesnegotiable: TStringField;
    sqlqChequesnearsol_id: TStringField;
    sqlqChequesclient_id: TStringField;
    sqlqChequesid_account: TStringField;
    sqlqChequesdocument: TStringField;
    sqlqChequesbankAccount: TStringField;
    sqlqChequesprintDetail: TSmallintField;
    sqlqChequesuser_create: TStringField;
    sqlqChequescreation_date: TSQLTimeStampField;
    sqlqChequespayment: TIntegerField;
    sqlqChequesprinted: TSmallintField;
    cdsChequeidchecks: TIntegerField;
    cdsChequeplace: TStringField;
    cdsChequedate: TWideStringField;
    cdsChequevalue: TFMTBCDField;
    cdsChequename: TStringField;
    cdsChequedescription: TStringField;
    cdsChequenegotiable: TStringField;
    cdsChequenearsol_id: TStringField;
    cdsChequeclient_id: TStringField;
    cdsChequeid_account: TStringField;
    cdsChequedocument: TStringField;
    cdsChequebankAccount: TStringField;
    cdsChequeprintDetail: TSmallintField;
    cdsChequeuser_create: TStringField;
    cdsChequecreation_date: TSQLTimeStampField;
    cdsChequepayment: TIntegerField;
    cdsChequeprinted: TSmallintField;
  private
    FValor: string;
    FValor_En_Letras: string;
    FAutorizacion: string;
    FFecha: string;
    FDocumento: string;
    FNegociable: string;
    FMoneda: string;
    FNombre: string;
    FConcepto: string;
    FImpDetalle: boolean;
    procedure SetAutorizacion(const Value: string);
    procedure SetConcepto(const Value: string);
    procedure SetDocumento(const Value: string);
    procedure SetFecha(const Value: string);
    procedure SetMoneda(const Value: string);
    procedure SetNegociable(const Value: string);
    procedure SetNombre(const Value: string);
    procedure SetValor(const Value: string);
    procedure SetValor_En_Letras(const Value: string);
    procedure SetImpDetalle(const Value: boolean);
    { Private declarations }
  public
    { Public declarations }
    function InWords(R1: real; Tipo: string): string;
    function IntToWord(R: Real): string;
    property Negociable: string read FNegociable write SetNegociable;
    property Fecha: string read FFecha write SetFecha;
    property Nombre: string read FNombre write SetNombre;
    property Valor: string read FValor write SetValor;
    property Valor_En_Letras: string read FValor_En_Letras write SetValor_En_Letras;
    property Autorizacion: string read FAutorizacion write SetAutorizacion;
    property Concepto: string read FConcepto write SetConcepto;
    property Documento: string read FDocumento write SetDocumento;
    property Moneda: string read FMoneda write SetMoneda;
    property ImpDetalle: boolean read FImpDetalle write SetImpDetalle;
    function Redondea(Valor1: Double; dec: Integer): Double;
    function QuitaComas(aValue: string): string;
  end;

var
  dmCheques: TdmCheques;

implementation

{$R *.dfm}

{ TDataModule1 }

function TdmCheques.IntToWord(R: Real): string;
var I,I2: integer;
  T: string;
begin
  T := '';
  I := Trunc (R/100);
  case I of
    1: if R=100 then
         T:='CIEN '
       else
         T:='CIENTO ';
    2: T:='DOSCIENTOS ';
    3: T:='TRESCIENTOS ';
    4: T:='CUATROCIENTOS ';
    5: T:='QUINIENTOS ';
    6: T:='SEISCIENTOS ';
    7: T:='SETECIENTOS ';
    8: T:='OCHOCIENTOS ';
    9: T:='NOVECIENTOS ';
   end;
   I2 := Trunc(R-I*100);
   I := Trunc(R/10-I*10);
  case I of
    1:
      case I2 of
        10: T:=T+'DIEZ ';
        11: T:=T+'ONCE ';
        12: T:=T+'DOCE ';
        13: T:=T+'TRECE ';
        14: T:=T+'CATORCE ';
        15: T:=T+'QUINCE ';
      else
        T:=T+'DIECI';
      end;
    2: if I2=20 then
        T:=T+'VEINTE '
      else
        T:=T+'VEINTI';
     3: T:=T+'TREINTA ';
     4: T:=T+'CUARENTA ';
     5: T:=T+'CINCUENTA ';
     6: T:=T+'SESENTA ';
     7: T:=T+'SETENTA ';
     8: T:=T+'OCHENTA ';
     9: T:=T+'NOVENTA ';
   end;
   I := Trunc(R-(Trunc(R/100)*100+I*10));
   if (Trunc(R/10-Trunc(R/100)*10)>2) and (I>0) then
     T:=T+'Y ';
   if not (I2 in [10..15]) then
   case I of
     1:
     begin
       if (I2 > 20) or (I2 < 10) then
         T := T + 'UN '
       else
         T:=T+'UNO ';
     end;
     2: T:=T+'DOS ';
     3: T:=T+'TRES ';
     4: T:=T+'CUATRO ';
     5: T:=T+'CINCO ';
     6: T:=T+'SEIS ';
     7: T:=T+'SIETE ';
     8: T:=T+'OCHO ';
     9: T:=T+'NUEVE ';
   end;
   IntToWord := T;
end;

function TdmCheques.InWords(R1: real; Tipo: string): string;
var
  R2: real;
  T : string;

  function Recorta(Cad:String): string;
  begin
    Result := Cad;
    if Copy(Cad, Length(Cad)-3,3)= 'UNO' then
      Result := Copy(Cad,1,Length(Cad)-2)+' ';
  end;

  begin
    R1 := Redondea(R1,2);
    T := '';
    R2 := Trunc(R1/1000000);
    if R2>0 then
      if R2=1 then
        T := 'UN MILLON '
      else
        T:=Recorta(IntToWord(R2))+'MILLONES ';
     R2 := Trunc((R1-R2*1000000)/1000);
     if R2>0 then
      if R2=1 then
        T:=T+'MIL '
      else
        T:=T+Recorta(IntToWord(R2))+'MIL ';
     R2 := Trunc (R1-Trunc(R1/1000000)*1000000-R2*1000);
     if R2>0 then
       T:=T+IntToWord(R2);
     R2 := (R1-Trunc(R1))*100;
     if (R2>0) and (Trunc(R1)>0) then
       if Tipo='Q' then
         T := T + 'QUETZALES CON '
       else
         if Tipo = '$' then
           T := T + 'D�LARES CON '
         else
           T := T + 'CON ';
     if R2>0 then
       T:=T+FormatFloat('##',R2)+'/100.'
     else if R1>0 then
       if Tipo = 'Q' then
          T := T + 'QUETZALES EXACTOS'
       else
         if Tipo = '$' then
           T := T + 'D�LARES EXACTOS'
         else
           T := T + 'EXACTOS';
  InWords := T;
end;

function TdmCheques.QuitaComas(aValue: string): string;
begin
  Result := StringReplace(aValue, ',', '', [rfReplaceAll]);
end;

function TdmCheques.Redondea(Valor1: Double; dec: Integer): Double;
var
  ceros,
  todo,
  nousa,
  siusa,
  temp_siusa,
  temp_todo: string;
  inc_todo,
  negativo
  {es_nueve} : Boolean;
  valor: Double;
begin
  valor := valor1;
  if valor < 0 then
  begin
    negativo := True;
    valor := valor*-1;
  end
  else
    negativo := False;
  ceros := '00000000';
//   es_nueve := false;
  todo  := FormatFloat('00000000.00000000',valor);
  nousa := Copy(todo,10+dec,1);
  siusa := Copy(todo,10,dec);
  temp_siusa := siusa;
  if StrToInt(nousa) >= 5 then
    temp_siusa := FormatFloat(Copy(ceros,1,dec), StrToInt(temp_siusa) + 1);
  inc_todo := False;
  if length(temp_siusa) > length(siusa) then
  begin
    temp_siusa:='0';
    inc_todo := True;
  end;
  temp_todo := Copy(todo,1,8);
  if inc_todo then temp_todo := IntToStr(StrToInt(temp_todo) + 1);
    todo := temp_todo + '.' + temp_siusa;
  if negativo then
    Result := StrToFloat(todo)* -1
  else Result := StrToFloat(todo);
end;

procedure TdmCheques.SetAutorizacion(const Value: string);
begin
  FAutorizacion := Value;
end;

procedure TdmCheques.SetConcepto(const Value: string);
begin
  FConcepto := Value;
end;

procedure TdmCheques.SetDocumento(const Value: string);
begin
  FDocumento := Value;
end;

procedure TdmCheques.SetFecha(const Value: string);
begin
  FFecha := Value;
end;

procedure TdmCheques.SetImpDetalle(const Value: boolean);
begin
  FImpDetalle := Value;
end;

procedure TdmCheques.SetMoneda(const Value: string);
begin
  FMoneda := Value;
end;

procedure TdmCheques.SetNegociable(const Value: string);
begin
  FNegociable := Value;
end;

procedure TdmCheques.SetNombre(const Value: string);
begin
  FNombre := Value;
end;

procedure TdmCheques.SetValor(const Value: string);
begin
  FValor := Value;
  Valor_En_Letras := InWords(StrToFloatDef(QuitaComas(FValor), 0.00), Moneda);
  FValor := FormatFloat('###,##0.00', StrToFloat(Value));
end;

procedure TdmCheques.SetValor_En_Letras(const Value: string);
begin
  FValor_En_Letras := Value;
end;

end.
