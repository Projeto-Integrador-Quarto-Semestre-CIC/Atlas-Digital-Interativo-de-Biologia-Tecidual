# language: pt
Funcionalidade: Permissões de acesso de editores
  Como administrador ou professor
  Quero ter permissões adequadas ao meu papel
  Para gerenciar apenas o que me é permitido

  Cenário: Administrador pode gerenciar tecidos e professores
    Dado que estou autenticado como administrador
    Quando acesso a página de edição
    Então devo visualizar a opção "Gerenciar Tecidos"
    E devo visualizar a opção "Gerenciar Professores"

  Cenário: Professor pode gerenciar apenas tecidos
    Dado que estou autenticado como professor
    Quando acesso a página de edição
    Então devo visualizar a opção "Gerenciar Tecidos"
    E não devo visualizar a opção "Gerenciar Professores"

  Cenário: Usuário não logado vê acesso restrito
    Dado que não estou autenticado
    Quando acesso diretamente a página de edição
    Então devo ver a mensagem "Acesso restrito"
    E devo ver um botão "Ir para Login"
