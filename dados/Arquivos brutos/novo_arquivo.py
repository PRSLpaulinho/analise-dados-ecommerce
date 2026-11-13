import pandas as pd

#1. Carregar os arquivos brutos
df_orig = pd.read_csv('ecommerce_sales_customer_analytics_150k.csv')
df_items = pd.read_csv('order_items.csv')
df_catalog = pd.read_csv('product_catalog.csv')

# 2. CRIAR TABELA PRODUTOS
df_produtos = df_catalog.rename(columns={
    'product_id': 'pro_id',
    'product_name': 'pro_nome',
    'product_category': 'pro_categoria',
    'product_subcategory': 'pro_subcategoria',
    'brand': 'pro_marca',
    'supplier': 'pro_fornecedor',
    'unit_price': 'pro_preco_unitario',
    'product_cost': 'pro_custo',
    'product_rating': 'pro_avaliacao'
})
df_produtos.to_csv('produtos.csv', index=False)

#3. CRIAR TABELA ITENS_PEDIDOS
df_itens_pedidos = df_items.copy()
df_itens_pedidos['ite_id'] = ['ITE-' + str(i+1).zfill(7) for i in range(len(df_itens_pedidos))]
df_itens_pedidos = df_itens_pedidos.rename(columns={
    'order_id': 'ped_id',
    'product_id': 'pro_id',
    'quantity': 'ite_quantidade',
    'unit_price': 'ite_preco_unitario',
    'discount_percentage': 'ite_porcent_desconto',
    'discount_amount': 'ite_valor_desconto',
    'gross_sales': 'ite_vendas_brutas',
    'tax_amount': 'ite_taxa_imposto',
    'shipping_cost': 'ite_custo_envio',
    'net_sales': 'ite_vendas_liquidas',
    'product_cost': 'ite_custo_produto',
    'profit': 'ite_lucro'
})
# Reordenar com ite_id no início
cols_itens = ['ite_id', 'ped_id', 'pro_id'] + [c for c in df_itens_pedidos.columns if c not in ['ite_id', 'ped_id', 'pro_id']]
df_itens_pedidos = df_itens_pedidos[cols_itens]
df_itens_pedidos.to_csv('itens_pedidos.csv', index=False)

#4. CRIAR TABELAS CLIENTES E ENDERECOS
df_cli_raw = df_orig[['customer_id', 'customer_name', 'customer_age', 'gender', 
                     'customer_segment', 'customer_type', 'customer_lifetime_value', 
                     'is_repeat_customer', 'customer_order_count']].drop_duplicates(subset=['customer_id'])

df_clientes = df_cli_raw.rename(columns={
    'customer_id': 'cli_id',
    'customer_name': 'cli_nome',
    'customer_age': 'cli_idade',
    'gender': 'cli_genero',
    'customer_segment': 'cli_segmento',
    'customer_type': 'cli_tipo',
    'customer_lifetime_value': 'cli_custo_vida',
    'is_repeat_customer': 'cli_recorrencia',
    'customer_order_count': 'cli_total_pedidos'
})
df_clientes.to_csv('clientes.csv', index=False)

#Endereços
df_end_raw = df_orig[['customer_id', 'customer_city', 'customer_state', 'customer_country', 'region', 'customer_postal_code']].drop_duplicates(subset=['customer_id'])
df_end_raw['end_id'] = ['END-' + str(i+1).zfill(6) for i in range(len(df_end_raw))]

df_enderecos = df_end_raw.rename(columns={
    'customer_id': 'cli_id',
    'customer_city': 'end_cidade',
    'customer_state': 'end_estado',
    'customer_country': 'end_pais',
    'region': 'end_regiao',
    'customer_postal_code': 'end_codigo_postal'
})[['end_id', 'cli_id', 'end_cidade', 'end_estado', 'end_pais', 'end_regiao', 'end_codigo_postal']]
df_enderecos.to_csv('enderecos.csv', index=False)

