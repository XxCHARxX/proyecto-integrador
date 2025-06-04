import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 13, 161, 38),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(color: Color(0xFF0D47A1), elevation: 0),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF0D47A1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          prefixIconColor: const Color(0xFF0D47A1),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ---------------- LOGIN ----------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  void _resetPassword() {
    if (emailController.text.isNotEmpty) {
      _showMessage("Info", "Funcionalidad de restablecimiento no disponible.");
    } else {
      _showMessage("Error", "Ingresa tu correo");
    }
  }

  void _showMessage(String title, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // ✅ Fondo claro azul suave
      body: Stack(
        children: [
          // ✅ Imagen superior izquierda
          Positioned(
            top: 20,
            left: 20,
            child: Image.asset('assets/ISC.png', width: 120, height: 100),
          ),

          // ✅ Imagen superior derecha
          Positioned(
            top: 20,
            right: 20,
            child: Image.asset('assets/LOGO.png', width: 120, height: 100),
          ),

          // ✅ Imagen inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/esc.png',
              fit: BoxFit.cover,
              height: 240,
            ),
          ),

          // ✅ Contenido principal
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5),

                    const Text(
                      "Iniciar Sesión",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),

                    const SizedBox(height: 10),

                    buildInputField(
                      "Correo electrónico",
                      Icons.email,
                      false,
                      emailController,
                    ),

                    const SizedBox(height: 10),

                    buildInputField(
                      "Contraseña",
                      Icons.lock,
                      true,
                      passwordController,
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        "Iniciar sesión",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextButton(
                      onPressed: _resetPassword,
                      child: const Text(
                        "¿Olvidaste tu contraseña?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 2, 2, 2),
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          ),
                      child: const Text(
                        "Registrarse",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Campo de entrada personalizado
  Widget buildInputField(
    String label,
    IconData icon,
    bool isPassword,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.black), // ✅ Texto dentro del campo
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF0D47A1)), // ✅ Label azul
          prefixIcon: Icon(icon, color: Color(0xFF0D47A1)), // ✅ Ícono azul
          filled: true,
          fillColor: Colors.white, // ✅ Fondo blanco del campo
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF0D47A1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF1976D2)),
          ),
        ),
        validator: (value) => value!.isEmpty ? "Campo requerido" : null,
      ),
    );
  }
}

// ---------------- REGISTRO ----------------
class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();
  final TextEditingController calleController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos válidos. Registro exitoso')),
      );

      // Aquí puedes proceder a guardar, enviar o mostrar otra vista si lo deseas.
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildInputField("Nombre", Icons.person, false, nombreController, const Color(0xFF0D47A1)),
              buildInputField("Apellido", Icons.person_outline, false, apellidoController, const Color(0xFF0D47A1)),
              buildInputField("Matrícula", Icons.confirmation_number, false, matriculaController, const Color(0xFF0D47A1)),
              buildInputField("Ciudad", Icons.location_city, false, ciudadController, const Color(0xFF0D47A1)),
              buildInputField("Calle", Icons.home, false, calleController, const Color(0xFF0D47A1)),
              buildInputField("Correo electrónico", Icons.email, false, emailController, const Color(0xFF0D47A1)),
              buildInputField("Contraseña", Icons.lock, true, passwordController, const Color(0xFF0D47A1)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _register(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text("Registrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
    String hint,
    IconData icon,
    bool isPassword,
    TextEditingController controller,
    Color iconColor,
  ) {
    final FocusNode focusNode = FocusNode();

    return StatefulBuilder(
      builder: (context, setState) {
        focusNode.addListener(() {
          setState(() {});
        });

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            focusNode: focusNode,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Este campo es obligatorio';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: iconColor),
              filled: true,
              fillColor: focusNode.hasFocus
                  ? const Color(0xFF0D47A1).withOpacity(0.85)
                  : const Color(0xFFBDBDBD),
              hintStyle: const TextStyle(color: Colors.black54),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
              ),
            ),
          ),
        );
      },
    );
  }
}




