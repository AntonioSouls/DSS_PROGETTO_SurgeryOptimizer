import 'package:flutter/material.dart';
import 'package:surgery_optimizer/pages/home_page.dart';
import 'package:surgery_optimizer/pages/not_found_page.dart';

// STARTER DELL'APP
void main() {
  runApp(const SurgeryOptimizer());   // Crea un'istanza del widget SurgeryOptimizer e la esegue, avviando l'app
}

// WIDGET PRINCIPALE DELL'APP, CHE DEFINISCE IL TEMA DI TUTTA L'APPLICAZIONE E LA NAVIGAZIONE DELLE ROTTE
class SurgeryOptimizer extends StatelessWidget {
  const SurgeryOptimizer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Surgery Optimizer',         // Titolo dell'app
      theme: ThemeData(                   
        colorScheme: ColorScheme.fromSeed(      // Definisce la palette di colori dell'app a partire da un colore seed
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),   // Colore di sfondo predefinito per tutte le pagine dell'app
        useMaterial3: true,         // Abilita il supporto per Material Design 3, che include stili e componenti aggiornati
      ),
      onGenerateRoute: (settings) {       // Gestisce la generazione delle rotte in base al nome della rotta richiesta
        if (settings.name == '/') {            
          return MaterialPageRoute<void>(
            builder: (_) => const HomePage(),
            settings: settings,
          );
        }

        return MaterialPageRoute<void>(
          builder: (_) => NotFoundPage(path: settings.name ?? 'unknown'),
          settings: settings,
        );
      },
    );
  }
}



