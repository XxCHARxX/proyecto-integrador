import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DatosAlumno(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DatosAlumno extends StatefulWidget {
  @override
  _DatosAlumnoState createState() => _DatosAlumnoState();
}

class _DatosAlumnoState extends State<DatosAlumno> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para cada campo
  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController curpController = TextEditingController();
  final TextEditingController sexoController = TextEditingController();
  final TextEditingController domicilioController = TextEditingController();
  final TextEditingController telefonoCasaController = TextEditingController();
  final TextEditingController telefonoTrabajoController = TextEditingController();
  final TextEditingController telefonoCelularController = TextEditingController();

  bool datosGuardados = false;

  /* Función para continuar a la siguiente ventana
  void _continuar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pasando al siguiente paso.')),
      );
    }
  }*/

  // Función para guardar los datos
  void _guardar() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        datosGuardados = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados exitosamente.')),
      );
    }
  }

  /* Función para cancelar y regresar a la ventana anterior
  void _cancelar() {
    Navigator.pop(context);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DATOS DEL ALUMNO')),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 143, 85, 153), Color.fromARGB(255, 129, 175, 255)], // Color de fondo
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campos del formulario
              _buildMatriculaField(),
              _buildNombreField(),
              _buildCurpField(),
              _buildSexoField(),
              _buildField(label: 'DOMICILIO', controller: domicilioController),
              _buildPhoneField('TELÉFONO DE CASA O FAMILIAR', telefonoCasaController),
              _buildOptionalPhoneField('TELÉFONO DE TRABAJO', telefonoTrabajoController),
              _buildPhoneField('TELÉFONO CELULAR', telefonoCelularController),
              const SizedBox(height: 20),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /*ElevatedButton(
                    onPressed: _cancelar,
                    child: const Text('CANCELAR'),
                  ),*/
                  ElevatedButton(
                    onPressed: _guardar,
                    child: const Text('GUARDAR'),
                  )
                  /*ElevatedButton(
                    onPressed: (_formKey.currentState?.validate() ?? false) ? _continuar : null, // Validación adicional antes de continuar
                    child: const Text('CONTINUAR'),
                  ),*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Campo de matrícula (8-10 dígitos numéricos)
  Widget _buildMatriculaField() {
    return _buildField(
      label: 'MATRÍCULA',
      controller: matriculaController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo requerido';
        } else if (!RegExp(r'^\d{9}').hasMatch(value)) { // Cambié el patrón de la expresión regular
          return 'Debe tener 9 dígitos numéricos';
        }
        return null;
      },
    );
  }

  // Campo de nombre (solo letras mayúsculas)
  Widget _buildNombreField() {
    return _buildField(
      label: 'NOMBRE',
      controller: nombreController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo requerido';
        } else if (!RegExp(r'^[A-ZÁÉÍÓÚÑ ]+$').hasMatch(value)) { // Asegurándote de permitir acentos y la Ñ
          return 'Solo letras mayúsculas';
        }
        return null;
      },
    );
  }

  // Campo CURP (formato CURP válido)
  Widget _buildCurpField() {
    return _buildField(
      label: 'CURP',
      controller: curpController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo requerido';
        } else if (!RegExp(r'^[A-Z]{4}\d{6}[A-Z]{7}\d{1}$').hasMatch(value)) { // Ajusté el patrón para permitir 18 caracteres
          return 'Formato inválido (18 caracteres: 4 letras mayúsculas, 6 números, 7 letras mayúsculas, 1 número)';
        }
        return null;
      },
    );
  }

  // Campo de sexo (solo letras mayúsculas)
  Widget _buildSexoField() {
    return _buildField(
      label: 'SEXO',
      controller: sexoController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo requerido';
        } else if (!RegExp(r'^[A-Z]+$').hasMatch(value)) { // Acepta cualquier cantidad de letras mayúsculas
          return 'Debe contener solo mayúsculas';
        }
        return null;
      },
    );
  }

  // Campos de teléfono
  Widget _buildPhoneField(String label, TextEditingController controller) {
    return _buildField(
      label: label,
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 10,
      validator: (value) {
        if (value == null || value.isEmpty || value.length != 10) {
          return 'Debe tener 10 dígitos';
        }
        return null;
      },
    );
  }

  Widget _buildOptionalPhoneField(String label, TextEditingController controller) {
    return _buildField(
      label: label,
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 10,
    );
  }

  // Función genérica para construir campos de texto
  Widget _buildField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        maxLength: maxLength,
        validator: validator,
      ),
    );
  }
}
