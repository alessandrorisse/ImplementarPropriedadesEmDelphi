program ImplementarPropriedades;

uses
  Forms,
  UPrincipal in 'UPrincipal.pas' {FPrincipal},
  UImplementarPropriedades in 'UImplementarPropriedades.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Implementador de propriedades';
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.
