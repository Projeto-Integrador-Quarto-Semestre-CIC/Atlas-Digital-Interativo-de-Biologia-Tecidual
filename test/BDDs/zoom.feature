# language: pt
Funcionalidade: Zoom e navegação na imagem

  Cenário: Dar zoom até 1000x na imagem
    Dado que a imagem está exibida
    Quando o usuário aumenta o zoom
    Então a imagem deve ser ampliada em até 1000x
    
  Cenário: Diminuir o zoom da imagem
    Dado que a imagem está ampliada
    Quando o usuário reduz o zoom
    Então a imagem deve retornar a um nível menor ou ao original