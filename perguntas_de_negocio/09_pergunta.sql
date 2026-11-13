-- Qual foi a evolução do faturamento líquido mês a mês ao longo do tempo, apresentando o valor do mês atual, o valor do mês anterior e a variação percentual de crescimento (MoM)?

WITH separacao_meses AS (
    SELECT 
        DATE_FORMAT(p.ped_data, '%Y-%m') AS ano_mes,
        ROUND(SUM(i.ite_vendas_liquidas), 2) AS faturamento_mes
    FROM 
        pedidos AS p
    JOIN 
        itens_pedidos AS i ON p.ped_id = i.ped_id
    GROUP BY 
        ano_mes
),
faturamento_com_anterior AS (
    SELECT 
        ano_mes,
        faturamento_mes,
        LAG(faturamento_mes, 1) OVER (ORDER BY ano_mes) AS faturamento_mes_anterior
    FROM 
        separacao_meses
)
SELECT 
    ano_mes,
    faturamento_mes,
    ROUND(
        CASE 
            WHEN faturamento_mes_anterior IS NULL THEN 0.00
            ELSE ((faturamento_mes - faturamento_mes_anterior) / faturamento_mes_anterior) * 100
        END, 2
    ) AS variacao_percentual_mes
FROM 
    faturamento_com_anterior
WHERE 
    ano_mes >= '2025-11'
ORDER BY 
    ano_mes;