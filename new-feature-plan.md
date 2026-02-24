# 📌 FEATURE: QR-Based Instant Schedule Sharing

### (Now with Selective Export)

---

# 🎯 Updated Goal

Allow students to:

* Export:

  * ✅ Full schedule
  * ✅ Selected courses only
* Generate QR from selection
* Classmate scans
* Preview
* Import (replace or merge)
* Fully offline

Scope remains:

> Share schedule structure only (not full DB).

---

# 1️⃣ Product-Level Decisions (Updated)

---

## A. Export Modes (New Section)

### Mode 1 — Full Schedule

Exports:

* All courses
* All sessions

### Mode 2 — Selective Export

User selects:

* One or more courses
* Only sessions belonging to selected courses

Important:

> If a course is selected, all its sessions must be included automatically.

No partial sessions.

---

## B. UI Flow for Selective Export

New Screen:

### "Select Courses to Share"

UI:

* List of all courses
* Checkbox per course
* "Select All" toggle
* Continue button

Rules:

* At least one course must be selected
* Disable continue if none selected

---

# 2️⃣ Architecture Update

Extend sharing module:

```text
features/
└── sharing/
    ├── domain/
    │   └── schedule_share_dto.dart
    ├── data/
    │   ├── share_encoder_service.dart
    │   ├── share_decoder_service.dart
    │   └── share_import_service.dart
    └── presentation/
        ├── export_mode_screen.dart        ← NEW
        ├── course_selection_screen.dart   ← NEW
        ├── share_qr_screen.dart
        ├── scan_qr_screen.dart
        └── share_preview_screen.dart
```

---

# 3️⃣ Domain Layer Update

## ScheduleShareDTO (No structural change required)

But encoder now accepts:

```text
List<Course> selectedCourses
```

Instead of always exporting all.

---

# 4️⃣ Data Layer Updates

---

## A. Share Encoder Service (Updated Responsibility)

Now must:

1. Accept export mode:

   * Full
   * Selected

2. If Selected:

   * Filter Isar query by selected course IDs
   * Fetch only sessions for those courses

3. Build DTO only from filtered dataset

---

## B. Byte Budget Benefit

Selective export drastically reduces QR size.

Example:

If full schedule = 1.8 KB
Exporting 2 of 6 courses:

→ ~600–800 bytes

This increases:

* Reliability
* Scan speed
* QR readability
* Future scalability

Selective export is actually a technical safeguard.

---

# 5️⃣ Presentation Layer Flow (Updated)

---

## Step 1 — Export Mode Screen

Options:

* Share Full Schedule
* Share Specific Courses

If Full:
→ Direct to QR generation

If Specific:
→ Navigate to course selection screen

---

## Step 2 — Course Selection Screen

* Checkbox list
* Select all
* Continue button

On Continue:
→ Generate QR using selected course IDs

---

## Step 3 — Share QR Screen

Same as before.
Now built from filtered dataset.

---

# 6️⃣ Import Side (No Change Needed)

Receiver does NOT need to know if export was full or partial.

They only see:

* Courses included
* Sessions included

Import logic remains identical.

---

# 7️⃣ Conflict Handling With Selective Export

Scenario:

User imports 2 courses out of 6.

If conflicts occur:

* Only check conflicts against those 2 courses.
* Do NOT affect other courses in DB.

Important rule:

> Replace/Merge must apply only to imported courses, not entire schedule.

---

# 8️⃣ Edge Case Handling

---

### Edge Case 1:

User exports course with zero sessions.

Allowed?
Decision:

Recommended:
✔ Allow it
(Useful for sharing subject list only)

---

### Edge Case 2:

User selects all courses.

Treat same as Full export.

---

### Edge Case 3:

Very small export (< 200 bytes)

Still generate QR.
No special handling required.

---

# 9️⃣ Testing Plan Update

Test combinations:

* 1 course
* 2 courses
* 6 courses
* Full schedule
* Course with many sessions
* Course with no sessions

Measure encoded size for each.

Ensure all ≤ safe QR threshold.

---

# 🔟 Updated Performance & UX Impact

Selective export:

* Reduces payload
* Reduces scan failure risk
* Improves user control
* Adds perceived power
* Makes feature feel premium

Minimal additional complexity.

---

# 🧠 Optional Enhancements (Extended)

---

## 🔹 1. Compression (Still Recommended)

Even with selective export:

```text
JSON → GZIP → Base64 → QR
```

Benefits:

* Future-proof
* Allows more session data later
* Makes QR more resilient

Especially useful if:

* You later add room notes
* You allow longer course names

---

## 🔹 2. Hybrid Model (Now Even Smarter)

New logic:

If Full export:
If size ≤ 2500 bytes → QR
Else → File fallback

If Selective export:
Almost always safe for QR

This makes the system intelligent.

---

## 🔹 3. Smart Size Indicator (Premium UX)

On course selection screen:

Show:

> “Estimated QR size: Small / Medium / Large”

Or show byte estimate live.

This makes the app feel engineered.

---

## 🔹 4. QR Safety Threshold

Define internal rule:

```text
If encoded_length > 2500 bytes:
    Disable QR
    Show fallback to file
```

Never risk generating unreadable QR.

---

# 🏆 Final Strategic Impact

With Selective Export, your sharing feature becomes:

* Lightweight
* Flexible
* Byte-safe
* Scalable
* More classroom practical

It also reduces fear about QR capacity.

---

# 🎯 Final Recommended Implementation Stack

For MVP:

* Selective export
* Short-key DTO
* Version field
* Preview before import
* Replace/Merge logic

Strongly Recommended:

* Compression
* Size threshold guard

Optional:

* Hybrid QR/File fallback

---

