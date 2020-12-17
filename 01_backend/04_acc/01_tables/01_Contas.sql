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


-- - Dados Iniciais -- -

-- Centros de resultados:
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CR010101',"Teste");
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CR010102',"Teste");
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CR0102',"Teste");
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CR020101',"Teste");
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CR020102',"Teste");
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CR0202',"Teste");
-- Analítica:
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('AN010101',"Teste");
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('AN010102',"Teste");
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('AN0102',"Teste");
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('AN020101',"Teste");
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('AN020102',"Teste");
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('AN0202',"Teste");
-- Fornecedores:
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome, Extra) VALUES ('FO0000111',"Fornecedor01",'{"ImpostoIndustrial": 1}');
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome, Extra) VALUES ('FO0000222',"Fornecedor02",'{"ImpostoPredial": 1}');
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome, Extra) VALUES ('FO0000333',"Fornecedor03",'{}');
-- Colaboradores:
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CO123',"Teste01");
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CO456',"Teste02");
-- Contas bancárias:
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CB01',"Teste01");
-- Impostos:
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('IM01',"ImpostosRetencao");
-- Clientes:
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CL1',"Cliente1");
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CL2',"Cliente2");
