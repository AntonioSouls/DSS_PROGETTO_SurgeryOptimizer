import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// CLASSE CHE DEFINISCE LO STILE ED IL COMPORTAMENTO DELLA PAGINA PRINCIPALE DELL'APP
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;   // Leggo la larghezza dello schermo per adattare il layout
    final isMobile = width < 800;                     // Se la larghezza è inferiore a 800 pixel, considero il dispositivo come mobile

    return Scaffold(
      body: Stack(
        children: [
          // Colore sfondo
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4F46E5), // viola
                    Color(0xFF06B6D4), // ciano
                  ],
                ),
              ),
            ),
          ),
          // Immagine di sfondo
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                "assets/images/background.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Sovrapposizione semitrasparente per migliorare la leggibilità del testo
          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
          // Contenuto della pagina, inserito nella SafeArea per evitare sovrapposizioni con notch o barre di sistema
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 15), // Spazio verticale tra il bordo superiore e l'header
                const _AppHeader(),     // Header dell'app con logo e titolo (definiti in una funzione separata)
                // Dopo l'header, occupiamo tutto lo spazio rimanente con il contenuto principale, che è centrato e ha un padding adattivo in base alla dimensione dello schermo
                Expanded(
                  child: Align(
                    alignment:
                        isMobile ? Alignment.center : Alignment.centerRight,  // Se è mobile, centro il contenuto, altrimenti lo allineo a destra
                    child: Padding(                                         // Padding adattivo
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 20 : 100,                   // Più spazio orizzontale su desktop, meno su mobile
                        vertical: 24,                                     // Padding verticale costante
                      ),
                      child: ConstrainedBox(                                // Limitiamo la larghezza massima del contenuto per evitare che diventi troppo largo su schermi grandi
                        constraints: const BoxConstraints(maxWidth: 700), 
                        child: const _HeroCard(), // Card principale con titolo, descrizione e bottoni (definita in una funzione separata)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// CLASSE CHE DEFINISCE L'HEADER DELL'APP, CON LOGO E TITOLO
class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(                                 // Posiziono i vari elementi dell'header in una riga (orizzontale)
        children: [
          // Contenitore in cui inserisco il logodell'app
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
              ),
            ),
            child: Icon(Icons.add_chart, color: colors.onPrimary),
          ),

          // Spazio tra il logo e il titolo
          const SizedBox(width: 15),
          
          // Titolo dell'app, con uno stile personalizzato
          Text(
            'Surgery Optimizer',
            style: GoogleFonts.inter(
              fontSize: 35,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.4,
              shadows: const [
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 8,
                  color: Colors.black26,
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}


// CLASSE CHE DEFINISCE LA CARD PRINCIPALE NELLA HOME, CON TITOLO, DESCRIZIONE E BOTTONI DI AZIONE
class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 600;

    return Card(
      elevation: 10,
      color: Colors.white.withValues(alpha: 0.88),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedula e Visualizza gli interventi per il tuo ospedale',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    fontSize: isCompact ? 30 : 36,
                  ),
            ),
            const SizedBox(height: 24),
            isCompact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _PrimaryCtaButton(
                        icon: Icons.calendar_month,
                        label: 'Programmazione Mensile',
                        onPressed: () => _showSnack(
                          context,
                          'Programmazione Mensile selezionata',
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SecondaryCtaButton(
                        icon: Icons.playlist_add,
                        label: 'Inserimento Interventi',
                        onPressed: () => _showSnack(
                          context,
                          'Inserimento Interventi selezionato',
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _PrimaryCtaButton(
                          icon: Icons.calendar_month,
                          label: 'Programmazione Mensile',
                          onPressed: () => _showSnack(
                            context,
                            'Programmazione Mensile selezionata',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SecondaryCtaButton(
                          icon: Icons.playlist_add,
                          label: 'Inserimento Interventi',
                          onPressed: () => _showSnack(
                            context,
                            'Inserimento Interventi selezionato',
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryCtaButton extends StatelessWidget {
  const _PrimaryCtaButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _SecondaryCtaButton extends StatelessWidget {
  const _SecondaryCtaButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}


void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ),
  );
}