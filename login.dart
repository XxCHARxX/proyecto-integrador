import 'package:flutter/material.dart';

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
        primaryColor: const Color(0xFF40E0D0),
        scaffoldBackgroundColor: const Color(0xFFE0FFFF),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF40E0D0),
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          prefixIconColor: Colors.teal,
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
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text("Iniciar Sesión", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                buildInputField("Correo electrónico", Icons.email, false, emailController),
                buildInputField("Contraseña", Icons.lock, true, passwordController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40E0D0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text("Iniciar sesión", style: TextStyle(fontSize: 16)),
                ),
                TextButton(onPressed: _resetPassword, child: const Text("¿Olvidaste tu contraseña?")),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen())),
                  child: const Text("Registrarse"),
                ),
              ],
            ),
          ),
        ),
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

  RegisterScreen({super.key});

  void _register(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DatosAlumno()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildInputField("Nombre", Icons.person, false, nombreController),
            buildInputField("Apellido", Icons.person_outline, false, apellidoController),
            buildInputField("Matrícula", Icons.confirmation_number, false, matriculaController),
            buildInputField("Ciudad", Icons.location_city, false, ciudadController),
            buildInputField("Calle", Icons.home, false, calleController),
            buildInputField("Correo electrónico", Icons.email, false, emailController),
            buildInputField("Contraseña", Icons.lock, true, passwordController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _register(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40E0D0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("Registrar"),
            ),
          ],
        ),
      ),
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
  final TextEditingController materiaController = TextEditingController();
  final TextEditingController semestreController = TextEditingController();
  final TextEditingController estatusController = TextEditingController();
  final TextEditingController promedioController = TextEditingController();

  void _continuar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pasando al siguiente paso.')));
    }
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Datos guardados exitosamente.')));
    }
  }

  void _cancelar() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos del Alumno')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField("Matrícula", matriculaController),
              _buildField("Nombre", nombreController),
              _buildField("CURP", curpController),
              _buildField("Sexo", sexoController),
              _buildField("Domicilio", domicilioController),
              _buildField("Teléfono de casa", telefonoCasaController),
              _buildField("Teléfono de trabajo", telefonoTrabajoController),
              _buildField("Teléfono celular", telefonoCelularController),
              _buildField("Materia", materiaController),
              _buildField("Semestre", semestreController),
              _buildField("Estatus", estatusController),
              _buildField("Promedio", promedioController),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: _cancelar, child: const Text('Cancelar')),
                  ElevatedButton(onPressed: _guardar, child: const Text('Guardar')),
                  ElevatedButton(onPressed: _continuar, child: const Text('Continuar')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
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
                gradient: LinearGradient(colors: [Colors.teal, Colors.tealAccent]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.account_circle, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text("Menú principal", style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            buildMenuItem("Datos", Icons.insert_drive_file, context, screen: const DatosAlumno()),
            buildMenuItem("Consulta", Icons.search, context, screen: const ConsultaScreen()),
            buildMenuItem("Selección", Icons.check_circle, context, screen: const SeleccionScreen()),
            buildMenuItem("Estadísticas", Icons.bar_chart, context, screen: const EstadisticasScreen()),
            buildMenuItem("CARGA DE ARCHIVOS", Icons.upload, context, screen: const Cargadearchivos()),
            buildMenuItem("Cerrar sesión", Icons.exit_to_app, context, logout: true),
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
Widget buildMenuItem(String title, IconData icon, BuildContext context, {Widget? screen, bool logout = false}) {
  return ListTile(
    leading: Icon(icon, color: const Color(0xFF40E0D0)),
    title: Text(title),
    onTap: () {
      if (logout) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
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
            DataRow(cells: [
              DataCell(Text("Matemáticas")),
              DataCell(Text("7")),
              DataCell(Text("Activo")),
              DataCell(Text("9.0")),
            ]),
            DataRow(cells: [
              DataCell(Text("Programación")),
              DataCell(Text("8")),
              DataCell(Text("Activo")),
              DataCell(Text("8.5")),
            ]),
          ],
        ),
      ),
    );
  }
}

// ---------------- SELECCIÓN ----------------
class SeleccionScreen extends StatelessWidget {
  const SeleccionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selección")),
      body: const Center(child: Text("Pantalla de Selección")),
    );
  }
}

// ---------------- ESTADÍSTICAS ----------------
class EstadisticasScreen extends StatelessWidget {
  const EstadisticasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Estadísticas")),
      body: const Center(child: Text("Pantalla de Estadísticas")),
    );
  }
}

// ---------------CARGA DE ARCHIVO ----------------
class Cargadearchivos extends StatelessWidget {
  const Cargadearchivos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Estadísticas")),
      body: const Center(child: Text("Pantalla de Estadísticas")),
    );
  }
}

// ---------------- INPUT FIELD SHARED ----------------
Widget buildInputField(String hint, IconData icon, bool isPassword, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.teal),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
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
