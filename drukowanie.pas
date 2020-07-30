unit drukowanie;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, LR_DBSet,
  ZDataset;

type

  { Tdr }

  Tdr = class(TDataModule)
    dbksiegi: TZQuery;
    dbksiegiid: TLargeintField;
    dbksieginazwa: TStringField;
    dbksieginr: TLargeintField;
    dbksiegirodzaj: TStringField;
    dbksiegiskrot: TStringField;
    dbksiegisort: TLargeintField;
    dbksiegiwydanie_id: TLongintField;
    dbrozdzialy: TZQuery;
    dbrozdzialyksiega_id: TLongintField;
    dbrozdzialyrozdzial: TLargeintField;
    dbrozdzialywydanie_id: TLongintField;
    dbtresc: TZQuery;
    dbtrescid: TLargeintField;
    dbtrescinterpretacja: TMemoField;
    dbtrescksiega_id: TLargeintField;
    dbtrescrozdzial: TLargeintField;
    dbtresctresc: TMemoField;
    dbtresctytul1: TStringField;
    dbtresctytul2: TStringField;
    dbtrescwers: TLargeintField;
    dbwydania: TZQuery;
    dbwydaniaid: TLargeintField;
    dbwydanianazwa: TStringField;
    dbwydaniarodzaj_id: TLargeintField;
    dbwydaniasort_ksiegi_nazwa: TSmallintField;
    dbwydaniaurl: TStringField;
    dsksiegi: TDataSource;
    dsroz: TDataSource;
    dstresc: TDataSource;
    dswyd: TDataSource;
    wydania: TfrDBDataSet;
    ksiegi: TfrDBDataSet;
    rozdzialy: TfrDBDataSet;
    wersety: TfrDBDataSet;
    rep: TfrReportPlus;
    procedure _OPEN_CLOSE(DataSet: TDataSet);
  private

  public

  end;

var
  dr: Tdr;

implementation

{$R *.lfm}

{ Tdr }

procedure Tdr._OPEN_CLOSE(DataSet: TDataSet);
begin
  dbksiegi.Active:=DataSet.Active;
  dbrozdzialy.Active:=DataSet.Active;
  dbtresc.Active:=DataSet.Active;
end;

end.

