-- Curva ABC de Produtos por Contribuição no Faturamento Objetivo: Classificar o catálogo de produtos em A (até 80% do faturamento), B (80% a 95%) e C (95% a 100%) para otimizar gestão de estoque e margem.

WITH faturamento_por_produto AS (
    SELECT 
        ip.pro_id,
        ROUND(SUM(ip.ite_vendas_liquidas), 2) AS faturamento_produto,
        ROUND(SUM(ip.ite_lucro), 2) AS lucro_produto
    FROM 
        itens_pedidos AS ip
    INNER JOIN 
        pedidos AS p ON ip.ped_id = p.ped_id
    INNER JOIN 
        pagamentos AS pg ON p.pag_id = pg.pag_id
    WHERE 
        pg.pag_status = 'Paid'
    GROUP BY 
        ip.pro_id
),
faturamento_acumulado AS (
    SELECT 
        pro_id,
        faturamento_produto,
        lucro_produto,
        SUM(faturamento_produto) OVER (ORDER BY faturamento_produto DESC) AS acumulado_produto,
        SUM(faturamento_produto) OVER () AS faturamento_total_empresa
    FROM 
        faturamento_por_produto
)
SELECT 
    pro_id AS produto_id,
    faturamento_produto,
    lucro_produto,
    CASE 
        WHEN (acumulado_produto / faturamento_total_empresa) <= 0.80 THEN 'Classe A (Essencial - Top 80%)'
        WHEN (acumulado_produto / faturamento_total_empresa) <= 0.95 THEN 'Classe B (Intermediário - 15%)'
        ELSE 'Classe C (Baixo - 5%)'
    END AS classificacao_abc
FROM 
    faturamento_acumulado
ORDER BY 
    faturamento_produto DESC;