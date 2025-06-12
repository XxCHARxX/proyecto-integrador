import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Importar FirebaseAuth
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:proyectointegrador/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
 try {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  debugPrint('✅ Firebase inicializado correctamente');
  debugPrint('🔹 Proyecto ID: ${Firebase.app().options.projectId}');
  debugPrint('🔹 App ID: ${Firebase.app().options.appId}');
  debugPrint('🔹 API Key: ${Firebase.app().options.apiKey}');
  
  // Verificación explícita del proveedor de autenticación
  try {
    final auth = FirebaseAuth.instance;
    debugPrint('🔹 Instancia de Auth creada');
    
    // Intenta un método simple para verificar si la autenticación está habilitada
    final methods = await auth.fetchSignInMethodsForEmail('test@example.com');
    debugPrint('🔹 Métodos de autenticación disponibles: $methods');
  } catch (e) {
    debugPrint('❌ Error verificando autenticación: $e');
  }
  
} catch (e) {
  debugPrint('❌ Error crítico inicializando Firebase: $e');
  // Puedes mostrar un error al usuario o manejar esto de otra manera
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Text('Error de configuración. Por favor reinicia la app.'),
      ),
    ),
  ));
  return;
}
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Color primario
        primaryColor: const Color(0xFF0D47A1),

        // Fondo de la aplicación
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),

        // AppBar estilizada
        appBarTheme: const AppBarTheme(
          color: Color(0xFF0D47A1),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // TextFields personalizados
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFE0E0E0), // Gris humo
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 24,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50), // Muy redondeado
            borderSide: BorderSide(color: Color(0xFF0D47A1), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50), // Muy redondeado
            borderSide: BorderSide(color: Color(0xFF0D47A1), width: 2.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Color(0xFF0D47A1), width: 1),
          ),
          hintStyle: const TextStyle(color: Colors.grey),
          labelStyle: const TextStyle(color: Colors.black87),
          prefixIconColor: const Color(0xFF0D47A1),
        ),

        // Estilo de textos
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
          titleLarge: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        // Radio buttons con color azul
        radioTheme: RadioThemeData(
          fillColor: WidgetStatePropertyAll(Color(0xFF0D47A1)),
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
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = '';
        if (e.code == 'user-not-found') {
          errorMessage = 'Usuario no encontrado';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Contraseña incorrecta';
        } else {
          errorMessage = 'Error: ${e.message}';
        }
        _showMessage("Error", errorMessage);
      }
    }
  }

  Future<void> _resetPassword() async {
    if (emailController.text.isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: emailController.text.trim());
        _showMessage("Éxito", "Se ha enviado un enlace para restablecer tu contraseña.");
      } catch (e) {
        _showMessage("Error", "No se pudo enviar el correo. Verifica el correo ingresado.");
      }
    } else {
      _showMessage("Error", "Ingresa tu correo");
    }
  }

  void _showMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Image.asset('assets/ISC.png', width: 120, height: 100),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Image.asset('assets/LOGO.png', width: 120, height: 100),
          ),
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
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      ),
                      child: const Text(
                        "Registrarse",
                        style: TextStyle(color: Colors.black),
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
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF0D47A1)),
          prefixIcon: Icon(icon, color: Color(0xFF0D47A1)),
          filled: true,
          fillColor: Colors.white,
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


