unit edycja_wersetu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  Buttons, ExtMessage, ZDataset, ZSqlUpdate, ueled;

type

  { TFEditWers }

  TFEditWers = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    mess: TExtMessage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    uELED1: TuELED;
    dswers: TDataSource;
    wers: TZQuery;
    wers_update: TZQuery;
    wersid: TLargeintField;
    wersinterpretacja: TMemoField;
    wersrozdzial: TLargeintField;
    werstresc: TMemoField;
    werstytul1: TStringField;
    werstytul2: TStringField;
    werswers: TLargeintField;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure wersBeforeOpen(DataSet: TDataSet);
    procedure _CHANGE(Sender: TObject);
  private
    procedure wczytaj;
  public
    io_id: integer;
    io_zapis: boolean;
  end;

var
  FEditWers: TFEditWers;

implementation

{$R *.lfm}

{ TFEditWers }

procedure TFEditWers.wersBeforeOpen(DataSet: TDataSet);
begin
  wers.ParamByName('id').AsInteger:=io_id;
end;

procedure TFEditWers._CHANGE(Sender: TObject);
begin
  uELED1.Active:=true;
end;

procedure TFEditWers.wczytaj;
begin
  io_zapis:=false;
  uELED1.Active:=false;
  wers.Open;
  Label1.Caption:='ID='+wersid.AsString+', Rozdział='+wersrozdzial.AsString+', Werset='+werswers.AsString;
  Edit1.Text:=werstytul1.AsString;
  Edit2.Text:=werstytul2.AsString;
  Memo1.Clear;
  Memo2.Clear;
  Memo1.Lines.AddText(werstresc.AsString);
  Memo2.Lines.AddText(wersinterpretacja.AsString);
  wers.Close;
end;

procedure TFEditWers.FormShow(Sender: TObject);
begin
  wczytaj;
end;

procedure TFEditWers.BitBtn2Click(Sender: TObject);
begin
  if uELED1.Active then
  begin
    if trim(Memo1.Text)='' then
    begin
      mess.ShowWarning('Pole treść wersu jest wymagane!');
      exit;
    end;
    wers_update.ParamByName('tresc').AsString:=trim(Memo1.Text);
    if trim(Edit1.Text)='' then wers_update.ParamByName('t1').Clear else wers_update.ParamByName('t1').AsString:=trim(Edit1.Text);
    if trim(Edit2.Text)='' then wers_update.ParamByName('t2').Clear else wers_update.ParamByName('t2').AsString:=trim(Edit2.Text);
    if trim(Memo2.Text)='' then wers_update.ParamByName('interpretacja').Clear else wers_update.ParamByName('interpretacja').AsString:=trim(Memo2.Text);
    wers_update.ParamByName('id').AsInteger:=io_id;
    wers_update.ExecSQL;
    io_zapis:=true;
  end;
  close;
end;

procedure TFEditWers.BitBtn1Click(Sender: TObject);
begin
  wczytaj;
end;

end.

