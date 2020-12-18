-- Devolve o valor total da fatura, somando todos os componentes do campo 'Valor' do campo 'Extra' do documento
-- Formato do campo 'Valor': {"Bens": {"ValorBase": 0.00, "Iva": 0.00}, "Servicos": {"ValorBase": 0.00, "Iva": 0.00}}

CREATE OR REPLACE FUNCTION ACC_FaturaValorTotal (Extra TEXT)
RETURNS DECIMAL(18,2)
RETURN JSON_VALUE(Extra, '$.Valor.Bens.ValorBase') +
       JSON_VALUE(Extra, '$.Valor.Bens.Iva') +
       JSON_VALUE(Extra, '$.Valor.Servicos.ValorBase') +
       JSON_VALUE(Extra, '$.Valor.Servicos.Iva');
