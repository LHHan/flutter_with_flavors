import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  /// Start services later
  WidgetsFlutterBinding.ensureInitialized();

  /// Load environment and set app config
  await _loadEnvironment();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter with flavors',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
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

/// Environments type enum declare here
enum EnvType { dev, prod }

/// Environment declare here
class Env {
  Env._({
    required this.envType,
    required this.apiBaseUrl,
  });

  final EnvType envType;
  final String apiBaseUrl;

  /// Dev mode
  factory Env.dev() {
    return Env._(
      envType: EnvType.dev,
      apiBaseUrl: 'https://devapi.lehoha.app.com',
    );
  }

  /// Prod mode
  factory Env.prod() {
    return Env._(
      envType: EnvType.prod,
      apiBaseUrl: 'https://prodapi.lehoha.app.com',
    );
  }
}

/// Config env
class AppConfig {
  factory AppConfig({required Env env}) {
    I.env = env;
    return I;
  }

  AppConfig._private();

  static final AppConfig I = AppConfig._private();

  Env env = Env.dev();
}

Future<void> _loadEnvironment() async {
  /// Get Flavor value from native via method channel
  String? flavor =
      await const MethodChannel('flavor').invokeMethod<String>('getFlavor');

  if (flavor == EnvType.dev.name) {
    AppConfig(env: Env.dev());
  } else if (flavor == EnvType.prod.name) {
    AppConfig(env: Env.prod());
  } else {
    throw Exception("Unknown flavor: $flavor");
  }
}
