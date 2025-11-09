# language: pt
Funcionalidade: Login de editores
  Como usuário editor
  Quero acessar o sistema com usuário e senha
  Para poder editar os conteúdos

  Cenário: Login como administrador com credenciais válidas
    Dado que existe um administrador cadastrado com nome "admin" e senha "admin123"
    E estou na tela de login
    Quando eu preencho o campo "Usuário" com "admin"
    E preencho o campo "Senha" com "admin123"
    E clico no botão "entrar"
    Então devo ser redirecionado para a página de edição
    E devo visualizar as opções "Gerenciar Tecidos" e "Gerenciar Professores"

  Cenário: Login como professor com credenciais válidas
    Dado que existe um professor cadastrado com nome "duarte" e senha "duarte123"
    E estou na tela de login
    Quando eu preencho o campo "Usuário" com "duarte"
    E preencho o campo "Senha" com "duarte123"
    E clico no botão "entrar"
    Então devo ser redirecionado para a página de edição
    E devo visualizar apenas a opção "Gerenciar Tecidos"
    E não devo visualizar a opção "Gerenciar Professores"

  Cenário: Login com credenciais inválidas
    Dado que estou na tela de login
    Quando eu preencho o campo "Usuário" com "invalido"
    E preencho o campo "Senha" com "senhaerrada"
    E clico no botão "entrar"
    Então devo permanecer na tela de login
    E devo ver a mensagem "Usuário ou senha inválidos."
