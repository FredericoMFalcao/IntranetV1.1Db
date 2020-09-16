-- Tabela: Contas
-- Descrição: Lista todos os nomes e propriedades das contas contabilísticas da aplicação

CREATE TABLE Contas (
  Conta VARCHAR(20) NOT NULL,
  Nome VARCHAR(255) NOT NULL,
  Tipo VARCHAR(50) NOT NULL,
  Extra JSON,
  PRIMARY KEY (Conta,Tipo)
);


-- - SAMPLE -- -
INSERT INTO Contas (Conta, Nome, Tipo) VALUES ('01',"Teste01","Fornecedor");
INSERT INTO Contas (Conta, Nome, Tipo) VALUES ('02',"Teste02","Fornecedor");
