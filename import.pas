unit import;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, EditBtn,
  StdCtrls, Buttons, AbUnzper, ExtMessage;

type

  { TFImport }

  TFImport = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label7: TLabel;
    ProgressBar1: TProgressBar;
    srodzina: TLabel;
    unzip: TAbUnZipper;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    swydaniekomentarz: TLabel;
    swydanieurl: TLabel;
    swydanie: TLabel;
    mess: TExtMessage;
    FileImport: TFileNameEdit;
    Label1: TLabel;
    StatusBar1: TStatusBar;
    swydanierodzaj: TLabel;
    swydanieopis: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FileImportAcceptFileName(Sender: TObject; var Value: String);
    procedure FileImportButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    tekst: TStrings;
    procedure plik_getinfo(aPlik: string);
    function x2enter(s: string): string;
  public
  end;

var
  FImport: TFImport;

implementation

uses
  ecode, serwis, class_import;

{$R *.lfm}

{ TFImport }

procedure TFImport.FileImportAcceptFileName(Sender: TObject;
  var Value: String);
begin
  plik_getinfo(Value);
end;

procedure TFImport.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TFImport.BitBtn1Click(Sender: TObject);
var
  ii: TImport;
  i: integer;
  s,s1,s2: string;
begin
  ii:=TImport.Create(dm.db);
  try
    for i:=0 to tekst.Count-1 do
    begin
      s:=trim(tekst[i]);
      if s='' then continue;
      if s[1]='$' then
      begin
        s1:=GetLineToStr(s,1,'=');
        s2:=x2enter(GetLineToStr(s,2,'='));
        if s1='$wydanie' then ii.wydanie_nazwa:=s2 else
        if s1='$wydanie_rodzaj' then ii.wydanie_rodzaj:=s2 else
        if s1='$wydanie_url' then ii.wydanie_url:=s2 else
        if s1='$wydanie_opis' then ii.wydanie_opis:=s2 else
        if s1='$wydanie_komentarz' then ii.wydanie_komentarz:=s2 else
        if s1='$wydanie_rodzina' then ii.wydanie_rodzina:=s2 else
        if s1='$rk_rodzaj' then break else
        if s1='$ks_rodzaj' then break;
      end;

    end;
  finally
    ii.Free;
  end;
end;

procedure TFImport.FileImportButtonClick(Sender: TObject);
begin
  if FileImport.InitialDir='' then FileImport.InitialDir:=MyDir;
end;

procedure TFImport.FormCreate(Sender: TObject);
begin
  tekst:=TStringList.Create;
end;

procedure TFImport.FormDestroy(Sender: TObject);
begin
  tekst.Free;
end;

procedure TFImport.plik_getinfo(aPlik: string);
var
  s,s1,s2: string;
  b: boolean;
  ms: TStringStream;
  mm: TMemoryStream;
  i: integer;
begin
  ms:=TStringStream.Create;
  mm:=TMemoryStream.Create;
  try
    unzip.FileName:=aPlik;
    unzip.ExtractToStream('ver.txt',ms);
    s:=ms.DataString;
    b:=pos('Bible ver. ',s)=1;
    if not b then
    begin
      mess.ShowError('To nie jest plik z oczekiwanymi danymi!');
      exit;
    end;
    unzip.ExtractToStream('export.txt',mm);
    mm.Position:=0;
    tekst.Clear;
    tekst.LoadFromStream(mm);
  finally
    ms.Free;
    mm.Free;
  end;
  (* czyszczenie kontrolek *)
  swydanie.Caption:='';
  swydanierodzaj.Caption:='';
  swydanieurl.Caption:='';
  swydanieopis.Caption:='';
  swydaniekomentarz.Caption:='';
  srodzina.Caption:='';
  (* wczytanie danych nagłówka *)
  for i:=0 to tekst.Count-1 do
  begin
    s:=trim(tekst[i]);
    if s='' then continue;
    if s[1]='$' then
    begin
      s1:=GetLineToStr(s,1,'=');
      s2:=x2enter(GetLineToStr(s,2,'='));
      if s1='$wydanie' then swydanie.Caption:=s2 else
      if s1='$wydanie_rodzaj' then swydanierodzaj.Caption:=s2 else
      if s1='$wydanie_url' then swydanieurl.Caption:=s2 else
      if s1='$wydanie_opis' then swydanieopis.Caption:=s2 else
      if s1='$wydanie_komentarz' then swydaniekomentarz.Caption:=s2 else
      if s1='$wydanie_rodzina' then srodzina.Caption:=s2 else
      if s1='$rk_rodzaj' then break else
      if s1='$ks_rodzaj' then break;
    end;
    if i>20 then break;
  end;
end;

function TFImport.x2enter(s: string): string;
begin
  s:=trim(s);
  s:=StringReplace(s,'{$10}',#10,[rfReplaceAll]);
  s:=StringReplace(s,'{$13}',#13,[rfReplaceAll]);
  s:=StringReplace(s,'{$1}','''',[rfReplaceAll]);
  s:=StringReplace(s,'{$2}','"',[rfReplaceAll]);
  result:=s;
end;

end.

