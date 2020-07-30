unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls,
  Menus, ExtCtrls, XMLPropStorage, ComCtrls, DBGrids, DBCtrls, ZDataset, ueled,
  ExtMessage, Presentation, DSMaster, db, HtmlView, HtmlGlobals,
  HTMLUn2, Types, HTMLSubs;

type

  { TFMain }

  TFMain = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    c_ksiegi: TComboBox;
    c_rozdzialy: TComboBox;
    c_wydania: TComboBox;
    c_interpretacje: TCheckBox;
    master: TDSMaster;
    dsnotatnik: TDataSource;
    dbfindcount: TZQuery;
    dbnotatnik: TZQuery;
    dbfindid: TLargeintField;
    DBGrid2: TDBGrid;
    dbksiegisort: TLargeintField;
    dbksiegiwydanie_id: TLongintField;
    dbrozdzialyksiega_id: TLongintField;
    dbrozdzialyrozdzial: TLargeintField;
    dbrozdzialywydanie_id: TLongintField;
    dbtrescid: TLargeintField;
    dbtrescinterpretacja: TMemoField;
    dbtresctytul1: TStringField;
    dbtresctytul2: TStringField;
    dbwydaniasort_ksiegi_nazwa: TSmallintField;
    dsroz: TDataSource;
    dbfind: TZQuery;
    dbfindilosc: TLargeintField;
    dbfindnazwa: TStringField;
    dbfindrodzaj: TStringField;
    dbfindrozdzial: TLargeintField;
    dbfindskrot: TStringField;
    DBGrid1: TDBGrid;
    dbksiegiid: TLargeintField;
    dbwydaniarodzaj_id: TLargeintField;
    dsfind: TDataSource;
    Edit1: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    dbnotatnikadres: TStringField;
    dbnotatnikid: TLargeintField;
    dbnotatnikinsertdt: TDateTimeField;
    dbnotatniknazwa: TStringField;
    dbnotatnikopis: TMemoField;
    dbnotatnikwyrazenie: TStringField;
    OpenDialogTxt: TOpenDialog;
    PageControl1: TPageControl;
    Panel2: TPanel;
    pilot: TPresentation;
    autorun: TTimer;
    pm_notatnik: TPopupMenu;
    wer_force_enter: TRadioGroup;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    uELED1: TuELED;
    uELED2: TuELED;
    dbtresc: TZQuery;
    dbtrescksiega_id: TLargeintField;
    dbtrescrozdzial: TLargeintField;
    dbtresctresc: TMemoField;
    dbtrescwers: TLargeintField;
    dsksiegi: TDataSource;
    dstresc: TDataSource;
    dswyd: TDataSource;
    dbksiegi: TZQuery;
    dbksieginazwa: TStringField;
    dbksieginr: TLargeintField;
    dbksiegirodzaj: TStringField;
    dbksiegiskrot: TStringField;
    Label2: TLabel;
    mess: TExtMessage;
    MenuGlowne: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Panel1: TPanel;
    dbwydania: TZQuery;
    dbwydaniaid: TLargeintField;
    dbwydanianazwa: TStringField;
    dbwydaniaurl: TStringField;
    propstorage: TXMLPropStorage;
    www: THtmlViewer;
    dbrozdzialy: TZQuery;
    procedure autorunTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure c_interpretacjeClick(Sender: TObject);
    procedure c_ksiegiChange(Sender: TObject);
    procedure c_rozdzialyChange(Sender: TObject);
    procedure c_wydaniaChange(Sender: TObject);
    procedure c_wydaniaDropDown(Sender: TObject);
    procedure dbfindBeforeOpen(DataSet: TDataSet);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure dbksiegiCalcFields(DataSet: TDataSet);
    procedure dbnotatnikBeforeDelete(DataSet: TDataSet);
    procedure dbrozdzialyCalcFields(DataSet: TDataSet);
    procedure dbwydaniaAfterScroll(DataSet: TDataSet);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure pilotClick(aButton: integer; var aTestDblClick: boolean);
    procedure pilotClickLong(aButton: integer; aDblClick: boolean);
    procedure wer_force_enterClick(Sender: TObject);
    procedure wwwHotSpotClick(Sender: TObject; const SRC: ThtString;
      var Handled: Boolean);
    procedure wwwKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuItem4Click(Sender: TObject);
    procedure rozdzialySelect(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
  private
    l_wydania,l_ksiegi: TStringList;
    procedure goto_adres(aStr: string; aFind: string = '');
    procedure zaladuj(aZawartosc: integer);
    function wybierz(aZawartosc: integer): boolean;
    procedure zmiana(aTryb: integer = 0);
    procedure go_focus;
    function opt_odczytaj: string;
    procedure opt_wczytaj(aOpt: string);
    procedure load;
  public

  end;

var
  FMain: TFMain;

implementation

uses
  ecode, serwis, lcltype, edycja_wersetu, notatnik, eksport;

{$R *.lfm}

{ TFMain }

var
  mem_find: string = '';
  memories: string = '';
  vpilot: TArchitektPilot;
  tryb: integer = 1;
  const_find: string = '';

procedure TFMain.MenuItem3Click(Sender: TObject);
begin
  if not mess.ShowConfirmationYesNo('Czy na pewno chcesz ten import wykonać?') then exit;
  try
    mess.ShowInfo('Trwa import - czekaj...');
    application.ProcessMessages;
    dm.import_biblia_daeon_pl;
  finally
    mess.HideInfo;
  end;
end;

procedure TFMain.goto_adres(aStr: string; aFind: string);
var
  b: boolean;
begin
  b:=false;
  if aStr='' then exit;
  if c_wydania.ItemIndex<>StrToInt(GetLineToStr(aStr,1,'-')) then
  begin
    b:=true;
    c_wydania.ItemIndex:=StrToInt(GetLineToStr(aStr,1,'-'));
    c_wydania.Update;
    wybierz(1);
    zaladuj(2);
  end;
  if b or (c_ksiegi.ItemIndex<>StrToInt(GetLineToStr(aStr,2,'-'))) then
  begin
    b:=true;
    c_ksiegi.ItemIndex:=StrToInt(GetLineToStr(aStr,2,'-'));
    c_ksiegi.Update;
    wybierz(2);
    zaladuj(3);
  end;
  if b or (c_rozdzialy.ItemIndex<>StrToInt(GetLineToStr(aStr,3,'-'))) then
  begin
    b:=true;
    c_rozdzialy.ItemIndex:=StrToInt(GetLineToStr(aStr,3,'-'));
    c_rozdzialy.Update;
    wybierz(3);
    const_find:=aFind;
    load;
    go_focus;
  end;
  if b or (www.VScrollBarPosition<>StrToInt(GetLineToStr(aStr,4,'-'))) then
    www.VScrollBarPosition:=StrToInt(GetLineToStr(aStr,4,'-'));
end;

procedure TFMain.zaladuj(aZawartosc: integer);
begin
  if aZawartosc=1 then
  begin
    c_wydania.Clear;
    l_wydania.Clear;
    dbwydania.First;
    while not dbwydania.EOF do
    begin
      c_wydania.Items.Add(dbwydanianazwa.AsString);
      l_wydania.Add(dbwydaniaid.AsString);
      dbwydania.Next;
    end;
    if c_wydania.Items.Count>0 then c_wydania.ItemIndex:=0;
  end else
  if aZawartosc=2 then
  begin
    c_ksiegi.Clear;
    l_ksiegi.Clear;
    dbksiegi.First;
    while not dbksiegi.EOF do
    begin
      c_ksiegi.Items.Add(dbksieginazwa.AsString);
      l_ksiegi.Add(dbksiegiid.AsString);
      dbksiegi.Next;
    end;
    if c_ksiegi.Items.Count>0 then c_ksiegi.ItemIndex:=0;
  end else
  if aZawartosc=3 then
  begin
    c_rozdzialy.Clear;
    dbrozdzialy.First;
    while not dbrozdzialy.EOF do
    begin
      c_rozdzialy.Items.Add(dbrozdzialyrozdzial.AsString);
      dbrozdzialy.Next;
    end;
    if c_rozdzialy.Items.Count>0 then c_rozdzialy.ItemIndex:=0;
  end;
end;

function TFMain.wybierz(aZawartosc: integer): boolean;
begin
  result:=false;
  const_find:='';
  if (aZawartosc=1) and (c_wydania.ItemIndex>-1) then
  begin
    dbwydania.First;
    result:=dbwydania.Locate('id',StrToInt(l_wydania[c_wydania.ItemIndex]),[]);
  end else
  if (aZawartosc=2) and (c_ksiegi.ItemIndex>-1) then
  begin
    dbksiegi.First;
    result:=dbksiegi.Locate('id',StrToInt(l_ksiegi[c_ksiegi.ItemIndex]),[]);
  end else
  if (aZawartosc=3) and (c_rozdzialy.ItemIndex>-1) then
  begin
    dbrozdzialy.First;
    result:=dbrozdzialy.Locate('rozdzial',StrToInt(c_rozdzialy.Text),[]);
  end;
end;

procedure TFMain.zmiana(aTryb: integer);
begin
  if aTryb=0 then
  begin
    uELED1.Active:=false;
    uELED2.Active:=false;
  end else begin
    tryb:=aTryb;
    uELED1.Active:=tryb=1;
    uELED2.Active:=tryb=2;
  end;
end;

procedure TFMain.go_focus;
begin
  if PageControl1.ActivePageIndex=0 then www.SetFocus else DBGrid1.SetFocus;
end;

function TFMain.opt_odczytaj: string;
begin
  result:=dbwydaniaid.AsString+','+dbksiegiid.AsString+','+dbrozdzialyrozdzial.AsString+','+IntToStr(www.VScrollBarPosition);
end;

procedure TFMain.opt_wczytaj(aOpt: string);
var
  b1,b2,b3: boolean;
  s: string;
begin
  if aOpt='' then
  begin
    zaladuj(1);
    if wybierz(1) then zaladuj(2);
    if wybierz(2) then zaladuj(3);
    if wybierz(3) then
    begin
      load;
      go_focus;
    end;
  end else begin
    b1:=true;
    b2:=true;
    b3:=true;
    zaladuj(1);
    s:=GetLineToStr(aOpt,1,',');
    if dbwydania.Locate('id',StrToInt(s),[]) then c_wydania.ItemIndex:=StringToItemIndex(l_wydania,s,0) else b1:=false;
    wybierz(1);
    zaladuj(2);
    s:=GetLineToStr(aOpt,2,',');
    if dbksiegi.Locate('id',StrToInt(s),[]) then c_ksiegi.ItemIndex:=StringToItemIndex(l_ksiegi,s,0) else b2:=false;
    wybierz(2);
    zaladuj(3);
    s:=GetLineToStr(aOpt,3,',');
    if dbrozdzialy.Locate('rozdzial',StrToInt(s),[]) then c_rozdzialy.ItemIndex:=StringToItemIndex(c_rozdzialy.Items,s,0) else b3:=false;
    wybierz(3);
    load;
    go_focus;
    if b1 and b2 and b3 then
    begin
      s:=GetLineToStr(aOpt,4,',');
      if s<>'' then www.VScrollBarPosition:=StrToInt(s);
    end;
  end;
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
  style_find = 'background-color: yellow; color: black';
  style_find2 = 'font-size: 10%';

function najmniejszy(ss: TStringList): integer;
var
  i,a,b,x: integer;
begin
  x:=-1;
  a:=maxint;
  for i:=0 to ss.Count-1 do
  begin
    b:=StrToInt(ss[i]);
    if b=0 then continue;
    if b<a then
    begin
      a:=b;
      x:=i;
    end;
  end;
  result:=x;
end;

function zaznacz(aStr,aSub: string): string;
var
  l1,l2: TStringList;
  s,sub,ss,pom: string;
  i,a,l,x: integer;
begin
  l1:=TStringList.Create;
  l2:=TStringList.Create;
  try
    l:=1;
    while true do
    begin
      s:=GetLineToStr(aSub,l,' ');
      inc(l);
      if s='' then break;
      if s[1]='-' then continue;
      if s[1]='+' then delete(s,1,1);
      l1.Add(s);
    end;
    ss:='';
    s:=aStr;
    while true do
    begin
      l2.Clear;
      for i:=0 to l1.Count-1 do l2.Add(IntToStr(pos(ansiuppercase(l1[i]),ansiuppercase(s))));
      x:=najmniejszy(l2);
      if x=-1 then
      begin
        ss:=ss+s;
        break;
      end;
      sub:=l1[x];
      l:=length(sub);
      a:=StrToInt(l2[x]);
      pom:=copy(s,a,l);
      ss:=ss+copy(s,1,a-1);
      ss:=ss+'<sup style="'+style_find2+'">$FIND$</sup><span style="'+style_find+'"><b>'+pom+'</b></span>';
      delete(s,1,a+l-1);
    end;
  finally
    l1.Free;
    l2.Free;
  end;
  result:=ss;
end;

procedure TFMain.load;
const
  qs1 = ''; qs2 = '';
  {qs = 'p';
  qs1 = '<'+qs+' align="justify" style="text-align: justify; text-justify: inter-character">';
  qs2 = '</'+qs+'>';}
var
  nr: integer;
  strona: TStrings;
  mem: TMemoryStream;
  akapit: integer;
  akapit2: boolean;
  s,si,we,aFinded: string;
procedure br(aNumber: integer = 1);
var
  i: integer;
begin
  for i:=1 to aNumber do strona.Add('<br>');
end;
begin
  case wer_force_enter.ItemIndex of
    0: we:='';
    1: we:='<br>';
    2: we:='<br><br>';
  end;
  nr:=0;
  aFinded:=trim(const_find);
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
    strona.Add('<div style="'+style_rodzaj+'">'+dbwydanianazwa.AsString+' - '+dbksiegirodzaj.AsString+'</div>');
    strona.Add('<div style="'+style_ksiega+'">'+dbksieginazwa.AsString+' ('+dbksiegiskrot.AsString+')</div>');
    strona.Add('<hr>');
    strona.Add('<div style="'+style_tresc+'">');
    dbtresc.First;
    akapit:=0;
    akapit2:=true;
    while not dbtresc.EOF do
    begin
      if not dbtresctytul1.IsNull then
      begin
        br(akapit);
        strona.Add('<div style="'+style_t1+'">'+dbtresctytul1.AsString+'</div>');
        br;
        akapit:=2;
        akapit2:=false;
      end;
      if not dbtresctytul2.IsNull then
      begin
        if akapit2 then br(akapit);
        strona.Add('<div style="'+style_t2+'">'+dbtresctytul2.AsString+'</div>');
        br;
        akapit:=2;
      end;
      if nr<>dbtrescrozdzial.AsInteger then
      begin
        nr:=dbtrescrozdzial.AsInteger;
        strona.Add('<div style="'+style_rozdzial+'">'+dbtrescrozdzial.AsString+'</div>');
        strona.Add('<span style="'+style_t0+'"><br></span>'); //&nbsp;
      end;
      strona.Add('<span style="'+style_werset+'">');
      //strona.Add(dbtrescwers.AsString);
      strona.Add('<a href="id:'+dbtrescid.AsString+'"><sup>'+dbtrescwers.AsString+'</sup></a>');
      strona.Add('</span>');
      s:=dbtresctresc.AsString;
      if aFinded<>'' then s:=zaznacz(s,aFinded);
      s:=StringReplace(s,#10,'<br>',[rfReplaceAll]);
      si:='';
      if c_interpretacje.Checked then
        if dbtrescinterpretacja.AsString<>'' then
          si:='<blockquote><small style="color: black">'+dbtrescinterpretacja.AsString+'</small></blockquote>';
      strona.Add(qs1+s+si+we+qs2);
      dbtresc.Next;
      akapit:=2;
      akapit2:=true;
    end;
    strona.Add('</div>');
    strona.Add('<br>');
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

procedure TFMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  propstorage.WriteString('db_record',opt_odczytaj);
  master.Close;
end;

procedure TFMain.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if Key=VK_RETURN then BitBtn2.Click;
end;

procedure TFMain.BitBtn1Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex:=0;
end;

procedure TFMain.autorunTimer(Sender: TObject);
begin
  autorun.Enabled:=false;
  application.ProcessMessages;
  master.Open;
  opt_wczytaj(propstorage.ReadString('db_record',''));
end;

procedure TFMain.BitBtn2Click(Sender: TObject);
begin
  if trim(Edit1.Text)='' then exit;
  if mem_find=trim(Edit1.Text) then
  begin
    PageControl1.ActivePageIndex:=1;
    go_focus;
    exit;
  end;
  if dbfind.Active then dbfind.Close;
  dbfind.Open;
  if dbfind.IsEmpty then
  begin
    dbfind.Close;
    go_focus;
    exit;
  end;
  PageControl1.ActivePageIndex:=1;
  mem_find:=trim(Edit1.Text);
  go_focus;
end;

procedure TFMain.BitBtn3Click(Sender: TObject);
var
  s: string;
  a: integer;
begin
  s:=trim(Edit1.Text);
  //dbfindcount.ParamByName('find').AsString:=s;
  dbfindcount.ParamByName('find').AsString:=s;
  dbfindcount.ParamByName('find_like').AsString:='%'+s+'%';
  dbfindcount.Open;
  a:=dbfindcount.Fields[0].AsInteger;
  dbfindcount.Close;
  mess.ShowInformation('Wyraz "'+s+'" w całym wydaniu wystąpił '+IntToStr(a)+' razy.');
end;

procedure TFMain.BitBtn4Click(Sender: TObject);
var
  s: string;
begin
  //s:=dbwydaniaid.AsString+'-'+dbksiegiid.AsString+'-'+dbrozdzialyrozdzial.AsString+'-'+IntToStr(www.VScrollBarPosition);
  s:=IntToStr(c_wydania.ItemIndex)+'-'+IntToStr(c_ksiegi.ItemIndex)+'-'+IntToStr(c_rozdzialy.ItemIndex)+'-'+IntToStr(www.VScrollBarPosition);
  BitBtn5.Caption:=s;
end;

procedure TFMain.BitBtn5Click(Sender: TObject);
begin
  goto_adres(BitBtn5.Caption);
end;

procedure TFMain.c_interpretacjeClick(Sender: TObject);
begin
  load;
  go_focus;
end;

procedure TFMain.c_ksiegiChange(Sender: TObject);
begin
  wybierz(2);
  zaladuj(3);
  wybierz(3);
  load;
  go_focus;
end;

procedure TFMain.c_rozdzialyChange(Sender: TObject);
begin
  wybierz(3);
  load;
  go_focus;
end;

procedure TFMain.c_wydaniaChange(Sender: TObject);
var
  b: boolean;
  s: string;
begin
  wybierz(1);
  zaladuj(2);
  s:=GetLineToStr(memories,2,'-');
  c_ksiegi.ItemIndex:=StringToItemIndex(c_ksiegi.Items,s,0);
  b:=c_ksiegi.Text=s;
  wybierz(2);
  zaladuj(3);
  if b then
  begin
    s:=GetLineToStr(memories,3,'-');
    c_rozdzialy.ItemIndex:=StringToItemIndex(c_rozdzialy.Items,s,0);
    b:=c_rozdzialy.Text=s;
  end;
  wybierz(3);
  load;
  go_focus;
  if b then www.VScrollBarPosition:=StrToInt(GetLineToStr(memories,4,'-','0'));
end;

procedure TFMain.c_wydaniaDropDown(Sender: TObject);
begin
  memories:=dbwydanianazwa.AsString+'-'+dbksieginazwa.AsString+'-'+dbrozdzialyrozdzial.AsString+'-'+IntToStr(www.VScrollBarPosition);
end;

procedure TFMain.dbfindBeforeOpen(DataSet: TDataSet);
var
  s: string;
begin
  s:=trim(Edit1.Text);
  dbfind.ParamByName('find').AsString:=s;
  dbfind.ParamByName('find_like').AsString:='%'+s+'%';
end;

procedure TFMain.DBGrid1DblClick(Sender: TObject);
begin
  c_ksiegi.ItemIndex:=StringToItemIndex(l_ksiegi,dbfindid.AsString);
  wybierz(2);
  zaladuj(3);
  c_rozdzialy.Text:=dbfindrozdzial.AsString;
  wybierz(3);
  const_find:=trim(Edit1.Text);
  load;
  BitBtn1.Click;
end;

procedure TFMain.DBGrid2DblClick(Sender: TObject);
begin
  goto_adres(dbnotatnikadres.AsString,dbnotatnikwyrazenie.AsString);
end;

procedure TFMain.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if dbnotatnik.IsEmpty then exit;
  if Key=VK_DELETE then dbnotatnik.Delete;
end;

procedure TFMain.dbksiegiCalcFields(DataSet: TDataSet);
begin
  dbksiegiwydanie_id.AsInteger:=dbwydaniaid.AsInteger;
end;

procedure TFMain.dbnotatnikBeforeDelete(DataSet: TDataSet);
begin
end;

procedure TFMain.dbrozdzialyCalcFields(DataSet: TDataSet);
begin
  dbrozdzialywydanie_id.AsInteger:=dbwydaniaid.AsInteger;
  dbrozdzialyksiega_id.AsInteger:=dbksiegiid.AsInteger;
end;

procedure TFMain.dbwydaniaAfterScroll(DataSet: TDataSet);
begin
  if dbwydaniasort_ksiegi_nazwa.AsInteger=0 then
  dbksiegi.SortedFields:='sort' else dbksiegi.SortedFields:='nazwa';
end;

procedure TFMain.Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if Key=VK_RETURN then BitBtn3.Click;
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
  l_wydania.Free;
  l_ksiegi.Free;
end;

procedure TFMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if MenuItem7.Checked then pilot.Execute(Key);
end;

procedure TFMain.MenuItem10Click(Sender: TObject);
begin
  try
    FNotatnik:=TFNotatnik.Create(self);
    FNotatnik.io_id:=0; //dodanie nowej pozycji
    FNotatnik.io_adres:=IntToStr(c_wydania.ItemIndex)+'-'+IntToStr(c_ksiegi.ItemIndex)+'-'+IntToStr(c_rozdzialy.ItemIndex)+'-'+IntToStr(www.VScrollBarPosition);
    FNotatnik.io_wyrazenie:=Edit1.Text;
    FNotatnik.ShowModal;
    if FNotatnik.io_id>0 then
    begin
      dbnotatnik.Refresh;
      dbnotatnik.First;
      dbnotatnik.Locate('id',FNotatnik.io_id,[]);
    end;
  finally
    FNotatnik.Free;
  end;
end;

procedure TFMain.MenuItem11Click(Sender: TObject);
begin
  try
    FNotatnik:=TFNotatnik.Create(self);
    FNotatnik.io_id:=dbnotatnikid.AsInteger; //edycja pozycji
    FNotatnik.ShowModal;
    if FNotatnik.io_id>0 then dbnotatnik.Refresh;
  finally
    FNotatnik.Free;
  end;
end;

procedure TFMain.MenuItem12Click(Sender: TObject);
begin
  if dbnotatnik.IsEmpty then exit;
  dbnotatnik.Delete;
end;

procedure TFMain.MenuItem13Click(Sender: TObject);
begin
  FEksport:=TFEksport.Create(self);
  FEksport.ShowModal;
end;

procedure TFMain.MenuItem6Click(Sender: TObject);
begin
  MenuItem6.Checked:=not MenuItem6.Checked;
  {if MenuItem6.Checked then
    www.HtOptions:=[htPrintTableBackground,htPrintMonochromeBlack]
  else
    www.HtOptions:=[htNoLinkUnderline,htPrintTableBackground,htPrintMonochromeBlack];}
end;

procedure TFMain.MenuItem7Click(Sender: TObject);
begin
  MenuItem7.Checked:=not MenuItem7.Checked;
  if MenuItem7.Checked then zmiana(1) else zmiana;
end;

procedure TFMain.MenuItem9Click(Sender: TObject);
begin
//  dm.schema.SaveSchema;
end;

procedure TFMain.pilotClick(aButton: integer; var aTestDblClick: boolean);
var
  a: ^TArchitekt;
  b: ^TArchitektPrzycisk;
begin
  b:=nil;
  if tryb=1 then a:=@vpilot.t1 else a:=@vpilot.t2;
  case aButton of
    1: b:=@a^.p1;
    2: b:=@a^.p2;
    3: b:=@a^.p3;
    4: b:=@a^.p4;
    5: if a^.suma45 then b:=@a^.p4 else b:=@a^.p5;
  end;
  case b^.funkcja_wewnetrzna of
    1: zmiana(1);
    2: zmiana(2);
    3: if tryb=1 then zmiana(2) else zmiana(1);
    4: zmiana(1);
    5: zmiana(2);
    6: zmiana(1);
    7: zmiana(2);
  end;
  if b^.kod_wewnetrzny>0 then pilot.SendKey(b^.kod_wewnetrzny);
  aTestDblClick:=b^.operacja_zewnetrzna;
end;

procedure TFMain.pilotClickLong(aButton: integer; aDblClick: boolean);
var
  a: ^TArchitekt;
begin
  if tryb=1 then a:=@vpilot.t1 else a:=@vpilot.t2;
  if aDblClick then
  begin
    case aButton of
      1: if a^.p1.dwuklik>0 then pilot.SendKey(a^.p1.dwuklik);
      2: if a^.p2.dwuklik>0 then pilot.SendKey(a^.p2.dwuklik);
      3: if a^.p3.dwuklik>0 then pilot.SendKey(a^.p3.dwuklik);
      4: if a^.p4.dwuklik>0 then pilot.SendKey(a^.p4.dwuklik);
      5: if a^.p5.dwuklik>0 then pilot.SendKey(a^.p5.dwuklik);
    end;
  end else begin
    case aButton of
      1: if a^.p1.klik>0 then pilot.SendKey(a^.p1.klik);
      2: if a^.p2.klik>0 then pilot.SendKey(a^.p2.klik);
      3: if a^.p3.klik>0 then pilot.SendKey(a^.p3.klik);
      4: if a^.p4.klik>0 then pilot.SendKey(a^.p4.klik);
      5: if a^.p5.klik>0 then pilot.SendKey(a^.p5.klik);
    end;
  end;
end;

procedure TFMain.wer_force_enterClick(Sender: TObject);
begin
  load;
  go_focus;
end;

procedure TFMain.wwwHotSpotClick(Sender: TObject; const SRC: ThtString;
  var Handled: Boolean);
var
  vid: integer;
  a: integer;
begin
  if MenuItem7.Checked then
  begin
    vid:=StrToInt(GetLineToStr(SRC,2,':'));
    dbtresc.First;
    if dbtresc.Locate('id',vid,[]) then
    begin
      dm.wygeneruj_plik('('+dbtrescwers.AsString+') '+dbtresctresc.AsString);
    end;
  end else
  if MenuItem6.Checked then
  begin
    vid:=StrToInt(GetLineToStr(SRC,2,':'));
    dbtresc.First;
    FEditWers:=TFEditWers.Create(self);
    try
      FEditWers.io_id:=vid;
      FEditWers.ShowModal;
      if FEditWers.io_zapis then
      begin
        a:=www.VScrollBarPosition;
        dbtresc.Refresh;
        load;
        www.VScrollBarPosition:=a;
      end;
    finally
      FEditWers.Free;
    end;
  end;
end;

procedure TFMain.wwwKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  s: string;
begin
  s:='$FIND$';
  {kopiowanie zaznaczonego tekstu do schowka}
  if (ssCtrl in Shift) and ((Key=ord('c')) or (Key=ord('C'))) then www.CopyToClipboard else
  if (Key=VK_F3) and (s<>'') then
  begin
    if ssShift in Shift then www.FindEx(s,false,true) else www.Find(s,false);
  end;
  Key:=0;
end;

procedure TFMain.MenuItem4Click(Sender: TObject);
var
  b: boolean;
begin
  if OpenDialogTxt.Execute then
  begin
    b:=dm.import_txt_generuj(OpenDialogTxt.FileName);
    if b then
    begin
      try
        if mess.ShowConfirmationYesNo('Domyślnie zostanie przeprowadzony test z wyświetleniem importu na ekranie.^^Czy wykonać test?') then
        begin
          dm.import_txt(OpenDialogTxt.FileName,true);
        end else begin
          dm.trans.StartTransaction;
          if dm.import_txt(OpenDialogTxt.FileName) then dm.trans.Commit else dm.trans.Rollback;
        end;
      except
        dm.trans.Rollback;
      end;
    end else mess.ShowInformation('Wygenerowany został plik nagłówkowy, uzupełnij go prawidłowo i spróbuj jeszcze raz.');
  end;
end;

procedure TFMain.rozdzialySelect(Sender: TObject);
begin
  dbtresc.Close;
  dbtresc.Open;
  load;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  l_wydania:=TStringList.Create;
  l_ksiegi:=TStringList.Create;
  SetConfDir('pisma-starozytne');
  vpilot:=dm.pilot_wczytaj;
  propstorage.FileName:=MyConfDir('config.xml');
  propstorage.Active:=true;
  PageControl1.ActivePageIndex:=0;
  www.Clear;
  autorun.Enabled:=true;
end;

end.

