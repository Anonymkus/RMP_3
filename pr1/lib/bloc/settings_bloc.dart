import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  final bool isDark;
  final String userName;
  final bool showHints;

  const Settings({
    required this.isDark,
    required this.userName,
    required this.showHints,
  });

  Settings copyWith({
    bool? isDark,
    String? userName,
    bool? showHints,
  }) {
    return Settings(
      isDark: isDark ?? this.isDark,
      userName: userName ?? this.userName,
      showHints: showHints ?? this.showHints,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDark': isDark,
      'userName': userName,
      'showHints': showHints,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      isDark: json['isDark'] ?? false,
      userName: json['userName'] ?? '',
      showHints: json['showHints'] ?? true,
    );
  }

  factory Settings.defaultSettings() {
    return const Settings(
      isDark: false,
      userName: '',
      showHints: true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Settings &&
        other.isDark == isDark &&
        other.userName == userName &&
        other.showHints == showHints;
  }

  @override
  int get hashCode {
    return isDark.hashCode ^ userName.hashCode ^ showHints.hashCode;
  }

  @override
  String toString() {
    return 'Settings(isDark: $isDark, userName: $userName, showHints: $showHints)';
  }
}

abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class UpdateTheme extends SettingsEvent {
  final bool isDark;
  UpdateTheme(this.isDark);
}

class UpdateUserName extends SettingsEvent {
  final String userName;
  UpdateUserName(this.userName);
}

class UpdateShowHints extends SettingsEvent {
  final bool showHints;
  UpdateShowHints(this.showHints);
}

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Settings settings;
  SettingsLoaded(this.settings);
}

class SettingsLoading extends SettingsState {}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  static const String _themeKey = 'isDark';
  static const String _userNameKey = 'userName';
  static const String _showHintsKey = 'showHints';

  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateTheme>(_onUpdateTheme);
    on<UpdateUserName>(_onUpdateUserName);
    on<UpdateShowHints>(_onUpdateShowHints);
  }

  Future<void> _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final settings = Settings(
      isDark: prefs.getBool(_themeKey) ?? false,
      userName: prefs.getString(_userNameKey) ?? '',
      showHints: prefs.getBool(_showHintsKey) ?? true,
    );
    emit(SettingsLoaded(settings));
  }

  Future<void> _onUpdateTheme(UpdateTheme event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, event.isDark);
    
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(isDark: event.isDark);
      emit(SettingsLoaded(updatedSettings));
    }
  }

  Future<void> _onUpdateUserName(UpdateUserName event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, event.userName);
    
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(userName: event.userName);
      emit(SettingsLoaded(updatedSettings));
    }
  }

  Future<void> _onUpdateShowHints(UpdateShowHints event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showHintsKey, event.showHints);
    
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(showHints: event.showHints);
      emit(SettingsLoaded(updatedSettings));
    }
  }
}
