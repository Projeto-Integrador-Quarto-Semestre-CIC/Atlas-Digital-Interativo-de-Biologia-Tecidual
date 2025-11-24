import 'package:flutter/material.dart';
import '../components/barra_lateral.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool telaGrande = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: const Color(0xFF4B5190),
      appBar: telaGrande
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              toolbarHeight: 120,
              leading: Builder(
                builder: (context) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        borderRadius: BorderRadius.circular(10),
                        splashColor: Colors.white24,
                        child: Container(
                          width: 48,
                          height: 48,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF38853A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.menu, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
              title: const Center(child: BotaoHome(sidebar: false)),
              centerTitle: true,
            ),
      drawer: telaGrande ? null : const SidebarDrawer(),
      body: Row(
        children: [
          if (telaGrande) const Sidebar(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ------------------ VISÃO GERAL --------------------
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'VISÃO GERAL SOBRE O APP',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Text(
                            '''
O App é uma plataforma moderna desenvolvida para apoiar o estudo, a pesquisa e o ensino da citologia — uma área essencial da biologia celular e das ciências biomédicas. O aplicativo foi projetado para oferecer uma experiência rica, intuitiva e altamente visual, reunindo imagens de alta qualidade, descrições detalhadas e conteúdos educacionais interativos.

Este atlas digital funciona como um guia de referência completo, permitindo que estudantes, professores e profissionais explorem estruturas celulares com clareza, organização e contextualização científica. Todas as informações são apresentadas de forma didática, com foco na compreensão morfológica, funcional e diagnóstica das células.

🔍 Objetivos do Aplicativo
- Facilitar a aprendizagem da citologia por meio de recursos digitais intuitivos.  
- Substituir e complementar materiais impressos tradicionais.  
- Fornecer imagens ampliáveis com alta resolução.  
- Apoiar o ensino acadêmico com conteúdos confiáveis e atualizados.  
- Servir como ferramenta de consulta para profissionais da saúde.

📚 Conteúdos Disponíveis
O aplicativo reúne:
- Descrições detalhadas de componentes celulares.  
- Explicações sobre organização estrutural e função.  
- Comparações morfológicas entre diferentes tipos celulares.  
- Sessões explicativas sobre técnicas citológicas.  
- Imagens ampliáveis com marcadores e legendas.  

🧭 Navegação Intuitiva
A interface foi construída para ser simples e eficiente. As seções são organizadas de forma lógica, permitindo que o usuário explore o conteúdo de maneira fluida, seja para estudo rápido ou pesquisa aprofundada.

O objetivo principal é fornecer um ambiente digital acessível, claro e completo, tornando o aprendizado mais eficiente e visualmente rico.
''',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ------------------ CITOLOGIA --------------------
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'CITOLOGIA',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Text(
                            '''
A citologia é o ramo da biologia responsável pelo estudo das células — suas estruturas, funções, características morfológicas e comportamento em diferentes ambientes. Como unidade fundamental da vida, a célula desempenha funções vitais que sustentam todos os organismos, desde os mais simples até os mais complexos.

O estudo citológico é essencial para diversas áreas, incluindo biomedicina, enfermagem, biologia, farmácia e medicina, sendo a base para compreender processos fisiológicos, patológicos e diagnósticos.

🧬 O que a Citologia Estuda?
A citologia engloba a análise de:
- Morfologia celular  
- Organelas e suas funções  
- Ciclo celular e divisão  
- Processos metabólicos essenciais  
- Interações celulares  
- Técnicas de coloração e observação microscópica  

🔬 Importância da Citologia
A citologia tem grande relevância científica e médica, pois:
- Auxilia no diagnóstico de doenças, incluindo câncer.  
- Permite identificar alterações morfológicas patológicas.  
- Fornece base para estudos de genética, bioquímica e fisiologia.  
- Ajuda a compreender como tecidos e órgãos são formados.  

🧪 Técnicas Utilizadas
O aplicativo também aborda conteúdos explicativos sobre métodos citológicos, como:
- Colorações clássicas (H&E, Papanicolau, Giemsa, entre outras).  
- Preparação de lâminas.  
- Microscopia óptica e digital.  
- Técnicas modernas de análise celular.  

🧠 Para Quem é Este Atlas?
Este atlas digital é ideal para:
- Estudantes de cursos da área da saúde.  
- Professores que buscam recursos visuais para aulas.  
- Profissionais que necessitam revisar conceitos celulares.  
- Pesquisadores que precisam de referência rápida e acessível.  

A citologia é uma ciência visual, e um atlas digital facilita imensamente a observação, o estudo detalhado e a comparação entre diferentes tipos celulares — o que torna o aprendizado mais dinâmico, claro e eficiente.
''',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}