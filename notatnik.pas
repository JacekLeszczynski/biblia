unit notatnik;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  ExtCtrls, Buttons, ZDataset, ueled;

type

  { TFNotatnik }

  TFNotatnik = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    dbnotatnik: TZQuery;
    dbupdate: TZQuery;
    dbnotatnikadres: TStringField;
    dbnotatnikid: TLargeintField;
    dbnotatnikinsertdt: TDateTimeField;
    dbnotatniknazwa: TStringField;
    dbnotatnikopis: TMemoField;
    dbnotatnikwyrazenie: TStringField;
    dbinsert: TZQuery;
    dsnotatnik: TDataSource;
    knazwa: TEdit;
    kwyrazenie: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    kid: TLabel;
    kczas: TLabel;
    kopis: TMemo;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    kzmiany: TuELED;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure dbnotatnikBeforeOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure _CHANGE(Sender: TObject);
  private
    procedure wczytaj;
    procedure zapisz;
  public
    io_id: integer;
    io_adres,io_wyrazenie: string;
  end;

var
  FNotatnik: TFNotatnik;

implementation

uses
  serwis;

{$R *.lfm}

{ TFNotatnik }

procedure TFNotatnik.FormShow(Sender: TObject);
begin
  wczytaj;
end;

procedure TFNotatnik._CHANGE(Sender: TObject);
begin
  kzmiany.Active:=true;
end;

procedure TFNotatnik.BitBtn2Click(Sender: TObject);
begin
  wczytaj;
end;

procedure TFNotatnik.dbnotatnikBeforeOpen(DataSet: TDataSet);
begin
  dbnotatnik.ParamByName('id').AsInteger:=io_id;
end;

procedure TFNotatnik.BitBtn1Click(Sender: TObject);
begin
  if kzmiany.Active then zapisz else io_id:=0;
  close;
end;

procedure TFNotatnik.wczytaj;
begin
  kopis.Clear;
  if io_id=0 then
  begin
    kid.Caption:='(nowy rekord)';
    kczas.Caption:=' ';
    knazwa.Text:='';
    kwyrazenie.Text:=io_wyrazenie;
  end else begin
    dbnotatnik.Open;
    kid.Caption:=dbnotatnikid.AsString;
    kczas.Caption:=FormatDateTime('yyyy-mm-dd',dbnotatnikinsertdt.AsDateTime);
    knazwa.Text:=dbnotatniknazwa.AsString;
    kopis.Lines.AddText(dbnotatnikopis.AsString);
    kwyrazenie.Text:=dbnotatnikwyrazenie.AsString;
    dbnotatnik.Close;
  end;
  kzmiany.Active:=false;
  knazwa.SetFocus;
end;

procedure TFNotatnik.zapisz;
begin
  if io_id=0 then
  begin
    dbinsert.ParamByName('czas').AsDateTime:=now;
    dbinsert.ParamByName('nazwa').AsString:=knazwa.Text;
    dbinsert.ParamByName('adres').AsString:=io_adres;
    if trim(kopis.Text)='' then dbinsert.ParamByName('opis').Clear else
      dbinsert.ParamByName('opis').AsString:=kopis.Text;
    if trim(kwyrazenie.Text)='' then dbinsert.ParamByName('wyrazenie').Clear else
      dbinsert.ParamByName('wyrazenie').AsString:=kwyrazenie.Text;
    dbinsert.ExecSQL;
    io_id:=dm.GetLastID;
  end else begin
    dbupdate.ParamByName('czas').AsDateTime:=now;
    dbupdate.ParamByName('nazwa').AsString:=knazwa.Text;
    if trim(kopis.Text)='' then dbupdate.ParamByName('opis').Clear else
      dbupdate.ParamByName('opis').AsString:=kopis.Text;
    if trim(kwyrazenie.Text)='' then dbupdate.ParamByName('wyrazenie').Clear else
      dbupdate.ParamByName('wyrazenie').AsString:=kwyrazenie.Text;
    dbupdate.ParamByName('id').AsInteger:=io_id;
    dbupdate.ExecSQL;
  end;
end;

end.

