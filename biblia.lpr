program biblia;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads, cmem,
  {$ENDIF}{$ENDIF}
  Classes, CustApp, ExtParams, cverinfo,
  Interfaces, // this includes the LCL widgetset
  Forms, main, serwis;

{$R *.res}

type

  { TBiblia }

  TBiblia = class(TCustomApplication)
  protected
    procedure DoRun; override;
  private
    par: TExtParams;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

procedure TBiblia.DoRun;
var
  v1,v2,v3,v4: integer;
  go_exit: boolean;
begin
  inherited DoRun;
  go_exit:=false;
  randomize;

  par:=TExtParams.Create(nil);
  try
    par.Execute;
    if par.IsParam('ver') then
    begin
      GetProgramVersion(v1,v2,v3,v4);
      if v4>0 then writeln(v1,'.',v2,'.',v3,'-',v4) else
      if v3>0 then writeln(v1,'.',v2,'.',v3) else
      if v2>0 then writeln(v1,'.',v2) else writeln(v1,'.',v2);
      go_exit:=true;
    end;
    //par.ParamsForValues.Add('db');
    //if par.IsParam('db') then sciezka_db:=par.GetValue('db');
    //if par.IsParam('dev') then _DEV_ON:=true;
  finally
    par.Free;
  end;
  if go_exit then
  begin
    terminate;
    exit;
  end;

  {uruchomienie głównej formy}
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFMain, FMain);
  Application.Run;
  {wygaszenie procesu}
  Terminate;
end;

constructor TBiblia.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=true;
end;

destructor TBiblia.Destroy;
begin
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

