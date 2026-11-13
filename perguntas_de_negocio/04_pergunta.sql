-- Qual é o tempo médio real de entrega vs. o tempo estimado, e a taxa de pedidos entregues com atraso, agrupados por estado do cliente?

WITH log_pedido_resumo AS (
    SELECT 
        ped_id,
        CASE 
            WHEN ped_dias_entrega > ped_dias_estimados_entrega THEN 1
            ELSE 0
        END AS entrega_atrasada
    FROM 
        pedidos
    WHERE 
        ped_status = 'Completed'
)
SELECT 
    e.end_estado AS estado,
    COUNT(p.ped_id) AS total_pedidos_entregues,
    ROUND(AVG(p.ped_dias_entrega), 1) AS media_dias_entrega,
    ROUND(AVG(p.ped_dias_estimados_entrega), 1) AS media_dias_estimado,
    ROUND((SUM(l.entrega_atrasada) / COUNT(p.ped_id)) * 100, 2) AS taxa_atraso_pct
FROM 
    pedidos AS p
INNER JOIN 
    enderecos AS e ON p.cli_id = e.cli_id
INNER JOIN 
    log_pedido_resumo AS l ON p.ped_id = l.ped_id
GROUP BY 
    e.end_estado
ORDER BY 
    taxa_atraso_pct DESC;