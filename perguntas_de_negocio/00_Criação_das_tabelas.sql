CREATE DATABASE IF NOT EXISTS ecommerce_analytics;
USE ecommerce_analytics;

-- 1. Dimensão Produtos
CREATE TABLE produtos (
    pro_id VARCHAR(50),
    pro_nome VARCHAR(255),
    pro_categoria VARCHAR(100),
    pro_subcategoria VARCHAR(100),
    pro_marca VARCHAR(100),
    pro_fornecedor VARCHAR(100),
    pro_preco_unitario DECIMAL(10,2),
    pro_custo DECIMAL(10,2),
    pro_avaliacao DECIMAL(3,2),
constraint produtos_pro_id_pk primary key (pro_id)
);

-- 2. Dimensão Clientes
CREATE TABLE clientes (
    cli_id VARCHAR(50),
    cli_nome VARCHAR(255),
    cli_idade INT,
    cli_genero VARCHAR(50),
    cli_segmento VARCHAR(100),
    cli_tipo VARCHAR(100),
    cli_custo_vida DECIMAL(10,2),
    cli_recorrencia BOOLEAN,
    cli_total_pedidos INT,
constraint clientes_cli_id_pk primary key (cli_id)
);

-- 3. Dimensão Endereços
CREATE TABLE enderecos (
    end_id VARCHAR(50),
    cli_id VARCHAR(50),
    end_cidade VARCHAR(100),
    end_estado VARCHAR(100),
    end_pais VARCHAR(100),
    end_regiao VARCHAR(100),
    end_codigo_postal VARCHAR(20),
constraint enderecos_end_id_pk primary key (end_id),
constraint enderecos_cli_id_fk foreign key (cli_id) references clientes(cli_id)
);

-- 4. Dimensão Logística
CREATE TABLE logistica (
    log_id VARCHAR(50),
    log_armazem VARCHAR(100),
    log_metodo_envio VARCHAR(100),
constraint logistica_log_id_pk primary key (log_id)
);

-- 5. Dimensão Marketing
CREATE TABLE marketing (
    mkt_id VARCHAR(50),
    mkt_canal VARCHAR(100),
    mkt_canal_vendas VARCHAR(100),
    mkt_campanha VARCHAR(255),
    mkt_cupom VARCHAR(100),
constraint marketing_mkt_id_pk primary key (mkt_id)
);

-- 6. Dimensão Pagamentos
CREATE TABLE pagamentos (
    pag_id VARCHAR(50),
    pag_metodo VARCHAR(100),
    pag_status VARCHAR(100),
    pag_moeda VARCHAR(10),
constraint pagamentos_pag_id_pk primary key (pag_id)
);

-- 7. Fato Pedidos
CREATE TABLE pedidos (
    ped_id VARCHAR(50),
    cli_id VARCHAR(50),
    log_id VARCHAR(50),
    mkt_id VARCHAR(50),
    pag_id VARCHAR(50),
    ped_data DATE,
    ped_tempo TIME,
    ped_status VARCHAR(50),
    ped_dias_entrega INT,
    ped_dias_estimados_entrega INT,
    ped_status_entrega VARCHAR(50),
    ped_status_retorno VARCHAR(50),
    ped_motivo_retorno VARCHAR(255),
    ped_avaliacao DECIMAL(3,2),
    ped_sentimento VARCHAR(50),
    ped_avaliacao_cliente TEXT,
    ped_pts_fidelidade_ganhos INT,
    ped_pts_fidelidade_resgatados INT,
constraint pedidos_ped_id_pk primary key (ped_id),
constraint pedidos_cli_id_fk foreign key (cli_id) references clientes(cli_id),
constraint pedidos_log_id_fk foreign key (log_id) references logistica(log_id),
constraint pedidos_mkt_id_fk foreign key (mkt_id) references marketing(mkt_id),
constraint pedidos_pag_id_fk foreign key (pag_id) references pagamentos(pag_id)
);

-- 8. Fato Itens Pedidos
CREATE TABLE itens_pedidos (
    ite_id VARCHAR(50),
    ped_id VARCHAR(50),
    pro_id VARCHAR(50),
    ite_quantidade INT,
    ite_preco_unitario DECIMAL(10,2),
    ite_porcent_desconto DECIMAL(5,2),
    ite_valor_desconto DECIMAL(10,2),
    ite_vendas_brutas DECIMAL(10,2),
    ite_taxa_imposto DECIMAL(10,2),
    ite_custo_envio DECIMAL(10,2),
    ite_vendas_liquidas DECIMAL(10,2),
    ite_custo_produto DECIMAL(10,2),
    ite_lucro DECIMAL(10,2),
constraint itens_pedidos_ite_id_pk primary key (ite_id),
constraint itens_pedidos_ped_id_fk foreign key (ped_id) references pedidos(ped_id),
constraint itens_pedidos_pro_id_fk foreign key (pro_id) references produtos(pro_id)
);