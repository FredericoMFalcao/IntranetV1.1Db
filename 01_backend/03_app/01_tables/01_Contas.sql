-- Tabela: Contas
-- Descrição: Lista todos os nomes e propriedades das contas contabilísticas da aplicação

CREATE TABLE <?=tableNameWithModule()?> (
  Conta VARCHAR(20) NOT NULL, -- Dois primeiros caracteres reflectem o tipo de conta
  Nome VARCHAR(255) NOT NULL,
  Extra JSON,
  PRIMARY KEY (Conta)
);


-- - Dados Iniciais -- -
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CR0101',"Teste01"); -- centro de resultados
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('AN0202',"Teste02"); -- analítica
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('FO32121000',"Teste03"); -- fornecedor
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('COabc',"Teste04"); -- colaborador
INSERT INTO <?=tableNameWithModule()?> (Conta, Nome) VALUES ('CG01',"FaturasFornecedor"); -- custos gerais

-- vim: syntax=sql
