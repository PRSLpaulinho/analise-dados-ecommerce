-- Qual é a taxa geral de devolução de pedidos (ped_status_retorno), os 3 principais motivos alegados pelos clientes e o impacto financeiro total (lucro deixado de ganhar) dessas devoluções?

SELECT 
    COUNT(p.ped_id) AS total_pedidos_geral,
    COUNT(p.ped_status_retorno) AS total_devolucoes,
    ROUND((COUNT(p.ped_status_retorno) / COUNT(p.ped_id)) * 100, 2) AS taxa_geral_devolucao_pct,
    ROUND(SUM(CASE 
                WHEN p.ped_status_retorno = 'Returned' THEN i.ite_lucro
            END), 2) AS impacto_financeiro_total_rs
FROM 
    pedidos AS p
LEFT JOIN 
    itens_pedidos AS ip ON p.ped_id = ip.ped_id;

SELECT 
    p.ped_motivo_retorno AS motivo_devolucao,
    COUNT(p.ped_status_retorno) AS quantidade_devolucoes,
    ROUND(SUM(ip.ite_lucro), 2) AS impacto_financeiro_motivo_rs
FROM 
    pedidos AS p
LEFT JOIN 
    itens_pedidos AS ip ON p.ped_id = ip.ped_id
WHERE 
    p.ped_status_retorno = 'Returned'
GROUP BY 
    p.ped_motivo_retorno
ORDER BY 
    quantidade_devolucoes DESC
LIMIT 
    3;