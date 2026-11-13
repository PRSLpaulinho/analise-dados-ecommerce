-- Os pedidos que utilizaram cupom de desconto (mkt_cupom) resultaram em uma margem de lucro percentual maior ou menor do que os pedidos sem cupom? Vale a pena manter a estratégia atual de descontos?

SELECT
    CASE
        WHEN m.mkt_cupom IS NOT NULL THEN 'Com Cupom'
        ELSE 'Sem Cupom'
    END AS tipo_cupom,
    COUNT(DISTINCT p.ped_id) AS total_pedidos,
    ROUND(SUM(ip.ite_vendas_liquidas), 2) AS faturamento_total,
    ROUND(SUM(ip.ite_lucro) / SUM(ip.ite_vendas_liquidas) * 100, 2) AS margem_lucro_percentual
FROM 
    pedidos AS p
LEFT JOIN 
    marketing AS m ON p.mkt_id = m.mkt_id
INNER JOIN 
    itens_pedidos AS ip ON p.ped_id = ip.ped_id
INNER JOIN 
    pagamentos AS pg ON p.pag_id = pg.pag_id
WHERE 
    pg.pag_status = 'Paid'
GROUP BY 
    tipo_cupom;