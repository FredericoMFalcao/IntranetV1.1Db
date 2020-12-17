-- ------------------------
-- Tabela: DocEstados
-- Descricao: Lista todos os estados que cada tipo de documento pode ter
-- ------------------------

CREATE TABLE <?=tableNameWithModule()?> (  
  Id INT PRIMARY KEY AUTO_INCREMENT,
  TipoDoc VARCHAR(50) NOT NULL,
  Estado VARCHAR(50) NOT NULL,
  Descricao VARCHAR(255),
  `Schema` JSON DEFAULT '{}',
  
  UNIQUE (TipoDoc,Estado),
  FOREIGN KEY (TipoDoc) REFERENCES <?=tableNameWithModule("DocTipos")?>(Tipo) ON DELETE RESTRICT ON UPDATE CASCADE
);


-- - Dados Iniciais - --

-- Faturas de fornecedor:
INSERT INTO <?=tableNameWithModule()?> (TipoDoc, Estado, Descricao, `Schema`) VALUES ('FaturaFornecedor', 'PorClassificarFornecedor', 'Existe no sistema apenas com um PDF.','{"Fornecedor":"string","Descricao":"string?"}');
INSERT INTO <?=tableNameWithModule()?> (TipoDoc, Estado, Descricao, `Schema`) VALUES ('FaturaFornecedor', 'PorClassificarAnalitica', 'À espera de ser classificada em termos de contabilidade analítica.','{"CentroResultados":"string","Analitica":"string","Colaborador":"string"}');
INSERT INTO <?=tableNameWithModule()?> (TipoDoc, Estado, Descricao) VALUES ('FaturaFornecedor', 'PorRegistarContabilidade', 'À espera de integrar custo no software de contabilidade fiscal.');
INSERT INTO <?=tableNameWithModule()?> (TipoDoc, Estado, Descricao, `Schema`) VALUES ('FaturaFornecedor', 'PorAnexarCPagamento', 'À espera de ser anexado comprovativo de pagamento.','{"FileId":"string"}');
INSERT INTO <?=tableNameWithModule()?> (TipoDoc, Estado, Descricao) VALUES ('FaturaFornecedor', 'PorRegistarPagamentoContab', 'À espera de integrar pagamento no software de contabilidade fiscal.');
INSERT INTO <?=tableNameWithModule()?> (TipoDoc, Estado, Descricao) VALUES ('FaturaFornecedor', 'Concluido', 'Todos os procedimentos foram realizados.');
-- Comprovativos de pagamento:
INSERT INTO <?=tableNameWithModule()?> (TipoDoc, Estado) VALUES ('ComprovativoPagamento', 'PorAprovar');
INSERT INTO <?=tableNameWithModule()?> (TipoDoc, Estado) VALUES ('ComprovativoPagamento', 'Concluido');
-- Faturas de cliente:
INSERT INTO <?=tableNameWithModule()?> (TipoDoc, Estado) VALUES ('FaturaCliente', 'PorClassificarCliente');
INSERT INTO <?=tableNameWithModule()?> (TipoDoc, Estado) VALUES ('FaturaCliente', 'PorClassificarAnalitica');
INSERT INTO <?=tableNameWithModule()?> (TipoDoc, Estado) VALUES ('FaturaCliente', 'PorAnexarCPagamento');
INSERT INTO <?=tableNameWithModule()?> (TipoDoc, Estado) VALUES ('FaturaCliente', 'Concluido');
