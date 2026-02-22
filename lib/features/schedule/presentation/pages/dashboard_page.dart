import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../course/presentation/pages/course_add_page.dart';
import '../../../../core/providers/time_provider.dart';
import '../../../../core/widgets/dynamic_nav_bar.dart';
import '../../../course/presentation/pages/course_list_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../providers/session_provider.dart';
import '../widgets/live_status_card.dart';
import '../widgets/timeline_event_card.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage>
    with WidgetsBindingObserver {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came back from background — refresh schedule immediately
      ref.invalidate(dayScheduleProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: Consumer(
                builder: (context, ref, child) {
                  final nowAsync = ref.watch(timeProvider);
                  final now = nowAsync.value ?? DateTime.now();

                  final formattedDate = DateFormat(
                    'EEEE, MMM d',
                  ).format(now).toUpperCase();
                  final formattedTime = DateFormat(
                    'h:mm a',
                  ).format(now).toUpperCase();
                  return Text(
                    '$formattedDate • $formattedTime',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      letterSpacing: 2.0,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
              actions: [
                IconButton(icon: const Icon(Icons.person), onPressed: () {}),
              ],
            )
          : null,
      body: Stack(
        children: [
          Positioned.fill(
            child: _currentIndex == 0
                ? _buildDashboardBody()
                : _currentIndex == 1
                ? const CourseListPage()
                : _currentIndex == 2
                ? const SettingsPage()
                : Center(child: Text('Index $_currentIndex')),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: DynamicNavBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardBody() {
    return Consumer(
      builder: (context, ref, child) {
        final scheduleData = ref.watch(dashboardScheduleProvider);

        return scheduleData.when(
          data: (data) {
            final liveItem = data.liveItem;
            final upcomingItems = data.upcomingItems;

            // If there's no live item and no upcoming items left today
            if (liveItem == null && upcomingItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.weekend, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'All Caught Up',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text('No more classes scheduled for today.'),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CourseAddPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add a class'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                // Only invalidate the schedule data — NOT timeProvider.
                // Invalidating a StreamProvider restarts the stream from zero,
                // which means a 30-second wait before the first emission.
                ref.invalidate(dayScheduleProvider);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                children: [
                  if (liveItem != null) ...[
                    LiveStatusCard(item: liveItem),
                    const SizedBox(height: 16),
                  ],
                  if (upcomingItems.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'UP NEXT TODAY',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...upcomingItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TimelineEventCard(item: item),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        );
      },
    );
  }
}
