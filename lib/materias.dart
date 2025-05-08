import 'package:flutter/material.dart';

void main() {
  runApp(MateriasApp());
}

class MateriasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MateriasScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MateriasScreen extends StatefulWidget {
  @override
  _MateriasScreenState createState() => _MateriasScreenState();
}

class _MateriasScreenState extends State<MateriasScreen> {
  String? selectedGrupo;
  int? semestreSeleccionado;
  List<Map<String, String>> materiasDelSemestre = [];
  List<Map<String, String>> materiasCargadas = [];

  final Color fondoColor = Colors.grey.shade100;

  final Map<int, Map<String, List<Map<String, String>>>> materiasPorSemestre = {
    for (int semestre = 1; semestre <= 12; semestre++)
      semestre: {
        'Grupo 1': List.generate(7, (i) => {
              'nombre': 'Materia ${i + 1} - S$semestre',
              'profesor': 'Profesor ${(i + 65).toRadixString(36).toUpperCase()}$semestre',
              'grupo': 'G1'
            }),
        'Grupo 2': List.generate(7, (i) => {
              'nombre': 'Materia ${i + 1} - S$semestre',
              'profesor': 'Profesor ${(i + 65).toRadixString(36).toUpperCase()}$semestre',
              'grupo': 'G2'
            }),
      }
  };

  void seleccionarGrupo(int semestre, String grupo) {
    if (_bloqueadoPorCondicion(semestre)) return;

    setState(() {
      selectedGrupo = grupo;
      semestreSeleccionado = semestre;
      materiasDelSemestre = materiasPorSemestre[semestre]?[grupo] ?? [];
    });
  }

  void agregarMateria(Map<String, String> materia) {
    if (!materiasCargadas.contains(materia)) {
      setState(() {
        materiasCargadas.add(materia);
      });
    }
  }

  void eliminarMateria(int index) {
    setState(() {
      materiasCargadas.removeAt(index);
    });
  }

  void guardarMaterias() {
    if (materiasCargadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No has seleccionado ninguna materia")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Materias guardadas correctamente"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: materiasCargadas.map((materia) {
            return ListTile(
              title: Text(materia['nombre']!),
              subtitle: Text("Profesor: ${materia['profesor']}"),
              trailing: Text("Grupo: ${materia['grupo']}"),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cerrar"),
          )
        ],
      ),
    );
  }

  bool _bloqueadoPorCondicion(int semestre) {
    final cargadosPorSemestre = materiasCargadas
        .map((m) => int.tryParse(m['nombre']!.split(' - S').last))
        .toSet();

    // Regla para semestres 1 a 4
    if ((1 <= semestre && semestre <= 4) && cargadosPorSemestre.any((s) => s != semestre && (s ?? 0) <= 4)) {
      return true;
    }

    // Regla para semestres 4 en adelante
    if ((semestre >= 4) && cargadosPorSemestre.any((s) => s != semestre && (s ?? 0) >= 4)) {
      return true;
    }

    return false;
  }

  Widget crearBotonGrupo(int semestre, String grupo) {
    final bool bloqueado = _bloqueadoPorCondicion(semestre);

    return ElevatedButton.icon(
      onPressed: bloqueado ? null : () => seleccionarGrupo(semestre, grupo),
      icon: bloqueado ? Icon(Icons.lock, size: 14) : SizedBox.shrink(),
      label: Text(
        grupo,
        style: TextStyle(
          fontSize: 12,
          color: bloqueado ? Colors.black45 : null,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: bloqueado ? Colors.grey.shade300 : null,
        foregroundColor: bloqueado ? Colors.black45 : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MATERIAS')),
      body: Container(
        color: fondoColor,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text("SEMESTRE AL QUE CURSARÁS", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Semestres 1 a 6
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(6, (index) {
                        int semestre = index + 1;
                        return Expanded(
                          child: Column(
                            children: [
                              Text("Semestre $semestre", style: TextStyle(fontWeight: FontWeight.bold)),
                              if (materiasPorSemestre.containsKey(semestre))
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: materiasPorSemestre[semestre]!.keys
                                      .map((grupo) => crearBotonGrupo(semestre, grupo))
                                      .toList(),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                    Divider(),
                    // Semestres 7 a 12
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(6, (index) {
                        int semestre = index + 7;
                        return Expanded(
                          child: Column(
                            children: [
                              Text("Semestre $semestre", style: TextStyle(fontWeight: FontWeight.bold)),
                              if (materiasPorSemestre.containsKey(semestre))
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: materiasPorSemestre[semestre]!.keys
                                      .map((grupo) => crearBotonGrupo(semestre, grupo))
                                      .toList(),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            if (materiasDelSemestre.isNotEmpty) ...[
              Text("MATERIAS DEL GRUPO SELECCIONADO", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: materiasDelSemestre.length,
                  itemBuilder: (context, index) {
                    var materia = materiasDelSemestre[index];
                    return ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.add, color: Colors.red),
                        onPressed: () => agregarMateria(materia),
                      ),
                      title: Text(materia['nombre']!),
                      subtitle: Text("Profesor: ${materia['profesor']}"),
                      trailing: Text("Grupo: ${materia['grupo']}"),
                    );
                  },
                ),
              ),
            ],
            Divider(),
            Text("MATERIAS CARGADAS", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: materiasCargadas.length,
                itemBuilder: (context, index) {
                  var materia = materiasCargadas[index];
                  return ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.remove, color: Colors.blue),
                      onPressed: () => eliminarMateria(index),
                    ),
                    title: Text(materia['nombre']!),
                    subtitle: Text("Profesor: ${materia['profesor']}"),
                    trailing: Text("Grupo: ${materia['grupo']}"),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: guardarMaterias,
              child: Text("GUARDAR"),
            ),
          ],
        ),
      ),
    );
  }
}