// ---------------- DATOS DEL ALUMNO ----------------
class DatosAlumno extends StatefulWidget {
  const DatosAlumno({super.key});

  @override
  _DatosAlumnoState createState() => _DatosAlumnoState();
}

class _DatosAlumnoState extends State<DatosAlumno> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController curpController = TextEditingController();
  final TextEditingController sexoController = TextEditingController();
  final TextEditingController domicilioController = TextEditingController();
  final TextEditingController telefonoCasaController = TextEditingController();
  final TextEditingController telefonoTrabajoController = TextEditingController();
  final TextEditingController telefonoCelularController = TextEditingController();
  bool datosGuardados = false;

  final Color colorPrincipal = const Color(0xFF002855); // Azul oscuro institucional

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DATOS DEL ALUMNO')),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField(
                label: "Matrícula",
                controller: matriculaController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
                  } else if (!RegExp(r'^\d{9}$').hasMatch(value)) {
                    return 'Debe tener 9 dígitos numéricos';
                  }
                  return null;
                },
              ),
              _buildField(
                label: "Nombre Completo",
                controller: nombreController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
                  } else if (!RegExp(r'^[A-ZÁÉÍÓÚÑ ]+$').hasMatch(value)) {
                    return 'Solo letras mayúsculas';
                  }
                  return null;
                },
              ),
              _buildField(
                label: "CURP",
                controller: curpController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
                  } else if (!RegExp(r'^[A-Z]{4}\d{6}[A-Z]{7}\d{1}$').hasMatch(value)) {
                    return 'Formato inválido (18 caracteres: 4 letras mayúsculas, 6 números, 7 letras mayúsculas, 1 número)';
                  }
                  return null;
                },
              ),
              _buildField(
                label: "Sexo",
                controller: sexoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
                  } else if (!RegExp(r'^[A-Z]+$').hasMatch(value)) {
                    return 'Debe contener solo mayúsculas';
                  }
                  return null;
                },
              ),
              _buildField(
                label: "Domicilio",
                controller: domicilioController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
                  }
                  return null;
                },
              ),
              _buildField(
                label: "Teléfono de casa",
                controller: telefonoCasaController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
                  } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Debe contener solo 10 dígitos numéricos';
                  }
                  return null;
                },
              ),
              _buildField(
                label: "Teléfono de trabajo",
                controller: telefonoTrabajoController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      !RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Debe contener exactamente 10 dígitos numéricos';
                  }
                  return null;
                },
              ),
              _buildField(
                label: "Teléfono de celular",
                controller: telefonoCelularController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
                  } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Debe contener solo 10 dígitos numéricos';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _guardar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrincipal, // Fondo azul
                      foregroundColor: Colors.white, // Texto blanco
                      side: BorderSide(color: colorPrincipal, width: 2), // Contorno azul
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          filled: true,
          fillColor: const Color(0xFFBDBDBD).withOpacity(0.9), // Más opaco que el fondo
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: colorPrincipal, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: colorPrincipal, width: 1.5),
          ),
        ),
        keyboardType: keyboardType,
        maxLength: maxLength,
        validator: validator,
      ),
    );
  }
}

// ---------------- BIENVENIDA ----------------
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bienvenida")),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5561D4), Color(0xFF0D47A1)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.account_circle, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Menú principal",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            buildMenuItem(
              "Datos",
              Icons.insert_drive_file,
              context,
              screen: const DatosAlumno(),
            ),
            buildMenuItem(
              "Consulta",
              Icons.search,
              context,
              screen: const ConsultaScreen(),
            ),
            buildMenuItem(
              "Selección",
              Icons.check_circle,
              context,
              screen: const SeleccionScreen(),
            ),
            buildMenuItem(
              "Estadísticas",
              Icons.bar_chart,
              context,
              screen: const EstadisticasScreen(),
            ),
            buildMenuItem(
              "CARGA DE ARCHIVOS",
              Icons.upload,
              context,
              screen: const Cargadearchivos(),
            ),
            buildMenuItem(
              "Cerrar sesión",
              Icons.exit_to_app,
              context,
              logout: true,
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text("¡Bienvenido!", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

// ---------------- MENÚ ITEM ----------------
Widget buildMenuItem(
  String title,
  IconData icon,
  BuildContext context, {
  Widget? screen,
  bool logout = false,
}) {
  return ListTile(
    leading: Icon(icon, color: const Color(0xFF0D47A1)),
    title: Text(title),
    onTap: () {
      if (logout) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen!));
      }
    },
  );
}

