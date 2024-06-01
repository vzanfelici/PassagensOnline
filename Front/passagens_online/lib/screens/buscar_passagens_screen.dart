import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/passagem.dart';
import 'detalhes_passagem_screen.dart'; // Importe a nova tela

class BuscarPassagensScreen extends StatefulWidget {
  @override
  _BuscarPassagensScreenState createState() => _BuscarPassagensScreenState();
}

class _BuscarPassagensScreenState extends State<BuscarPassagensScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dataPartidaController = TextEditingController();
  List<Passagem> _passagens = [];
  List<String> _origens = [];
  List<String> _destinos = [];
  String? _origemSelecionada;
  String? _destinoSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarCidades();
  }

  void _carregarCidades() async {
    try {
      final origens = await ApiService().buscarOrigens();
      final destinos = await ApiService().buscarDestinos();
      setState(() {
        _origens = origens;
        _destinos = destinos;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar cidades: $e')),
      );
    }
  }

  Future<void> _selecionarData(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dataPartidaController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _buscarPassagens() async {
    try {
      final passagens = await ApiService().buscarPassagens(
        _origemSelecionada!,
        _destinoSelecionado!,
        _dataPartidaController.text,
      );
      setState(() {
        _passagens = passagens;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar passagens: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Passagens'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _origemSelecionada,
                decoration: InputDecoration(labelText: 'Origem'),
                items: _origens.map((String origem) {
                  return DropdownMenuItem<String>(
                    value: origem,
                    child: Text(origem),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _origemSelecionada = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione a origem';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _destinoSelecionado,
                decoration: InputDecoration(labelText: 'Destino'),
                items: _destinos.map((String destino) {
                  return DropdownMenuItem<String>(
                    value: destino,
                    child: Text(destino),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _destinoSelecionado = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione o destino';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dataPartidaController,
                decoration: InputDecoration(
                  labelText: 'Data de Partida',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selecionarData(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data de partida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    _buscarPassagens();
                  }
                },
                child: Text('Buscar'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _passagens.length,
                  itemBuilder: (context, index) {
                    final passagem = _passagens[index];
                    return ListTile(
                      title: Text('${passagem.origem} - ${passagem.destino}'),
                      subtitle: Text(
                          'Data: ${passagem.dataPartida}\nPreço: R\$${passagem.preco}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetalhesPassagemScreen(passagem: passagem),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
