import 'package:flutter/material.dart';
import '../models/passagem.dart';

class DetalhesPassagemScreen extends StatelessWidget {
  final Passagem passagem;

  DetalhesPassagemScreen({required this.passagem});

  void _comprarPassagem(BuildContext context) {
    // Aqui você pode implementar a lógica de compra.
    // Por enquanto, apenas exibimos uma mensagem de sucesso.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Passagem comprada com sucesso!')),
    );

    // Navega de volta para a tela anterior após a compra
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Passagem'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${passagem.origem} - ${passagem.destino}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Data de Partida: ${passagem.dataPartida}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Preço: R\$${passagem.preco}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _comprarPassagem(context),
              child: Text('Comprar'),
            ),
          ],
        ),
      ),
    );
  }
}
