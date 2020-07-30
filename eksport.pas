unit eksport;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ComCtrls, ZDataset;

type

  { TFEksport }

  TFEksport = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    wydanie: TComboBox;
    dbwydania: TZQuery;
    dbwydaniaid: TLargeintField;
    dbwydanianazwa: TStringField;
    dswyd: TDataSource;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure wydanieChange(Sender: TObject);
  private
    wid: TStrings;
    procedure eksportuj_do_pliku(aPlik: string);
  public

  end;

var
  FEksport: TFEksport;

implementation

{$R *.lfm}

{ TFEksport }

procedure TFEksport.FormCreate(Sender: TObject);
begin
  wid:=TStringList.Create;
  dbwydania.Open;
  while not dbwydania.EOF do
  begin
    dbwydaniaid.AsInteger;
    wydanie.Items.Add(dbwydanianazwa.AsString);
    dbwydania.Next;
  end;
  dbwydania.Close;
end;

procedure TFEksport.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TFEksport.BitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure TFEksport.BitBtn2Click(Sender: TObject);
begin
  if wydanie.ItemIndex=-1 then exit;
  if SaveDialog1.Execute then eksportuj_do_pliku(SaveDialog1.FileName);
end;

procedure TFEksport.FormDestroy(Sender: TObject);
begin
  wid.Free;
end;

procedure TFEksport.wydanieChange(Sender: TObject);
begin
  BitBtn2.Enabled:=wydanie.ItemIndex>-1;
end;

procedure TFEksport.eksportuj_do_pliku(aPlik: string);
begin

end;

end.

