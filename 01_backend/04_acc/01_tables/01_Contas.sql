-- ------------------------
-- Tabela: Contas
--
-- Descrição: Lista todos os nomes e propriedades das contas contabilísticas da aplicação
-- ------------------------

CREATE TABLE <?=tableNameWithModule()?> (
  Conta VARCHAR(20) NOT NULL, -- Dois primeiros caracteres reflectem o tipo de conta
  Nome VARCHAR(255) NOT NULL,
  Extra JSON DEFAULT '{}',
  PRIMARY KEY (Conta)
);


