SELECT
    ip.ite_vendas_liquidas AS vendas_liquidas,
    ip.ite_lucro AS lucro,
    ip.ite_vendas_brutas AS vendas_brutas,
    pg.pag_status AS status_pagamento
FROM
    itens_pedidos AS ip
JOIN
    pedidos AS p ON ip.ped_id = p.ped_id
JOIN
    pagamentos AS pg ON p.pag_id = pg.pag_id
WHERE
    pg.pag_status = 'Failed'