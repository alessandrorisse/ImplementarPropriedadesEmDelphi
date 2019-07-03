unit UPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TFPrincipal = class(TForm)
    pgcPrincipal: TPageControl;
    tabPropriedades: TTabSheet;
    tabInterface: TTabSheet;
    tabClasse: TTabSheet;
    memoPropriedades: TMemo;
    memoInterface: TMemo;
    memoClasse: TMemo;
    pnlCabecalhoPropriedades: TPanel;
    lblCabecalhoPropriedades: TLabel;
    lblNome: TLabel;
    edtNome: TEdit;
    lblInterface: TLabel;
    lblClasse: TLabel;
    btnGerarImplementacao: TButton;
    procedure edtNomeChange(Sender: TObject);
    procedure btnGerarImplementacaoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure memoPropriedadesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memoInterfaceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memoClasseKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    function GetNomeInterface: String;
    function GetNomeClasse: String;
  public

  end;

var
  FPrincipal: TFPrincipal;

implementation

uses UImplementarPropriedades;

{$R *.dfm}

procedure TFPrincipal.edtNomeChange(Sender: TObject);
begin
  lblInterface.Caption := 'Interface: ' + GetNomeInterface;
  lblClasse.Caption := 'Classe: ' + GetNomeClasse;
end;

procedure TFPrincipal.btnGerarImplementacaoClick(Sender: TObject);
var
  Implementar: TImplementarPropriedades;
begin
  btnGerarImplementacao.Enabled := False;

  Implementar := TImplementarPropriedades.Create(GetNomeInterface, GetNomeClasse, memoPropriedades.Text);
  memoInterface.Text := Trim(Implementar.ImplementacaoInterface);
  memoClasse.Text := Trim(Implementar.ImplementacaoClasse);

  btnGerarImplementacao.Enabled := True;
  FreeAndNil(Implementar);
end;

function TFPrincipal.GetNomeClasse: String;
begin
  Result := 'T' + Trim(edtNome.Text);
end;

function TFPrincipal.GetNomeInterface: String;
begin
  Result := 'I' + Trim(edtNome.Text);
end;

procedure TFPrincipal.memoClasseKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = Ord('A')) or (Key = Ord('a'))) and (ssCtrl in Shift) then
    memoClasse.SelectAll;
end;

procedure TFPrincipal.memoInterfaceKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = Ord('A')) or (Key = Ord('a'))) and (ssCtrl in Shift) then
    memoInterface.SelectAll;
end;

procedure TFPrincipal.memoPropriedadesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ((Key = Ord('A')) or (Key = Ord('a'))) and (ssCtrl in Shift) then
    memoPropriedades.SelectAll;
end;

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  Constraints.MinHeight := Height;
  Constraints.MinWidth  := Width;
end;

end.
