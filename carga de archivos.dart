import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MaterialApp(
    home: InscripcionScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class InscripcionScreen extends StatefulWidget {
  @override
  _InscripcionScreenState createState() => _InscripcionScreenState();
}

class _InscripcionScreenState extends State<InscripcionScreen> {
  String? archivoPago;
  String? archivoBoleta;
  String? archivoSolicitud;

  Future<void> seleccionarArchivo(Function(String) onFileSelected) async {
    final resultado = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (resultado != null && resultado.files.single.size <= 1000000) {
      onFileSelected(resultado.files.single.name);
    } else if (resultado != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El archivo debe ser menor a 1000 KB')),
      );
    }
  }

  Widget buildItem(String titulo, String? archivoNombre, Function(String) onFileSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ElevatedButton(
            onPressed: () => seleccionarArchivo(onFileSelected),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade600,
              foregroundColor: Colors.white,
            ),
            child: Text(archivoNombre ?? "Adjuntar archivo\n(1000 KB)", textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD6B4E7), Color(0xFF9BD1F1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Configuración\nde inscripción",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            buildItem("Comprobante de pago", archivoPago, (value) {
              setState(() => archivoPago = value);
            }),
            buildItem("Boleta de semestre anterior", archivoBoleta, (value) {
              setState(() => archivoBoleta = value);
            }),
            buildItem("Solicitud de aprovechamiento academico", archivoSolicitud, (value) {
              setState(() => archivoSolicitud = value);
            }),
          ],
        ),
      ),
    );
  }
}
