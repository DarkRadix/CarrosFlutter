class NovoEstoque {
  final String? id;
  final String carro;
  final String modelo;
  final int ano;
  final String placa;
  final String cor;
  final bool revisado;

  NovoEstoque({
    this.id,
    required this.carro,
    required this.modelo,
    required this.ano,
    required this.placa,
    required this.cor,
    required this.revisado,
  });

  factory NovoEstoque.fromJson(Map<String, dynamic> json) {
    return NovoEstoque(
      id: json['id'],
      carro: json['Carro'] ?? '',
      modelo: json['Modelo'] ?? '',
      ano: int.tryParse(json['Ano'].toString()) ?? 0,
      placa: json['placa'] ?? '',
      cor: json['cor'] ?? '',
      revisado: json['Revisado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Carro': carro,
      'Modelo': modelo,
      'Ano': ano,
      'placa': placa,
      'cor': cor,
      'Revisado': revisado,
    };
  }
}
