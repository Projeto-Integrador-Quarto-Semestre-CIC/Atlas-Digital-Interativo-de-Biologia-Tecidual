# language: pt
Funcionalidade: Navegação com barra lateral

  Cenário: Mostrar barra lateral na navegação
    Quando o usuário navega pelas telas do aplicativo
    Então a barra lateral deve estar visível
    E quando uma imagem estiver em tela cheia
    Então a barra lateral deve estar oculta

  Cenário: Abrir e fechar barra lateral no mobile
    Quando o aplicativo é usado em um dispositivo móvel
    Então a barra lateral deve estar oculta por padrão
    E o usuário deve poder abrir ou fechar pelo botão hambúrguer

  Cenário: Acessar outra área do app pela barra lateral
    Quando o usuário seleciona uma opção na barra lateral
    Então o aplicativo deve exibir a tela correspondente


