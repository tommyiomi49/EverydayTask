import 'package:flutter/material.dart';
import '../../models/schoolwork_with_subject.dart';
import '../../models/user_model.dart';
import '../../services/schoolwork_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/notebook_card.dart';
import '../../widgets/ruler_progress_bar.dart';
import '../../widgets/schoolwork_card.dart';
import '../../widgets/stats_card.dart';
import '../schoolworks/add_edit_schoolwork_screen.dart';
import '../schoolworks/schoolwork_detail_screen.dart';

/// TaskTracker Home Dashboard Screen
/// Extracted from Stitch Screen: 93dd4f304f094b8d88d9f882b86bde2e
class DashboardTab extends StatefulWidget {
  final UserModel currentUser;
  final VoidCallback onNavigateToSchoolworks;
  final VoidCallback onNavigateToSubjects;

  const DashboardTab({
    Key? key,
    required this.currentUser,
    required this.onNavigateToSchoolworks,
    required this.onNavigateToSubjects,
  }) : super(key: key);

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  DashboardStats? _stats;
  bool _isLoading = true;
  String _activeFilter = 'all'; // 'all', 'high', 'today'

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    final userId = widget.currentUser.userId;
    try {
      if (userId != null) {
        final stats = await SchoolworkService.instance.getDashboardStats(userId);
        if (mounted) {
          setState(() {
            _stats = stats;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading dashboard: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatTodayDate() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  List<SchoolworkWithSubject> get _filteredWorks {
    final urgent = _stats?.urgentWorks ?? [];
    if (_activeFilter == 'high') {
      return urgent
          .where((w) => w.priority.toLowerCase() == 'high')
          .toList();
    } else if (_activeFilter == 'today') {
      return urgent.where((w) => w.isDueToday).toList();
    }
    return urgent;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final stats = _stats;
    final filteredWorks = _filteredWorks;

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          // 1. Top Greeting Sticky Note with Washi Tape
          NotebookCard(
            backgroundColor: AppTheme.pastelYellow,
            tiltAngle: -0.5,
            hasWashiTape: true,
            washiColor: AppTheme.pastelLilac.withAlpha(220),
            showRuledLines: true,
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Hello, ${widget.currentUser.fName}!',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            const Text('✏️', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                size: 14, color: AppTheme.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              _formatTodayDate(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Handwritten Weather Doodle Badge
                    Transform.rotate(
                      angle: 2.0 * (3.14159 / 180),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.paperSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: AppTheme.doodleBorder(1.5),
                          boxShadow: AppTheme.doodleShadow(1.5),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.wb_sunny_rounded,
                                size: 18, color: AppTheme.primary),
                            SizedBox(height: 2),
                            Text(
                              '68°F Sun ☀️',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Motivational Scribble Note with dashed divider
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0x33786833),
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          stats != null && stats.pendingCount > 0
                              ? "You've got ${stats.pendingCount} assignments this week! You can do it!"
                              : "All assignments completed! You're on top of everything!",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('✨', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Weekly Goal / Ruler Progress Bar
          RulerProgressBar(
            progress: stats?.overallProgress ?? 0.0,
            label: 'Weekly Goal Tracker',
          ),
          const SizedBox(height: AppTheme.spaceMd),

          // 3. 2x2 Grid of Sticky Notes
          Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Active Subjects',
                  value: '${stats?.totalSubjects ?? 0}',
                  icon: Icons.folder_copy_rounded,
                  color: AppTheme.pastelLilac,
                  badge: 'Sem 1',
                  tilt: -1.0,
                  onTap: widget.onNavigateToSubjects,
                ),
              ),
              const SizedBox(width: AppTheme.spaceSm),
              Expanded(
                child: StatsCard(
                  title: 'Schoolworks Total',
                  value: '${stats?.totalSchoolworks ?? 0}',
                  icon: Icons.auto_stories_rounded,
                  color: AppTheme.pastelYellow,
                  emoji: '📚',
                  tilt: 1.0,
                  onTap: widget.onNavigateToSchoolworks,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Pending Tasks',
                  value: '${stats?.pendingCount ?? 0}',
                  icon: Icons.alarm_rounded,
                  color: AppTheme.pastelPink,
                  badge: 'Action',
                  tilt: 1.0,
                  hasPaperclip: true,
                  onTap: widget.onNavigateToSchoolworks,
                ),
              ),
              const SizedBox(width: AppTheme.spaceSm),
              Expanded(
                child: StatsCard(
                  title: 'Done & Checked',
                  value: '${stats?.completedCount ?? 0}',
                  icon: Icons.check_circle_rounded,
                  color: AppTheme.pastelMint,
                  emoji: '🌟',
                  tilt: -1.0,
                  onTap: widget.onNavigateToSchoolworks,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceLg),

          // 4. Upcoming Deadlines Header with Filters
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('📌', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 6),
                      Text(
                        'Upcoming Deadlines',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerHigh,
                      borderRadius: AppTheme.borderRadiusFull,
                    ),
                    child: const Text(
                      'Priority Watch',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Filter Pills Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton('all', 'All', dot: AppTheme.pastelYellow),
                    const SizedBox(width: 8),
                    _buildFilterButton('high', 'High Priority', emoji: '🔴'),
                    const SizedBox(width: 8),
                    _buildFilterButton('today', 'Due Today', emoji: '⏰'),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // Urgent Subtitle Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.trending_up_rounded,
                          size: 14, color: AppTheme.error),
                      SizedBox(width: 4),
                      Text(
                        'MUST SUBMIT TODAY!',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.error,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Tap box to mark done',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 5. Schoolwork Cards
          if (filteredWorks.isEmpty)
            NotebookCard(
              backgroundColor: AppTheme.paperWhite,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: const [
                      Icon(Icons.check_circle_outline_rounded,
                          size: 40, color: AppTheme.tertiary),
                      SizedBox(height: 8),
                      Text(
                        'All caught up for now! 🎉',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'No pending schoolworks matching this filter.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ...filteredWorks.map((item) {
              return SchoolworkCard(
                item: item,
                onTap: () async {
                  final res = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => SchoolworkDetailScreen(item: item),
                    ),
                  );
                  if (res == true) _loadDashboardData();
                },
                onToggleComplete: (val) async {
                  await SchoolworkService.instance
                      .toggleCompleted(item.workId!, val ?? false);
                  _loadDashboardData();
                },
                onStatusChange: (newStatus) async {
                  await SchoolworkService.instance
                      .updateStatus(item.workId!, newStatus);
                  _loadDashboardData();
                },
                onEdit: () async {
                  final res = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => AddEditSchoolworkScreen(
                        schoolworkToEdit: item.schoolwork,
                      ),
                    ),
                  );
                  if (res == true) _loadDashboardData();
                },
                onDelete: () async {
                  await SchoolworkService.instance
                      .deleteSchoolwork(item.workId!);
                  _loadDashboardData();
                },
              );
            }).toList(),

          const SizedBox(height: AppTheme.spaceLg),

          // 6. Fun Footer Hand-Drawn Motivational Stamp
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.star_outline_rounded,
                    size: 16, color: AppTheme.textOutline),
                SizedBox(width: 6),
                Text(
                  'STAY CURIOUS • ONE DOODLE AT A TIME',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppTheme.textOutline,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.star_outline_rounded,
                    size: 16, color: AppTheme.textOutline),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filterKey, String label,
      {Color? dot, String? emoji}) {
    final isSelected = _activeFilter == filterKey;

    return GestureDetector(
      onTap: () {
        setState(() => _activeFilter = filterKey);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.textPrimary : AppTheme.surfaceContainer,
          borderRadius: AppTheme.borderRadiusFull,
          border: AppTheme.doodleBorder(1.5),
          boxShadow: isSelected
              ? AppTheme.doodleShadow(1.5, AppTheme.primary)
              : AppTheme.doodleShadow(1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppTheme.paperSurface : AppTheme.textPrimary,
              ),
            ),
            if (dot != null) ...[
              const SizedBox(width: 5),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: dot,
                  shape: BoxShape.circle,
                ),
              ),
            ] else if (emoji != null) ...[
              const SizedBox(width: 4),
              Text(emoji, style: const TextStyle(fontSize: 10)),
            ],
          ],
        ),
      ),
    );
  }
}
