unit UImplementarPropriedades;

interface

uses
  Classes;

type
  TImplementarPropriedades = class
  private
    FNomeInterface: String;
    FNomeClasse: String;
    FPropriedades: TStringList;
    FImplementacaoInterface: TStringList;
    FImplementacaoClasse: TStringList;

    function GetImplementacaoInterface: String;
    function GetImplementacaoClasse: String;
    function CriarGetInterface(const Nome, Tipo: String): String;
    function CriarSetInterface(const Nome, Tipo: String): String;
    function CriarPropriedades(const Nome, Tipo: String; const PossuiGet, PossuiSet: Boolean): String;
    function CriarGetClasse(const Nome, Tipo: String): String;
    function CriarSetClasse(const Nome, Tipo: String): String;
    function CriarVariaveis(const Nome, Tipo: String): String;
    procedure Implementar;

  public
    constructor Create(const NomeInterface, NomeClasse, Propriedades: String);
    destructor Destroy; override;

    property ImplementacaoInterface: String read GetImplementacaoInterface;
    property ImplementacaoClasse: String read GetImplementacaoClasse;
  end;

implementation

uses SysUtils, StrUtils;

{ TImplementarPropriedades }

constructor TImplementarPropriedades.Create(const NomeInterface, NomeClasse, Propriedades: String);
begin
  inherited Create;
  FImplementacaoInterface := TStringList.Create;
  FImplementacaoClasse := TStringList.Create;
  FPropriedades := TStringList.Create;

  FNomeInterface := NomeInterface;
  FNomeClasse := NomeClasse;
  FPropriedades.Text := Propriedades;

  Implementar;
end;

destructor TImplementarPropriedades.Destroy;
begin
  FreeAndNil(FImplementacaoInterface);
  FreeAndNil(FImplementacaoClasse);
  FreeAndNil(FPropriedades);
  inherited;
end;

function TImplementarPropriedades.GetImplementacaoClasse: String;
begin
  Result := FImplementacaoClasse.Text;
end;

function TImplementarPropriedades.GetImplementacaoInterface: String;
begin
  Result := FImplementacaoInterface.Text;
end;

procedure TImplementarPropriedades.Implementar;
var
  i, PosGet, PosSet: Integer;
  linha, NomeProp, TipoProp: String;
  ListaGet, ListaSet, ListaProp, ListaVariaveis, ListaGetImplementada, ListaSetImplementada: TStringList;
begin
  ListaGet := TStringList.Create;
  ListaSet := TStringList.Create;
  ListaProp := TStringList.Create;
  ListaVariaveis := TStringList.Create;
  ListaGetImplementada := TStringList.Create;
  ListaSetImplementada := TStringList.Create;

  for i := 0 to FPropriedades.Count - 1 do
  begin
    linha := Trim(FPropriedades[i]);

    if (linha <> EmptyStr) then
    begin
      TipoProp := EmptyStr;
      NomeProp := Trim(Copy(linha, 1, Pos(':', linha) - 1));
      Delete(linha, 1, Pos(':', linha));

      PosGet := Pos('read', AnsiLowerCase(linha));
      if (PosGet > 0) then
      begin
        TipoProp := Trim(Copy(linha, 1, PosGet - 1));
        Delete(linha, 1, PosGet + 4);
      end;

      PosSet := Pos('write', AnsiLowerCase(linha));
      if (PosSet > 0) then
      begin
        if (TipoProp = EmptyStr) then
          TipoProp := Trim(Copy(linha, 1, PosSet - 1));
        Delete(linha, 1, PosSet + 5);
      end;

      if (TipoProp = EmptyStr) then
      begin
        TipoProp := Trim(Copy(linha, 1, Length(linha)));
        PosGet := 1;
        PosSet := 1;
      end;

      if (PosGet > 0) then
      begin
        ListaGet.Add(CriarGetInterface(NomeProp, TipoProp));
        ListaGetImplementada.Add(CriarGetClasse(NomeProp, TipoProp));
      end;

      if (PosSet > 0) then
      begin
        ListaSet.Add(CriarSetInterface(NomeProp, TipoProp));
        ListaSetImplementada.Add(CriarSetClasse(NomeProp, TipoProp));
      end;

      ListaVariaveis.Add(CriarVariaveis(NomeProp, TipoProp));

      ListaProp.Add(CriarPropriedades(NomeProp, TipoProp, (PosGet > 0), (PosSet > 0)));
    end;
  end;

  FImplementacaoInterface.Clear;
  FImplementacaoInterface.Add(FNomeInterface + ' = interface');
  FImplementacaoInterface.Add(ListaGet.Text);
  FImplementacaoInterface.Add(ListaSet.Text);
  FImplementacaoInterface.Add(ListaProp.Text + 'end;');

  FImplementacaoClasse.Clear;
  FImplementacaoClasse.Add(FNomeClasse + ' = class');
  FImplementacaoClasse.Add('private');
  FImplementacaoClasse.Add(ListaVariaveis.Text);
  FImplementacaoClasse.Add(ListaGet.Text);
  FImplementacaoClasse.Add(ListaSet.Text);
  FImplementacaoClasse.Add('public');
  FImplementacaoClasse.Add(ListaProp.Text + 'end;');
  FImplementacaoClasse.Add('');
  FImplementacaoClasse.Add('implementation');
  FImplementacaoClasse.Add('');
  FImplementacaoClasse.Add(Trim(ListaGetImplementada.Text));
  FImplementacaoClasse.Add('');  
  FImplementacaoClasse.Add(ListaSetImplementada.Text);    

  FreeAndNil(ListaGet);
  FreeAndNil(ListaSet);
  FreeAndNil(ListaProp);
  FreeAndNil(ListaVariaveis);
  FreeAndNil(ListaGetImplementada);
  FreeAndNil(ListaSetImplementada);
end;

function TImplementarPropriedades.CriarGetInterface(const Nome, Tipo: String): String;
begin
  Result := '  function Get' + Nome + ': ' + Tipo + ';';
end;

function TImplementarPropriedades.CriarSetInterface(const Nome, Tipo: String): String;
begin
  Result := '  procedure Set' + Nome + '(const Value: ' + Tipo + ');';
end;

function TImplementarPropriedades.CriarPropriedades(const Nome, Tipo: String;
  const PossuiGet, PossuiSet: Boolean): String;
begin
  Result := '  property ' + Nome + ': ' + Tipo +
            IfThen(PossuiGet, ' read Get' + Nome) +
            IfThen(PossuiSet, ' write Set' + Nome) + ';';
end;

function TImplementarPropriedades.CriarGetClasse(const Nome, Tipo: String): String;
begin
  Result := 'function ' + FNomeClasse + '.Get' + Nome + ': ' + Tipo + ';' + sLineBreak +
            'begin' + sLineBreak +
            '  Result := F' + Nome + ';' + sLineBreak +
            'end;' + sLineBreak;
end;

function TImplementarPropriedades.CriarSetClasse(const Nome, Tipo: String): String;
begin
  Result := 'procedure ' + FNomeClasse + '.Set' + Nome + '(const Value: ' + Tipo + ');' + sLineBreak +
            'begin' + sLineBreak +
            '  F' + Nome + ' := Value;' + sLineBreak +
            'end;' + sLineBreak;
end;

function TImplementarPropriedades.CriarVariaveis(const Nome, Tipo: String): String;
begin
  Result := '  F' + Nome + ': ' + Tipo + ';';
end;

end.
