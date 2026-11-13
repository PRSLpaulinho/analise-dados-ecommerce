-- Quem são os 3 clientes que mais geraram faturamento líquido acumulado dentro de cada estado brasileiro?

WITH faturamento_cliente AS (
    SELECT 
        c.cli_id,
        c.cli_nome AS nome_cliente,
        e.end_estado AS estado,
        ROUND(SUM(ip.ite_vendas_liquidas), 2) AS faturamento_total,
        COUNT(DISTINCT p.ped_id) AS total_pedidos
    FROM 
        clientes AS c
    INNER JOIN 
        enderecos AS e ON c.cli_id = e.cli_id
    INNER JOIN 
        pedidos AS p ON c.cli_id = p.cli_id
    INNER JOIN 
        itens_pedidos AS ip ON p.ped_id = ip.ped_id
    INNER JOIN
        pagamentos AS pg ON p.pag_id = pg.pag_id
    WHERE 
        pg.pag_status = 'Paid'
    GROUP BY 
        c.cli_id, 
        c.cli_nome, 
        e.end_estado
),
clientes_ranqueados AS (
    SELECT 
        cli_id,
        nome_cliente,
        estado,
        faturamento_total,
        total_pedidos,
        ROW_NUMBER() 
            OVER (
                PARTITION BY estado 
                ORDER BY faturamento_total DESC
            ) AS ranking_estado
    FROM 
        faturamento_cliente
)
SELECT 
    estado,
    ranking_estado AS posicao,
    nome_cliente,
    faturamento_total,
    total_pedidos
FROM 
    clientes_ranqueados
WHERE 
    ranking_estado <= 3
ORDER BY 
    estado ASC, 
    ranking_estado ASC;

