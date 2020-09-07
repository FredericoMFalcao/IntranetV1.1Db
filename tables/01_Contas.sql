-- Tabela: Contas
-- Descrição: Lista todos os nomes e propriedades das contas contabilísticas da aplicação

CREATE TABLE Contas(
  Conta VARCHAR(20) NOT NULL,
  Nome VARCHAR(255) NOT NULL,
  Tipo ENUM('CentroResultados','Analitica','Fornecedor','Cliente','Colaborador'),
  Extra JSON,
  PRIMARY KEY(Conta,Tipo)
);
