# TaskTracker: A School Works Reminder and Academic Management Mobile Application

TaskTracker is a Flutter mobile application built for students to track, organize, and manage academic subjects, coursework, deadlines, and schoolwork reminders.

---

## 📊 Database Architecture (School Works ERD)

The application architecture directly implements the School Works ERD:

```
+------------------------------------+
|               Users                |
+------------------------------------+
| PK | user_id                       |
+----+-------------------------------+
|    | fName                         |
|    | lName                         |
|    | gmail                         |
|    | password                      |
+----+-------------------------------+
                   |
                   | 1-to-Many
                   v
+------------------------------------+
|              Subject               |
+------------------------------------+
| PK | subject_id                    |
+----+-------------------------------+
| FK | user_id                       |
|    | subject_code                  |
|    | subject_name                  |
|    | instructor_name               |
+----+-------------------------------+
                   |
                   | 1-to-Many
                   v
+------------------------------------+
|             Schoolwork             |
+------------------------------------+
| PK | work_id                       |
+----+-------------------------------+
| FK | subject_id                    |
|    | title                         |
|    | description                   |
|    | due_date                      |
|    | due_time                      |
|    | priority                      |
|    | status                        |
+----+-------------------------------+
```

### Table Definitions

1. **`users` Table**
   - `user_id` (INTEGER, Primary Key, Autoincrement)
   - `fName` (TEXT, Student's First Name)
   - `lName` (TEXT, Student's Last Name)
   - `gmail` (TEXT, Unique Gmail address)
   - `password` (TEXT, Account password)

2. **`subject` Table**
   - `subject_id` (INTEGER, Primary Key, Autoincrement)
   - `user_id` (INTEGER, Foreign Key referencing `users(user_id)` ON DELETE CASCADE)
   - `subject_code` (TEXT, Course/Subject code, e.g., CS301, MATH202)
   - `subject_name` (TEXT, Course title, e.g., Data Structures and Algorithms)
   - `instructor_name` (TEXT, Name of professor/instructor)

3. **`schoolwork` Table**
   - `work_id` (INTEGER, Primary Key, Autoincrement)
   - `subject_id` (INTEGER, Foreign Key referencing `subject(subject_id)` ON DELETE CASCADE)
   - `title` (TEXT, Schoolwork/task title)
   - `description` (TEXT, Task description, guidelines, and reference notes)
   - `due_date` (TEXT, Due date formatted as `YYYY-MM-DD`)
   - `due_time` (TEXT, Due time formatted as `HH:mm`)
   - `priority` (TEXT, `High`, `Medium`, or `Low`)
   - `status` (TEXT, `Pending`, `In Progress`, or `Completed`)

---

## 🚀 Key Features

### 1. Student Authentication & Profile Management
- Student registration with full name, Gmail, and password.
- Secure login and persistent session state.
- Quick **One-Tap Demo Student Login** for instant evaluation and testing.
- Student profile editing with student ID badge display.

### 2. Academic Management (Subjects)
- Complete CRUD operations for enrolled subjects.
- Subject cards displaying course code, course name, and instructor name.
- Real-time progress bar tracking the completion rate of tasks under each subject.
- Dedicated **Subject Details** page listing all schoolworks assigned to that subject.

### 3. School Works & Task Tracker
- Comprehensive list of schoolwork items with:
  - Subject code badge
  - Interactive completion checkbox
  - Real-time countdown & overdue notifications (e.g., "Due today at 11:59 PM", "Overdue by 1 day")
  - Priority badge (`High`, `Medium`, `Low`)
  - Status badge (`Pending`, `In Progress`, `Completed`, `Overdue`)
- Filters:
  - Tabbed status filtering: **All**, **Pending**, **In Progress**, **Completed**, and **Overdue**
  - Subject dropdown filter
  - Priority filter
  - Live search by task title, description, or subject
  - Sort by Due Date, Priority, or Alphabetical title

### 4. School Works Reminder & Notifications
- Integrated local notification alerts using `flutter_local_notifications`.
- Prominent Urgent / Overdue alert banner on the Academic Dashboard.
- Scheduled reminders for upcoming deadlines.

### 5. Academic Dashboard
- Personalized student greeting with date.
- Overall semester academic completion progress meter.
- Overview metrics cards: Total Subjects, Total Tasks, Pending Tasks, Completed Tasks.
- "Urgent & Due Soon" quick-action carousel.
- "Your Subjects" horizontal preview.

---

## 🛠️ Project Structure

```
lib/
├── main.dart                          # App Entrypoint
└── task_tracker/
    ├── database/
    │   └── task_tracker_db.dart       # SQLite Database Helper & Schema (Users, Subject, Schoolwork)
    ├── models/
    │   ├── user_model.dart            # Users Entity Model
    │   ├── subject_model.dart         # Subject Entity Model
    │   ├── schoolwork_model.dart      # Schoolwork Entity Model
    │   └── schoolwork_with_subject.dart # Joined Schoolwork & Subject Presentation Model
    ├── services/
    │   ├── auth_service.dart          # Authentication & User Session Service
    │   ├── subject_service.dart       # Subject CRUD & Analytics Service
    │   ├── schoolwork_service.dart    # Schoolwork CRUD, Filters & Dashboard Stats Service
    │   └── notification_service.dart  # Reminder & Alert Notification Service
    ├── screens/
    │   ├── auth/
    │   │   ├── login_screen.dart      # Student Login & Demo Login
    │   │   └── register_screen.dart   # Student Registration
    │   ├── home/
    │   │   └── main_navigation_screen.dart # Bottom Navigation Shell (4 Tabs)
    │   ├── dashboard/
    │   │   └── dashboard_tab.dart     # Academic Overview & Reminders Dashboard
    │   ├── schoolworks/
    │   │   ├── schoolworks_tab.dart   # All Schoolworks List, Search & Filters
    │   │   ├── add_edit_schoolwork_screen.dart # Add/Edit Schoolwork Form
    │   │   └── schoolwork_detail_screen.dart   # Schoolwork Detail View & Actions
    │   ├── subjects/
    │   │   ├── subjects_tab.dart      # Subjects List & Enrollment Cards
    │   │   ├── add_edit_subject_screen.dart    # Add/Edit Subject Form
    │   │   └── subject_detail_screen.dart      # Subject Detail & Course Tasks
    │   └── profile/
    │       └── profile_tab.dart       # Profile, Theme, ERD Info & Logout
    ├── widgets/
    │   ├── schoolwork_card.dart       # Interactive Schoolwork Task Card
    │   ├── subject_card.dart          # Subject Summary Card with Progress Bar
    │   ├── stats_card.dart            # Quick Metrics Card
    │   ├── priority_badge.dart        # High / Medium / Low Badge
    │   └── status_badge.dart          # Pending / In Progress / Completed Badge
    ├── theme/
    │   └── app_theme.dart             # Academic Indigo & Teal Design System
    └── task_tracker_app.dart          # Root Application Widget
```

---

## 🏃 Running the Application

1. Ensure Flutter is installed and in your environment PATH.
2. In the project directory, run:
   ```bash
   flutter pub get
   flutter run
   ```
3. On the login screen:
   - Click **One-Tap Demo Student Login** to immediately explore the app with preloaded subjects and schoolworks.
   - Or click **Create Account** to register a new student with your own name and Gmail.
