unit eksport;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ComCtrls, ExtCtrls, CheckLst, DSMaster, ExtMessage, ZDataset, ZSqlMonitor,
  AbZipper;

type

  { TFEksport }

  TFEksport = class(TForm)
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    ksiega: TCheckListBox;
    dbksiegi: TZQuery;
    dbksiegiid: TLargeintField;
    dbksieginazwa: TStringField;
    dsksiegi: TDataSource;
    Label2: TLabel;
    StatusBar1: TStatusBar;
    zip: TAbZipper;
    allid: TLargeintField;
    allksiega_id: TLargeintField;
    allrodzaj_id: TLargeintField;
    allwydanie_id: TLargeintField;
    ds_rwyd: TDataSource;
    ds_wersy: TDataSource;
    ds_rodzaj: TDataSource;
    ds_ksiegi: TDataSource;
    ds_ksort: TDataSource;
    mess: TExtMessage;
    s_ks: TZQuery;
    s_ksid: TLargeintField;
    s_kskomentarz: TMemoField;
    s_ksnazwa: TStringField;
    s_ksnr: TLargeintField;
    s_ksopis: TMemoField;
    s_ksortksiegi_id: TLargeintField;
    s_ksortsort: TLargeintField;
    s_ksortwydania_id: TLargeintField;
    s_ksrodzaj_id: TLargeintField;
    s_ksskrot: TStringField;
    s_ksurl: TStringField;
    s_kswydanie_id: TLargeintField;
    s_rwyd: TZQuery;
    s_rodzid: TLargeintField;
    s_rodzid1: TLargeintField;
    s_rodzid_nadrzedne: TLargeintField;
    s_rodzid_nadrzedne1: TLargeintField;
    s_rodznazwa: TStringField;
    s_rodznazwa1: TStringField;
    s_rodzskrot: TStringField;
    s_rodzskrot1: TStringField;
    s_wersy: TZQuery;
    s_ksort: TZQuery;
    s_wersyid: TLargeintField;
    s_wersyinterpretacja: TMemoField;
    s_wersyksiega_id: TLargeintField;
    s_wersyrodzaj_id: TLargeintField;
    s_wersyrozdzial: TLargeintField;
    s_wersytresc: TMemoField;
    s_wersytytul1: TStringField;
    s_wersytytul2: TStringField;
    s_wersyurl: TStringField;
    s_wersywers: TLargeintField;
    s_wersywydanie_id: TLargeintField;
    s_wyd: TZQuery;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ds_all: TDataSource;
    ds_wydanie: TDataSource;
    master: TDSMaster;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    s_rodz: TZQuery;
    s_wyddata_importu: TDateField;
    s_wydid: TLargeintField;
    s_wydkomentarz: TMemoField;
    s_wydnazwa: TStringField;
    s_wydopis: TMemoField;
    s_wydrodzaj_id: TLargeintField;
    s_wydsort_ksiegi_nazwa: TLargeintField;
    s_wydurl: TStringField;
    wydanie: TComboBox;
    dbwydania: TZQuery;
    dbwydaniaid: TLargeintField;
    dbwydanianazwa: TStringField;
    dswyd: TDataSource;
    Label1: TLabel;
    all: TZQuery;
    ZSQLMonitor1: TZSQLMonitor;
    procedure allBeforeOpen(DataSet: TDataSet);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure dbksiegiBeforeOpen(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ksiegaClickCheck(Sender: TObject);
    procedure wydanieChange(Sender: TObject);
  private
    wid,wid2: TStrings;
    procedure refresh_ksiegi;
    procedure ksiegi_on;
    procedure ksiegi_off;
    procedure ksiegi_nop;
    function ksiega_test: boolean;
    procedure eksportuj_do_pliku(aPlik: string);
    function enter2x(s: string): string;
  public

  end;

var
  FEksport: TFEksport;

implementation

uses
  serwis, ecode;

{$R *.lfm}

{ TFEksport }

procedure TFEksport.FormCreate(Sender: TObject);
begin
  wid:=TStringList.Create;
  wid2:=TStringList.Create;
  dbwydania.Open;
  while not dbwydania.EOF do
  begin
    wid.Add(dbwydaniaid.AsString);
    wydanie.Items.Add(dbwydanianazwa.AsString);
    dbwydania.Next;
  end;
  dbwydania.Close;
  if wydanie.Items.Count>0 then
  begin
    wydanie.ItemIndex:=0;
    refresh_ksiegi;
  end;
end;

procedure TFEksport.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TFEksport.BitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure TFEksport.allBeforeOpen(DataSet: TDataSet);
var
  s1,s2: string;
  i: integer;
begin
  (* obliczenia *)
  s1:=wid[wydanie.ItemIndex];
  s2:='';
  for i:=0 to ksiega.Count-1 do if ksiega.Checked[i] then if s2='' then s2:=wid2[i] else s2:=s2+','+wid2[i];
  (* SQL *)
  all.SQL.Clear;
  all.SQL.Add('select * from v_wersy');
  all.SQL.Add('where wydanie_id='+s1);
  all.SQL.Add('  and ksiega_id in ('+s2+')');
  all.SQL.Add('order by id');
end;

procedure TFEksport.BitBtn2Click(Sender: TObject);
begin
  if wydanie.ItemIndex=-1 then exit;
  if SaveDialog1.Execute then eksportuj_do_pliku(SaveDialog1.FileName);
end;

procedure TFEksport.BitBtn3Click(Sender: TObject);
begin
  ksiegi_on;
end;

procedure TFEksport.BitBtn4Click(Sender: TObject);
begin
  ksiegi_off;
end;

procedure TFEksport.BitBtn5Click(Sender: TObject);
begin
  ksiegi_nop;
end;

procedure TFEksport.dbksiegiBeforeOpen(DataSet: TDataSet);
begin
  dbksiegi.ParamByName('id').AsInteger:=StrToInt(wid[wydanie.ItemIndex]);
end;

procedure TFEksport.FormDestroy(Sender: TObject);
begin
  wid.Free;
  wid2.Free;
end;

procedure TFEksport.ksiegaClickCheck(Sender: TObject);
begin
  BitBtn2.Enabled:=ksiega_test;
end;

procedure TFEksport.wydanieChange(Sender: TObject);
begin
  refresh_ksiegi;
end;

procedure TFEksport.refresh_ksiegi;
begin
  ksiega.Clear;
  wid2.Clear;
  dbksiegi.Open;
  while not dbksiegi.EOF do
  begin
    wid2.Add(dbksiegiid.AsString);
    ksiega.Items.Add(dbksieginazwa.AsString);
    dbksiegi.Next;
  end;
  dbksiegi.Close;
  ksiegi_on;
end;

procedure TFEksport.ksiegi_on;
begin
  ksiega.CheckAll(cbChecked);
  BitBtn2.Enabled:=ksiega.Count>0;
end;

procedure TFEksport.ksiegi_off;
begin
  ksiega.CheckAll(cbUnchecked);
  BitBtn2.Enabled:=false;
end;

procedure TFEksport.ksiegi_nop;
var
  i: integer;
begin
  for i:=0 to ksiega.Items.Count-1 do ksiega.Checked[i]:=not ksiega.Checked[i];
  BitBtn2.Enabled:=ksiega_test;
end;

function TFEksport.ksiega_test: boolean;
var
  i: integer;
begin
  result:=false;
  for i:=0 to ksiega.Count-1 do if ksiega.Checked[i] then
  begin
    result:=true;
    break;
  end;
end;

procedure TFEksport.eksportuj_do_pliku(aPlik: string);
var
  s: string;
  v_rodz_ks,v_ksiega: string;
  v_rozdzial: integer;
  ss: TStringList;
  mm: TMemoryStream;
  mm2: TStringStream;
begin
  s:=ExtractFileExt(aPlik);
  if s='' then aPlik:=aPlik+'.zip';
  if FileExists(aPlik) then if mess.ShowConfirmationYesNo('Plik "'+aPlik+'" istnieje, czy chcesz go nadpisać?') then DeleteFile(aPlik) else exit;
  v_rodz_ks:='';
  v_ksiega:='';
  v_rozdzial:=-1;
  //ZSQLMonitor1.Active:=true;
  master.Open;
  //ZSQLMonitor1.Active:=false;
  if all.RecordCount=0 then
  begin
    mess.ShowError('Brak danych z niewiadomego powodu, przerywam!');
    master.Close;
    exit;
  end;
  ss:=TStringList.Create;
  try
    ProgressBar1.Position:=0;
    ProgressBar1.Max:=all.RecordCount;
    (* wydanie *)
    ss.Add('$wydanie='+enter2x(s_wydnazwa.AsString));
    ss.Add('$wydanie_rodzaj='+enter2x(s_rodznazwa1.AsString));
    if IsString(s_wydurl.AsString) then ss.Add('$wydanie_url='+enter2x(s_wydurl.AsString));
    if IsString(s_wydopis.AsString) then ss.Add('$wydanie_opis='+enter2x(s_wydopis.AsString));
    if IsString(s_wydkomentarz.AsString) then ss.Add('$wydanie_komentarz='+enter2x(s_wydkomentarz.AsString));
    if IsString(s_wydsort_ksiegi_nazwa.AsString) then ss.Add('$wydanie_sort_ksiegi_nazwa='+enter2x(s_wydsort_ksiegi_nazwa.AsString));
    if IsString(s_rodznazwa1.AsString) then ss.Add('$wydanie_rodzina='+enter2x(s_rodznazwa1.AsString));
    while not all.EOF do
    begin
      (* rodzaj księgi *)
      if v_rodz_ks<>s_rodznazwa.AsString then
      begin
        v_rodz_ks:=s_rodznazwa.AsString;
        if IsString(s_rodznazwa.AsString) then ss.Add('$rk_rodzaj='+enter2x(s_rodznazwa.AsString));
        if IsString(s_rodzskrot.AsString) then ss.Add('$rk_skrot='+enter2x(s_rodzskrot.AsString));
      end;
      (* ksiega *)
      if v_ksiega<>s_ksnazwa.AsString then
      begin
        StatusBar1.Panels[0].Text:=enter2x(s_ksnazwa.AsString);
        ksiega.ItemIndex:=StringToItemIndex(wid2,s_ksid.AsString);
        v_ksiega:=s_ksnazwa.AsString;
        if IsString(s_ksnazwa.AsString) then ss.Add('$ks_rodzaj='+enter2x(s_ksnazwa.AsString));
        if IsString(s_ksskrot.AsString) then ss.Add('$ks_skrot='+enter2x(s_ksskrot.AsString));
        if IsString(s_ksurl.AsString) then ss.Add('$ks_url='+enter2x(s_ksurl.AsString));
        if IsString(s_ksopis.AsString) then ss.Add('$ks_opis='+enter2x(s_ksopis.AsString));
        if IsString(s_kskomentarz.AsString) then ss.Add('$ks_komentarz='+enter2x(s_kskomentarz.AsString));
      end;
      (* wersety ustawione w odpowiedniej kolejności *)
      if v_rozdzial<>s_wersyrozdzial.AsInteger then
      begin
        StatusBar1.Panels[1].Text:='Rozdział: '+s_wersyrozdzial.AsString;
        v_rozdzial:=s_wersyrozdzial.AsInteger;
        ss.Add('$rozdzial='+enter2x(s_wersyrozdzial.AsString));
      end;
      if IsString(s_wersytytul1.AsString) then ss.Add('$tytul1='+enter2x(s_wersytytul1.AsString));
      if IsString(s_wersytytul2.AsString) then ss.Add('$tytul2='+enter2x(s_wersytytul2.AsString));
      if IsString(s_wersyinterpretacja.AsString) then ss.Add('$interpretacja='+enter2x(s_wersyinterpretacja.AsString));
      if IsString(s_wersyurl.AsString) then ss.Add('url='+enter2x(s_wersyurl.AsString));
      StatusBar1.Panels[2].Text:='Wers: '+s_wersywers.AsString;
      ss.Add(enter2x(s_wersytresc.AsString));
      all.Next;
      ProgressBar1.Position:=ProgressBar1.Position+1;
      application.ProcessMessages;
    end;
    (* kompresja *)
    mm:=TMemoryStream.Create;
    mm2:=TStringStream.Create('Bible ver. '+dm.GetVersion);
    try
      zip.FileName:=aPlik;
      ss.SaveToStream(mm);
      zip.AddFromStream('ver.txt',mm2);
      zip.AddFromStream('export.txt',mm);
      zip.Save;
      zip.CloseArchive;
    finally
      mm.Free;
      mm2.Free;
    end;
  finally
    StatusBar1.Panels[0].Text:='';
    StatusBar1.Panels[1].Text:='';
    StatusBar1.Panels[2].Text:='';
    ss.Free;
    master.Close;
    StatusBar1.SimpleText:='';
    mess.ShowInformation('Eksport wykonany.');
  end;
end;

function TFEksport.enter2x(s: string): string;
begin
  s:=trim(s);
  s:=StringReplace(s,#10,'{$10}',[rfReplaceAll]);
  s:=StringReplace(s,#13,'{$13}',[rfReplaceAll]);
  s:=StringReplace(s,'''','{$1}',[rfReplaceAll]);
  s:=StringReplace(s,'"','{$2}',[rfReplaceAll]);
  result:=s;
end;

end.

