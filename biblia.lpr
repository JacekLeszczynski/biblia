program biblia;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads, cmem,
  {$ENDIF}{$ENDIF}
  Classes, CustApp, ExtParams, cverinfo, ecode,
  Interfaces, // this includes the LCL widgetset
  Forms, main, serwis, ExtSharedMemory;

{$R *.res}

type

  { TBiblia }

  TBiblia = class(TCustomApplication)
  protected
    procedure DoRun; override;
  private
    par: TExtParams;
    share: TExtSharedMemory;
    procedure share_OnServer(Sender: TObject);
    procedure share_OnMessage(Sender: TObject; AMessage: string);
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

procedure TBiblia.DoRun;
var
  skey: string;
  v1,v2,v3,v4: integer;
  go_exit: boolean;
begin
  inherited DoRun;
  go_exit:=false;
  randomize;

  par:=TExtParams.Create(nil);
  par.ParamsForValues.Add('key');
  try
    par.Execute;
    if par.IsParam('ver') then
    begin
      GetProgramVersion(v1,v2,v3,v4);
      if v4>0 then writeln(v1,'.',v2,'.',v3,'-',v4) else
      if v3>0 then writeln(v1,'.',v2,'.',v3) else
      if v2>0 then writeln(v1,'.',v2) else writeln(v1,'.',v2);
      go_exit:=true;
    end else
    if par.IsParam('key') then skey:=par.GetValue('key');
    //par.ParamsForValues.Add('db');
    //if par.IsParam('db') then sciezka_db:=par.GetValue('db');
    //if par.IsParam('dev') then _DEV_ON:=true;
  finally
    par.Free;
  end;

  if go_exit then
  begin
    terminate(0);
    exit;
  end;

  if not share.Execute then
  begin
    if skey<>'' then share.SendMessage(skey);
    Terminate(0);
  end;
end;

procedure TBiblia.share_OnServer(Sender: TObject);
begin
  {uruchomienie głównej formy}
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFMain, FMain);
  Application.Run;
  {wygaszenie procesu}
  Terminate(0);
end;

procedure TBiblia.share_OnMessage(Sender: TObject; AMessage: string);
var
  s1: string;
  s2: string;
begin
  s1:=GetLineToStr(AMessage,1,'=');
  s2:=GetLineToStr(AMessage,2,'=');
  if s1='key' then FMain.goto_adres(s2);
end;

constructor TBiblia.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=true;
  share:=TExtSharedMemory.Create(nil);
  share.ApplicationKey:='{3ADC7678-E5D2-4BE5-9085-D5F788295A41}';
  share.OnServer:=@share_OnServer;
  share.OnMessage:=@share_OnMessage;
end;

destructor TBiblia.Destroy;
begin
  share.Free;
  inherited Destroy;
end;

var
  Application: TBiblia;
begin
  Application:=TBiblia.Create(nil);
  Application.Title:='Biblia';
  Application.Run;
  Application.Free;
end.

