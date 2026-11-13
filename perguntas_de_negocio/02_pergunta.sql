-- Quais são as 5 categorias de produtos que trazem a maior margem de lucro líquido absoluto? Apresente a quantidade total de itens vendidos, o ticket médio por item e o lucro acumulado

SELECT 
    pr.pro_categoria AS categoria,
    SUM(ip.ite_quantidade) AS total_itens_vendidos,
    ROUND(AVG(ip.ite_preco_unitario), 2) AS ticket_medio_item,
    ROUND(SUM(ip.ite_lucro), 2) AS lucro_acumulado
FROM 
    produtos AS pr
INNER JOIN 
    itens_pedidos AS ip ON pr.pro_id = ip.pro_id
INNER JOIN
    pedidos AS p ON ip.ped_id = p.ped_id
INNER JOIN
    pagamentos AS pg ON pg.pag_id = p.pag_id
WHERE
    pg.pag_status = 'Paid'
GROUP BY 
    pr.pro_categoria
ORDER BY 
    lucro_acumulado DESC
LIMIT 
    5;