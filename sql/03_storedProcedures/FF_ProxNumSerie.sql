DROP FUNCTION IF EXISTS FF_ProxNumSerie;

CREATE FUNCTION FF_ProxNumSerie (Pais TEXT, Ano TEXT) -- e.g. Pais = 'An', Ano = '20'
RETURNS TEXT
RETURN
 CONCAT(
  'FT',
  Pais,
  Ano,
  '#',
  (
   SELECT MAX(SUBSTRING_INDEX(SUBSTRING_INDEX(NumSerie,".",1),"#",-1)) + 1
   FROM Documentos
   WHERE Tipo = 'FaturaFornecedor'
    AND LEFT(NumSerie,6) = CONCAT('FT', Pais, Ano)
  ),
  '.pdf'
 );
