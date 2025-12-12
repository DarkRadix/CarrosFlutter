import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/estoque_model.dart';
import 'estoque_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiUrl = "https://6912663b52a60f10c8218a09.mockapi.io/API/V1/tarefa";
  List<NovoEstoque> lista = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final resposta = await http.get(Uri.parse(apiUrl));

    if (resposta.statusCode == 200) {
      final List dados = json.decode(resposta.body);

      setState(() {
        lista = dados.map((e) => NovoEstoque.fromJson(e)).toList();
      });
    }
  }

  Future<void> deletar(String id) async {
    await http.delete(Uri.parse("$apiUrl/$id"));
    carregarDados();
  }

  // -----------------------------------------
  // NOVO: Confirmação antes de excluir
  // -----------------------------------------
  Future<void> confirmarExclusao(String id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar exclusão"),
        content: const Text("Deseja realmente excluir este item?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir"),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      deletar(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carros"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EstoqueFormPage(),
            ),
          );
          carregarDados();
        },
      ),
      body: ListView.builder(
        itemCount: lista.length,
        itemBuilder: (context, index) {
          final item = lista[index];

          return ListTile(
            title: Text("${item.carro} - ${item.modelo}"),
            subtitle: Text("Placa: ${item.placa}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => confirmarExclusao(item.id!), // <---- ALTERADO
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EstoqueFormPage(
                    estoqueExistente: item,
                  ),
                ),
              );
              carregarDados();
            },
          );
        },
      ),
    );
  }
}
