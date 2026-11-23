# TaskTracker: Academic Planner App
## Design System & UI Specification: "Paper Planner & Doodle Tracker"

> **Source**: Google Stitch Design System  
> **Project ID**: `7523627416489242021`  
> **Application**: TaskTracker — School Works Reminder and Academic Management Mobile Application  
> **Target Platforms**: Flutter Mobile (iOS, Android, Web, Desktop)  
> **Associated ERD**: School Works ERD (`users` ➔ `subject` ➔ `schoolwork`)

---

## 1. Executive Summary & Brand Identity

### The Vision
**TaskTracker: Paper Planner & Doodle Tracker** transforms academic management into a warm, inviting, and tactile experience. Rather than relying on cold, utilitarian corporate enterprise layouts, TaskTracker recreates the charming intimacy of a student's bullet journal, spiral notebook, and desk stationery.

### Target Audience
Middle school, high school, and university students seeking to alleviate academic anxiety through mindful, glanceable organization.

### Core Design Pillars
1. **Paper Metaphor**: Every surface feels physically tangible, like high-grade cream drawing paper (`#FCF9F8`), ruled loose-leaf sheets, or pastel sticky note cardstock.
2. **Hand-Inked Expression**: Crisp ink charcoal outlines (`2px solid #292929`) and hard-edged offset drop shadows (`3px 3px 0px #292929`) emulate genuine felt-tip pen illustrations and neobrutalist stationery.
3. **Tactile Stationery Accents**: Semitransparent washi tape strips, wire paperclips, red thumbtacks, and notebook spine spiral rings anchor cards naturally to the canvas.
4. **Mindful Organization**: Visual whimsy never compromises hierarchy. Deadlines, exam milestones, subjects, and urgent deliverables remain immediately glanceable.

---

## 2. Color System & Design Tokens

The color palette is grounded in authentic stationery tones: warm paper substrates, highlighter pastels, and deep ink black. The design operates primarily in light mode to preserve the paper illusion.

### 2.1 Core Stationery Palette

| Token Name | Hex Code | Role & Usage |
| :--- | :--- | :--- |
| `paperSurface` / `background` | `#FCF9F8` | Warm cream notebook paper canvas |
| `paperWhite` | `#FFFFFF` | Index card, input field, and modal background |
| `surfaceContainerLow` | `#F6F3F2` | Subtle secondary paper background |
| `surfaceContainer` | `#F0EDED` | Subtle container fill |
| `surfaceContainerHigh` | `#EAE7E7` | Section headers and semester pills |
| `inkColor` | `#292929` | Ink outlines, text headings, hard drop shadows |
| `textPrimary` | `#1B1C1C` | Primary charcoal reading text |
| `textSecondary` | `#4B463A` | Graphite pencil subtitle & caption text |
| `textOutline` | `#7D7769` | Subtle borders, ruler hatch ticks |
| `outlineVariant` | `#CEC6B6` | Ruled paper lines, spiral binding holes |

### 2.2 Pastel Sticky Notes & Highlighters

| Accent Token | Hex Code | Associated Subject / Status |
| :--- | :--- | :--- |
| `primaryContainer` (Pastel Yellow) | `#FFE9A8` | Primary CTA, greeting sticky note, 📚 Schoolworks |
| `onPrimaryContainer` | `#786833` | Yellow sticky text & contrast accents |
| `secondaryContainer` (Pastel Lilac) | `#E5DCF6` | 📁 Active Subjects, Literature, Languages |
| `onSecondaryContainer` | `#665F75` | Lilac sticky text & contrast accents |
| `tertiaryContainer` (Pastel Mint) | `#D4F1E2` | 🌟 Done & Checked, Science, Completed tasks |
| `onTertiaryContainer` | `#556F63` | Mint sticky text & contrast accents |
| `errorContainer` (Pastel Pink) | `#FFDAD6` | ⏰ Urgent deadlines, High Priority 🔴, Actions |
| `onErrorContainer` | `#93000A` | Pink sticky text & urgent warnings |
| `pastelBlue` | `#DCEEFF` | STEM subjects, Math, Computer Science |

### 2.3 Priority & Status Mapping

