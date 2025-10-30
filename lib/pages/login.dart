import 'package:flutter/material.dart';
import 'package:app_pii/components/barra_lateral.dart';

class TelaLogin extends StatelessWidget {
	const TelaLogin({super.key});

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
																color: Colors.green,
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
								child: Center(
									child: Container(
										padding: const EdgeInsets.all(20),
										constraints: const BoxConstraints(maxWidth: 400),
										child: Column(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												Card(
													child: Padding(
														padding: const EdgeInsets.all(16),
														child: Column(
															children: [
																TextField(
																	decoration: InputDecoration(
																		labelText: 'Email',
																		border: OutlineInputBorder(),
																		prefixIcon: const Icon(Icons.email),
																	),
																),
																const SizedBox(height: 16),
																TextField(
																	obscureText: true,
																	decoration: InputDecoration(
																		labelText: 'Senha',
																		border: OutlineInputBorder(),
																		prefixIcon: const Icon(Icons.lock),
																	),
																),
																const SizedBox(height: 24),
																ElevatedButton(
																	onPressed: () {
																		// TODO: lógica de login
																	},
																	style: ElevatedButton.styleFrom(
																		backgroundColor: const Color(0xFF38853A),
																		padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
																	),
																	child: const Text(
																		'Entrar',
																		style: TextStyle(fontSize: 16, color: Colors.white),
																	),
																),
															],
														),
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
			},
		);
	}
}