class Passagem {
  final String id;
  final String origem;
  final String destino;
  final DateTime dataPartida;
  final DateTime dataChegada;
  final double preco;

  Passagem({
    required this.id,
    required this.origem,
    required this.destino,
    required this.dataPartida,
    required this.dataChegada,
    required this.preco,
  });

  factory Passagem.fromJson(Map<String, dynamic> json) {
    return Passagem(
      id: json['_id'],
      origem: json['origem'],
      destino: json['destino'],
      dataPartida: DateTime.parse(json['dataPartida']),
      dataChegada: DateTime.parse(json['dataChegada']),
      preco: json['preco'].toDouble(),
    );
  }
}
