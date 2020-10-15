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
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('AN0202',"Teste01"); -- analítica
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome, Extra) VALUES ('FO0000111',"Teste01",'{"ImpostoIndustrial": 1}'); -- fornecedor
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CO123',"Teste01"); -- colaborador
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CO456',"Teste02"); -- colaborador
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CB01',"Teste01"); -- conta bancária
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('IM01',"ImpostosRetencao"); -- impostos


-- vim: syntax=sql
