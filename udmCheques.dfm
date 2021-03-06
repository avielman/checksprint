object dmCheques: TdmCheques
  OldCreateOrder = False
  Height = 360
  Width = 641
  object sqlcServer: TSQLConnection
    DriverName = 'MSSQL'
    GetDriverFunc = 'getSQLDriverMSSQL'
    LibraryName = 'dbxmss30.dll'
    LoginPrompt = False
    Params.Strings = (
      'HostName=172.18.2.39'
      'DataBase=MiNearsol_local'
      'User_Name=minearsol'
      'Password=Nearsol.2020'
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'MSSQL TransIsolation=ReadCommited'
      'OS Authentication=False'
      'Prepare SQL=False')
    VendorLib = 'oledb'
    Left = 96
    Top = 16
  end
  object cdsCheque: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspCheques'
    Left = 96
    Top = 168
    object cdsChequeidchecks: TIntegerField
      FieldName = 'idchecks'
      Required = True
    end
    object cdsChequeplace: TStringField
      FieldName = 'place'
      Size = 45
    end
    object cdsChequedate: TWideStringField
      FieldName = 'date'
    end
    object cdsChequevalue: TFMTBCDField
      FieldName = 'value'
      Precision = 18
      Size = 2
    end
    object cdsChequename: TStringField
      FieldName = 'name'
      Size = 100
    end
    object cdsChequedescription: TStringField
      FieldName = 'description'
      Size = 100
    end
    object cdsChequenegotiable: TStringField
      FieldName = 'negotiable'
      Size = 45
    end
    object cdsChequenearsol_id: TStringField
      FieldName = 'nearsol_id'
      Size = 45
    end
    object cdsChequeclient_id: TStringField
      FieldName = 'client_id'
      Size = 45
    end
    object cdsChequeid_account: TStringField
      FieldName = 'id_account'
      Size = 45
    end
    object cdsChequedocument: TStringField
      FieldName = 'document'
      Size = 45
    end
    object cdsChequebankAccount: TStringField
      FieldName = 'bankAccount'
      Size = 45
    end
    object cdsChequeprintDetail: TSmallintField
      FieldName = 'printDetail'
    end
    object cdsChequeuser_create: TStringField
      FieldName = 'user_create'
      Size = 45
    end
    object cdsChequecreation_date: TSQLTimeStampField
      FieldName = 'creation_date'
    end
    object cdsChequepayment: TIntegerField
      FieldName = 'payment'
    end
    object cdsChequeprinted: TSmallintField
      FieldName = 'printed'
    end
  end
  object dsCheques: TDataSource
    DataSet = cdsCheque
    Left = 96
    Top = 224
  end
  object dspCheques: TDataSetProvider
    DataSet = sqlqCheques
    UpdateMode = upWhereChanged
    Left = 96
    Top = 120
  end
  object sqlqCheques: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      
        'select * from MiNearsol_local.dbo.checks c where c.printed != 1 ' +
        'OR c.printed is null;')
    SQLConnection = sqlcServer
    Left = 96
    Top = 72
    object sqlqChequesidchecks: TIntegerField
      FieldName = 'idchecks'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object sqlqChequesplace: TStringField
      FieldName = 'place'
      Size = 45
    end
    object sqlqChequesdate: TWideStringField
      FieldName = 'date'
    end
    object sqlqChequesvalue: TFMTBCDField
      FieldName = 'value'
      Precision = 18
      Size = 2
    end
    object sqlqChequesname: TStringField
      FieldName = 'name'
      Size = 100
    end
    object sqlqChequesdescription: TStringField
      FieldName = 'description'
      Size = 100
    end
    object sqlqChequesnegotiable: TStringField
      FieldName = 'negotiable'
      Size = 45
    end
    object sqlqChequesnearsol_id: TStringField
      FieldName = 'nearsol_id'
      Size = 45
    end
    object sqlqChequesclient_id: TStringField
      FieldName = 'client_id'
      Size = 45
    end
    object sqlqChequesid_account: TStringField
      FieldName = 'id_account'
      Size = 45
    end
    object sqlqChequesdocument: TStringField
      FieldName = 'document'
      Size = 45
    end
    object sqlqChequesbankAccount: TStringField
      FieldName = 'bankAccount'
      Size = 45
    end
    object sqlqChequesprintDetail: TSmallintField
      FieldName = 'printDetail'
    end
    object sqlqChequesuser_create: TStringField
      FieldName = 'user_create'
      Size = 45
    end
    object sqlqChequescreation_date: TSQLTimeStampField
      FieldName = 'creation_date'
    end
    object sqlqChequespayment: TIntegerField
      FieldName = 'payment'
    end
    object sqlqChequesprinted: TSmallintField
      FieldName = 'printed'
    end
  end
end
