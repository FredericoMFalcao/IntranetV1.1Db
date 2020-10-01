-- Devolve o valor total da fatura, somando todos os componentes do campo 'Valor' do campo 'Extra' do documento
-- Formato do campo 'Valor': {"Bens": {"ValorBase": 0.00, "Iva": 0.00}, "Servicos": {"ValorBase": 0.00, "Iva": 0.00}}

DROP FUNCTION IF EXISTS FF_ValorTotal;

CREATE FUNCTION FF_ValorTotal (Extra TEXT)
RETURNS DECIMAL(18,2)
RETURN JSON_EXTRACT(JSON_EXTRACT(JSON_EXTRACT(Extra, '$.Valor'), '$.Bens'), '$.ValorBase') +
       JSON_EXTRACT(JSON_EXTRACT(JSON_EXTRACT(Extra, '$.Valor'), '$.Bens'), '$.Iva') +
       JSON_EXTRACT(JSON_EXTRACT(JSON_EXTRACT(Extra, '$.Valor'), '$.Servicos'), '$.ValorBase') +
       JSON_EXTRACT(JSON_EXTRACT(JSON_EXTRACT(Extra, '$.Valor'), '$.Servicos'), '$.Iva');
