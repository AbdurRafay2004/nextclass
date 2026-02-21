import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/schedule_provider.dart';

class LiveStatusCard extends StatelessWidget {
  final ScheduleItem item;

  const LiveStatusCard({super.key, required this.item});

  String _formatTime(int minutesSinceMidnight) {
    final now = DateTime.now();
    final time = DateTime(
      now.year,
      now.month,
      now.day,
      minutesSinceMidnight ~/ 60,
      minutesSinceMidnight % 60,
    );
    return DateFormat('h:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate progress for the Live Card
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final endMinutes =
        item.session.startTimeMinutes + item.session.durationMinutes;

    final progress =
        (currentMinutes - item.session.startTimeMinutes) /
        item.session.durationMinutes;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final remainingMinutes = endMinutes - currentMinutes;

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NOW tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF00E676), width: 1.0),
              borderRadius: BorderRadius.circular(4),
              color: Colors.transparent,
            ),
            child: const Text(
              'NOW',
              style: TextStyle(
                color: Color(0xFF00E676),
                fontWeight: FontWeight.w900,
                fontSize: 8,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Course Code
          Text(
            item.course.code.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          // Course Name
          Text(
            item.course.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          // Room and Faculty Info
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ROOM',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.session.room,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'FACULTY ACRONYM',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.course.facultyAcronym,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Divider
          Divider(color: Colors.grey[900], thickness: 1.0),
          const SizedBox(height: 12),
          // Time Remaining and Ends At
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TIME REMAINING',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${remainingMinutes > 0 ? remainingMinutes : 0}',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'min',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'ENDS AT',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(endMinutes),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          LinearProgressIndicator(
            value: clampedProgress,
            backgroundColor: Colors.grey[900],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: 12), // Extra spacing before the next section
        ],
      ),
    );
  }
}
