DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //
-- ------------------------
--  Tabela (sql): Contas Funcao: Apagar
--
--  Descrição: Apaga uma conta contabilística
--          No caso da conta ter lançamentos associados, FALTA DEFINIR O QUE ACONTECE
-- ------------------------
CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_Conta TEXT)

  BEGIN
  
    -- 1. Verificar se a conta já existe:
    IF NOT EXISTS (SELECT Conta FROM <?=tableNameWithModule("Contas")?> WHERE Conta = in_Conta)
      THEN signal sqlstate '23000' set message_text = 'Conta inexistente.';
      

    -- 2. Verificar se a conta tem lançamentos associados:
    ELSEIF EXISTS (SELECT Conta FROM <?=tableNameWithModule("Lancamentos")?> WHERE Conta LIKE CONCAT('%', in_Conta, '%'))
      THEN signal sqlstate '23000' set message_text = 'Conta tem lançamentos associados.';
    
    
    -- 3. Apagar a conta:
    ELSE
      DELETE FROM <?=tableNameWithModule("Contas")?>
      WHERE Conta = in_Conta;
      
    END IF;

  END;
  
//

DELIMITER ;
