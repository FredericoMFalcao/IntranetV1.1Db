-- Descrição: devolve o próximo número de série disponível para uma nova fatura de fornecedor

DROP FUNCTION IF EXISTS <?=tableNameWithModule()?>;

CREATE FUNCTION <?=tableNameWithModule()?> (Pais TEXT, Ano TEXT) -- e.g. Pais = 'An', Ano = '20'
RETURNS TEXT
RETURN
 CONCAT(
  'FT',
  Pais,
  Ano,
  '#',
  (
   SELECT MAX(SUBSTRING_INDEX(SUBSTRING_INDEX(NumSerie,".",1),"#",-1)) + 1
   FROM <?=tableNameWithModule("Documentos","DOC")?>
   WHERE Tipo = 'FaturaFornecedor'
    AND LEFT(NumSerie,6) = CONCAT('FT', Pais, Ano)
  ),
  '.pdf'
 );
