# language: pt
Funcionalidade: Recuperação de senha
  Como usuário esquecido
  Quero solicitar a redefinição de senha
  Para recuperar o acesso ao sistema

  Cenário: Abrir modal de esqueci a senha
    Dado que estou na tela de login
    Quando clico no link "Esqueci a senha"
    Então um modal de redefinição de senha deve ser exibido
    E o modal deve conter um campo para digitar o e-mail
    E o modal deve conter os botões "Cancelar" e "Enviar"

  Cenário: Solicitar redefinição de senha
    Dado que o modal de redefinição de senha está aberto
    E eu preenchi o campo de e-mail com "usuario@teste.com"
    Quando clico no botão "Enviar"
    Então o sistema deve registrar a solicitação de redefinição de senha
    E o modal deve ser fechado
    E devo ver uma mensagem informando que um link de redefinição foi enviado
