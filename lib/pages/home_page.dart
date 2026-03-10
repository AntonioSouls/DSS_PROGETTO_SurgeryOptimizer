import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


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
          // Immagine di sfondo
          Positioned.fill(
            child: Opacity(
              opacity: 1,
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

    return Container(
      color: Colors.white,                      // Sfondo bianco per l'header
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),  // Padding interno per distanziare il contenuto dai bordi
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
              letterSpacing: 0.4,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                ).createShader(const Rect.fromLTWH(0, 0, 300, 70),),
            ),
          ),

          // Spacer per lasciare spazio alle icone
          const Spacer(),

          // Icona di GitHub
          IconButton(
            tooltip: "GitHub",
            onPressed: () {
              _openLink('https://github.com/AntonioSouls');
            },
            icon: const FaIcon(
              FontAwesomeIcons.github,
              size: 50,
              color: Colors.black87,
            ),
          ),

          // Spazio tra le icone
          const SizedBox(width: 20),

          // Icona di LinkedIn
          IconButton(
            tooltip: "LinkedIn",
            onPressed: () {
              _openLink('https://www.linkedin.com/in/antonio-lanza-25a342246');
            },
            icon: const FaIcon(
              FontAwesomeIcons.linkedin,
              size: 50,
              color: Color(0xFF0A66C2),
            ),
          ),

          // Spazio finale a destra
          const SizedBox(width: 90),
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
      elevation: 40,                   // Ombreggiatura della Card per darle profondità
      color: Colors.white,           // Sfondo bianco per la Card
      shape: RoundedRectangleBorder(      // Bordo arrotondato
        borderRadius: BorderRadius.circular(35),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),   // Padding interno per distanziare il contenuto dai bordi della Card
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Titolo principale della Card, sfumato come il logo
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [ Color(0xFF4F46E5), Color(0xFF06B6D4),],
              ).createShader(bounds),
              child: Text(
                'Ottimizza la Programmazione degli Interventi Chirurgici',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  height: 1.2,
                  color: Colors.white,          // Il colore del testo è bianco, ma sarà mascherato dal gradiente
                ),
              ),
            ),

            // Spazio tra il titolo e la descrizione
            const SizedBox(height: 24),

            // Descrizione della funzionalità dell'app, con uno stile più leggero
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Surgery Optimizer ',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,   // grassetto
                      letterSpacing: 0.3,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text:
                        'è un’applicazione progettata per semplificare e ottimizzare la programmazione degli interventi chirurgici, migliorando l’efficienza e la gestione delle risorse ospedaliere.',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),

            // Spazio tra la descrizione e i bottoni
            const SizedBox(height: 30),

            // Se lo schermo è stretto (mobile), i bottoni sono disposti in colonna, altrimenti in riga
            isCompact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _CtaButtons(
                        icon: Icons.calendar_month,
                        label: 'Programmazione Mensile',
                        onPressed: () => _showSnack(
                          context,
                          'Programmazione Mensile selezionata',
                        ),
                      ),
                      const SizedBox(height: 12),
                      _CtaButtons(
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
                        child: _CtaButtons(
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
                        child: _CtaButtons(
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


// CLASSE CHE DEFINISCE LO STILE E IL COMPORTAMENTO DEI BOTTONI DI AZIONE
class _CtaButtons extends StatelessWidget {
  const _CtaButtons({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}


// PROVVISORIA
void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ),
  );
}


// FUNZIONE PER APRIRE UN LINK ESTERNO (UTILE PER LE ICONE DI LINKEDIN E GITHUB PRESENTI NELL'HEADER)
Future<void> _openLink(String url) async {
  final uri = Uri.parse(url);

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Impossibile aprire il link: $url');
  }
}