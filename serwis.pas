unit serwis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZTransaction, NetSynHTTP, PointerTab, DBSchemaSync,
  Process, db, AsyncProcess, ZConnection, ZDataset;

type
  TArchitektPrzycisk = record
    funkcja_wewnetrzna: integer;
    kod_wewnetrzny: word;
    operacja_zewnetrzna: boolean; //wykonaj spawdzenie na zewnątrz (pojedyńczy klik, podwójny klik)
    klik,dwuklik: word; //jaki kod ma zostać wywołany w obu przypadkach (0 - funkcja nieaktywna)
  end;

  TArchitekt = record
    p1,p2,p3,p4,p5: TArchitektPrzycisk;
    suma45: boolean; //przycisk piąty ma zachowywać się dokładnie tak jak czwarty!
  end;

  TArchitektPilot = record
    t1,t2,t3,t4: TArchitekt;
  end;

  { Tdm }

  Tdm = class(TDataModule)
    db: TZConnection;
    get_ksid: TLargeintField;
    get_ksiegiid: TLargeintField;
    get_ksieginazwa: TStringField;
    get_ksiegiskrot: TStringField;
    ksiega2id: TZQuery;
    get_rodzajid: TLargeintField;
    get_rodzajid_nadrzedne: TLargeintField;
    http: TNetSynHTTP;
    ksiega2idrodzaj_id: TLargeintField;
    lastidid: TLargeintField;
    ptab: TPointerTab;
    trans: TZTransaction;
    adding: TZQuery;
    get_rodzaj: TZQuery;
    get_ks: TZQuery;
    get_ksiegi: TZQuery;
    add_wydanie: TZQuery;
    lastid: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure dbBeforeConnect(Sender: TObject);
    procedure ptabCreateElement(Sender: TObject; var AWskaznik: Pointer);
    procedure ptabDestroyElement(Sender: TObject; var AWskaznik: Pointer);
    procedure ptabReadElement(Sender: TObject; var AWskaznik: Pointer);
    procedure ptabWriteElement(Sender: TObject; var AWskaznik: Pointer);
  private
    procedure zeruj_przycisk(var aKontrolka: TArchitektPrzycisk);
    procedure zeruj(var aKontrolka: TArchitekt);
    procedure konwersja(aText: TStrings);
  public
    function GetLastID: integer;
    function pilot_wczytaj: TArchitektPilot;
    procedure wygeneruj_plik(nazwa: string = '');
    procedure import_biblia_daeon_pl;
    function import_txt_generuj(aFilename: string): boolean;
    function import_txt(aFilename: string; aTest: boolean = false): boolean;
  end;

var
  dm: Tdm;

implementation

uses
  ecode, lconvencoding, synacode, inifiles;

{$R *.lfm}

type
  TElement = record
    ksiega,rozdzial,wers: integer;
  end;
  PElement = ^TElement;

var
  rr: record
    url,url2,swydanie,srodzaj,sksiega: string;
    numeracja: boolean; //numeracja wersów
    wydanie: integer;
    rodzaj,ksiega,ksiega_rodzaj,rozdzial,wers: integer;
    tresc: string;
    tytul1,tytul2: string;
  end;
  element: TElement;

{ Tdm }

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  //schema.init;
  db.Connect;
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  db.Disconnect;
end;

procedure Tdm.dbBeforeConnect(Sender: TObject);
begin
  db.Database:=MyDir('biblia.sqlite');
end;

procedure Tdm.ptabCreateElement(Sender: TObject; var AWskaznik: Pointer);
var
  el: PElement;
begin
  new(el);
  AWskaznik:=el;
end;

procedure Tdm.ptabDestroyElement(Sender: TObject; var AWskaznik: Pointer);
var
  el: PElement;
begin
  el:=AWskaznik;
  dispose(el);
  AWskaznik:=nil;
end;

procedure Tdm.ptabReadElement(Sender: TObject; var AWskaznik: Pointer);
var
  el: PElement;