// registro //
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController curpController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoPaternoController = TextEditingController();
  final TextEditingController apellidoMaternoController = TextEditingController();
  final TextEditingController domicilioController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController matriculaController = TextEditingController();

  String? generoSeleccionado;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (generoSeleccionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor seleccione su género')),
        );
        return;
      }

      try {
        // Crear usuario en Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim());

        // Guardar datos en Firestore
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userCredential.user!.uid)
            .set({
          'curp': curpController.text.trim(),
          'nombre': nombreController.text.trim(),
          'apellidoPaterno': apellidoPaternoController.text.trim(),
          'apellidoMaterno': apellidoMaternoController.text.trim(),
          'genero': generoSeleccionado,
          'domicilio': domicilioController.text.trim(),
          'ciudad': ciudadController.text.trim(),
          'telefono': telefonoController.text.trim(),
          'matricula': matriculaController.text.trim(),
          'email': emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        String mensajeError = 'Error desconocido';
        if (e.code == 'email-already-in-use') {
          mensajeError = 'El correo ya está registrado';
        } else if (e.code == 'weak-password') {
          mensajeError = 'La contraseña es muy débil';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensajeError)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
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
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLength: maxLength,
            focusNode: focusNode,
            validator: validator,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Color(0xFF0D47A1)),
              prefixIcon: Icon(icon, color: const Color(0xFF0D47A1)),
              filled: true,
              fillColor: focusNode.hasFocus
                  ? const Color(0xFF0D47A1).withOpacity(0.1)
                  : const Color(0xFFE3F2FD),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Alumno"),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField(
                label: "CURP",
                icon: Icons.badge,
                controller: curpController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
                  } else if (!RegExp(
                    r'^[A-Z][AEIOU][A-Z]{2}\d{2}(0[1-9]|1[0-2])'
                    r'(0[1-9]|[12]\d|3[01])[HM]'
                    r'(AS|BC|BS|CC|CL|CM|CS|CH|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS)'
                    r'[B-DF-HJ-NP-TV-Z]{3}[0-9A-Z]\d$',
                  ).hasMatch(value)) {
                    return 'Formato de CURP inválido';
                  }
                  return null;
                },
              ),
              _buildField(
                label: "Nombre(s)",
                icon: Icons.person,
                controller: nombreController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              _buildField(
                label: "Apellido Paterno",
                icon: Icons.person_outline,
                controller: apellidoPaternoController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              _buildField(
                label: "Apellido Materno",
                icon: Icons.person_outline,
                controller: apellidoMaternoController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Género*",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Hombre'),
                            value: 'H',
                            groupValue: generoSeleccionado,
                            activeColor: const Color(0xFF0D47A1),
                            onChanged: (value) {
                              setState(() => generoSeleccionado = value);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Mujer'),
                            value: 'M',
                            groupValue: generoSeleccionado,
                            activeColor: const Color(0xFF0D47A1),
                            onChanged: (value) {
                              setState(() => generoSeleccionado = value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildField(
                label: "Domicilio (Calle y número)",
                icon: Icons.home,
                controller: domicilioController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              _buildField(
                label: "Ciudad",
                icon: Icons.location_city,
                controller: ciudadController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              _buildField(
                label: "Teléfono",
                icon: Icons.phone,
                controller: telefonoController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo requerido';
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Debe tener 10 dígitos';
                  }
                  return null;
                },
              ),
              _buildField(
                label: "Matrícula",
                icon: Icons.confirmation_number,
                controller: matriculaController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo requerido';
                  if (!RegExp(r'^\d{9}$').hasMatch(value)) {
                    return 'Debe tener 9 dígitos';
                  }
                  return null;
                },
              ),
              _buildField(
                label: "Correo electrónico",
                icon: Icons.email,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo requerido';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Correo electrónico inválido';
                  }
                  return null;
                },
              ),
              _buildField(
                label: "Contraseña",
                icon: Icons.lock,
                controller: passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo requerido';
                  if (value.length < 6) return 'Mínimo 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'REGISTRARSE',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// DATOS ALUMNO //

class DatosAlumno extends StatefulWidget {
  const DatosAlumno({super.key});
  @override
  _DatosAlumnoState createState() => _DatosAlumnoState();
}

class _DatosAlumnoState extends State<DatosAlumno> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController curpController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoPaternoController = TextEditingController();
  final TextEditingController apellidoMaternoController = TextEditingController();
  final TextEditingController domicilioController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  String? generoSeleccionado;
  bool datosGuardados = false;

  @override
  void initState() {
    super.initState();
    _cargarDatosAlumno();
  }

  Future<void> _cargarDatosAlumno() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          curpController.text = data['curp'] ?? '';
          nombreController.text = data['nombre'] ?? '';
          apellidoPaternoController.text = data['apellidoPaterno'] ?? '';
          apellidoMaternoController.text = data['apellidoMaterno'] ?? '';
          generoSeleccionado = data['genero'] ?? '';
          domicilioController.text = data['domicilio'] ?? '';
          ciudadController.text = data['ciudad'] ?? '';
          telefonoController.text = data['telefono'] ?? '';
          datosGuardados = true;
        });
      }
    }
  }

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      if (generoSeleccionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor seleccione su género')),
        );
        return;
      }

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final docRef = FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
        await docRef.set({
          'curp': curpController.text.trim(),
          'nombre': nombreController.text.trim(),
          'apellidoPaterno': apellidoPaternoController.text.trim(),
          'apellidoMaterno': apellidoMaternoController.text.trim(),
          'genero': generoSeleccionado,
          'domicilio': domicilioController.text.trim(),
          'ciudad': ciudadController.text.trim(),
          'telefono': telefonoController.text.trim(),
        }, SetOptions(merge: true));

        setState(() {
          datosGuardados = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos actualizados exitosamente.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos del Alumno'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(controller: curpController, label: 'CURP'),
              _buildTextField(controller: nombreController, label: 'Nombre'),
              _buildTextField(controller: apellidoPaternoController, label: 'Apellido Paterno'),
              _buildTextField(controller: apellidoMaternoController, label: 'Apellido Materno'),
              const SizedBox(height: 16),
              _buildGeneroSelector(),
              const SizedBox(height: 16),
              _buildTextField(controller: domicilioController, label: 'Domicilio'),
              _buildTextField(controller: ciudadController, label: 'Ciudad'),
              _buildTextField(controller: telefonoController, label: 'Teléfono'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardar,
                child: const Text('GUARDAR DATOS'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Por favor ingrese $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGeneroSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Género', style: TextStyle(fontSize: 16)),
        ListTile(
          title: const Text('Masculino'),
          leading: Radio<String>(
            value: 'Masculino',
            groupValue: generoSeleccionado,
            onChanged: (value) {
              setState(() {
                generoSeleccionado = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Femenino'),
          leading: Radio<String>(
            value: 'Femenino',
            groupValue: generoSeleccionado,
            onChanged: (value) {
              setState(() {
                generoSeleccionado = value;
              });
            },
          ),
        ),
      ],
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
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
              onTap: () {
                // Cierra el drawer primero
                Navigator.pop(context);
                // Navega a la pantalla de login
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: DatosAlumno(),
    );
  }

  Widget buildMenuItem(
    String title,
    IconData icon,
    BuildContext context, {
    Widget? screen,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        }
      },
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
class ConsultaScreen extends StatefulWidget {
  const ConsultaScreen({super.key});

  @override
  State<ConsultaScreen> createState() => _ConsultaScreenState();
}

class _ConsultaScreenState extends State<ConsultaScreen> {
  List<Map<String, String>> materias = [];

  @override
  void initState() {
    super.initState();
    _cargarMaterias();
  }

  Future<void> _cargarMaterias() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('No hay usuario autenticado');
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid) // o user.uid si guardaste así
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      List<Map<String, String>> nuevasMaterias = [];

      if (data['materias'] is List) {
        final List materiasData = data['materias'];

        for (var materia in materiasData) {
          if (materia is Map<String, dynamic>) {
            nuevasMaterias.add({
              'materia': materia['materia'] ?? '',
              'estatus': materia['estatus'] ?? '',
            });
          }
        }
      }

      setState(() {
        materias = nuevasMaterias;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta"),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: materias.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Materia")),
                    DataColumn(label: Text("Estatus")),
                  ],
                  rows: materias.map((materia) {
                    return DataRow(cells: [
                      DataCell(Text(materia['materia'] ?? '')),
                      DataCell(Text(materia['estatus'] ?? '')),
                    ]);
                  }).toList(),
                ),
              ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5561D4), Color(0xFF0D47A1)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text("Menú principal", style: TextStyle(color: Colors.white, fontSize: 20)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.insert_drive_file),
            title: const Text("Datos"),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DatosAlumno()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text("Consulta"),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ConsultaScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text("Selección"),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SeleccionScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text("Estadísticas"),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const EstadisticasScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.upload),
            title: const Text("Carga de Archivos"),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Cargadearchivos()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}  


// ---------------- SELECCIÓN ----------------

class SeleccionScreen extends StatefulWidget {
  const SeleccionScreen({super.key});

  @override
  _SeleccionScreenState createState() => _SeleccionScreenState();
}

class _SeleccionScreenState extends State<SeleccionScreen> {
  String? selectedGrupo;
  int? semestreSeleccionado;
  List<Map<String, String>> materiasDelSemestre = [];
  List<Map<String, String>> materiasCargadas = [];

  final materiasPorSemestre = {
    1: {'Grupo 1': _crearMaterias(1, '3101'), 'Grupo 2': _crearMaterias(1, '3102')},
    2: {'Grupo 1': _crearMaterias(2, '3201'), 'Grupo 2': _crearMaterias(2, '3202')},
    3: {'Grupo 1': _crearMaterias(3, '3301'), 'Grupo 2': _crearMaterias(3, '3302')},
    4: {'Grupo 1': _crearMaterias(4, '3401'), 'Grupo 2': _crearMaterias(4, '3402')},
    5: {'Grupo 1': _crearMaterias(5, '3501'), 'Grupo 2': _crearMaterias(5, '3502')},
    6: {'Grupo 1': _crearMaterias(6, '3601'), 'Grupo 2': _crearMaterias(6, '3602')},
    7: {'Grupo 1': _crearMaterias(7, '3701'), 'Grupo 2': _crearMaterias(7, '3702')},
    8: {'Grupo 1': _crearMaterias(8, '3801'), 'Grupo 2': _crearMaterias(8, '3802')},
    9: {'Grupo 1': _crearMaterias(9, '3901'), 'Grupo 2': _crearMaterias(9, '3902')},
  };

  static List<Map<String, String>> _crearMaterias(int semestre, String grupo) {
    final nombresMaterias = [
      ['Cálculo Diferencial', 'Fundamentos de Programación', 'Taller de Ética', 'Matemáticas Discretas', 'Taller de Administración', 'Álgebra Lineal', 'Taller de Lectura y Redacción'],
      ['Cálculo Integral', 'Programación Orientada a Objetos', 'Contabilidad Financiera', 'Química', 'Sistemas Operativos I', 'Probabilidad y Estadística', 'Taller de Programación'],
      ['Cálculo Vectorial', 'Estructura de Datos', 'Cultura Empresarial', 'Investigación de Operaciones I', 'Taller de Sistemas Operativos', 'Física General', 'Actividades Culturales'],
      ['Ecuaciones Diferenciales', 'Tópicos Avanzados de Programación', 'Métodos Numéricos', 'Fundamentos de Base de Datos', 'Fundamentos de Ingeniería de Software', 'Principios Eléctricos y Aplicaciones Digitales', 'Actividades Deportivas'],
      ['Simulación', 'Fundamentos de Telecomunicaciones', 'Programación Web', 'Taller de Base de Datos', 'Ingeniería de Requerimientos', 'Arquitectura de Computadoras', 'Taller de Emprendedor'],
      ['Lenguajes y Autómatas I', 'Redes de Computadoras', 'Desarrollo Sustentable', 'Administración de Base de Datos', 'Fundamentos de Investigación II', 'Lenguaje de Interfaz', 'Servicio Social'],
      ['Lenguajes y Autómatas II', 'Lenguajes de Programación', 'Inteligencia Artificial', 'Programación Lógica y Funcional', 'Taller de Investigación I', 'Gestión de Proyectos de Software', 'Sistemas Programables'],
      ['Desarrollo de Aplicaciones Móviles', 'Enrutamiento de Redes', 'Modelos y Ciencia de Datos', 'Inteligencia de Negocios', 'Taller de Investigación II', 'Gráficación'],
      ['Internet de las Cosas', 'Analítica Inteligente de Datos', 'Residencia Profesional']
    ];
    return nombresMaterias[semestre-1].map((nombre) => {
      'nombre': nombre,
      'profesor': 'Profesor ${String.fromCharCode(64 + semestre)}${grupo[3]}',
      'grupo': grupo
    }).toList();
  }

  void seleccionarGrupo(int semestre, String grupo) {
    if (_bloqueadoPorCondicion(semestre)) return;
    setState(() {
      selectedGrupo = grupo;
      semestreSeleccionado = semestre;
      materiasDelSemestre = materiasPorSemestre[semestre]?[grupo] ?? [];
    });
  }

  void agregarMateria(Map<String, String> materia) {
    final materiaConSemestre = {...materia, 'semestre': semestreSeleccionado.toString()};
    if (!materiasCargadas.any((m) => m['nombre'] == materia['nombre'] && m['grupo'] == materia['grupo'])) {
      setState(() => materiasCargadas.add(materiaConSemestre));
    }
  }

  void eliminarMateria(int index) => setState(() => materiasCargadas.removeAt(index));

  Future<void> imprimirMaterias() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (context) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Lista de Materias Cargadas', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.Text('Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}'),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          headers: ['Nombre', 'Profesor', 'Grupo'],
          data: materiasCargadas.map((m) => [m['nombre'], m['profesor'], m['grupo']]).toList(),
        ),
      ],
    )));
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  void guardarMaterias() {
    if (materiasCargadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No has seleccionado ninguna materia")));
      return;
    }
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Materias guardadas correctamente'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Flexible(child: SingleChildScrollView(child: Column(
          children: materiasCargadas.map((m) => ListTile(
            title: Text(m['nombre']!),
            subtitle: Text('Profesor: ${m['profesor']}'),
            trailing: Text('Grupo: ${m['grupo']}'),
          )).toList(),
        ))),
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cerrar')),
          SizedBox(width: 8),
          TextButton(onPressed: () async { Navigator.pop(context); await imprimirMaterias(); }, child: Text('Imprimir')),
        ]),
      ]),
    ));
  }

  bool _bloqueadoPorCondicion(int semestre) {
    final cargados = materiasCargadas.map((m) => int.tryParse(m['semestre'] ?? '')).whereType<int>().toSet();
    if (semestre >= 1 && semestre <= 4) return cargados.any((s) => s != semestre && s >= 1 && s <= 4);
    if (semestre >= 5 && semestre <= 9) return cargados.any((s) => s != semestre && s >= 5 && s <= 9);
    return false;
  }

  Widget crearBotonGrupo(int semestre, String grupo) {
    final bloqueado = _bloqueadoPorCondicion(semestre);
    return ElevatedButton.icon(
      onPressed: bloqueado ? null : () => seleccionarGrupo(semestre, grupo),
      icon: bloqueado ? Icon(Icons.lock, size: 14) : SizedBox.shrink(),
      label: Text(grupo, style: TextStyle(fontSize: 12, color: bloqueado ? Colors.black45 : null)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bloqueado ? Colors.grey.shade300 : null,
        foregroundColor: bloqueado ? Colors.black45 : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MATERIAS'),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5561D4), Color(0xFF0D47A1)],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Menú principal",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text("Datos"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DatosAlumno()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text("Consulta"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ConsultaScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text("Selección"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SeleccionScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text("Estadísticas"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const EstadisticasScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text("Carga de Archivos"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Cargadearchivos()),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text("SEMESTRE AL QUE CURSARÁS", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(5, (i) => Expanded(
                        child: Column(
                          children: [
                            Text("Semestre ${i+1}", style: TextStyle(fontWeight: FontWeight.bold)),
                            if (materiasPorSemestre.containsKey(i+1))
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: materiasPorSemestre[i+1]!.keys.map((g) => crearBotonGrupo(i+1, g)).toList(),
                              ),
                          ],
                        ),
                      )),
                    ),
                    Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(4, (i) => Expanded(
                        child: Column(
                          children: [
                            Text("Semestre ${i+6}", style: TextStyle(fontWeight: FontWeight.bold)),
                            if (materiasPorSemestre.containsKey(i+6))
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: materiasPorSemestre[i+6]!.keys.map((g) => crearBotonGrupo(i+6, g)).toList(),
                              ),
                          ],
                        ),
                      )),
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
                  itemBuilder: (context, i) => ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.add, color: Colors.red),
                      onPressed: () => agregarMateria(materiasDelSemestre[i]),
                    ),
                    title: Text(materiasDelSemestre[i]['nombre']!),
                    subtitle: Text("Profesor: ${materiasDelSemestre[i]['profesor']}"),
                    trailing: Text("Grupo: ${materiasDelSemestre[i]['grupo']}"),
                  ),
                ),
              ),
            ],
            Divider(),
            Text("MATERIAS CARGADAS", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: materiasCargadas.length,
                itemBuilder: (context, i) => ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.remove, color: Colors.blue),
                    onPressed: () => eliminarMateria(i),
                  ),
                  title: Text(materiasCargadas[i]['nombre']!),
                  subtitle: Text("Profesor: ${materiasCargadas[i]['profesor']}"),
                  trailing: Text("Grupo: ${materiasCargadas[i]['grupo']}"),
                ),
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