#5. CRIAR DIMENSÕES DE APOIO (LOGISTICA, MARKETING, PAGAMENTOS)

# Logística
df_log = df_orig[['warehouse', 'shipping_method']].drop_duplicates().reset_index(drop=True)
df_log['log_id'] = ['LOG-' + str(i+1).zfill(4) for i in range(len(df_log))]
df_logistica = df_log.rename(columns={'warehouse': 'log_armazem', 'shipping_method': 'log_metodo_envio'})[['log_id', 'log_armazem', 'log_metodo_envio']]
df_logistica.to_csv('logistica.csv', index=False)

# Marketing
df_mkt = df_orig[['marketing_channel', 'sales_channel', 'campaign_name', 'coupon_code']].drop_duplicates().reset_index(drop=True)
df_mkt['mkt_id'] = ['MKT-' + str(i+1).zfill(4) for i in range(len(df_mkt))]
df_marketing = df_mkt.rename(columns={
    'marketing_channel': 'mkt_canal',
    'sales_channel': 'mkt_canal_vendas',
    'campaign_name': 'mkt_campanha',
    'coupon_code': 'mkt_cupom'
})[['mkt_id', 'mkt_canal', 'mkt_canal_vendas', 'mkt_campanha', 'mkt_cupom']]
df_marketing.to_csv('marketing.csv', index=False)

# Pagamentos
df_pag = df_orig[['payment_method', 'payment_status', 'currency']].drop_duplicates().reset_index(drop=True)
df_pag['pag_id'] = ['PAG-' + str(i+1).zfill(4) for i in range(len(df_pag))]
df_pagamentos = df_pag.rename(columns={
    'payment_method': 'pag_metodo',
    'payment_status': 'pag_status',
    'currency': 'pag_moeda'
})[['pag_id', 'pag_metodo', 'pag_status', 'pag_moeda']]
df_pagamentos.to_csv('pagamentos.csv', index=False)

#6. CRIAR TABELA FATO PEDIDOS (MAAPEADA COM AS FKS)
df_pedidos = df_orig.merge(df_log, on=['warehouse', 'shipping_method'], how='left') \
                    .merge(df_mkt, on=['marketing_channel', 'sales_channel', 'campaign_name', 'coupon_code'], how='left') \
                    .merge(df_pag, on=['payment_method', 'payment_status', 'currency'], how='left')

df_pedidos_final = df_pedidos.rename(columns={
    'order_id': 'ped_id',
    'customer_id': 'cli_id',
    'order_date': 'ped_data',
    'order_time': 'ped_tempo',
    'order_status': 'ped_status',
    'delivery_days': 'ped_dias_entrega',
    'estimated_delivery_days': 'ped_dias_estimados_entrega',
    'delivery_status': 'ped_status_entrega',
    'return_status': 'ped_status_retorno',
    'return_reason': 'ped_motivo_retorno',
    'customer_rating': 'ped_avaliacao',
    'review_sentiment': 'ped_sentimento',
    'customer_review': 'ped_avaliacao_cliente',
    'loyalty_points_earned': 'ped_pts_fidelidade_ganhos',
    'loyalty_points_redeemed': 'ped_pts_fidelidade_resgatados'
})[[
    'ped_id', 'cli_id', 'log_id', 'mkt_id', 'pag_id', 'ped_data', 'ped_tempo', 'ped_status',
    'ped_dias_entrega', 'ped_dias_estimados_entrega', 'ped_status_entrega', 'ped_status_retorno',
    'ped_motivo_retorno', 'ped_avaliacao', 'ped_sentimento', 'ped_avaliacao_cliente',
    'ped_pts_fidelidade_ganhos', 'ped_pts_fidelidade_resgatados'
]]

df_pedidos_final.to_csv('pedidos.csv', index=False)
print("Todas as tabelas foram geradas e salvas em arquivos CSV com sucesso!")