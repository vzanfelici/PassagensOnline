import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthModel>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bem-vindo à sua página inicial!'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/buscar_passagens');
              },
              child: Text('Buscar Passagens'),
            ),
          ],
        ),
      ),
    );
  }
}
