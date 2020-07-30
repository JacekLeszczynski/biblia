unit viewer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, Buttons, ZDataset,
  HtmlView;

type

  { TFViewer }

  TFViewer = class(TForm)
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure _OPEN_CLOSE(DataSet: TDataSet);
  private
    procedure start;
  public

  end;

var
  FViewer: TFViewer;

implementation

uses
  lcltype;

{$R *.lfm}

{ TFViewer }

procedure TFViewer.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dbwydania.Close;
end;

procedure TFViewer.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then close;
end;

procedure TFViewer._OPEN_CLOSE(DataSet: TDataSet);
begin
  dbtresc.Active:=DataSet.Active;
  ksiega.Active:=DataSet.Active;
end;

const
  style_body = 'margin: 0; padding: 0; border: 0; outline: 0; vertical-align: baseline; background: 0 0; font-family: tahoma,sans-serif; background-color: 0 0; width: 100%; line-height: 1.5em; font-size: 16px;';
  style_wrap = 'font-family: tahoma,sans-serif; line-height: 1.5em; padding: 0; outline: 0; font-size: 100%; vertical-align: baseline; margin: 0 auto; text-align: center; background: #fff; border: 1px solid #000; width: 960px;';
  style_content = 'font-family: arial,tahoma,sans-serif; line-height: 1.5em; text-align: center; padding: 0; border: 0; outline: 0; font-size: 100%; background: 0 0; margin: 10px 1%; vertical-align: top; display: inline-block; width: 70%;';
  style_rodzaj = 'font-family: tahoma,sans-serif; line-height: 1.5em; margin: 0; border: 0; outline: 0; vertical-align: baseline; background: 0 0; width: 100%; text-align: center; font-size: 1.6em; padding: 12px 0;';
  style_ksiega = 'font-family: tahoma,sans-serif; line-height: 1.5em; text-align: center; margin: 0; padding: 0; border: 0; outline: 0; vertical-align: baseline; background: 0 0; font-size: 1.4em;';
  style_rozdzial = 'font-family: arial,tahoma,sans-serif; text-align: justify; margin: 0; border: 0; outline: 0; vertical-align: baseline; background: 0 0; color: blue; font-size: 4.5em; line-height: .9em; padding: 0 10px 0 0; float: left;';
  style_tresc = 'font-family: arial,tahoma,sans-serif; line-height: 1.5em; margin: 0; border: 0; outline: 0; font-size: 100%; vertical-align: baseline; background: 0 0; padding: 0 2%; text-align: justify;';
  style_werset = 'font-family: arial,tahoma,sans-serif; line-height: 1.5em; text-align: justify; margin: 0; padding: 0; border: 0; outline: 0; font-size: 100%; vertical-align: baseline; background: 0 0; font-weight: 700; color: #000;';
  style_line = 'font-family: tahoma,sans-serif; line-height: 1.5em; text-align: center; padding: 0; border: 0; outline: 0; font-size: 100%; vertical-align: baseline; background: url(../gfx/sep_k_v1.gif) repeat-x center center; height: 20px; margin: 0;';
  style_t0 = 'font-family: tahoma,sans-serif; line-height: 1.5em; margin: 0; padding: 0; border: 0; outline: 0; font-size: 100%; vertical-align: baseline; background: 0 0; font-weight: 700; text-align: justify; color: #0099cf;';
  style_t1 = 'font-family: tahoma,sans-serif; line-height: 1.5em; margin: 0; padding: 0; border: 0; outline: 0; font-size: 100%; vertical-align: baseline; background: 0 0; font-weight: 700; text-align: center; color: #0099cf;';
  style_t2 = 'font-family: tahoma,sans-serif; line-height: 1.5em; margin: 0; padding: 0; border: 0; outline: 0; font-size: 100%; vertical-align: baseline; background: 0 0; font-weight: 700; text-align: center; color: #0099cf;';

procedure TFViewer.start;
var
  nr: integer;
  strona: TStrings;
  mem: TMemoryStream;
  procedure br(aNumber: integer = 1);
  var
    i: integer;
  begin
    for i:=1 to aNumber do strona.Add('<br>');
  end;
begin
  nr:=0;
  strona:=TStringList.Create;
  mem:=TMemoryStream.Create;
  try
    strona.Add('<html>');
    strona.Add('<head>');
    strona.Add('<title>Treść</title>');
    strona.Add('</head>');
    strona.Add('<body style="'+style_body+'">');
    //strona.Add('<div style="'+style_wrap+'">');
    //strona.Add('<div style="'+style_content+'">');
    (* wczytuję dane z bazy *)
    strona.Add('<div style="'+style_rodzaj+'">'+wydanianazwa.AsString+' - '+ksiegarodzaj.AsString+'</div>');
    strona.Add('<div style="'+style_ksiega+'">'+ksieganazwa.AsString+' ('+ksiegaskrot.AsString+')</div>');
    strona.Add('<hr>');
    strona.Add('<div style="'+style_tresc+'">');
    dbtresc.First;
    while not dbtresc.EOF do
    begin
      if not dbtresctytul1.IsNull then
      begin
        br(2);
        strona.Add('<div style="'+style_t1+'">'+dbtresctytul1.AsString+'</div>');
        br;
      end;
      if not dbtresctytul2.IsNull then
      begin
        br(2);
        strona.Add('<div style="'+style_t2+'">'+dbtresctytul2.AsString+'</div>');
        br;
      end;
      if nr<>dbtrescrozdzial.AsInteger then
      begin
        nr:=dbtrescrozdzial.AsInteger;
        strona.Add('<div style="'+style_rozdzial+'">'+dbtrescrozdzial.AsString+'</div>');
        strona.Add('<span style="'+style_t0+'">&nbsp;</span>');
      end;
      strona.Add('<span style="'+style_werset+'">');
      strona.Add('<sup>'+dbtrescwers.AsString+'</sup>');
      strona.Add('</span>');
      strona.Add(dbtresctresc.AsString+' ');
      dbtresc.Next;
    end;
    strona.Add('</div>');
    (* wszystko *)
    //strona.Add('</div>');
    //strona.Add('</div>');
    strona.Add('</body>');
    strona.Add('</html>');
    strona.SaveToStream(mem);
    www.LoadFromStream(mem);
  finally
    mem.Free;
    strona.Free;
  end;
end;

end.

