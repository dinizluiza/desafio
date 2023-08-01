# pip install pyodbc

import pyodbc
import csv

dados_conexao = (
    "Driver={SQL Server};" # Driver do SQL Server
    "Server=DESKTOP-SQ7EGS1;" # vai no cmd e digita 'hostname', o que aparecer é o nome do servidor. substituir pelo meu.
    "Database=hospital_staging;"
)

conexao = pyodbc.connect(dados_conexao)
print("Conexão realizada com sucesso!")
cursor = conexao.cursor()

nome_arquivo_csv = "caminho/do/arquivo.csv"  # substituir pelo caminho do arquivo
with open(nome_arquivo_csv, newline="", encoding="utf-8") as arquivo_csv:
    leitor_csv = csv.reader(arquivo_csv)
    colunas = next(leitor_csv)  # lê a primeira linha com os nomes das colunas pra definir os atributos

comando_criacao_tabela = f"CREATE TABLE stg_prontuario.procedimentos_medicos ("

for coluna in colunas:
    comando_criacao_tabela += f"{coluna} VARCHAR(100), " # adicionando atributos
comando_criacao_tabela = comando_criacao_tabela.rstrip(", ") + ");" # removendo a última vírgula e espaço; e adicionando ');' para finalizar a criação da tabela
cursor.execute(comando_criacao_tabela)
conexao.commit()

for linha in leitor_csv: # lê linha por linha para inserir os dados
    comando_insercao_dados = f"INSERT INTO stg_prontuario.procedimentos_medicos ({', '.join(colunas)}) VALUES (" # adicionando os atributos
    valores = [f"'{valor}'" for valor in linha]
    comando_insercao_dados += f"{', '.join(valores)});" # adiciona os valores
    cursor.execute(comando_insercao_dados)
    conexao.commit()

# EXEMPLO DE FORMATAÇÃO DA PLANILHA
# codigo_procedimento | descricao_procedimento | valor_procedimento
# 1010101             | Consulta Médica        | 100.00
# 2020202             | Cirurgia de Apendicite | 500.00
# 3030303             | Exame de Sangue        | 50.00
