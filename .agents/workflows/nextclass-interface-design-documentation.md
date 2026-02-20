---
description: NextClass app Interface design documentation
---

# Class Schedule App - Interface Design

## Design Philosophy

This app follows **Apple Human Interface Guidelines (HIG)** and is optimized for **mobile portrait orientation (9:16)** with **one-handed usage** in mind. The design prioritizes immediate information retrieval with zero cognitive load, especially for students checking their daily schedule.

---

## Screen List

1. **Dashboard (Home)** - Primary screen showing today's schedule with timeline view
2. **Course List** - Browse all courses with quick actions
3. **Course Detail** - View and edit a specific course
4. **Add/Edit Session** - Input form for adding or modifying class sessions
5. **Settings** - App preferences (dark mode, notifications, time format)
6. **Weekend/Empty State** - Special messaging when no classes are scheduled

---

## Primary Content and Functionality

### 1. Dashboard (Home Screen)

**Purpose:** Immediate view of today's schedule with smart context awareness.

**Content:**
- **Live Status Card** (if a class is currently active)
  - Course name and code (bold)
  - "Class in progress" badge with elapsed time
  - Room number with icon
  - Faculty name
  - Time remaining indicator

- **Up Next Section** (if classes remain today)
  - Vertical timeline with left-aligned times
  - Course cards on the right of the timeline
  - Each card shows: Course Code + Title, Room, Faculty
  - Card background/border matches course color
  - Tap to view details or edit

- **Tomorrow's Plan** (if today is finished or weekend)
  - Same timeline layout as "Up Next"
  - Shows first 3-4 classes of next day
  - "Weekend Mode" message if Saturday/Sunday with Monday preview

**Functionality:**
- Swipe down to refresh schedule
- Tap course card to view details
- Long-press to duplicate or delete session
- Tap "+" button to add new course

### 2. Course List

**Purpose:** Browse all courses in the system.

**Content:**
- List of all courses with color-coded indicators
- Course name, code, and faculty name
- Number of sessions per course
- Quick action buttons (edit, delete, add session)

**Functionality:**
- Tap course to view detail screen
- Tap "+" to add new course
- Swipe to delete (with confirmation)
- Search/filter by course name or code

### 3. Course Detail

**Purpose:** View and manage a specific course.

**Content:**
- Course name and code (header)
- Faculty name
- Color swatch (tap to change)
- List of all sessions for this course
  - Day, time, room, type (Lecture/Lab/Tutorial)
  - Visual timeline showing distribution across week

**Functionality:**
- Edit course details
- Add new session
- Edit/delete existing sessions
- Duplicate session to another day
- Delete entire course (with confirmation)

### 4. Add/Edit Session

**Purpose:** Input class session details with minimal friction.

**Content:**
- Course selector (dropdown or search)
- Day selector (7 tappable chips: S M T W T F S)
- Time picker (24-hour format, display as 12-hour AM/PM)
- Room number input (text field)
- Session type selector (Lecture, Lab, Tutorial)
- Conflict warning (if overlaps with existing session)
- "Duplicate to..." button (after saving first session)

**Functionality:**
- Validate time conflicts before saving
- Show "Conflict with [Course Name]. Save anyway?" warning
- Allow quick duplication to other days
- Support 24-hour internal storage, 12-hour UI display
- Haptic feedback on save

### 5. Settings

**Purpose:** Customize app behavior.

**Content:**
- Dark mode toggle
- Notification settings (enabled/disabled)
- Time format (12-hour AM/PM or 24-hour)
- Notification timing (15 minutes before class - fixed for MVP)
- About section

**Functionality:**
- Toggle dark mode (persists across sessions)
- Enable/disable notifications
- Change time display format

### 6. Weekend/Empty State

**Purpose:** Prevent blank screens and guide users.

**Content:**
- "Weekend Mode" heading
- "Next class: Monday at 10:00 AM" with course name
- Illustration or icon
- "Add a class" button

**Functionality:**
- Tap to jump to next week's schedule
- Quick add button

---

## Key User Flows

### Flow 1: Add First Course and Session

1. User taps "+" on Dashboard
2. Enters course name (e.g., "Computer Graphics"), code (e.g., "CSE-401"), selects color
3. Saves course
4. Taps "Add Session" on course card
5. Selects day (Monday), time (10:00 AM), room (B-201), type (Lecture)
6. Saves session
7. Dashboard updates with new class in timeline

### Flow 2: Duplicate Session to Multiple Days

