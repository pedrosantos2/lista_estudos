import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';

void main() async {
  // Inicializa o Firebase ao iniciar o aplicativo
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Estudos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Define a cor de fundo do aplicativo
        scaffoldBackgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBarTheme: AppBarTheme(
          color: Color.fromRGBO(34, 40, 49, 1), // Cor da AppBar
          iconTheme: IconThemeData(
            color: Color.fromRGBO(0, 173, 181, 1) // Cor dos ícones
          ),
          titleTextStyle: TextStyle(
            color: Color.fromRGBO(238, 238, 238, 1),
            fontSize: 20, // Estilo do texto da AppBar
            ),
          ),
        // Estilização dos botões elevados (ElevatedButton)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Color.fromRGBO(0, 173, 181, 1),
            foregroundColor: Color.fromRGBO(238, 238, 238, 1)
          )
        )
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), // Define a tela inicial
    );
  }
}