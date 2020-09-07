-- Tabela: Documentos
-- Descricao: Lista todos os códigos e propriedades dos documentos inseridos na aplicação

CREATE TABLE Documentos (
  NumSerie VARCHAR(25) NOT NULL,
  Tipo ENUM('FactForn'),
  Estado ENUM('Inserido','Aprovado','Registado','Pago','Confirmado','Anulado'),
  FileId VARCHAR(250),
  PRIMARY KEY (NumSerie,Tipo)
);
  
