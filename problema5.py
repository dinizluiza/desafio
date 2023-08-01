# pip install pyodbc

import pyodbc

dados_conexao = (
    "Driver={SQL Server};" # Driver do SQL Server
    "Server=DESKTOP-SQ7EGS1;" # vai no cmd e digita 'hostname', o que aparecer é o nome do servidor. substituir pelo meu.
    "Database=hospital_staging;"
)

conexao = pyodbc.connect(dados_conexao)
print("Conexão realizada com sucesso!")

cursor = conexao.cursor()

comando = """comando sql"""

cursor.execute(comando)
cursor.commit() # só se for editar o BD