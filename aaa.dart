import 'package:flutter/material.dart';

void main() => runApp(SemestreApp());

class SemestreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Historial Académico',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int semestreSeleccionado = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Encabezado y botones
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE1CCF9), Color(0xFFB9B3F1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Selecciona el semestre  $semestreSeleccionado',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: List.generate(9, (index) {
                    int num = index + 1;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          semestreSeleccionado = num;
                        });
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$num',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // Imagen gráfica debajo de botones
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Image.asset(
              'build/flutter_assets/images/datos.png',
              height: 200,
              fit: BoxFit.contain,
            ),
          ),

          // Texto resumen
          Container(
            width: double.infinity,
            color: Color(0xFFB4C8F3),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                'Resumen de los parciales',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
