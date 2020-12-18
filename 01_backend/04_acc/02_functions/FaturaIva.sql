-- Devolve o valor do IVA da fatura
-- Formato do campo 'Valor': {"Bens": {"ValorBase": 0.00, "Iva": 0.00}, "Servicos": {"ValorBase": 0.00, "Iva": 0.00}}

CREATE OR REPLACE FUNCTION ACC_FaturaIva (Extra TEXT)
RETURNS DECIMAL(18,2)
RETURN JSON_VALUE(Extra, '$.Valor.Bens.Iva') + JSON_VALUE(Extra, '$.Valor.Servicos.Iva');
