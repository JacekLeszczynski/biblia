unit class_import;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset;

type

  TWydanie = record
    id,rodzaj_id: integer;
    rk_rodzaj,rk_skrot: string;
    rodzaj,rodzina,nazwa,url,opis,komentarz: string;
    sort_ksiegi_nazwa: integer;
  end;

  { TImport }

  TImport = class
  private
    db: TZConnection;
    db_wydanie_insert: TZQuery;
    wydanie: TWydanie;
  public
    constructor Create(aDB: TZConnection);
    destructor Destroy; override;
    procedure clear;
  published
    property wydanie_id: integer read wydanie.id write wydanie.id;
    property wydanie_rodzaj_id: integer read wydanie.rodzaj_id write wydanie.rodzaj_id;
    property wydanie_rodzaj: string read wydanie.rodzaj write wydanie.rodzaj;
    property wydanie_rodzina: string read wydanie.rodzina write wydanie.rodzina;
    property wydanie_nazwa: string read wydanie.nazwa write wydanie.nazwa;
    property wydanie_url: string read wydanie.url write wydanie.url;
    property wydanie_opis: string read wydanie.opis write wydanie.opis;
    property wydanie_komentarz: string read wydanie.komentarz write wydanie.komentarz;
    property wydanie_sort_ksiegi_nazwa: integer read wydanie.sort_ksiegi_nazwa write wydanie.sort_ksiegi_nazwa;
  end;

implementation

{ TImport }

constructor TImport.Create(aDB: TZConnection);
begin
  db:=aDB;
  clear;
  db_wydanie_insert:=TZQuery.Create(nil);
end;

destructor TImport.Destroy;
begin
  db_wydanie_insert.Free;
  inherited Destroy;
end;

procedure TImport.clear;
begin
  wydanie.id:=0;
  wydanie.rodzaj_id:=0;
  wydanie.rodzaj:='';
  wydanie.rodzina:='';
  wydanie.nazwa:='';
  wydanie.url:='';
  wydanie.opis:='';
  wydanie.komentarz:='';
  wydanie.sort_ksiegi_nazwa:=0;
end;

end.

