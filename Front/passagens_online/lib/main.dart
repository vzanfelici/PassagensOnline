import 'package:flutter/material.dart';
import 'package:passagens_online/models/passagem.dart';
import 'package:passagens_online/screens/buscar_passagens_screen.dart';
import 'package:passagens_online/screens/detalhes_passagem_screen.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'models/auth_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Passagens de Ônibus',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => AppSwitcher(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/buscar_passagens': (context) => BuscarPassagensScreen(),
          '/detalhes': (context) => DetalhesPassagemScreen(
              passagem: ModalRoute.of(context)!.settings.arguments as Passagem),
        },
      ),
    );
  }
}

class AppSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context);
    return auth.isAuthenticated ? HomeScreen() : LoginScreen();
  }
}