```
High Priority   🔴  ➔  Bg: #FFDAD6 | Border: #292929 | Text: #BA1A1A (Pulse Dot)
Medium Priority 🟡  ➔  Bg: #FFE9A8 | Border: #292929 | Text: #6D5D2A
Low / Normal    🟢  ➔  Bg: #D4F1E2 | Border: #292929 | Text: #4A6458
Pending Status      ➔  Bg: #FFE9A8 | Icon: alarm      | Text: #786833
Completed Status    ➔  Bg: #D4F1E2 | Icon: check_box  | Text: #334C41 (Strikethrough)
```

---

## 3. Typography Hierarchy

The typography pairs an expressive display face with a clean humanist sans-serif.

- **Headings & Milestone Display**: `Bricolage Grotesque` (sharp ink-traps, handcrafted flair).
- **Body, Inputs & Metadata**: `Quicksand` (rounded terminal strokes, high legibility).

| Style | Font Family | Size | Weight | Line Height | Letter Spacing | Usage |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `headline-xl` | Bricolage Grotesque | 34px | 800 | 40px | -0.02em | Welcome title, Big banners |
| `headline-xl-mobile` | Bricolage Grotesque | 26px | 800 | 32px | -0.02em | Screen headers, Hero title |
| `headline-lg` | Bricolage Grotesque | 24px | 700 | 30px | -0.01em | Greeting ("Hello, Alex!"), Numbers |
| `headline-md` | Bricolage Grotesque | 20px | 700 | 26px | Normal | Section titles ("Upcoming Deadlines") |
| `headline-sm` | Bricolage Grotesque | 17px | 600 | 22px | Normal | Card titles, Subject codes |
| `body-lg` | Quicksand | 16px | 600 | 24px | Normal | Subheadings, button text |
| `body-md` | Quicksand | 14px | 500 | 20px | Normal | Descriptions, body copy |
| `body-sm` | Quicksand | 12px | 500 | 16px | Normal | Metadata, notes, timestamps |
| `label-lg` | Quicksand | 13px | 700 | 18px | +0.02em | Feature pills, CTA subtext |
| `label-md` | Quicksand | 11px | 700 | 14px | +0.04em | Badges, tags, due times |
| `label-sm` | Quicksand | 10px | 600 | 12px | +0.03em | Smallest tags, tick labels |

---

## 4. Tactile Elevation, Shapes & Depth

TaskTracker does not use blurred digital shadows. Depth is achieved purely through **physical stationery cues**:

### 4.1 Neobrutalist Hard Offset Shadow
- **Standard Cards & Sticky Notes**:
  ```css
  box-shadow: 3px 3px 0px #292929;
  border: 2px solid #292929;
  ```
- **Interactive Hover / Lifted**:
  ```css
  box-shadow: 5px 5px 0px #292929;
  transform: translateY(-2px);
  ```
- **Active / Pressed (Tactile Feedback)**:
  ```css
  box-shadow: 0px 0px 0px #292929;
  transform: translate(3px, 3px);
  ```

### 4.2 Playful Rotations & Paper Misalignments
Elements are placed casually, as if tossed onto a wooden study desk:
- Sticky Memo Greeting: `transform: rotate(-0.5deg);`
- Sticky Note 1 (Subjects): `transform: rotate(-1.0deg);`
- Sticky Note 2 (Total Works): `transform: rotate(1.0deg);`
- Sticky Note 3 (Pending): `transform: rotate(1.0deg);`
- Sticky Note 4 (Completed): `transform: rotate(-1.0deg);`
- Feature Pills: alternated `rotate(-1deg)` and `rotate(1deg)`.

### 4.3 Stationery Accents
- **Washi Tape**:
  - Dimensions: `width: 100px - 120px`, `height: 14px - 18px`.
  - Opacity: `0.75 - 0.85` translucent pastel wash with subtle dashed line.
  - Position: centered across top border of cards at `-2deg` or `+2deg` tilt.
- **Wire Paperclips**:
  - 2px ink wire outline looped over the top edge of urgent reminder cards.
- **Thumbtacks**:
  - Circular red pin (`#BA1A1A`) with glossy highlight anchored at card corners.
- **Spiral Spine**:
  - Vertical row of pill-shaped ring holes (`#CEC6B6`) along the left edge.

---

## 5. UI Component Library

