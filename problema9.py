def verificar_prescricao(prescricao, estoque):
    prescricao_dict = {}
    estoque_dict = {}

    for medicamento in prescricao: # dicionário pra contar quantidade por medicamento
        prescricao_dict[medicamento] = prescricao_dict.get(medicamento, 0) + 1 # vê quantos já foram contados (se nenhum, então 0) e adiciona 1

    for medicamento in estoque: # mesma lógica mas agora para estoque
        estoque_dict[medicamento] = estoque_dict.get(medicamento, 0) + 1

    # checa se todos medicamentos prescritos estão no estoque e também se a quantidade é suficiente
    for medicamento, quantidade_prescrita in prescricao_dict.items():
        if medicamento not in estoque_dict or quantidade_prescrita > estoque_dict[medicamento]:
            return False

    return True

prescricao = input("Digite a prescrição: ")
estoque = input("Digite o estoque: ")
print(verificar_prescricao(prescricao, estoque))  
# Exemplos de uso:
# print(verificar_prescricao("a", "b"))     # Saída: False
# print(verificar_prescricao("aa", "b"))    # Saída: False
# print(verificar_prescricao("aa", "aab"))  # Saída: True
# print(verificar_prescricao("aba", "cbaa"))# Saída: True
# print(verificar_prescricao("abcdefffb", "fdbafecbf")) # Saída: True