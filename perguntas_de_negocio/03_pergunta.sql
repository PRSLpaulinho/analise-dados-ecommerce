-- Qual canal de vendas (ex: App, Web) combinado com a origem do cliente/campanha traz o maior ticket médio de pedido e o maior volume de vendas líquidas?

WITH faturamento_por_pedido AS (
    SELECT 
        ped_id,
        SUM(ite_vendas_liquidas) AS valor_total_pedido
    FROM 
        itens_pedidos AS ip
    INNER JOIN
        pedidos AS p ON ip.ped_id = p.ped_id
    INNER JOIN
        pagamentos AS pg ON p.pag_id = pg.pag_id
    WHERE
        pg.pag_status = 'Paid'
    GROUP BY 
        ped_id
)
SELECT 
    m.mkt_canal_vendas AS canal_vendas,
    m.mkt_campanha AS origem_campanha,
    ROUND(AVG(f.valor_total_pedido), 2) AS ticket_medio_pedido,
    ROUND(SUM(f.valor_total_pedido), 2) AS volume_vendas_liquidas
FROM 
    marketing m
INNER JOIN 
    pedidos p ON m.mkt_id = p.mkt_id
INNER JOIN 
    faturamento_por_pedido f ON p.ped_id = f.ped_id
GROUP BY 
    m.mkt_canal_vendas,
    m.mkt_campanha
ORDER BY 
    volume_vendas_liquidas DESC;