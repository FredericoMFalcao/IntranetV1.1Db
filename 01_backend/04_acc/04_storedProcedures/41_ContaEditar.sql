DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //
-- ------------------------
--  Tabela (sql): Contas Funcao: Editar
--
--  Descrição: Altera um ou mais campos de uma conta contabilística já existente
--          No caso de o código da conta se alterar e esta ter lançamentos associados, altera também a tabela de Lançamentos
-- ------------------------
CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_Conta TEXT, IN in_Extra JSON)

  BEGIN
  
    -- 1. Separar os inputs de acordo com os campos da tabela de Contas:
    DECLARE in_ContaNova TEXT;
    DECLARE in_ContaNome TEXT;
    DECLARE in_Extra2 JSON;
    SET in_ContaNova = JSON_VALUE(in_Extra, '$.ContaNova');
    SET in_ContaNome = JSON_VALUE(in_Extra, '$.ContaNome');
    SET in_Extra2 = JSON_REMOVE(in_Extra, '$.ContaNova', '$.ContaNome');
    
  
    -- 2. Verificar se a conta já existe:
    IF NOT EXISTS (SELECT Conta FROM <?=tableNameWithModule("Contas")?> WHERE Conta = in_Conta)
      THEN signal sqlstate '23000' set message_text = 'Conta inexistente.';
    END IF;
    
    
    -- 3. Fazer as alterações aos campos da tabela de Contas:
    IF in_ContaNome IS NOT NULL THEN
      UPDATE <?=tableNameWithModule("Contas")?>
      SET Nome = in_ContaNome
      WHERE Conta = in_Conta;
    END IF;
      
    UPDATE <?=tableNameWithModule("Contas")?>
    SET Extra = JSON_MERGE_PATCH(Extra, in_Extra2)
    WHERE Conta = in_Conta;
    
    
    -- 4. No caso do código da conta ser alterado, alterar nas tabelas de Contas e Lançamentos:
    IF in_ContaNova IS NOT NULL THEN
    
      UPDATE <?=tableNameWithModule("Lancamentos")?>
      SET Conta = REPLACE(Conta, in_Conta, in_ContaNova)
      WHERE Conta LIKE CONCAT('%', in_Conta, '%');
      
      UPDATE <?=tableNameWithModule("Contas")?>
      SET Conta = in_ContaNova
      WHERE Conta = in_Conta;
      
    END IF;
  
  END;
  
//

DELIMITER ;
