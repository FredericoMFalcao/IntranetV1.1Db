-- Tabela: Contas
-- Descrição: Lista todas os nomes e propriedades das contas contabilísticas da aplicação

CREATE TABLE (
  Conta INT PRIMARY KEY,
  Nome VARCHAR(255) NOT NULL,
  Tipo ENUM('CentroResultado','Analitica','Fornecedor','Cliente','Colaborador'),
  Exta JSON
);