// ---------------- CONSULTA ----------------
class ConsultaScreen extends StatelessWidget {
  const ConsultaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consulta")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Materia")),
            DataColumn(label: Text("Semestre")),
            DataColumn(label: Text("Estatus")),
            DataColumn(label: Text("Promedio")),
          ],
          rows: const [
            DataRow(
              cells: [
                DataCell(Text("Matemáticas")),
                DataCell(Text("7")),
                DataCell(Text("Activo")),
                DataCell(Text("9.0")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Programación")),
                DataCell(Text("8")),
                DataCell(Text("Activo")),
                DataCell(Text("8.5")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- SELECCIÓN ----------------
class SeleccionScreen extends StatefulWidget {
  const SeleccionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SeleccionScreenState createState() => _SeleccionScreenState();
}

class _SeleccionScreenState extends State<SeleccionScreen> {
  String? selectedGrupo;
  int? semestreSeleccionado;
  List<Map<String, String>> materiasDelSemestre = [];
  List<Map<String, String>> materiasCargadas = [];

  final Map<int, Map<String, List<Map<String, String>>>> materiasPorSemestre = {
    1: {
      'Grupo 1': [
        {
          'nombre': 'Cálculo Diferencial',
          'profesor': 'Profesor A1',
          'grupo': '3101',
        },
        {
          'nombre': 'Fundamentos de Programación',
          'profesor': 'Profesor B1',
          'grupo': '3101',
        },
        {
          'nombre': 'Taller de Ética',
          'profesor': 'Profesor C1',
          'grupo': '3101',
        },
        {
          'nombre': 'Matemáticas Discretas',
          'profesor': 'Profesor D1',
          'grupo': '3101',
        },
        {
          'nombre': 'Taller de Administración',
          'profesor': 'Profesor E1',
          'grupo': '3101',
        },
        {
          'nombre': 'Álgebra Lineal',
          'profesor': 'Profesor F1',
          'grupo': '3101',
        },
        {
          'nombre': 'Taller de Lectura y Redacción',
          'profesor': 'Profesor G1',
          'grupo': '3101',
        },
      ],
      'Grupo 2': [
        {
          'nombre': 'Cálculo Diferencial',
          'profesor': 'Profesor A1',
          'grupo': '3102',
        },
        {
          'nombre': 'Fundamentos de Programación',
          'profesor': 'Profesor B1',
          'grupo': '3102',
        },
        {
          'nombre': 'Taller de Ética',
          'profesor': 'Profesor C1',
          'grupo': '3102',
        },
        {
          'nombre': 'Matemáticas Discretas',
          'profesor': 'Profesor D1',
          'grupo': '3102',
        },
        {
          'nombre': 'Taller de Administración',
          'profesor': 'Profesor E1',
          'grupo': '3102',
        },
        {
          'nombre': 'Álgebra Lineal',
          'profesor': 'Profesor F1',
          'grupo': '3102',
        },
        {
          'nombre': 'Taller de Lectura y Redacción',
          'profesor': 'Profesor G1',
          'grupo': '3102',
        },
      ],
    },
    2: {
      'Grupo 1': [
        {
          'nombre': 'Cálculo Integral',
          'profesor': 'Profesor A2',
          'grupo': '3201',
        },
        {
          'nombre': 'Programación Orientada a Objetos',
          'profesor': 'Profesor B2',
          'grupo': '3201',
        },
        {
          'nombre': 'Contabilidad Financiera',
          'profesor': 'Profesor C2',
          'grupo': '3201',
        },
        {'nombre': 'Química', 'profesor': 'Profesor D2', 'grupo': '3201'},
        {
          'nombre': 'Sistemas Operativos I',
          'profesor': 'Profesor E2',
          'grupo': '3201',
        },
        {
          'nombre': 'Probabilidad y Estadística',
          'profesor': 'Profesor F2',
          'grupo': '3201',
        },
        {
          'nombre': 'Taller de Programación',
          'profesor': 'Profesor G2',
          'grupo': '3201',
        },
      ],
      'Grupo 2': [
        {
          'nombre': 'Cálculo Integral',
          'profesor': 'Profesor A2',
          'grupo': '3202',
        },
        {
          'nombre': 'Programación Orientada a Objetos',
          'profesor': 'Profesor B2',
          'grupo': '3202',
        },
        {
          'nombre': 'Contabilidad Financiera',
          'profesor': 'Profesor C2',
          'grupo': '3202',
        },
        {'nombre': 'Química', 'profesor': 'Profesor D2', 'grupo': '3202'},
        {
          'nombre': 'Sistemas Operativos I',
          'profesor': 'Profesor E2',
          'grupo': '3202',
        },
        {
          'nombre': 'Probabilidad y Estadística',
          'profesor': 'Profesor F2',
          'grupo': '3202',
        },
        {
          'nombre': 'Taller de Programación',
          'profesor': 'Profesor G2',
          'grupo': '3202',
        },
      ],
    },
    3: {
      'Grupo 1': [
        {
          'nombre': 'Cálculo Vectorial',
          'profesor': 'Profesor A3',
          'grupo': '3301',
        },
        {
          'nombre': 'Estructura de Datos',
          'profesor': 'Profesor B3',
          'grupo': '3301',
        },
        {
          'nombre': 'Cultura Empresarial',
          'profesor': 'Profesor C3',
          'grupo': '3301',
        },
        {
          'nombre': 'Investigación de Operaciones I',
          'profesor': 'Profesor D3',
          'grupo': '3301',
        },
        {
          'nombre': 'Taller de Sistemas Operativos',
          'profesor': 'Profesor E3',
          'grupo': '3301',
        },
        {
          'nombre': 'Física General',
          'profesor': 'Profesor F3',
          'grupo': '3301',
        },
        {
          'nombre': 'Actividades Culturales',
          'profesor': 'Profesor G3',
          'grupo': '3301',
        },
      ],
      'Grupo 2': [
        {
          'nombre': 'Cálculo Vectorial',
          'profesor': 'Profesor A3',
          'grupo': '3302',
        },
        {
          'nombre': 'Estructura de Datos',
          'profesor': 'Profesor B3',
          'grupo': '3302',
        },
        {
          'nombre': 'Cultura Empresarial',
          'profesor': 'Profesor C3',
          'grupo': '3302',
        },
        {
          'nombre': 'Investigación de Operaciones I',
          'profesor': 'Profesor D3',
          'grupo': '3302',
        },
        {
          'nombre': 'Taller de Sistemas Operativos',
          'profesor': 'Profesor E3',
          'grupo': '3302',
        },
        {
          'nombre': 'Física General',
          'profesor': 'Profesor F3',
          'grupo': '3302',
        },
        {
          'nombre': 'Actividades Culturales',
          'profesor': 'Profesor G3',
          'grupo': '3302',
        },
      ],
    },
    4: {
      'Grupo 1': [
        {
          'nombre': 'Ecuaciones Diferenciales',
          'profesor': 'Profesor A4',
          'grupo': '3401',
        },
        {
          'nombre': 'Tópicos Avanzados de Programación',
          'profesor': 'Profesor B4',
          'grupo': '3401',
        },
        {
          'nombre': 'Métodos Numéricos',
          'profesor': 'Profesor C4',
          'grupo': '3401',
        },
        {
          'nombre': 'Fundamentos de Base de Datos',
          'profesor': 'Profesor D4',
          'grupo': '3401',
        },
        {
          'nombre': 'Fundamentos de Ingeniería de Software',
          'profesor': 'Profesor E4',
          'grupo': '3401',
        },
        {
          'nombre': 'Principios Eléctricos y Aplicaciones Digitales',
          'profesor': 'Profesor F4',
          'grupo': '3401',
        },
        {
          'nombre': 'Actividades Deportivas',
          'profesor': 'Profesor G4',
          'grupo': '3401',
        },
      ],
      'Grupo 2': [
        {
          'nombre': 'Ecuaciones Diferenciales',
          'profesor': 'Profesor A4',
          'grupo': '3402',
        },
        {
          'nombre': 'Tópicos Avanzados de Programación',
          'profesor': 'Profesor B4',
          'grupo': '3402',
        },
        {
          'nombre': 'Métodos Numéricos',
          'profesor': 'Profesor C4',
          'grupo': '3402',
        },
        {
          'nombre': 'Fundamentos de Base de Datos',
          'profesor': 'Profesor D4',
          'grupo': '3402',
        },
        {
          'nombre': 'Fundamentos de Ingeniería de Software',
          'profesor': 'Profesor E4',
          'grupo': '3402',
        },
        {
          'nombre': 'Principios Eléctricos y Aplicaciones Digitales',
          'profesor': 'Profesor F4',
          'grupo': '3402',
        },
        {
          'nombre': 'Actividades Deportivas',
          'profesor': 'Profesor G4',
          'grupo': '3402',
        },
      ],
    },
    5: {
      'Grupo 1': [
        {'nombre': 'Simulación', 'profesor': 'Profesor A5', 'grupo': '3501'},
        {
          'nombre': 'Fundamentos de Telecomunicaciones',
          'profesor': 'Profesor B5',
          'grupo': '3501',
        },
        {
          'nombre': 'Programación Web',
          'profesor': 'Profesor C5',
          'grupo': '3501',
        },
        {
          'nombre': 'Taller de Base de Datos',
          'profesor': 'Profesor D5',
          'grupo': '3501',
        },
        {
          'nombre': 'Ingeniería de Requerimientos',
          'profesor': 'Profesor E5',
          'grupo': '3501',
        },
        {
          'nombre': 'Arquitectura de Computadoras',
          'profesor': 'Profesor F5',
          'grupo': '3501',
        },
        {
          'nombre': 'Taller de Emprendedor',
          'profesor': 'Profesor G5',
          'grupo': '3501',
        },
      ],
      'Grupo 2': [
        {'nombre': 'Simulación', 'profesor': 'Profesor A5', 'grupo': '3502'},
        {
          'nombre': 'Fundamentos de Telecomunicaciones',
          'profesor': 'Profesor B5',
          'grupo': '3502',
        },
        {
          'nombre': 'Programación Web',
          'profesor': 'Profesor C5',
          'grupo': '3502',
        },
        {
          'nombre': 'Taller de Base de Datos',
          'profesor': 'Profesor D5',
          'grupo': '3502',
        },
        {
          'nombre': 'Ingeniería de Requerimientos',
          'profesor': 'Profesor E5',
          'grupo': '3502',
        },
        {
          'nombre': 'Arquitectura de Computadoras',
          'profesor': 'Profesor F5',
          'grupo': '3502',
        },
        {
          'nombre': 'Taller de Emprendedor',
          'profesor': 'Profesor G5',
          'grupo': '3502',
        },
      ],
    },
    6: {
      'Grupo 1': [
        {
          'nombre': 'Lenguajes y Autómatas I',
          'profesor': 'Profesor A6',
          'grupo': '3601',
        },
        {
          'nombre': 'Redes de Computadoras',
          'profesor': 'Profesor B6',
          'grupo': '3601',
        },
        {
          'nombre': 'Desarrollo Sustentable',
          'profesor': 'Profesor C6',
          'grupo': '3601',
        },
        {
          'nombre': 'Administración de Base de Datos',
          'profesor': 'Profesor D6',
          'grupo': '3601',
        },
        {
          'nombre': 'Fundamentos de Investigación II',
          'profesor': 'Profesor E6',
          'grupo': '3601',
        },
        {
          'nombre': 'Lenguaje de Interfaz',
          'profesor': 'Profesor F6',
          'grupo': '3601',
        },
        {
          'nombre': 'Servicio Social',
          'profesor': 'Profesor G6',
          'grupo': '3601',
        },
      ],
      'Grupo 2': [
        {
          'nombre': 'Lenguajes y Autómatas I',
          'profesor': 'Profesor A6',
          'grupo': '3602',
        },
        {
          'nombre': 'Redes de Computadoras',
          'profesor': 'Profesor B6',
          'grupo': '3602',
        },
        {
          'nombre': 'Desarrollo Sustentable',
          'profesor': 'Profesor C6',
          'grupo': '3602',
        },
        {
          'nombre': 'Administración de Base de Datos',
          'profesor': 'Profesor D6',
          'grupo': '3602',
        },
        {
          'nombre': 'Fundamentos de Investigación II',
          'profesor': 'Profesor E6',
          'grupo': '3602',
        },
        {
          'nombre': 'Lenguaje de Interfaz',
          'profesor': 'Profesor F6',
          'grupo': '3602',
        },
        {
          'nombre': 'Servicio Social',
          'profesor': 'Profesor G6',
          'grupo': '3602',
        },
      ],
    },
    7: {
      'Grupo 1': [
        {
          'nombre': 'Lenguajes y Autómatas II',
          'profesor': 'Profesor A7',
          'grupo': '3701',
        },
        {
          'nombre': 'Lenguajes de Programación',
          'profesor': 'Profesor B7',
          'grupo': '3701',
        },
        {
          'nombre': 'Inteligencia Artificial',
          'profesor': 'Profesor C7',
          'grupo': '3701',
        },
        {
          'nombre': 'Programación Lógica y Funcional',
          'profesor': 'Profesor D7',
          'grupo': '3701',
        },
        {
          'nombre': 'Taller de Investigación I',
          'profesor': 'Profesor E7',
          'grupo': '3701',
        },
        {
          'nombre': 'Gestión de Proyectos de Software',
          'profesor': 'Profesor F7',
          'grupo': '3701',
        },
        {
          'nombre': 'Sistemas Programables',
          'profesor': 'Profesor G7',
          'grupo': '3701',
        },
      ],
      'Grupo 2': [
        {
          'nombre': 'Lenguajes y Autómatas II',
          'profesor': 'Profesor A7',
          'grupo': '3702',
        },
        {
          'nombre': 'Lenguajes de Programación',
          'profesor': 'Profesor B7',
          'grupo': '3702',
        },
        {
          'nombre': 'Inteligencia Artificial',
          'profesor': 'Profesor C7',
          'grupo': '3702',
        },
        {
          'nombre': 'Programación Lógica y Funcional',
          'profesor': 'Profesor D7',
          'grupo': '3702',
        },
        {
          'nombre': 'Taller de Investigación I',
          'profesor': 'Profesor E7',
          'grupo': '3702',
        },
        {
          'nombre': 'Gestión de Proyectos de Software',
          'profesor': 'Profesor F7',
          'grupo': '3702',
        },
        {
          'nombre': 'Sistemas Programables',
          'profesor': 'Profesor G7',
          'grupo': '3702',
        },
      ],
    },
    8: {
      'Grupo 1': [
        {
          'nombre': 'Desarrollo de Aplicaciones Móviles',
          'profesor': 'Profesor A8',
          'grupo': '3801',
        },
        {
          'nombre': 'Enrutamiento de Redes',
          'profesor': 'Profesor B8',
          'grupo': '3801',
        },
        {
          'nombre': 'Modelos y Ciencia de Datos',
          'profesor': 'Profesor C8',
          'grupo': '3801',
        },
        {
          'nombre': 'Inteligencia de Negocios',
          'profesor': 'Profesor D8',
          'grupo': '3801',
        },
        {
          'nombre': 'Taller de Investigación II',
          'profesor': 'Profesor E8',
          'grupo': '3801',
        },
        {'nombre': 'Gráficación', 'profesor': 'Profesor F8', 'grupo': '3801'},
      ],
      'Grupo 2': [
        {
          'nombre': 'Desarrollo de Aplicaciones Móviles',
          'profesor': 'Profesor A8',
          'grupo': '3802',
        },
        {
          'nombre': 'Enrutamiento de Redes',
          'profesor': 'Profesor B8',
          'grupo': '3802',
        },
        {
          'nombre': 'Modelos y Ciencia de Datos',
          'profesor': 'Profesor C8',
          'grupo': '3802',
        },
        {
          'nombre': 'Inteligencia de Negocios',
          'profesor': 'Profesor D8',
          'grupo': '3802',
        },
        {
          'nombre': 'Taller de Investigación II',
          'profesor': 'Profesor E8',
          'grupo': '3802',
        },
        {'nombre': 'Gráficación', 'profesor': 'Profesor F8', 'grupo': '3802'},
      ],
    },
    9: {
      'Grupo 1': [
        {
          'nombre': 'Internet de las Cosas',
          'profesor': 'Profesor A9',
          'grupo': '3901',
        },
        {
          'nombre': 'Analítica Inteligente de Datos',
          'profesor': 'Profesor B9',
          'grupo': '3901',
        },
        {
          'nombre': 'Residencia Profesional',
          'profesor': 'Profesor C9',
          'grupo': '3901',
        },
      ],
      'Grupo 2': [
        {
          'nombre': 'Internet de las Cosas',
          'profesor': 'Profesor A9',
          'grupo': '3902',
        },
        {
          'nombre': 'Analítica Inteligente de Datos',
          'profesor': 'Profesor B9',
          'grupo': '3902',
        },
        {
          'nombre': 'Residencia Profesional',
          'profesor': 'Profesor C9',
          'grupo': '3902',
        },
      ],
    },
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
    final materiaConSemestre = {
      ...materia,
      'semestre': semestreSeleccionado.toString(), // Guardamos el semestre aquí
    };

    if (!materiasCargadas.any(
      (m) =>
          m['nombre'] == materiaConSemestre['nombre'] &&
          m['grupo'] == materiaConSemestre['grupo'],
    )) {
      setState(() {
        materiasCargadas.add(materiaConSemestre);
      });
    }
  }

  void eliminarMateria(int index) {
    setState(() {
      materiasCargadas.removeAt(index);
    });
  }

  Future<void> imprimirMaterias() async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(now);

    pdf.addPage(
      pw.Page(
        build:
            (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Lista de Materias Cargadas',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text('Fecha: $formattedDate'),
                pw.SizedBox(height: 10),
                // ignore: deprecated_member_use
                pw.Table.fromTextArray(
                  headers: ['Nombre', 'Profesor', 'Grupo'],
                  data:
                      materiasCargadas
                          .map(
                            (materia) => [
                              materia['nombre'],
                              materia['profesor'],
                              materia['grupo'],
                            ],
                          )
                          .toList(),
                ),
              ],
            ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
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
      builder:
          (context) => AlertDialog(
            title: Text('Materias guardadas correctamente'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children:
                          materiasCargadas.map((materia) {
                            return ListTile(
                              title: Text(materia['nombre']!),
                              subtitle: Text(
                                'Profesor: ${materia['profesor']}',
                              ),
                              trailing: Text('Grupo: ${materia['grupo']}'),
                            );
                          }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cerrar'),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await imprimirMaterias();
                      },
                      child: Text('Imprimir'),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  bool _bloqueadoPorCondicion(int semestre) {
    final cargadosPorSemestre =
        materiasCargadas
            .map((m) => int.tryParse(m['semestre'] ?? ''))
            .whereType<int>()
            .toSet();

    if (semestre >= 1 && semestre <= 4) {
      return cargadosPorSemestre.any((s) => s != semestre && s >= 1 && s <= 4);
    }

    if (semestre >= 5 && semestre <= 9) {
      return cargadosPorSemestre.any((s) => s != semestre && s >= 5 && s <= 9);
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              "SEMESTRE AL QUE CURSARÁS",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(5, (index) {
                        int semestre = index + 1;
                        return Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Semestre $semestre",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (materiasPorSemestre.containsKey(semestre))
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children:
                                      materiasPorSemestre[semestre]!.keys
                                          .map(
                                            (grupo) => crearBotonGrupo(
                                              semestre,
                                              grupo,
                                            ),
                                          )
                                          .toList(),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                    Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(4, (index) {
                        int semestre = index + 6;
                        return Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Semestre $semestre",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (materiasPorSemestre.containsKey(semestre))
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children:
                                      materiasPorSemestre[semestre]!.keys
                                          .map(
                                            (grupo) => crearBotonGrupo(
                                              semestre,
                                              grupo,
                                            ),
                                          )
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
              Text(
                "MATERIAS DEL GRUPO SELECCIONADO",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
            Text(
              "MATERIAS CARGADAS",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
            ElevatedButton(onPressed: guardarMaterias, child: Text("GUARDAR")),
          ],
        ),
      ),
    );
  }
}

// ---------------- ESTADÍSTICAS ----------------
class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  int selectedSemester = 1;

  void selectSemester(int semester) {
    setState(() {
      selectedSemester = semester;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Estadísticas Académicas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Selecciona el semestre:',
              style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(0, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: List.generate(
                9,
                (index) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedSemester == index + 1
                            ? const Color(0xFF0D47A1)
                            : Colors.grey.shade300,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: () => selectSemester(index + 1),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color:
                          selectedSemester == index + 1
                              ? Colors.white
                              : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Gráfica
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Gráfica de rendimiento',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/img1.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Tabla resumen
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF5F5F5),
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Text(
                      'Resumen de los parciales',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.asset('assets/img4.png', fit: BoxFit.contain),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------CARGA DE ARCHIVO ----------------
class Cargadearchivos extends StatelessWidget {
  const Cargadearchivos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Carga de archivos")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(""),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InscripcionScreen()),
                );
              },
              child: const Text(
                "Precione para subir los archivos en formato PDF",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InscripcionScreen extends StatefulWidget {
  const InscripcionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El archivo debe ser menor a 1000 KB')),
      );
    }
  }

  Widget buildItem(
    String titulo,
    String? archivoNombre,
    Function(String) onFileSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          ElevatedButton(
            onPressed: () => seleccionarArchivo(onFileSelected),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF0D47A1),
            ),
            child: Text(
              archivoNombre ?? "Adjuntar archivo\n(1000 KB)",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuración de Inscripción")),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0FFFF), Color(0xFFE0FFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Suba sus archivos\n para conluir su reinscripción",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            buildItem("Comprobante de pago", archivoPago, (value) {
              setState(() => archivoPago = value);
            }),
            buildItem("Boleta de semestre anterior", archivoBoleta, (value) {
              setState(() => archivoBoleta = value);
            }),
            buildItem(
              "Solicitud de aprovechamiento académico",
              archivoSolicitud,
              (value) {
                setState(() => archivoSolicitud = value);
              },
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    archivoPago = null;
                    archivoBoleta = null;
                    archivoSolicitud = null;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Archivos subidos")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0D47A1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text("Subir archivos"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- INPUT FIELD SHARED ----------------
Widget buildInputField(
  String hint,
  IconData icon,
  bool isPassword,
  TextEditingController controller,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF0D47A1)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
        ),
      ),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
