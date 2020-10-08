-- Descrição: para uma dada conta multipla (e.g. CR0101:AN0202), devolve a conta do tipo dado como argumento

DROP FUNCTION IF EXISTS ExtrairConta;

CREATE FUNCTION ExtrairConta (Tipo CHAR(2), Conta_Multi TEXT)
RETURNS TEXT
RETURN
  SUBSTRING_INDEX(SUBSTRING(Conta_Multi, LOCATE(Tipo, Conta_Multi)), ":", 1);
  -- 'SUBSTRING' devolve tudo a partir do tipo de conta dado no 'LOCATE'; 'SUBSTRING_INDEX' pega nesse string e devolve tudo o que está à esquerda do primeiro ':'
