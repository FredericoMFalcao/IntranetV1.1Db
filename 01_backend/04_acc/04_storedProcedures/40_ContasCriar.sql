DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //
-- ------------------------
--  Tabela (sql): Contas Funcao: Criar
--
--  Descrição: Cria uma nova conta contabilística 
--    (e.g. Fornecedor, Centro de Resultados, Analítica, Colaorador, Conta Bancária, etc)
-- ------------------------
CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_Extra JSON)

  BEGIN
    
    -- 1. Separar os inputs de acordo com os campos da tabela de Contas:
    DECLARE in_Conta TEXT;
    DECLARE in_ContaNome TEXT;
    DECLARE in_Extra2 JSON;
    SET in_Conta = JSON_VALUE(in_Extra, '$.Conta');
    SET in_ContaNome = JSON_VALUE(in_Extra, '$.ContaNome');
    SET in_Extra2 = JSON_REMOVE(in_Extra, '$.Conta', '$.ContaNome'); 
    
 
    -- 2. Verificar se a conta já existe:
    IF EXISTS (SELECT Conta FROM <?=tableNameWithModule("Contas")?> WHERE Conta = in_Conta)
      THEN signal sqlstate '23000' set message_text = 'Conta já existe.';
    END IF;
    
    
    -- 3. Inserir na tabela de Contas:
    INSERT INTO <?=tableNameWithModule("Contas")?> (Conta, Nome, Extra)
    VALUES (in_Conta, in_ContaNome, in_Extra2);

  END;
  
//

DELIMITER ;
