import 'package:flutter/material.dart';

class _ConteudoBarra extends StatelessWidget {
  const _ConteudoBarra();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: () { print("HOME CLICADO!"); }, // TODO: código que leva pra HOME
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size.fromHeight(130),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 130
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white, width: 2))),
            child: TextButton.icon(
                onPressed: () {print("LOGIN CLICADO!");}, // TODO: código que leva pra LOGIN
                icon: const Icon(Icons.person, size: 30, color: Colors.white),
                label: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("LOGIN PARA EDITORES"),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  alignment: Alignment.centerLeft,
                )),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white, width: 2))),
            child: TextButton.icon(
                onPressed: () {print("EXPLORAR CLICADO!");}, // TODO: código que leva pra EXPLORAR
                icon: const Icon(Icons.search, size: 30, color: Colors.white),
                label: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("EXPLORAR"),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  alignment: Alignment.centerLeft,
                )),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white, width: 2))),
            child: TextButton.icon(
                onPressed: () {print("CONTATO CLICADO!");}, // TODO: código que leva pra EXPLORAR
                icon: const Icon(Icons.phone, size: 30, color: Colors.white),
                label: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("CONTATO"),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  alignment: Alignment.centerLeft,
                )),
          ),
        ],
      ),
    );
  }
}

class BarraLateral extends StatelessWidget {
  const BarraLateral({super.key, this.width = 280});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: const Color(0xFF38853A),
      child: const _ConteudoBarra(),
    );
  }
}

class BarraLateralDrawer extends StatelessWidget {
  const BarraLateralDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: const Color(0xFF38853A),
      child: const _ConteudoBarra(),
    );
  }
}