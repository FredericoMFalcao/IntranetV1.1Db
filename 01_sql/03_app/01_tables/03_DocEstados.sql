-- Tabela: DocEstados
-- Descricao: Lista todos os estados que cada tipo de documento pode ter

CREATE TABLE DocEstados (  
  TipoDoc VARCHAR(50) NOT NULL,
  Estado VARCHAR(50) NOT NULL,
  Descricao VARCHAR(255),
  
  PRIMARY KEY (TipoDoc,Estado),
  FOREIGN KEY (TipoDoc) REFERENCES DocTipos(Tipo) ON DELETE RESTRICT ON UPDATE CASCADE
);


-- Dados Iniciais
INSERT INTO DocEstados (TipoDoc, Estado, Descricao) VALUES ('FaturaFornecedor', 'PorClassificarFornecedor', 'Existe no sistema apenas com um PDF.');
INSERT INTO DocEstados (TipoDoc, Estado, Descricao) VALUES ('FaturaFornecedor', 'PorClassificarAnalitica',  'À espera de ser classificada em termos de contabilidade analítica.');
INSERT INTO DocEstados (TipoDoc, Estado, Descricao) VALUES ('FaturaFornecedor', 'PorAnexarCPagamento',     'À espera de ser anexado comprovativo de pagamento.');
INSERT INTO DocEstados (TipoDoc, Estado, Descricao) VALUES ('FaturaFornecedor', 'PorRegistarContabilidade', 'À espera de integrar custo no software de contabilidade fiscal.');
INSERT INTO DocEstados (TipoDoc, Estado, Descricao) VALUES ('FaturaFornecedor', 'PorRegistarPagamentoContab', 'À espera de integrar pagamento no software de contabilidade fiscal.');
INSERT INTO DocEstados (TipoDoc, Estado, Descricao) VALUES ('FaturaFornecedor', 'Concluido', 'Todos os procedimentos foram realizados.');
