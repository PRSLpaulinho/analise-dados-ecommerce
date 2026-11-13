-- Qual foi o faturamento bruto total, o faturamento líquido, o custo total de produto/envio e a margem de lucro percentual média do e-commerce em todo o período registrado?

SELECT
    SUM(ip.ite_vendas_brutas) AS faturamento_bruto,
    SUM(ip.ite_vendas_liquidas) AS faturamento_liquido,
    SUM(ip.ite_custo_produto + ip.ite_custo_envio) AS custo_total,
    SUM(ip.ite_lucro) AS lucro_total,
    ROUND((SUM(ip.ite_lucro) / NULLIF(SUM(ip.ite_vendas_liquidas), 0)) * 100, 2) AS margem_lucro_pct
FROM
    itens_pedidos AS ip
INNER JOIN
    pedidos AS p ON ip.ped_id = p.ped_id
INNER JOIN
    pagamentos AS pg ON p.pag_id = pg.pag_id
WHERE
    pg.pag_status = 'Paid';