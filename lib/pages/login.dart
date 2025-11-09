import 'package:flutter/material.dart';
import 'package:app_pii/components/barra_lateral.dart';
import 'package:app_pii/services/auth.dart';

class PaginaLogin extends StatefulWidget {
	const PaginaLogin({super.key});

	@override
	State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
	final TextEditingController usuarioController = TextEditingController();
	final TextEditingController senhaController = TextEditingController();

	void _mostrarModalResetSenha(BuildContext context) {
		showDialog(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					backgroundColor: const Color(0xFF2FA14A),
					shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
					title: const Text(
						'Redefinir Senha',
						style: TextStyle(
							color: Colors.white,
							fontSize: 24,
							fontWeight: FontWeight.w600,
						),
					),
					content: Column(
						mainAxisSize: MainAxisSize.min,
						children: [
							const Text(
								'Digite seu e-mail para receber o link de redefinição de senha:',
								style: TextStyle(color: Colors.white),
							),
							const SizedBox(height: 16),
							TextField(
								decoration: InputDecoration(
									hintText: 'Email',
									hintStyle: const TextStyle(color: Color(0xFF2FA14A)),
									filled: true,
									fillColor: Colors.white,
									contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
									border: OutlineInputBorder(
										borderRadius: BorderRadius.circular(8),
										borderSide: BorderSide.none,
									),
									suffixIcon: const Icon(Icons.email_outlined, color: Color(0xFF2FA14A)),
								),
								style: const TextStyle(color: Color(0xFF2FA14A)),
							),
						],
					),
					actions: [
						TextButton(
							onPressed: () => Navigator.of(context).pop(),
							child: const Text(
								'Cancelar',
								style: TextStyle(color: Colors.white70),
							),
						),
						ElevatedButton(
							onPressed: () {
								Navigator.of(context).pop();
							},
							style: ElevatedButton.styleFrom(
								backgroundColor: Colors.white,
								shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
							),
							child: const Text(
								'Enviar',
								style: TextStyle(color: Color(0xFF2FA14A)),
							),
						),
					],
				);
			},
		);
	}

	@override
	void dispose() {
		usuarioController.dispose();
		senhaController.dispose();
		super.dispose();
	}

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
											child: Center(
												child: ConstrainedBox(
													constraints: const BoxConstraints(maxWidth: 720),
													child: Container(
														margin: const EdgeInsets.symmetric(horizontal: 24),
														padding: const EdgeInsets.all(28),
														decoration: BoxDecoration(
															color: const Color(0xFF2FA14A),
															borderRadius: BorderRadius.circular(16),
														),
														child: Column(
															mainAxisSize: MainAxisSize.min,
															crossAxisAlignment: CrossAxisAlignment.stretch,
															children: [
																const SizedBox(height: 8),
																const Center(
																	child: Text(
																		'Login para Editores',
																		style: TextStyle(
																			color: Colors.white,
																			fontSize: 38,
																			fontWeight: FontWeight.w600,
																		),
																	),
																),
																const SizedBox(height: 28),

																// Campo usuário
																TextField(
																	controller: usuarioController,
																	decoration: InputDecoration(
																		hintText: 'Usuario:',
																		filled: true,
																		fillColor: const Color(0xFFF0F0F0),
																		contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
																		border: OutlineInputBorder(
																			borderRadius: BorderRadius.circular(8),
																			borderSide: BorderSide.none,
																		),
																		suffixIcon: const Icon(Icons.person_outline, color: Color(0xFF2FA14A)),
																	),
																	style: const TextStyle(color: Color(0xFF2FA14A), fontSize: 18),
																),
																const SizedBox(height: 26),

																// Campo senha
																TextField(
																	controller: senhaController,
																	obscureText: true,
																	decoration: InputDecoration(
																		hintText: 'Senha:',
																		filled: true,
																		fillColor: const Color(0xFFF0F0F0),
																		contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
																		border: OutlineInputBorder(
																			borderRadius: BorderRadius.circular(8),
																			borderSide: BorderSide.none,
																		),
																		suffixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2FA14A)),
																	),
																	style: const TextStyle(color: Color(0xFF2FA14A), fontSize: 18),
																),
																const SizedBox(height: 26),

																// Botão entrar
																SizedBox(
																	width: 160,
																	child: ElevatedButton(
																		onPressed: () async {
																		final usuario = usuarioController.text.trim();
																		final senha = senhaController.text.trim();
																		final ok = await Auth.login(usuario, senha);
																		if (ok) {
																			Navigator.pushNamed(context, '/editar');
																		} else {
																			ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário/senha inválidos')));
																		}
																	},
																	style: ElevatedButton.styleFrom(
																		backgroundColor: Colors.white,
																		shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
																		padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
																		elevation: 2,
																	),
																	child: const Text(
																		'entrar',
																		style: TextStyle(color: Color(0xFF2FA14A), fontSize: 28, fontWeight: FontWeight.w500),
																		),
																	),
																),

																const SizedBox(height: 14),
																TextButton(
																	onPressed: () => _mostrarModalResetSenha(context),
																	child: const Text(
																		'Esqueci a senha',
																		style: TextStyle(color: Colors.white70, fontSize: 14),
																	),
																),
																const SizedBox(height: 8),
															],
														),
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