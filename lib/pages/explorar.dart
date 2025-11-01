import 'package:flutter/material.dart';
import 'package:app_pii/components/barra_lateral.dart';
import 'package:app_pii/components/botao_grupo_tecido.dart';

class PaginaExplorar extends StatelessWidget {
	const PaginaExplorar({super.key});

	@override
	Widget build(BuildContext context) {
		return LayoutBuilder(
			builder: (context, constraints) {
				const double breakpoint = 900;
				final isNarrow = constraints.maxWidth < breakpoint;

				return Scaffold(
					backgroundColor: const Color(0xFF4B5190),
					drawer: isNarrow ? const SidebarDrawer() : null,
					appBar: isNarrow
							? AppBar(
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
								)
							: null,

								body: Row(
									children: [
										if (!isNarrow) const Sidebar(),

                    Expanded(
                      child: Column(
                        children: [
                          
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: SearchBar(
                              trailing: [
                                IconButton(
                                  icon: const Icon(Icons.search, color: Color(0xFF38853A)),
                                  onPressed: () {
                                    //TODO: lógica de buscar itens (NESTE CASO PRECISA PEGAR O TEXTO DA SEARCHBAR)
                                  },
                                ),
                              ],
                              hintText:"Procure o tecido aqui!",
                              backgroundColor: WidgetStateProperty.all(Colors.grey[200]),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                              ),
                              onSubmitted: (query) {
                                //TODO: lógica de buscar itens
                              }
                            ),
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: GridView.count(
                                mainAxisSpacing: 20.0,
                                crossAxisSpacing: 20.0,
                                crossAxisCount: isNarrow ? 2 : 5,
                                children: [
                                  BotaoGrupoTecido(
                                    nomeGrupo: 'Grupo de Tecido X',
                                    onTap: () {
                                      // TODO: abrir tela referente ao grupo de tecido
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
								),
				);
			},
		);
	}
}