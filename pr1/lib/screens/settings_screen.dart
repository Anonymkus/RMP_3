import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    context.read<SettingsBloc>().add(LoadSettings());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SettingsLoaded) {
            final settings = state.settings;
            if (_nameController.text != settings.userName) {
              _nameController.text = settings.userName;
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Тема приложения',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: SwitchListTile(
                      title: const Text('Тёмная тема'),
                      subtitle: Text(
                        settings.isDark ? 'Включена' : 'Выключена',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      value: settings.isDark,
                      onChanged: (bool value) {
                        context.read<SettingsBloc>().add(UpdateTheme(value));
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  Text(
                    'Пользователь',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              Text(
                                'Ваше имя',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: 'Введите ваше имя',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {
                              context.read<SettingsBloc>().add(UpdateUserName(value));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                
                  Text(
                    'Дополнительные опции',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Card(
                    child: SwitchListTile(
                      title: const Text('Показывать подсказки'),
                      subtitle: Text(
                        settings.showHints ? 'Включены' : 'Выключены',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      value: settings.showHints
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}