begin
  el:=AWskaznik;
  element:=el^;
end;

procedure Tdm.ptabWriteElement(Sender: TObject; var AWskaznik: Pointer);
var
  el: PElement;
begin
  el:=AWskaznik;
  el^:=element;
end;

procedure Tdm.zeruj_przycisk(var aKontrolka: TArchitektPrzycisk);
begin
  aKontrolka.kod_wewnetrzny:=0;
  aKontrolka.funkcja_wewnetrzna:=0;
  aKontrolka.operacja_zewnetrzna:=false;
  aKontrolka.klik:=0;
  aKontrolka.dwuklik:=0;
end;

procedure Tdm.zeruj(var aKontrolka: TArchitekt);
begin
  zeruj_przycisk(aKontrolka.p1);
  zeruj_przycisk(aKontrolka.p2);
  zeruj_przycisk(aKontrolka.p3);
  zeruj_przycisk(aKontrolka.p4);
  zeruj_przycisk(aKontrolka.p5);
  aKontrolka.suma45:=false;
end;

procedure Tdm.konwersja(aText: TStrings);
var
  i: integer;
  s: string;
begin
  for i:=0 to aText.Count-1 do
  begin
    s:=aText[i];
    s:=ISO_8859_2ToUTF8(s);
    aText.Delete(i);
    aText.Insert(i,s);
  end;
end;

function Tdm.GetLastID: integer;
begin
  lastid.Open;
  result:=lastid.Fields[0].AsInteger;
  lastid.Close;
end;

function Tdm.pilot_wczytaj: TArchitektPilot;
var
  f: file of TArchitekt;
  a: TArchitektPilot;
  s: string;
  b: boolean;
begin
  s:=MyConfDir('keys.dat');
  b:=FileExists(s);
  if b then
  begin
    assignfile(f,s);
    reset(f);
  end;
  if b then read(f,a.t1) else zeruj(a.t1);
  if b then read(f,a.t2) else zeruj(a.t2);
  if b then read(f,a.t3) else zeruj(a.t3);
  if b then read(f,a.t4) else zeruj(a.t4);
  result:=a;
end;

procedure Tdm.wygeneruj_plik(nazwa: string);
var
  f: textfile;
begin
  assignfile(f,'/home/tao/Projekty/apps/youtube_player/nazwa_filmu.txt');
  rewrite(f);
  writeln(f,nazwa);
  closefile(f);
end;

procedure zapisz(aStr,aFilename: string);
var
  f: textfile;
begin
  assignfile(f,aFilename);
  rewrite(f);
  writeln(f,aStr);
  closefile(f);
end;

var
  rec: record
    wersja,rodzaj,nr: integer;
    nazwa,skrot: string;
    rozdzial,wers: integer;
    tresc: string;
    tytul1,tytul2: string;
  end;

function najmniejszy(a,b,c,d: integer): integer;
var
  x: integer;
begin
  //write('a=',a,', b=',b,', c=',c,', d=',d);
  if a=0 then a:=100000000;
  if b=0 then b:=100000000;
  if c=0 then c:=100000000;
  if d=0 then d:=100000000;
  if (a<b) and (a<c) and (a<d) then x:=1 else
  if (b<a) and (b<c) and (b<d) then x:=2 else
  if (c<a) and (c<b) and (c<d) then x:=3 else
  x:=4;
  if (x=4) and (d=100000000) then x:=0;
  //writeln(' = ',x);
  result:=x;
end;

procedure Tdm.import_biblia_daeon_pl;
const
  DB_ZAPIS = true;
var
  proc: TAsyncProcess;
  pp,mem,ks,roz: TStrings;
  pom,pom2,refer,s,s2,s3,s4,s5: string;
  i,j,k,a,b,c,d,x: integer;
  null: string;
