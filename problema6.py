import pyodbc
import requests

dados_conexao = (
    "Driver={SQL Server};"
    "Server=DESKTOP-SQ7EGS1;"
    "Database=hospital_staging;"
)

conexao = pyodbc.connect(dados_conexao)
print("Conexão realizada com sucesso!")
cursor = conexao.cursor()

url_api = "http://exemplo.com/api/procedimentos" # URL da API REST que retorna os procedimentos médicos em formato JSON

response = requests.get(url_api) # solicitação HTTP pra API

if response.status_code == 200: # checa  se a solicitação foi bem sucedida (código 200)
    procedimentos_medicos = response.json()  # converte resposta JSON -> lista de dicionários

    comando_criacao_tabela = f"CREATE TABLE stg_prontuario.procedimentos_medicos (" 
    colunas = list(procedimentos_medicos[0].keys())  # as chaves do primeiro dicionário são as colunas
    for coluna in colunas:
        comando_criacao_tabela += f"{coluna} VARCHAR(100), "  # adicionando atributos
    comando_criacao_tabela = comando_criacao_tabela.rstrip(", ") + ");" # removendo a última vírgula e espaço; e adicionando ');' para finalizar a criação da tabela
    cursor.execute(comando_criacao_tabela)
    conexao.commit()

    for procedimento in procedimentos_medicos: # inserir linha por linha na tabela
        comando_insercao_dados = f"INSERT INTO stg_prontuario.procedimentos_medicos ({', '.join(colunas)}) VALUES (" # adicionando os atributos
        valores = [f"'{valor}'" for valor in procedimento.values()]
        comando_insercao_dados += f"{', '.join(valores)});" # adiciona os valores
        cursor.execute(comando_insercao_dados)
        conexao.commit()

    print("Dados carregados com sucesso!")
else:
    print(f"Erro ao acessar a API: Código {response.status_code}")

# EXEMPLO DE FORMATAÇÃO DO ARQUIVO JSON
# [
#   {
#     "codigo_procedimento": "1010101",
#     "descricao_procedimento": "Consulta Médica",
#     "valor_procedimento": "100.00"
#   },
#   {
#     "codigo_procedimento": "2020202",
#     "descricao_procedimento": "Cirurgia de Apendicite",
#     "valor_procedimento": "500.00"
#   },
#   {
#     "codigo_procedimento": "3030303",
#     "descricao_procedimento": "Exame de Sangue",
#     "valor_procedimento": "50.00"
#   }
# ]
