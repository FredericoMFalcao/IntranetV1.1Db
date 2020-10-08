-- Tabela: Contas
-- Descrição: Lista todos os nomes e propriedades das contas contabilísticas da aplicação

CREATE TABLE <?=tableNameWithModule()?> (
  Conta VARCHAR(20) NOT NULL, -- Dois primeiros caracteres reflectem o tipo de conta
  Nome VARCHAR(255) NOT NULL,
  Extra JSON DEFAULT '{}',
  PRIMARY KEY (Conta)
);


-- - Dados Iniciais -- -
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CR0101',"Teste01"); -- centro de resultados
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('AN0202',"Teste02"); -- analítica
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('FO0000111',"Teste03"); -- fornecedor
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CO123',"Teste04"); -- colaborador
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CO456',"Teste05"); -- colaborador
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CB01',"Teste06"); -- conta bancária


-- vim: syntax=sql
