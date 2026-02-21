import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../course/presentation/pages/course_list_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../providers/schedule_provider.dart';
import '../widgets/live_status_card.dart';
import '../widgets/timeline_event_card.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentDay = ref.watch(currentDayProvider);
    final scheduleAsync = ref.watch(dayScheduleProvider(currentDay));

    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: const Text(
                'Today',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(icon: const Icon(Icons.person), onPressed: () {}),
              ],
            )
          : null,
      body: _currentIndex == 0
          ? _buildDashboardBody(scheduleAsync)
          : _currentIndex == 1
          ? const CourseListPage()
          : _currentIndex == 2
          ? const SettingsPage()
          : Center(child: Text('Index $_currentIndex')),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardBody(AsyncValue<List<ScheduleItem>> scheduleAsync) {
    return scheduleAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.weekend, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Weekend Mode',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text('No classes scheduled for today.'),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add a class'),
                ),
              ],
            ),
          );
        }

        // Determine if there is a live class
        ScheduleItem? liveItem;
        final now = DateTime.now();
        final currentMinutes = now.hour * 60 + now.minute;

        for (var item in items) {
          final endMinutes =
              item.session.startTimeMinutes + item.session.durationMinutes;
          if (currentMinutes >= item.session.startTimeMinutes &&
              currentMinutes <= endMinutes) {
            liveItem = item;
            break;
          }
        }

        // Filter out past items and the live item
        final upcomingItems = items.where((i) {
          if (i == liveItem) return false;
          final endMinutes =
              i.session.startTimeMinutes + i.session.durationMinutes;
          return currentMinutes < endMinutes;
        }).toList();

        return RefreshIndicator(
          onRefresh: () async {
            // Trigger a refresh (riverpod invalidation)
            ref.invalidate(dayScheduleProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
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
  }
}
