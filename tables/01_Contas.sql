-- Tabela: Contas
-- Descrição: Lista todos os nomes e propriedades das contas contabilísticas da aplicação

CREATE TABLE Contas(
  Conta INT PRIMARY KEY,
  Nome VARCHAR(255) NOT NULL,
  Tipo ENUM('CentroResultados','Analitica','Fornecedor','Cliente','Colaborador'),
  Extra JSON
);