// ---------------- ESTADÍSTICAS ----------------
class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  int selectedSemester = 1;

  final Map<int, List<double>> datosPorSemestre = {
    1: [85, 78, 92],
    2: [88, 90, 84],
    3: [75, 80, 70],
    4: [60, 70, 65],
    5: [95, 92, 88],
    6: [78, 85, 80],
    7: [70, 60, 75],
    8: [88, 85, 90],
    9: [77, 69, 73],
  };

  String getEscalaConceptual(double promedio) {
    if (promedio >= 90) return 'Excelente';
    if (promedio >= 80) return 'Notable';
    if (promedio >= 70) return 'Bueno';
    if (promedio >= 60) return 'Suficiente';
    return 'Insuficiente';
  }

  void selectSemester(int semester) {
    setState(() {
      selectedSemester = semester;
    });
  }

  Color getColorForValue(double value) {
    if (value >= 90) return Colors.greenAccent.shade700;
    if (value >= 70) return Colors.amber;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final List<double> notas = datosPorSemestre[selectedSemester]!;
    final double promedio = notas.reduce((a, b) => a + b) / notas.length;
    final String escala = getEscalaConceptual(promedio);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Estadísticas Académicas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 2,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5561D4), Color(0xFF0D47A1)],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Menú principal",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text("Datos"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DatosAlumno()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text("Consulta"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ConsultaScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text("Selección"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SeleccionScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text("Estadísticas"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const EstadisticasScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text("Carga de Archivos"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Cargadearchivos()),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Selecciona el semestre:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: List.generate(
                  9,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (selectedSemester == index + 1)
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedSemester == index + 1
                            ? const Color(0xFF0D47A1)
                            : const Color(0xFFE0E0E0),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: () => selectSemester(index + 1),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: selectedSemester == index + 1
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Gráfica de rendimiento',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: SizedBox(
                  key: ValueKey(selectedSemester),
                  height: 150,
                  child: BarChart(
                    BarChartData(
                      maxY: 100,
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const labels = ['P1', 'P2', 'P3'];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  labels[value.toInt()],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(notas.length, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: notas[i],
                              width: 18,
                              color: getColorForValue(notas[i]),
                              borderRadius: BorderRadius.circular(6),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 100,
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        ' Resumen del Semestre',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(3),
                      },
                      border: TableBorder(
                        horizontalInside: BorderSide(color: Colors.grey.shade300),
                      ),
                      children: [
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                '📊 Promedio:',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                '${promedio.toStringAsFixed(2)}%',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                '🧠 Conceptual:',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                escala,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                '🔢 Numérica:',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                promedio.toInt().toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------CARGA DE ARCHIVO ----------------
class Cargadearchivos extends StatefulWidget {
  const Cargadearchivos({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CargadearchivosState createState() => _CargadearchivosState();
}

class _CargadearchivosState extends State<Cargadearchivos> {
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
        const SnackBar(
          content: Text('El archivo debe ser menor a 1000 KB'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );
    }
  }

  // Ejemplo función para el botón nuevo
  void botonAccion(String tipoArchivo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Acción ejecutada para: $tipoArchivo'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget buildItem(
    String titulo,
    String? archivoNombre,
    Function(String) onFileSelected,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => seleccionarArchivo(onFileSelected),
              icon: const Icon(Icons.attach_file),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0D47A1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              label: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  archivoNombre ?? "Adjuntar archivo\n(1000 KB)",
                  key: ValueKey<String?>(archivoNombre),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => botonAccion(titulo),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              child: const Icon(Icons.info_outline, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carga de archivos"),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5561D4), Color(0xFF0D47A1)],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Menú principal",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text("Datos"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DatosAlumno()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text("Consulta"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ConsultaScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text("Selección"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SeleccionScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text("Estadísticas"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const EstadisticasScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text("Carga de Archivos"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Cargadearchivos()),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0E0E0), Color(0xFFE0E0E0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ListView(
          children: [
            Center(
              child: Text(
                "Suba sus archivos\npara concluir su reinscripción",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  height: 1.4,
                  shadows: [
                    Shadow(offset: Offset(0.5, 1), blurRadius: 2, color: Colors.grey),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Documentos requeridos:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Divider(thickness: 1.2),
            const SizedBox(height: 16),
            buildItem("Comprobante de pago", archivoPago, (value) {
              setState(() => archivoPago = value);
            }),
            const SizedBox(height: 16),
            buildItem("Boleta de semestre anterior", archivoBoleta, (value) {
              setState(() => archivoBoleta = value);
            }),
            const SizedBox(height: 16),
            buildItem("Solicitud de aprovechamiento académico", archivoSolicitud, (value) {
              setState(() => archivoSolicitud = value);
            }),
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
                    SnackBar(
                      content: const Text("Archivos subidos"),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0D47A1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 4,
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

 
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;

  void _incrementCounter() {
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
      
        child: Column(
         
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
      ), 
    );
  }
}
