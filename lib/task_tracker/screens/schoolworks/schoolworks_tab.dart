import 'package:flutter/material.dart';
import '../../models/schoolwork_with_subject.dart';
import '../../models/subject_model.dart';
import '../../models/user_model.dart';
import '../../services/schoolwork_service.dart';
import '../../services/subject_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/notebook_card.dart';
import '../../widgets/schoolwork_card.dart';
import 'add_edit_schoolwork_screen.dart';
import 'schoolwork_detail_screen.dart';

class SchoolworksTab extends StatefulWidget {
  final UserModel currentUser;

  const SchoolworksTab({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<SchoolworksTab> createState() => _SchoolworksTabState();
}

class _SchoolworksTabState extends State<SchoolworksTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<SchoolworkWithSubject> _schoolworks = [];
  List<SubjectModel> _subjects = [];
  bool _isLoading = true;

  int? _filterSubjectId;
  String _filterPriority = 'All';
  String _sortBy = 'due_date_asc';

  final List<String> _statusTabs = [
    'All',
    'Pending',
    'In Progress',
    'Completed',
    'Overdue',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _loadSchoolworks();
      }
    });
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final userId = widget.currentUser.userId;
    try {
      if (userId != null) {
        final subs = await SubjectService.instance.getSubjectsForUser(userId);
        if (mounted) setState(() => _subjects = subs);
      }
    } catch (e) {
      debugPrint('Error loading subjects in schoolworks tab: $e');
    }
    await _loadSchoolworks();
  }

  Future<void> _loadSchoolworks() async {
    setState(() => _isLoading = true);
    final userId = widget.currentUser.userId;
    try {
      if (userId != null) {
        final currentTab = _statusTabs[_tabController.index];
        final works = await SchoolworkService.instance.getSchoolworksForUser(
          userId,
          statusFilter: currentTab,
          subjectId: _filterSubjectId,
          priorityFilter: _filterPriority,
          searchQuery: _searchController.text,
          sortBy: _sortBy,
        );
        if (mounted) {
          setState(() {
            _schoolworks = works;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading schoolworks: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openAddSchoolwork() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const AddEditSchoolworkScreen(),
      ),
    );
    if (result == true) {
      _loadSchoolworks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paperSurface,
      appBar: AppBar(
        title: Row(
          children: const [
            Text('School Works & Tasks'),
            SizedBox(width: 6),
            Text('📌', style: TextStyle(fontSize: 18)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppTheme.pastelYellow,
                borderRadius: AppTheme.borderRadiusFull,
                border: AppTheme.doodleBorder(1.8),
                boxShadow: AppTheme.doodleShadow(1.5),
              ),
              labelColor: AppTheme.inkColor,
              unselectedLabelColor: AppTheme.textSecondary,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              dividerColor: Colors.transparent,
              tabs: _statusTabs.map((status) => Tab(text: status)).toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSchoolwork,
        tooltip: 'Add Schoolwork',
        child: const Icon(Icons.edit_note_rounded, size: 28),
      ),
      body: Column(
        children: [
          // Search & Filter Sticky Shelf
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(
              color: AppTheme.paperSurface,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.outlineVariant.withAlpha(80),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Search Input with Doodle border
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.paperWhite,
                    borderRadius: AppTheme.borderRadiusMd,
                    border: AppTheme.doodleBorder(1.8),
                    boxShadow: AppTheme.doodleShadow(1.5),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => _loadSchoolworks(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search tasks, topics or subjects...',
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textOutline,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: AppTheme.textSecondary,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                _loadSchoolworks();
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Filters Row: Subject + Priority + Sort
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Subject filter pill
                      _buildFilterChip(
                        child: DropdownButton<int?>(
                          value: _filterSubjectId,
                          hint: const Text('All Subjects',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700)),
                          underline: const SizedBox(),
                          isDense: true,
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('All Subjects',
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w700)),
                            ),
                            ..._subjects.map((s) => DropdownMenuItem<int?>(
                                  value: s.subjectId,
                                  child: Text(
                                    s.subjectCode,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )),
                          ],
                          onChanged: (val) {
                            setState(() => _filterSubjectId = val);
                            _loadSchoolworks();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Priority Filter pill
                      _buildFilterChip(
                        child: DropdownButton<String>(
                          value: _filterPriority,
                          underline: const SizedBox(),
                          isDense: true,
                          items: ['All', 'High', 'Medium', 'Low'].map((p) {
                            return DropdownMenuItem<String>(
                              value: p,
                              child: Text(
                                p == 'All' ? 'All Priorities' : '$p Priority',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _filterPriority = val);
                              _loadSchoolworks();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Sort By pill
                      _buildFilterChip(
                        child: DropdownButton<String>(
                          value: _sortBy,
                          underline: const SizedBox(),
                          isDense: true,
                          items: const [
                            DropdownMenuItem(
                              value: 'due_date_asc',
                              child: Text('Sort: Due Date',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ),
                            DropdownMenuItem(
                              value: 'priority_desc',
                              child: Text('Sort: Priority',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ),
                            DropdownMenuItem(
                              value: 'title_asc',
                              child: Text('Sort: Title A-Z',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _sortBy = val);
                              _loadSchoolworks();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main List View
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadSchoolworks,
                    child: _schoolworks.isEmpty
                        ? Center(
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(32),
                              child: NotebookCard(
                                backgroundColor: AppTheme.paperWhite,
                                padding: const EdgeInsets.all(28),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.checklist_rounded,
                                      size: 52,
                                      color: AppTheme.textOutline,
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'No tasks found',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'No schoolworks match your current filter or search criteria.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.add_rounded),
                                      label: const Text('Add Schoolwork'),
                                      onPressed: _openAddSchoolwork,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 8, bottom: 84),
                            itemCount: _schoolworks.length,
                            itemBuilder: (context, index) {
                              final item = _schoolworks[index];
                              return SchoolworkCard(
                                item: item,
                                onTap: () async {
                                  final res = await Navigator.of(context).push<bool>(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          SchoolworkDetailScreen(item: item),
                                    ),
                                  );
                                  if (res == true) _loadSchoolworks();
                                },
                                onToggleComplete: (val) async {
                                  await SchoolworkService.instance
                                      .toggleCompleted(
                                          item.workId!, val ?? false);
                                  _loadSchoolworks();
                                },
                                onStatusChange: (newStatus) async {
                                  await SchoolworkService.instance
                                      .updateStatus(item.workId!, newStatus);
                                  _loadSchoolworks();
                                },
                                onEdit: () async {
                                  final res = await Navigator.of(context).push<bool>(
                                    MaterialPageRoute(
                                      builder: (_) => AddEditSchoolworkScreen(
                                        schoolworkToEdit: item.schoolwork,
                                      ),
                                    ),
                                  );
                                  if (res == true) _loadSchoolworks();
                                },
                                onDelete: () async {
                                  await SchoolworkService.instance
                                      .deleteSchoolwork(item.workId!);
                                  _loadSchoolworks();
                                },
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.paperWhite,
        borderRadius: AppTheme.borderRadiusFull,
        border: AppTheme.doodleBorder(1.2),
        boxShadow: AppTheme.doodleShadow(1.0),
      ),
      child: child,
    );
  }
}
