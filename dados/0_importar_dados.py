import os
import pandas as pd
from sqlalchemy import create_engine

#1. Configuração da conexão com o MySQL
USUARIO = 'root'
SENHA = 'admin123'
HOST = 'localhost'
PORTA = '3306'
BANCO = 'ecommerce_analytics'

#String de conexão SQLAlchemy
conexao_url = f"mysql+pymysql://{USUARIO}:{SENHA}@{HOST}:{PORTA}/{BANCO}"
engine = create_engine(conexao_url)

#Pasta onde o script e os CSVs estão salvos
pasta_atual = os.path.dirname(os.path.abspath(__file__))

# 2. Mapeamento dos arquivos CSV para as tabelas do MySQL
tabelas_csv = [
    ('produtos.csv', 'produtos'),
    ('clientes.csv', 'clientes'),
    ('enderecos.csv', 'enderecos'),
    ('logistica.csv', 'logistica'),
    ('marketing.csv', 'marketing'),
    ('pagamentos.csv', 'pagamentos'),
    ('pedidos.csv', 'pedidos'),
    ('itens_pedidos.csv', 'itens_pedidos')
]

# 3. Processo de Carga (INSERT)
print("Iniciando a importação dos dados para o MySQL...\n")

for arquivo_csv, tabela in tabelas_csv:
    caminho_csv = os.path.join(pasta_atual, arquivo_csv)
    
    if os.path.exists(caminho_csv):
        print(f"Importando {arquivo_csv} para a tabela '{tabela}'...")
        df = pd.read_csv(caminho_csv)
        
        # Insere os dados na tabela já existente no MySQL
        df.to_sql(
            name=tabela,
            con=engine,
            if_exists='append',
            index=False
        )
        print(f" Registros inseridos com sucesso na tabela '{tabela}'.\n")
    else:
        print(f" Arquivo {arquivo_csv} não foi encontrado na pasta.\n")

print("Importação concluída com sucesso! Seu banco de dados está pronto para as queries.")