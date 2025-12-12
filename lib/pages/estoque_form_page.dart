import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/estoque_model.dart';

class EstoqueFormPage extends StatefulWidget {
  final NovoEstoque? estoqueExistente;

  const EstoqueFormPage({super.key, this.estoqueExistente});

  @override
  State<EstoqueFormPage> createState() => _EstoqueFormPageState();
}

class _EstoqueFormPageState extends State<EstoqueFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _carro = TextEditingController();
  final _modelo = TextEditingController();
  final _ano = TextEditingController();
  final _placa = TextEditingController();
  final _cor = TextEditingController();
  bool _revisado = false;

  final String apiUrl =
      "https://6912663b52a60f10c8218a09.mockapi.io/API/V1/tarefa";

  @override
  void initState() {
    super.initState();

    if (widget.estoqueExistente != null) {
      final e = widget.estoqueExistente!;
      _carro.text = e.carro;
      _modelo.text = e.modelo;
      _ano.text = e.ano.toString();
      _placa.text = e.placa;
      _cor.text = e.cor;
      _revisado = e.revisado;
    }
  }

  Future<void> salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final dados = NovoEstoque(
      id: widget.estoqueExistente?.id,
      carro: _carro.text,
      modelo: _modelo.text,
      ano: int.parse(_ano.text),
      placa: _placa.text,
      cor: _cor.text,
      revisado: _revisado,
    ).toJson();

    // EDITAR
    if (widget.estoqueExistente != null) {
      await http.put(
        Uri.parse("$apiUrl/${widget.estoqueExistente!.id}"),
        body: json.encode(dados),
        headers: {"Content-Type": "application/json"},
      );
    }
    // CRIAR
    else {
      await http.post(
        Uri.parse(apiUrl),
        body: json.encode(dados),
        headers: {"Content-Type": "application/json"},
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.estoqueExistente == null ? "Novo Veículo" : "Editar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _carro,
                decoration: const InputDecoration(labelText: "Carro"),
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              TextFormField(
                controller: _modelo,
                decoration: const InputDecoration(labelText: "Modelo"),
              ),
              TextFormField(
                controller: _ano,
                decoration: const InputDecoration(labelText: "Ano"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _placa,
                decoration: const InputDecoration(labelText: "Placa"),
              ),
              TextFormField(
                controller: _cor,
                decoration: const InputDecoration(labelText: "Cor"),
              ),
              SwitchListTile(
                title: const Text("Revisado"),
                value: _revisado,
                onChanged: (v) => setState(() => _revisado = v),
              ),
              ElevatedButton(
                onPressed: salvar,
                child: const Text("Salvar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
