# language: pt
Funcionalidade: Visualização das imagens microscópicas

  Cenário: Visualizar imagem digitalizada
    Quando o usuário acessa a tela de um tecido
    Então a imagem digitalizada deve ser exibida com qualidade

  Cenário: Mover a imagem para explorar
    Dado que a imagem está exibida
    Quando o usuário arrasta a imagem
    Então a imagem deve se mover conforme o gesto
