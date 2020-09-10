DELIMITER //

CREATE PROCEDURE NovaFaturaFornecedor (IN NumSerie TEXT, IN FileId TEXT )
 BEGIN
  -- 0. Começar Transacao
  START TRANSACTION;
  
  -- 1. Inserir em Documentos 
  INSERT INTO Documentos (NumSerie, Tipo, Estado, FileId) 
  VALUES (NumSerie, 'FaturaFornecedor', 'PorClassificarFornecedor', FileId);
  
  
  -- 10. Salvar
  COMMIT;
 END;
//

DELIMITER ;
