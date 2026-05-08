import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 768;
    final isNarrow = width < 480;

    final hPadding = isNarrow
        ? 16.0
        : isMobile
            ? 24.0
            : width < 1200
                ? 60.0
                : 100.0;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const _AppHeader(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Align(
                            alignment: isMobile
                                ? Alignment.center
                                : Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: hPadding,
                                vertical: 24,
                              ),
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 700),
                                child: const _HeroCard(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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


class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 600;

    final logoSize = isNarrow ? 40.0 : 50.0;
    final titleFontSize = isNarrow ? 22.0 : 35.0;
    final iconSize = isNarrow ? 30.0 : 44.0;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 16 : 24,
        vertical: isNarrow ? 12 : 18,
      ),
      child: Row(
        children: [
          Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isNarrow ? 14 : 20),
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
              ),
            ),
            child: Icon(Icons.add_chart, color: colors.onPrimary),
          ),
          SizedBox(width: isNarrow ? 10 : 15),
          Flexible(
            child: Text(
              'Surgery Optimizer',
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                  ).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: "GitHub",
            onPressed: () => _openLink('https://github.com/AntonioSouls'),
            icon: FaIcon(
              FontAwesomeIcons.github,
              size: iconSize,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: isNarrow ? 4 : 16),
          IconButton(
            tooltip: "LinkedIn",
            onPressed: () =>
                _openLink('https://www.linkedin.com/in/antonio-lanza-25a342246'),
            icon: FaIcon(
              FontAwesomeIcons.linkedin,
              size: iconSize,
              color: const Color(0xFF0A66C2),
            ),
          ),
          SizedBox(width: isNarrow ? 0 : 40),
        ],
      ),
    );
  }
}


class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 480;
    final isCompact = width < 768;

    final titleSize = isNarrow ? 24.0 : isCompact ? 28.0 : 35.0;
    final descSize = isNarrow ? 15.0 : 18.0;

    return Card(
      elevation: 40,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: EdgeInsets.all(isNarrow ? 20 : 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
              ).createShader(bounds),
              child: Text(
                'Ottimizza la Programmazione degli Interventi Chirurgici',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  height: 1.2,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Surgery Optimizer ',
                    style: GoogleFonts.inter(
                      fontSize: descSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text:
                        'è un’applicazione progettata per semplificare e ottimizzare la programmazione degli interventi chirurgici, migliorando l’efficienza e la gestione delle risorse ospedaliere.',
                    style: GoogleFonts.inter(
                      fontSize: descSize,
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
            SizedBox(height: isNarrow ? 20 : 30),
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
                        onPressed: () =>
                            Navigator.pushNamed(context, '/interventions'),
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
                          onPressed: () =>
                              Navigator.pushNamed(context, '/interventions'),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
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


Future<void> _openLink(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Impossibile aprire il link: $url');
  }
}
