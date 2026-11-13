-- Qual é a diferença de comportamento de compra entre clientes recorrentes (cli_recorrencia = true) e novos clientes em relação a: Ticket médio por pedido, volume de pedidos e taxa de uso de cupons de desconto?

WITH valor_por_pedido AS (
    SELECT 
        p.ped_id,
        p.cli_id,
        SUM(ip.ite_vendas_liquidas) AS valor_total_pedido,
        MAX(CASE 
                WHEN m.mkt_cupom IS NOT NULL THEN 1 
                ELSE 0 
            END) AS usou_cupom
    FROM 
        pedidos AS p 
    INNER JOIN 
        itens_pedidos AS ip ON p.ped_id = ip.ped_id
    LEFT JOIN 
        marketing AS m ON p.mkt_id = m.mkt_id
    INNER JOIN 
        pagamentos AS pg ON p.pag_id = pg.pag_id
    WHERE 
        pg.pag_status = 'Paid'
    GROUP BY 
        p.ped_id, p.cli_id
)
SELECT 
    c.cli_recorrencia AS cliente_recorrente,
    ROUND(AVG(v.valor_total_pedido), 2) AS ticket_medio_pedido,
    COUNT(DISTINCT v.ped_id) AS volume_pedidos,
    ROUND(SUM(v.usou_cupom) * 100.0 / COUNT(DISTINCT v.ped_id), 2) AS taxa_uso_cupons
FROM 
    clientes AS c
INNER JOIN 
    valor_por_pedido AS v ON c.cli_id = v.cli_id
GROUP BY 
    c.cli_recorrencia;