DROP PROCEDURE IF EXISTS NovaFaturaFornecedor;

DELIMITER //

CREATE PROCEDURE NovaFaturaFornecedor (IN NumSerie TEXT, IN FileId TEXT )
 BEGIN
 
  -- 0. Verificar validade dos argumentos
  IF NumSerie NOT REGEXP '^FT(An|Lx)[0-9]{2}#[0-9]{3,4}\.pdf$'
   THEN signal sqlstate '20000' set message_text = 'NumSerie com formato inválido';
  END IF;
   
  -- 1. Começar Transacao
  START TRANSACTION;
  
  -- 1. Inserir em Documentos 
  INSERT INTO Documentos (NumSerie, Tipo, Estado, FileId) 
  VALUES (NumSerie, 'FaturaFornecedor', 'PorClassificarFornecedor', FileId);
  
  -- 10. Salvar
  COMMIT;
 END;
//

DELIMITER ;
