# pip install matplotlib

import matplotlib.pyplot as plt # biblioteca de visualização de dados

def atendimentos_por_dia(lista_datas):
    atendimentos_por_dia = {} # mesma lógica do problema 9
    for data in lista_datas:
        atendimentos_por_dia[data] = atendimentos_por_dia.get(data, 0) + 1

    # separa as datas e as quantidades
    datas = list(atendimentos_por_dia.keys())
    quantidades = list(atendimentos_por_dia.values())

    # criação do gráfico de barras
    plt.figure(figsize=(10, 6)) # cria uma figura de 10 de largura e 6 de altura
    plt.bar(datas, quantidades) # datas coordenadas x, quantidades coordenadas y; cor azul
    plt.xlabel('Data') # label eixo x
    plt.ylabel('Quantidade de Atendimentos') # label eixo y
    plt.title('Quantidade de Atendimentos Médicos por Dia') # título do gráfico
    plt.tight_layout() # ajuste automático do layout para evitar sobreposição de elementos

    plt.show() # exibir gráfico

# exemplos de visualizações para diferentes entradas
exemplo1 = ['2023-07-01', '2023-07-02', '2023-07-03', '2023-07-02', '2023-07-03', '2023-07-03']
atendimentos_por_dia(exemplo1)

exemplo2 = ['2023-07-01', '2023-07-02', '2023-07-03', '2023-07-04', '2023-07-05', '2023-07-06']
atendimentos_por_dia(exemplo2)