### 5.1 Buttons
- **Highlighter Primary Button (`btn-get-started`)**:
  - Fill: `#FFE9A8`
  - Outline: `2px solid #292929`
  - Shadow: `3.5px 3.5px 0px #292929`
  - Typography: Bricolage Grotesque 17px, 700 weight
  - Tactile press: shrinks shadow to `0px` and shifts `(3px, 3px)`.
- **Doodle Underline Link**:
  - Text button featuring wavy underline (`decoration-wavy decoration-primary`).
- **Circular FAB (`edit_note`)**:
  - Size: `56px x 56px`
  - Fill: `#FFE9A8`
  - Outline: `2.5px solid #292929`
  - Shadow: `3px 3px 0px #292929`
  - Icon: `edit_note` 28px charcoal.

### 5.2 Ruler Progress Bar (Weekly Goal Tracker)
- **Container**: `height: 24px`, background `#FFFFFF`, border `2px solid #292929`.
- **Hatch Marks**: Repeating ruler tick lines (alternating 6px, 9px, 12px height).
- **Highlighter Marker Fill**: Angled highlighter tip with animated width progress.

### 5.3 Hand-Drawn Task Checkbox
- **Box**: `28px x 28px` rounded square with `2px solid #292929`.
- **Unchecked**: Pale cream `#F6F3F2`.
- **Checked**: Pastel Mint `#D4F1E2` with charcoal tick and celebratory confetti burst `🎉`.
- **Task Strikethrough**: Line-through wobble effect with 50% opacity fade on card.

### 5.4 Folder Tab Subject Divider
- **Top Tab**: Simulated folder tab accent (`40px` wide, `4px` high, `#E5DCF6` or `#FFE9A8`).
- **Subject Code Pill**: Hard-bordered pastel pill (e.g. `CS 101`, `MATH 301`).
- **Instructor Avatar**: Minimalist doodle portrait inside a circular ring.
- **Divider**: Stitched dashed horizontal guide rule.

---

## 6. Screen Specifications

### Screen 1: Welcome & Splash Screen (`welcome.html`)
*Stitch Screen ID: `3c585acf9cc946f591d4698c794c32f9`*

```
+------------------------------------------------------+
| [O] [O] [O]  (Spiral Binder Holes along left edge)   |
|                                                      |
|         [ ✏️ Study Smart • Grade High ] (Washi Pill) |
|                                                      |
|       +------------------------------------+         |
|       |     [Paperclip Pin]                |         |
|       |                                    |         |
|       |    📚 App Mascot Doodle Notebook   |         |
|       |            ✨     ✏️               |         |
|       +------------------------------------+         |
|                                                      |
|                   TaskTracker 📌                     |
|    [ Stay Organized, Never Miss a Deadline! ]        |
|                                                      |
|   /----------------------------------------------\   |
|   | 📝 Subject Notebooks & Color Tags       [✓]  |   |
|   \----------------------------------------------/   |
|   /----------------------------------------------\   |
|   | ⏰ Smart Gentle Reminders               [🔔] |   |
|   \----------------------------------------------/   |
|   /----------------------------------------------\   |
|   | 📅 Interactive Planner & Milestones     [📅] |   |
|   \----------------------------------------------/   |
|                                                      |
|   [📍 Red Thumbtack]                                 |
|   +------------------------------------------------+ |
|   | 💬 "Finally an assignment tracker that feels   | |
|   |     like my bullet journal without anxiety!"   | |
|   |     — Maya S., High School Junior              | |
|   +------------------------------------------------+ |
|                                                      |
|   [================= Get Started 🚀 ================]|
|           Already have an account? Log In            |
|             Take a quick tour as guest ➔             |
+------------------------------------------------------+
```

### Screen 2: Home Dashboard (`dashboard.html`)
*Stitch Screen ID: `93dd4f304f094b8d88d9f882b86bde2e`*