1. User adds session for Monday 10:00 AM
2. After saving, taps "Duplicate to..." button
3. Selects Wednesday and Friday
4. Confirms duplication
5. Dashboard now shows class on Mon, Wed, Fri at same time

### Flow 3: Handle Conflict

1. User tries to add class on Monday 10:00 AM
2. System detects existing class (e.g., "Math") at same time
3. Warning modal: "Conflict with Math. Save anyway?"
4. User can cancel or confirm (for edge cases like overlapping labs)

### Flow 4: Check Today's Schedule

1. User opens app
2. Dashboard shows:
   - If 10:00 AM class is active: "Live Status" card
   - If classes remain: "Up Next" timeline
   - If day finished: "Tomorrow's Plan"
3. User taps course card to view room/faculty details

### Flow 5: Dark Mode Support

1. User enables dark mode in Settings
2. All screens update: backgrounds darken, text lightens
3. Course colors remain visible and distinct in dark mode

---

## Color Choices

### Brand Palette (8-10 Pastel Colors)

These colors are used for course identification and must work in both light and dark modes:

1. **Sky Blue** - `#87CEEB` - Primary accent
2. **Soft Pink** - `#FFB6C1` - Secondary accent
3. **Mint Green** - `#98FF98` - Success/positive
4. **Peach** - `#FFCBA4` - Warm accent
5. **Lavender** - `#E6D5FF` - Calm accent
6. **Coral** - `#FF7F7F` - Alert/important
7. **Butter Yellow** - `#FFFACD` - Highlight
8. **Sage Green** - `#9DC183` - Neutral accent
9. **Periwinkle** - `#CCCCFF` - Cool accent
10. **Salmon** - `#FA8072` - Warm secondary

**Constraints:**
- No pure black or white as course colors
- All colors must maintain contrast in both light and dark modes
- Colors must be distinct enough to differentiate 10+ courses at a glance

### UI Palette

- **Background (Light):** `#FFFFFF`
- **Background (Dark):** `#151718`
- **Surface (Light):** `#F5F5F5`
- **Surface (Dark):** `#1E2022`
- **Foreground (Light):** `#11181C`
- **Foreground (Dark):** `#ECEDEE`
- **Muted (Light):** `#687076`
- **Muted (Dark):** `#9BA1A6`
- **Border (Light):** `#E5E7EB`
- **Border (Dark):** `#334155`

---

## Visual Hierarchy & Layout Specifics

### Dashboard Timeline Card Layout

```
┌─────────────────────────────────────┐
│ 10:00 │ Computer Graphics           │
│       │ CSE-401 · Lecture            │
│       │ 📍 B-201 · Dr. Smith         │
│───────┤                              │
│ 11:30 │ Linear Algebra               │
│       │ MATH-201 · Lecture           │
│       │ 📍 A-105 · Prof. Johnson     │
│───────┤                              │
│ 13:00 │ Data Structures Lab          │
│       │ CSE-301 · Lab                │
│       │ 📍 C-401 · Dr. Chen          │
└─────────────────────────────────────┘
```

**Key Elements:**
- Vertical line on left (color-coded per course)
- Time on left (e.g., "10:00")
- Card on right with course info
- Card border/background matches course color
- Icons for room (📍) and faculty (👤)
- Tap anywhere on card to view details

### Day Selector Chips

```
┌───┬───┬───┬───┬───┬───┬───┐
│ S │ M │ T │ W │ T │ F │ S │
└───┴───┴───┴───┴───┴───┴───┘
```

- 7 equal-width tappable chips
- Selected day highlighted with primary color
- No scroll wheel picker (too cumbersome for mobile)

### Time Picker

- 24-hour format stored internally
- 12-hour AM/PM display in UI
- Respects device locale settings
- Swipe or tap to adjust hours/minutes

---

## Accessibility & Dark Mode

- **Contrast:** All text meets WCAG AA standards (4.5:1 for body text)
- **Dark Mode:** Enabled by default if device setting is dark
- **Font Sizes:** Minimum 16px for body text, 14px for secondary
- **Touch Targets:** All interactive elements ≥ 44×44 points
- **Haptics:** Subtle feedback on button press (Light impact)

---

## Offline-First Considerations

- All data stored locally in SQLite/Isar
- No loading spinners (data always available)
- Sync state not shown to user (background operation)
- Notifications scheduled immediately after edit

---

## Next Steps

1. Implement data models (Course, ClassSession)
2. Build local database schema
3. Create Dashboard screen with timeline UI
4. Build Course and Session management flows
5. Add conflict detection logic (ask user if they want to proceed anyway)
6. Implement notification scheduling
7. Test dark mode and accessibility