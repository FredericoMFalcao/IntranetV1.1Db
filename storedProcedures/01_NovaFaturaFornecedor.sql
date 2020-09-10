DELIMITER //

CREATE PROCEDURE NovaFaturaFornecedor (IN NumSerie TEXT, IN FileId TEXT )
 BEGIN
  START TRANSACTION;
  INSERT INTO Documentos (NumSerie, Tipo, Estado, FileId) 
  VALUES (NumSerie, 'FaturaFornecedor', 'PorClassificarFornecedor', FileId) 
  COMMIT;
 END;
//

DELIMITER ;