```
+------------------------------------------------------+
| [📚 TaskTracker Home]                 [🔔(1)] [Avatar]|
+------------------------------------------------------+
|                                                      |
|  [========= Washi Tape =========]                    |
|  +------------------------------------------------+  |
|  | Hello, Alex! ✏️             [ ☀️ 68°F Sun ]     |  |
|  | 📅 Monday, Oct 21, 2024                        |  |
|  | - - - - - - - - - - - - - - - - - - - - - - -  |  |
|  | ✨ You've got 3 assignments this week!         |  |
|  +------------------------------------------------+  |
|                                                      |
|  Weekly Goal Tracker             [ 58% Finished 🎯 ] |
|  [||||||||||||||||||||||||..............] (Ruler Bar)|
|                                                      |
|  +---------------------+   +---------------------+   |
|  | 📁 [Sem 1]          |   | 📚 [Book]           |   |
|  | 4                   |   | 12                  |   |
|  | ACTIVE SUBJECTS     |   | SCHOOLWORKS TOTAL   |   |
|  +---------------------+   +---------------------+   |
|  +---------------------+   +---------------------+   |
|  | ⏰ [Action]         |   | 🌟 [Done]           |   |
|  | 5                   |   | 7                   |   |
|  | PENDING TASKS       |   | DONE & CHECKED      |   |
|  +---------------------+   +---------------------+   |
|                                                      |
|  📌 Upcoming Deadlines         [ Priority Watch ]    |
|  [ All (●) ]  [ High Priority 🔴 ]  [ Due Today ⏰ ]  |
|  ⚡ Must Submit Today! ➔ Tap box to mark done        |
|                                                      |
|  +------------------------------------------------+  |
|  | [CS 101] [High 🔴]                       [ □ ] |  |
|  | Algorithm Analysis Paper                       |  |
|  | Submit PDF to GradeScope • Sections 3.1 & 3.4  |  |
|  | ⏰ Due: Today, 11:59 PM            ⚡ Urgent   |  |
|  +------------------------------------------------+  |
|                                                      |
|                     [ (✏️) ]  (Quick Add FAB)        |
+------------------------------------------------------+
| [Home]       [Subjects]      [Add]   [Tasks]  [Cal]  |
+------------------------------------------------------+
```

### Screen 3: My Subjects (`subjects.html`)
*Stitch Screen ID: `c092daf5c17143eaa04c6337ba9da574`*

```
+------------------------------------------------------+
| [📚 TaskTracker Subjects]             [🔔]    [Avatar]|
+------------------------------------------------------+
|                                                      |
|  My Registered Subjects 📚                           |
|  [ Semester 1 • 2024-2025 ] • 4 Enrolled             |
|                                                      |
|  [ 🔍 Search subjects, codes or professors... ]      |
|  [ + Add Subject ]                                   |
|                                                      |
|  +--[Folder Tab]----------------------------------+  |
|  | [CS 101]                          [✏️]  [🗑️]    |  |
|  | Introduction to Computer Science & Structures   |  |
|  | (👩‍🏫 Prof. Sarah Jenkins, Ph.D.)               |  |
|  | - - - - - - - - - - - - - - - - - - - - - - -  |  |
|  | 📋 4 Schoolworks (2 Pending)   View Details ➔  |  |
|  +------------------------------------------------+  |
|                                                      |
|  +--[Folder Tab]----------------------------------+  |
|  | [MATH 301]                        [✏️]  [🗑️]    |  |
|  | Advanced Calculus & Linear Algebra             |  |
|  | (👨‍🏫 Dr. Robert Vance)                         |  |
|  | - - - - - - - - - - - - - - - - - - - - - - -  |  |
|  | 📋 3 Schoolworks (1 Pending)   View Details ➔  |  |
|  +------------------------------------------------+  |
|                                                      |
|  +------------------------------------------------+  |
|  | Have another class? ✨                          |  |
|  | Click + to add your 5th subject!      ➔ ⤵️      |  |
|  +------------------------------------------------+  |
|                                                      |
|                     [ (✏️) ]  (Quick Add FAB)        |
+------------------------------------------------------+
| [Home]       [Subjects]      [Add]   [Tasks]  [Cal]  |
+------------------------------------------------------+
```

---

## 7. School Works ERD & Database Schema Alignment

The user's database schema maps directly into the Stitch UI components:

