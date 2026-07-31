# Fitness-Tracker-App User Story

## 1. Registration
**As a** new user,
**I want** to create an account with my name, username, email, age, and password,
**So that** I can access personalized fitness tracking features.

**Acceptance Criteria:**
- Form includes fields for Name, Username, Email, Age, and Password.
- If a required field is empty or invalid (e.g., invalid email format), the user sees an inline error message.
- On successful submission, the user is redirected to the Login page or automatically logged in.

## 2. Login
**As a** returning user,
**I want** to log in using my email/username and password,
**So that** I can access my personal fitness dashboard.

**Acceptance Criteria:**
- Form includes fields for Email/Username and Password.
- If credentials are incorrect, an error message is displayed (e.g., "Invalid email or password").
- A "Forgot Password?" link and a "Sign Up" link are available for new users.

## 3. Login/Registration Error Feedback
**As a** user,
**I want** to receive clear feedback when I enter incorrect or incomplete information during login or registration,
**So that** I can quickly correct my mistakes without confusion.

**Acceptance Criteria:**
- Specific error messages appear for empty fields, invalid email formats, and incorrect credentials.
- Errors are displayed near the relevant field, not just as a generic banner.

## 4. Home Page / Dashboard
**As a** logged-in user,
**I want** to see a dashboard with a welcome message and my primary fitness activities (workouts, steps, goals),
**So that** I can quickly check my progress and jump into an activity.

**Acceptance Criteria:**
- Dashboard displays a personalized greeting (e.g., "Hello, [Name]!").
- Key stats (steps, calories, active minutes) are visible at a glance.
- A call-to-action button (e.g., "Start Workout" or "Add Activity") is present.

## 5. Detail Screen for a Workout/Exercise
**As a** user,
**I want** to view detailed information about a specific workout or exercise (description, duration, instructions),
**So that** I can understand exactly what to do before starting it.

**Acceptance Criteria:**
- Detail screen shows an image/thumbnail, title, duration, and description of the workout.
- Additional actions available, such as "Start" or "Add to Favorites."

## 6. Favorites / Profile Page with Persistent Storage
**As a** user,
**I want** to save workouts to a Favorites list and have my profile/settings persist between sessions,
**So that** I don't lose my saved preferences or progress when I close the app.

**Acceptance Criteria:**
- Users can tap "Add to Favorites" on a workout, and it appears in their Favorites/Profile list.
- Favorited items and profile data remain saved after logging out and back in (persistent storage, e.g., local storage or database).

## 7. External API Integration
**As a** user,
**I want** the app to pull in real-time fitness or health data (e.g., weather for outdoor workouts, or step-count sync from a health API),
**So that** my activity data is accurate and up to date without manual entry.

**Acceptance Criteria:**
- App successfully requests and displays data from an external API.
- If the API call fails, the user sees a friendly error/fallback message instead of a blank screen.

## 8. Settings Menu & Settings Screen
**As a** user,
**I want** to access a settings menu to update my personal info, toggle app preferences (like Light/Dark mode), and manage my account,
**So that** I can customize the app to fit my needs.

**Acceptance Criteria:**
- Settings menu includes links to Personal Info, Notifications, Reports, and Sign Out.
- Settings screen allows editing of name, username, age, and country, with a "Save Changes" button.
- Changes are confirmed with a success message and persist after saving.

## 9. Notifications
**As a** user,
**I want** to receive and manage reminders/notifications about workouts and goals,
**So that** I stay motivated and consistent with my fitness routine.

**Acceptance Criteria:**
- Users can set a daily reminder with a specific date and time.
- Users can view a list of upcoming/active notifications.
- Users can turn notifications on/off from the settings menu.