begin
  rec.wersja:=1;
  pp:=TStringList.Create;
  mem:=TStringList.Create;
  ks:=TStringList.Create;
  roz:=TStringList.Create;
  try
    (*http.Referrer:='https://biblia.deon.pl';
    http.UserAgent:='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36';
    http.UrlData:='action=ksiega_change&book=1';
    http.Mimetype:='<app>';
    http.execute('https://biblia.deon.pl/index.php',mem);
    refer:='https://biblia.deon.pl/index.php';
    konwersja(mem);
    { wczytanie rozdziałów }
    s:=mem.Text;
    if s[1]='{' then
    begin
      s:=StringReplace(s,'{','',[rfReplaceAll,rfIgnoreCase]);
      s:=StringReplace(s,'}','',[rfReplaceAll,rfIgnoreCase]);
      s:=StringReplace(s,'"','',[rfReplaceAll,rfIgnoreCase]);
      s:=StringReplace(s,',',#10,[rfReplaceAll,rfIgnoreCase]);
      pp.AddText(s);
      ks.Clear;
      for i:=0 to pp.Count-1 do ks.Add(GetLineToStr(pp[i],2,':'));
    end;*)
    for i:=1 to 73 do ks.Add(IntToStr(i));
    for i:=0 to ks.Count-1 do
    begin
      if DB_ZAPIS then trans.StartTransaction;
      {wczytuję rozdział pierwszy kolejnych ksiąg}
      mem.Clear;
      pom:=ks[i];
      writeln('KSIĘGA: ',i+1);
      proc:=TAsyncProcess.Create(nil);
      proc.Options:=[poWaitOnExit,poUsePipes];
      proc.PipeBufferSize:=500000;
      try
        proc.CurrentDirectory:=MyDir;
        proc.Executable:='curl';
        proc.Parameters.Add('https://biblia.deon.pl/index.php');
        proc.Parameters.Add('-H');
        proc.Parameters.Add('''authority: biblia.deon.pl''');
        proc.Parameters.Add('-H');
        proc.Parameters.Add('''origin: https://biblia.deon.pl''');
        proc.Parameters.Add('-H');
        proc.Parameters.Add('''user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36''');
        proc.Parameters.Add('-H');
        proc.Parameters.Add('''content-type: application/x-www-form-urlencoded; charset=UTF-8''');
        proc.Parameters.Add('-H');
        proc.Parameters.Add('''accept: */*''');
        proc.Parameters.Add('-H');
        proc.Parameters.Add('''sec-fetch-dest: empty''');
        proc.Parameters.Add('-H');
        proc.Parameters.Add('''x-requested-with: XMLHttpRequest''');
        proc.Parameters.Add('-H');
        proc.Parameters.Add('''dnt: 1''');
        proc.Parameters.Add('-H');
        proc.Parameters.Add('''sec-fetch-site: same-origin''');
        proc.Parameters.Add('-H');
        proc.Parameters.Add('''sec-fetch-mode: cors''');
        proc.Parameters.Add('-H');
        proc.Parameters.Add('''referer: '+refer+'''');
        proc.Parameters.Add('-H');
        proc.Parameters.Add('''accept-language: pl-PL,pl;q=0.9,en-US;q=0.8,en;q=0.7''');
        proc.Parameters.Add('-H');
        proc.Parameters.Add('''cookie: __cfduid=d83fad73e2e248883dc0c5173c272623b1585664144''');
        proc.Parameters.Add('--data');
        proc.Parameters.Add('action=ksiega_change&book='+pom);
        proc.Parameters.Add('--compressed');
        refer:='https://biblia.deon.pl/index.php';
        proc.Execute;
        mem.LoadFromStream(proc.Output);
        proc.Terminate(0);
      finally
        proc.Free;
      end;

      pp.Clear;
      s:=mem.Text;
      //zapisz(s,'STRONA_K.HTML');
      if s[1]='{' then
      begin
        s:=StringReplace(s,'{','',[rfReplaceAll,rfIgnoreCase]);
        s:=StringReplace(s,'}','',[rfReplaceAll,rfIgnoreCase]);
        s:=StringReplace(s,'"','',[rfReplaceAll,rfIgnoreCase]);
        s:=StringReplace(s,',',#10,[rfReplaceAll,rfIgnoreCase]);
        pp.AddText(s);
        roz.Clear;
        for j:=0 to pp.Count-1 do roz.Add(GetLineToStr(pp[j],2,':'));
      end else
      if s[1]='[' then
      begin
        s:=StringReplace(s,'[','',[rfReplaceAll,rfIgnoreCase]);
        s:=StringReplace(s,']','',[rfReplaceAll,rfIgnoreCase]);
        s:=StringReplace(s,'"','',[rfReplaceAll,rfIgnoreCase]);
        s:=StringReplace(s,',',#10,[rfReplaceAll,rfIgnoreCase]);
        pp.AddText(s);
        roz.Clear;
        if trim(GetLineToStr(pp[0],2,':'))='' then roz.Assign(pp) else
        for j:=0 to pp.Count-1 do roz.Add(GetLineToStr(pp[j],2,':'));
      end else begin
        writeln('COŚ POSZŁO ŹLE: Księga: I='+IntToStr(i)+', Index='+pom);
        continue;
      end;

      //writeln(roz.Text);

      {wczytuję kolejne rozdziały}
      for j:=0 to roz.Count-1 do
      begin
        mem.Clear;
        pom2:=roz[j];
        writeln('  - księga/rozdział: ',i+1,'/',pom2);
        proc:=TAsyncProcess.Create(nil);
        proc.Options:=[poWaitOnExit,poUsePipes];
        proc.PipeBufferSize:=500000;
        try
          proc.CurrentDirectory:=MyDir;
          proc.Executable:='curl';
          proc.Parameters.Add('https://biblia.deon.pl/rozdzial.php?id='+pom2);
          proc.Parameters.Add('-H');
          proc.Parameters.Add('''authority: biblia.deon.pl''');
          proc.Parameters.Add('-H');
          proc.Parameters.Add('''upgrade-insecure-requests: 1''');
          proc.Parameters.Add('-H');
          proc.Parameters.Add('''dnt: 1''');
          proc.Parameters.Add('-H');
          proc.Parameters.Add('''user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36''');
          proc.Parameters.Add('-H');
          proc.Parameters.Add('''sec-fetch-dest: document''');
          proc.Parameters.Add('-H');
          proc.Parameters.Add('''accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9''');
          proc.Parameters.Add('-H');
          proc.Parameters.Add('''sec-fetch-site: same-origin''');
          proc.Parameters.Add('-H');
          proc.Parameters.Add('''sec-fetch-mode: navigate''');
          proc.Parameters.Add('-H');
          proc.Parameters.Add('''sec-fetch-user: ?1''');
          proc.Parameters.Add('-H');
          proc.Parameters.Add('''referer: '+refer+'''');
          proc.Parameters.Add('-H');
          proc.Parameters.Add('''accept-language: pl-PL,pl;q=0.9,en-US;q=0.8,en;q=0.7''');
          proc.Parameters.Add('-H');
          proc.Parameters.Add('''cookie: __cfduid=d83fad73e2e248883dc0c5173c272623b1585664144''');
          proc.Parameters.Add('--compressed');
          refer:='https://biblia.deon.pl/rozdzial.php?id='+pom2;
          proc.Execute;
          mem.LoadFromStream(proc.Output);
          proc.Terminate(0);
        finally
          proc.Free;
        end;
        konwersja(mem);
        s:=mem.Text;

        while true do
        begin
          {wywalamy wszystkie odnośniki (sup)}
          a:=pos('<sup>',s);
          if a=0 then break;
          b:=pos('</sup>',s);
          delete(s,a,b-a+6);
        end;
        s:=StringReplace(s,'<br />'+#10,'',[rfReplaceAll]);
        s:=StringReplace(s,'<werset nr="[','<odnosnik nr="[',[rfReplaceAll]);
        s:=StringReplace(s,'&laquo;','«',[rfReplaceAll]);
        s:=StringReplace(s,'&raquo;','»',[rfReplaceAll]);
        mem.Clear;
        mem.AddText(s);
        //if pos('werset',s)=0 then continue;
        //mem.SaveToFile('STRONA.HTML');

        a:=pos('Pismo Święte Starego i Nowego Testamentu',s);
        delete(s,1,a);
        a:=pos('-',s);
        delete(s,1,a);
        a:=pos('<',s);
        s2:=trim(copy(s,1,a-1));
        k:=1; s3:=''; s4:='';
        while true do
        begin
          s5:=GetLineToStr(s2,k,' ');
          if s5='' then break;
          if s3='' then s3:=s3+s4 else s3:=s3+' '+s4;
          s4:=s5;
          inc(k);
        end;
        rec.skrot:=s3;
        try
          rec.rozdzial:=StrToInt(s4);
        except
          rec.rozdzial:=i-1;
        end;
        a:=pos('testament-label',s);
        delete(s,1,a);
        a:=pos(#10,s);
        delete(s,1,a);
        a:=pos('<',s);
        s2:=trim(copy(s,1,a-1));
        if s2='STARY TESTAMENT' then rec.rodzaj:=1 else rec.rodzaj:=2;
        rec.nr:=i+1;
        a:=pos('book-label',s);
        delete(s,1,a);
        a:=pos('>',s);
        delete(s,1,a);
        a:=pos('<',s);
        s2:=trim(copy(s,1,a-1));
        rec.nazwa:=s2;
        while true do
        begin
          a:=pos('miedzytytul1',s); //x=3
          b:=pos('werset',s);       //x=1
          c:=pos('"footnotes"',s);  //x=4
          d:=pos('tytul1',s);       //x=2
          x:=najmniejszy(b,d,a,c);
          if (x=0) or (x=4) then break else
          if x=2 then
          begin
            d:=pos('tytul1',s);
            delete(s,1,d);
            d:=pos('>',s);
            delete(s,1,d);
            d:=pos('<',s);
            s2:=trim(copy(s,1,d-1));
            rec.tytul1:=s2;
          end else
          if x=3 then
          begin
            {tytul2}
            delete(s,1,a);
            a:=pos('>',s);
            delete(s,1,a);
            a:=pos('<',s);
            s2:=trim(copy(s,1,a-1));
            rec.tytul2:=s2;
          end else
          if x=1 then
          begin
            {werset}
            delete(s,1,b);
            b:=pos('>',s);
            c:=pos('nr=',s);
            if ((b>0) and (c>0) and (b<c)) or ((b>0) and (c=0)) then
            begin
              delete(s,1,b);
              b:=pos('&',s);
              s2:=trim(copy(s,1,b-1));
            end else
            if ((b>0) and (c>0) and (b>c)) or ((c>0) and (b=0)) then
            begin
              if not DB_ZAPIS then writeln('[wyjątek A]');
              c:=pos('=',s);
              delete(s,1,c);
              if s[1]='"' then delete(s,1,1);
              if not DB_ZAPIS then writeln('Ciąg: ',copy(s,1,20));
              b:=pos(' ',s);
              c:=pos('"',s);
              if (c=0) or ((c>0) and (c>b)) then c:=b;
              s2:=trim(copy(s,1,c-1));
              if not DB_ZAPIS then writeln('Nr wersa (',c,') = ',s2);
            end;
            try
              //rec.wers:=StrToInt(s2);
              rec.wers:=StrToL(s2,null,0);
            except
              writeln('#2');
              mem.SaveToFile('STRONA.HTML');
              rec.wers:=StrToInt(s2);
            end;
            c:=pos(' ',s);
            b:=pos('>',s);
            if ((c>0) and (b>0) and (b<c)) or ((b>0) and (c=0)) then delete(s,1,b) else
            if not DB_ZAPIS then writeln('[wyjątek B]');
            b:=pos('<',s);
            c:=pos(#10,s);
            if ((c>0) and (c<b)) or (b=0) then b:=c;
            s2:=trim(copy(s,1,b-1));
            rec.tresc:=s2;
          end;
          {zapis do bazy}
          if rec.tresc<>'' then
          begin
            if DB_ZAPIS then
            begin
              adding.ParamByName('wydanie').AsInteger:=rec.wersja;
              adding.ParamByName('rodzaj').AsInteger:=rec.rodzaj;
              adding.ParamByName('ksiega').AsInteger:=rec.nr;
              adding.ParamByName('nazwa').AsString:=rec.nazwa;
              adding.ParamByName('skrot').AsString:=rec.skrot;
              adding.ParamByName('rozdzial').AsInteger:=rec.rozdzial;
              adding.ParamByName('wers').AsInteger:=rec.wers;
              adding.ParamByName('tresc').AsString:=rec.tresc;
              adding.ParamByName('t1').AsString:=rec.tytul1;
              adding.ParamByName('t2').AsString:=rec.tytul2;
              adding.ExecSQL;
            end else begin
              writeln('W:',rec.wersja,' R:',rec.rodzaj,' NR:',rec.nr,' N:',rec.nazwa,' ',rec.skrot,' ',rec.rozdzial,' ',rec.wers,' ',rec.tresc,' ',rec.tytul1,' ',rec.tytul2);
              //writeln('W:',rec.wersja,' R:',rec.rodzaj,' NR:',rec.nr,' N:',rec.nazwa,' ',rec.skrot,' ',rec.rozdzial,' ',rec.wers,' ',rec.tresc);
              //writeln('W:',rec.wersja,' R:',rec.rodzaj,' NR:',rec.nr,' N:',rec.nazwa,' ',rec.skrot,' ',rec.rozdzial,' ',rec.wers,' ',rec.tytul1,' ',rec.tytul2);
            end;
            rec.wers:=0;
            rec.tresc:='';
            rec.tytul1:='';
            rec.tytul2:='';
          end;
        end;
      end;
      if DB_ZAPIS then trans.Commit;
    end;
    {wyniki}
    //zapisz(mem.Text,'strona_1.html');
  finally
    if DB_ZAPIS then if trans.Database.InTransaction then trans.Rollback;
    writeln('finał');
    pp.Free;
    mem.Free;
    ks.Free;
    roz.Free;
  end;
end;

function Tdm.import_txt_generuj(aFilename: string): boolean;
var
  s,s1,s2,s3: string;
  plik: string;
  src: textfile;
  f: TIniFile;
  err,b_ksiegi: boolean;
begin
  err:=false;
  b_ksiegi:=false;
  ExtractPFE(aFilename,s1,s2,s3);
  plik:=s1+s2+'.ini';
  assignfile(src,aFilename);
  reset(src);
  f:=TInifile.Create(plik);
  rr.numeracja:=false;
  while not eof(src) do
  begin
    readln(src,s);
    if s='' then continue;
    if s[1]='$' then
    begin
      if pos('$wydanie',s)=1 then rr.swydanie:=GetLineToStr(s,2,'=') else
      if pos('$url',s)=1 then rr.url:=GetLineToStr(s,2,'=') else
      if pos('$rodzaj',s)=1 then
      begin
        rr.srodzaj:=GetLineToStr(s,2,'=');
        get_rodzaj.ParamByName('nazwa').AsString:=rr.srodzaj;
        get_rodzaj.Open;
        if get_rodzaj.IsEmpty then
        begin
          err:=true;
          f.WriteString('rodzaj','id','[ERROR]');
          break;
        end else begin
          rr.rodzaj:=get_rodzajid.AsInteger;
          f.WriteInteger('rodzaj','id',rr.rodzaj);
        end;
        get_rodzaj.Close;
      end else
      if s='$numeracja=1' then rr.numeracja:=true else
      if pos('$ksiega',s)=1 then
      begin
        rr.sksiega:=GetLineToStr(s,2,'=');
        if f.ReadString('ksiega',rr.sksiega,'[ERROR]')='[ERROR]' then
        begin
          get_ks.ParamByName('id').AsInteger:=rr.rodzaj;
          get_ks.ParamByName('nazwa').AsString:=rr.sksiega;
          get_ks.Open;
          if get_ks.IsEmpty then
          begin
            err:=true;
            b_ksiegi:=true;
            f.WriteString('ksiega',rr.sksiega,'[ERROR]');
          end else begin
            f.WriteInteger('ksiega',rr.sksiega,get_ksid.AsInteger);
          end;
        end;
        get_ks.Close;
      end;
    end;
  end;
  if b_ksiegi then
  begin
    get_ksiegi.ParamByName('id').AsInteger:=rr.rodzaj;
    get_ksiegi.Open;
    while not get_ksiegi.EOF do
    begin
      if f.ReadString('ksiega',get_ksieginazwa.AsString,'[ERROR]')='[ERROR]' then
        f.WriteInteger('spis ksiąg',get_ksieginazwa.AsString,get_ksiegiid.AsInteger);
      get_ksiegi.Next;
    end;
    get_ksiegi.Close;
  end;
  closefile(src);
  f.Free;
  result:=not err;
end;

function Tdm.import_txt(aFilename: string; aTest: boolean): boolean;
var
  ss: TStrings;
  a,i,j: integer;
  s,s1,s2,s3,plik,pom: string;
  b,multi,numeracja: boolean;
  f: TIniFile;
  dl: integer;
begin
  result:=true;
  dl:=0;
  ExtractPFE(aFilename,s1,s2,s3);
  plik:=s1+s2+'.ini';
  f:=TInifile.Create(plik);
  (* init rr *)
  rr.url:='';
  rr.swydanie:='';
  rr.srodzaj:='';
  rr.wydanie:=f.ReadInteger('wydanie','id',0);
  rr.rodzaj:=f.ReadInteger('rodzaj','id',0);
  rr.ksiega:=0;
  rr.rozdzial:=0;
  rr.wers:=0;
  rr.tresc:='';
  rr.tytul1:='';
  rr.tytul2:='';
  rr.url2:='';
  (* lecimy... *)
  multi:=false;
  numeracja:=false;
  ss:=TStringList.Create;
  try
    ss.LoadFromFile(aFilename);
    for i:=0 to ss.Count-1 do
    begin
      s:=trim(ss[i]);
      if (s='') and (not multi) then continue;
      if s='' then s:=' ';
      if pos('$<',s)=1 then
      begin
        multi:=true;
        pom:=s;
        delete(pom,1,2);
        pom:=trim(pom);
        continue;
      end else
      if s[1]='$' then
      begin
        s1:=GetLineToStr(s,1,'=');
        s2:=GetLineToStr(s,2,'=');
        if s1='$wydanie' then
        begin
          try
            rr.wydanie:=StrToInt(s2);
          except
            rr.swydanie:=trim(s2);
          end;
        end else
        if s1='$url' then rr.url:=trim(s2) else
        if s1='$ksiega' then
        begin
          rr.ksiega:=f.ReadInteger('ksiega',trim(s2),0);
          ksiega2id.ParamByName('id').AsInteger:=rr.ksiega;
          ksiega2id.Open;
          rr.ksiega_rodzaj:=ksiega2idrodzaj_id.AsInteger;
          ksiega2id.Close;
        end else
        if s1='$rozdzial' then rr.rozdzial:=StrToInt(s2) else
        if s1='$tytul1' then rr.tytul1:=trim(s2) else
        if s1='$tytul2' then rr.tytul2:=trim(s2) else
        if s1='$url2' then rr.url2:=trim(s2) else
        if (s1='$numeracja') and (s2='1') then numeracja:=true;
        continue;
      end;
{      if s[1]='%' then
      begin
        delete(s,1,1);
        rr.tytul1:=trim(s);
        continue;
      end;
      if s[1]='#' then
      begin
        delete(s,1,1);
        rr.tytul2:=trim(s);
        continue;
      end;}
      (* jeśli tworzymy multiwiersz *)
      if multi then
      begin
        s:=trim(s);
        if pos('$>',s)>0 then
        begin
          multi:=false;
          s:=StringReplace(s,'$>','',[rfReplaceAll]);
          pom:=pom+#10+trim(s);
          s:=pom;
        end else begin
          pom:=pom+#10+s;
          continue;
        end;
      end;
      (* obliczam nr wersetu *)
      if numeracja then
      begin
        a:=pos(':',s);
        rr.wers:=StrToInt(copy(s,1,a-1));
        delete(s,1,a);
      end else begin
        b:=true;
        for j:=0 to ptab.Count-1 do
        begin
          ptab.Read(j);
          if (element.ksiega=rr.ksiega) and (element.rozdzial=rr.rozdzial) then
          begin
            b:=false;
            element.wers:=element.wers+1;
            ptab.Edit(j);
            rr.wers:=element.wers;
            break;
          end;
        end;
        if b then
        begin
          element.ksiega:=rr.ksiega;
          element.rozdzial:=rr.rozdzial;
          element.wers:=1;
          ptab.Add;
          rr.wers:=element.wers;
        end;
      end;
      rr.tresc:=s;
      (* zapis rekordu *)
      if rr.wydanie=0 then
      begin
        (* zakładamy nowy rekord i podmieniamy komórki *)
        add_wydanie.ParamByName('rodzaj').AsInteger:=rr.rodzaj;
        add_wydanie.ParamByName('nazwa').AsString:=rr.swydanie;
        add_wydanie.ParamByName('url').AsString:=rr.url;
        add_wydanie.ExecSQL;
        lastid.Open;
        rr.wydanie:=lastidid.AsInteger;
        lastid.Close;
        f.WriteInteger('wydanie','id',rr.wydanie);
      end;
      if aTest then
      begin
        writeln('[NAG] WYDANIE=',rr.wydanie,', RODZAJ=',rr.ksiega_rodzaj);
        writeln('[REC] K=',rr.ksiega,', rozdział=',rr.rozdzial,', wers=',rr.wers);
        writeln(rr.tresc);
        if rr.tytul1<>'' then writeln('[ADD] T1="',rr.tytul1,'"');
        if rr.tytul2<>'' then writeln('[ADD] T2="',rr.tytul2,'"');
        writeln;
      end else begin
        adding.ParamByName('wydanie').AsInteger:=rr.wydanie;
        adding.ParamByName('rodzaj').AsInteger:=rr.ksiega_rodzaj;
        adding.ParamByName('ksiega').AsInteger:=rr.ksiega;
        adding.ParamByName('rozdzial').AsInteger:=rr.rozdzial;
        adding.ParamByName('wers').AsInteger:=rr.wers;
        adding.ParamByName('tresc').AsString:=rr.tresc;
        adding.ParamByName('t1').AsString:=rr.tytul1;
        adding.ParamByName('t2').AsString:=rr.tytul2;
        adding.ParamByName('url').AsString:=rr.url2;
        try
          adding.ExecSQL;
        except
          on E :Exception do
          begin
            writeln(E.Message);
            writeln('[NAG] WYDANIE=',rr.wydanie,', RODZAJ=',rr.ksiega_rodzaj);
            writeln('[REC] K=',rr.ksiega,', rozdział=',rr.rozdzial,', wers=',rr.wers);
            writeln(rr.tresc);
            if rr.tytul1<>'' then writeln('[ADD] T1="',rr.tytul1,'"');
            if rr.tytul2<>'' then writeln('[ADD] T2="',rr.tytul2,'"');
            result:=false;
            exit;
          end;
        end;
      end;
      (* czyszczę niektóre komórki *)
      rr.tytul1:='';
      rr.tytul2:='';
      rr.tresc:='';
      rr.url2:='';
    end;
  finally
    ss.Free;
    f.Free;
    writeln('Wychodzę...');
  end;
end;

end.