```
+-------------------------------------------------------+
|                       USERS                           |
|-------------------------------------------------------|
| PK  user_id   INTEGER AUTOINCREMENT                   |
|     fName     TEXT NOT NULL                           |
|     lName     TEXT NOT NULL                           |
|     gmail     TEXT NOT NULL UNIQUE                    |
|     password  TEXT NOT NULL                           |
+-------------------------------------------------------+
                           | 1
                           |
                           | N
+-------------------------------------------------------+
|                      SUBJECT                          |
|-------------------------------------------------------|
| PK  subject_id       INTEGER AUTOINCREMENT            |
| FK  user_id          INTEGER NOT NULL (CASCADE)       |
|     subject_code     TEXT NOT NULL (e.g. CS 101)      |
|     subject_name     TEXT NOT NULL                    |
|     instructor_name  TEXT NOT NULL                    |
+-------------------------------------------------------+
                           | 1
                           |
                           | N
+-------------------------------------------------------+
|                     SCHOOLWORK                        |
|-------------------------------------------------------|
| PK  work_id      INTEGER AUTOINCREMENT                |
| FK  subject_id   INTEGER NOT NULL (CASCADE)           |
|     title        TEXT NOT NULL                        |
|     description  TEXT                                 |
|     due_date     TEXT NOT NULL (YYYY-MM-DD)           |
|     due_time     TEXT NOT NULL (HH:mm)                |
|     priority     TEXT NOT NULL ('High', 'Med', 'Low') |
|     status       TEXT NOT NULL ('Pending', 'Done')    |
+-------------------------------------------------------+
```

### Data-to-UI Mapping Table

| Stitch UI Element | Data Source | Formatter / Transformer |
| :--- | :--- | :--- |
| Greeting Header | `users.fName` | `"Hello, ${user.fName}! ✏️"` |
| Active Subjects Count | `COUNT(subject.subject_id)` | `"4 Active Subjects"` |
| Total Schoolworks Count | `COUNT(schoolwork.work_id)` | `"12 Schoolworks Total"` |
| Pending Tasks Count | `COUNT(...) WHERE status='Pending'` | `"5 Pending Tasks"` |
| Done Tasks Count | `COUNT(...) WHERE status='Completed'` | `"7 Done & Checked"` |
| Goal Tracker % | `(completed / total) * 100` | `"${pct}% Finished 🎯"` |
| Subject Badge Pill | `subject.subject_code` | Pill tag with pastel background |
| Subject Title | `subject.subject_name` | `headline-md` Bricolage Grotesque |
| Professor Info | `subject.instructor_name` | Doodle Avatar + `"Prof. ${name}"` |
| Schoolwork Card Title | `schoolwork.title` | `headline-sm` with toggle strikethrough |
| Schoolwork Due Badge | `due_date`, `due_time` | Relative format (`"Due: Today, 11:59 PM"`) |
| Priority Tag | `schoolwork.priority` | High 🔴 (`#FFDAD6`), Med 🟡 (`#FFE9A8`), Low 🟢 (`#D4F1E2`) |
| Checkbox State | `schoolwork.status` | `'Completed'` (checked) vs `'Pending'` (unchecked) |

---

## 8. Flutter Implementation Reference

### 8.1 Reusable Box Shadow Helper
```dart
static List<BoxShadow> doodleShadow([double offset = 3.0, Color? color]) {
  return [
    BoxShadow(
      color: color ?? const Color(0xFF292929),
      offset: Offset(offset, offset),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];
}
```

### 8.2 Reusable Ink Border Helper
```dart
static Border doodleBorder([double width = 2.0, Color? color]) {
  return Border.all(
    color: color ?? const Color(0xFF292929),
    width: width,
  );
}
```

### 8.3 Tactile Sticky Memo Card Pattern
```dart
Container(
  transform: Matrix4.rotationZ(-0.015), // ~ -0.9 degrees
  decoration: BoxDecoration(
    color: AppTheme.pastelYellow,
    borderRadius: BorderRadius.circular(16),
    border: AppTheme.doodleBorder(2.0),
    boxShadow: AppTheme.doodleShadow(3.0),
  ),
  child: Stack(
    clipBehavior: Clip.none,
    children: [
      // Top Washi Tape Accent
      Positioned(
        top: -8,
        left: 24,
        child: WashiTape(color: AppTheme.pastelLilac.withOpacity(0.8), width: 90),
      ),
      // Memo Content
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: childContent,
      ),
    ],
  ),
)
```

---

*Generated from Stitch Project `7523627416489242021` ("TaskTracker Academic Planner App").*

