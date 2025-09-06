import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/settings_bloc.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc()..add(LoadSettings()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          bool isDark = false;
          
          if (state is SettingsLoaded) {
            isDark = state.settings.isDark;
          }

          return MaterialApp(
            title: 'PR1',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 58, 116, 183),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 58, 183, 100),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: const MyHomePage(title: 'PR1'),
          );
        },
      ),
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

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          String userName = '';
          
          if (state is SettingsLoaded) {
            userName = state.settings.userName;
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (userName.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 32),
                ] else ...[
                  Text(
                    'Имя не введено',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
                const SizedBox(height: 16),
                  Text(
                    'Настройки',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: _openSettings,
                    tooltip: 'Настройки',
                  ),
                  const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
