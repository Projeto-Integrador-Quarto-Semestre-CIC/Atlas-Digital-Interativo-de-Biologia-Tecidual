# 📘 Atlas-Digital-Interativo-de-Biologia-Tecidual

O **Atlas Digital Interativo de Biologia Tecidual** é um projeto educacional desenvolvido em parceria com a [FMABC](https://fmabc.br),criado para modernizar e aprimorar o ensino de **citologia e histologia** por meio de ferramentas digitais interativas.
A plataforma simula a experiência de observação microscópica, permitindo que alunos e professores analisem **lâminas citológicas escaneadas em altíssima resolução** (até 1.000x) diretamente em dispositivos **web, desktop ou mobile**.
O objetivo é proporcionar uma experiência acessível, detalhada e imersiva para o estudo de estruturas celulares e teciduais.

## ⚙️ Tecnologias:
- [💠Dart](https://dart.dev)
- [⚡Flutter](https://flutter.dev/)
- [🗄️MongoDB](https://www.mongodb.com)

## 🔗Links Relevantes:
- [📑Documentação de Software](https://docs.google.com/document/d/12jgqb8pKn475Vp74UGVJTLTQkdztc-_gSYYaClPAaUg/edit?usp=sharing)
- [📐Figma do Projeto](https://www.figma.com/design/QzooF7FUx1jfdhk8uvHeYU/PII-4%C2%B0-SEMESTRE?node-id=0-1&t=RXlrq9XfUyZVfNbN-1)
- [🚀Trello](https://trello.com/invite/b/68c2b0929e17a82b58941e45/ATTI5a32262ef26d06e3b85262192e117b857C00F79A/pii-4-semestre)

## 👥Componentes do Grupo:
- [@FelipeDuarte1](https://github.com/FelipeDuarte1)
- [@LeonardoTBelo](https://github.com/LeonardoTBelo)
- [@Lucas-Bueno04](https://github.com/Lucas-Bueno04)
- [@MurilloGmbi14](https://github.com/MurilloGambi14)
- [@PabloHenrique70](https://github.com/Pablohenrique70)
- [@VPortoV](https://github.com/VPortoV)

# Configurando o ambiente:

Primeiro, certifique-se que você possui o [Flutter SDK](https://docs.flutter.dev/install) e o [Python](https://www.python.org/downloads/) instalados em sua máquina.

Instale via ``pip install`` as seguintes bibliotecas Python:
- ``openslide-python``
-  ``Pillow``

Depois, baixe e configure a biblioteca [OpenSlide](https://openslide.org/download/) de acordo com seu sistema operacional.

Por fim, abra um terminal no diretório do projeto e cole o seguinte código:
```powershell
flutter pub get
```
Isso fará o flutter baixar todas as dependências do projeto.

# Rodando o aplicativo:

Abra um terminal no diretório do projeto e cole o seguinte código:
```powershell
dart run bin/server.dart
```
Isso fará com que o servidor back-end inicie. **Certifique-se de não fechar o terminal enquanto a aplicação estiver rodando.**

Depois, abra outro terminal no diretório do projeto e cole o seguinte código:
```
flutter run
```
Isso faz com que o aplicativo seja iniciado. Caso esteja tudo certo, você verá uma mensagem assim:


![A imagem consiste de um print do terminal contendo três opções: 1-Windows, 2-Chrome e 3-Edge.](https://github.com/Projeto-Integrador-Quarto-Semestre-CIC/imagens_readme/blob/923f076a5a4369d2970afa5c23a631b7d379a7e6/print_terminal.png)

Estes são dispositivos nos quais podemos rodar nosso aplicativo. Para selecionar o dispositivo desejado, basta digitar o número referente à opção no terminal.

Normalmente, você já conseguirá testar o aplicativo via **[2] Chrome** ou **[3] Edge**. Nós recomendamos testar via **[1] Windows**, porém para isso são necessários alguns passos extras, que podem ser encontrados [clicando aqui](https://docs.flutter.dev/platform-integration/windows/setup).