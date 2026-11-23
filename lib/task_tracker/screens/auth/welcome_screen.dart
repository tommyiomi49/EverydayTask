import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/notebook_card.dart';
import '../../widgets/washi_tape.dart';
import '../home/main_navigation_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

/// TaskTracker Welcome & Splash Screen
/// Extracted from Stitch Screen: 3c585acf9cc946f591d4698c794c32f9
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoggingInGuest = false;

  Future<void> _handleGuestTour() async {
    setState(() => _isLoggingInGuest = true);
    try {
      // Demo student account from seed data
      var user = await AuthService.instance.login(
        'alex.morales@gmail.com',
        'password123',
      );

      // Fallback if not found: register demo user
      user ??= await AuthService.instance.register(
        fName: 'Alex',
        lName: 'Morales',
        gmail: 'alex.morales@gmail.com',
        password: 'password123',
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => MainNavigationScreen(currentUser: user!),
          ),
        );
      }
    } catch (_) {
      // If error occurs, fallback to normal LoginScreen
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoggingInGuest = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paperSurface,
      body: Stack(
        children: [
          // Spiral Binder Spine Edge (Left notebook binding holes)
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: 14,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  16,
                  (index) => Container(
                    width: 14,
                    height: 7,
                    decoration: BoxDecoration(
                      color: AppTheme.outlineVariant.withAlpha(160),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppTheme.inkColor.withAlpha(70),
                        width: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Main Scrollable Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(36, 16, 24, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top Washi Tape Sticker
                      WashiTape(
                        width: 210,
                        height: 28,
                        color: AppTheme.paperWhite,
                        rotation: -1.0,
                        text: 'Study Smart • Grade High',
                        icon: Icons.edit_note_rounded,
                      ),
                      const SizedBox(height: 18),

                      // Mascot Notebook Hero Card
                      NotebookCard(
                        backgroundColor: AppTheme.paperWhite,
                        hasPaperclip: true,
                        hasWashiTape: true,
                        washiColor: AppTheme.pastelMint.withAlpha(200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          children: [
                            // Hero Icon with sparkles
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: AppTheme.pastelYellow,
                                    borderRadius: BorderRadius.circular(20),
                                    border: AppTheme.doodleBorder(2.5),
                                    boxShadow: AppTheme.doodleShadow(3.0),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.auto_stories_rounded,
                                      size: 48,
                                      color: AppTheme.inkColor,
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  top: -8,
                                  right: -10,
                                  child: Text('✨', style: TextStyle(fontSize: 22)),
                                ),
                                const Positioned(
                                  bottom: -6,
                                  left: -8,
                                  child: Text('✏️', style: TextStyle(fontSize: 20)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Brand Heading
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'TaskTracker',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.textPrimary,
                                      ),
                                ),
                                const SizedBox(width: 4),
                                const Text('📌', style: TextStyle(fontSize: 22)),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Tagline Banner
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.pastelYellow,
                                borderRadius: BorderRadius.circular(6),
                                border: AppTheme.doodleBorder(1.5),
                                boxShadow: AppTheme.doodleShadow(1.5),
                              ),
                              child: Text(
                                'Stay Organized, Never Miss a Deadline!',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.onPrimaryContainer,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Washi Feature Highlight Pills
                      _buildFeaturePill(
                        context,
                        emoji: '📝',
                        title: 'Subject Notebooks & Color Tags',
                        icon: Icons.check_circle_rounded,
                        color: AppTheme.pastelLilac,
                        rotation: -1.0,
                      ),
                      const SizedBox(height: 10),
                      _buildFeaturePill(
                        context,
                        emoji: '⏰',
                        title: 'Smart Gentle Reminders',
                        icon: Icons.notifications_active_rounded,
                        color: AppTheme.pastelMint,
                        rotation: 1.0,
                      ),
                      const SizedBox(height: 10),
                      _buildFeaturePill(
                        context,
                        emoji: '📅',
                        title: 'Interactive Planner & Milestones',
                        icon: Icons.calendar_month_rounded,
                        color: AppTheme.primaryFixed,
                        rotation: -0.5,
                      ),
                      const SizedBox(height: 18),

                      // Pinned Student Quote Sticky Note
                      NotebookCard(
                        backgroundColor: AppTheme.paperWhite,
                        tiltAngle: 1.0,
                        hasThumbtack: true,
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('💬', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '"Finally an assignment tracker that feels like my bullet journal, without the anxiety!"',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    '— Maya S., High School Junior',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.textOutline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Primary Action: Get Started Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.pastelYellow,
                            foregroundColor: AppTheme.inkColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(
                                  color: AppTheme.inkColor, width: 2.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('🚀', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Secondary CTA: Log In
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                            children: const [
                              TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Log In',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Guest Tour Action
                      if (_isLoggingInGuest)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        )
                      else
                        TextButton.icon(
                          onPressed: _handleGuestTour,
                          icon: const Text('Take a quick tour as guest',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textOutline,
                              )),
                          label: const Icon(Icons.arrow_forward_rounded,
                              size: 14, color: AppTheme.textOutline),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePill(
    BuildContext context, {
    required String emoji,
    required String title,
    required IconData icon,
    required Color color,
    required double rotation,
  }) {
    return Transform.rotate(
      angle: rotation * (math.pi / 180),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: AppTheme.doodleBorder(1.8),
          boxShadow: AppTheme.doodleShadow(2.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 17)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.inkColor,
                      ),
                ),
              ],
            ),
            Icon(icon, size: 18, color: AppTheme.inkColor),
          ],
        ),
      ),
    );
  }
}
