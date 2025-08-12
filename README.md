# InkQuest

InkQuest is a modern Flutter application designed to streamline the tattoo consultation process for both clients and artists. Users can submit detailed tattoo requests, upload reference images, and track the status of their consultations, while artists can efficiently review and manage incoming requests.

---

## Table of Contents

- [About the App](#about-the-app)
- [Tech Stack](#tech-stack)
- [Features](#features)
- [Screenshots](#screenshots)
- [Code Structure](#code-structure)
- [How It Works](#how-it-works)
- [Getting Started](#getting-started)
- [License](#license)

---

## About the App

InkQuest bridges the gap between tattoo enthusiasts and artists by providing a seamless platform for submitting, reviewing, and managing tattoo consultation requests. The app emphasizes user experience, security, and scalability, making it suitable for both individual artists and studios.

---

## Tech Stack

- **Frontend:** [Flutter](https://flutter.dev/) (Dart)
- **Backend:** [Firebase](https://firebase.google.com/)
  - Firestore (NoSQL Database)
  - Firebase Authentication
  - Firebase Storage (for image uploads)
- **State Management:** Flutter's built-in stateful widgets
- **Other:** Material Design, Responsive UI

---

## Features

- User authentication (sign up, login, logout)
- Submit new tattoo consultation requests with descriptions and reference images
- View and track the status of your requests (Pending, Reviewed, Confirmed)
- Detailed request view with image gallery and status updates
- Home navigation and intuitive UI
- Secure data storage and retrieval via Firebase

---

## Screenshots

### Home Screen

<!-- Add Home Screen screenshot here -->
![Home Screen](screenshots/home.png)

### Submit Consultation

<!-- Add Submit Consultation screenshot here -->
![Submit Consultation](screenshots/submit.png)

### My Requests

<!-- Add My Requests screenshot here -->
![My Requests](screenshots/requests.png)

### Consultation Details

<!-- Add Consultation Details screenshot here -->
![Consultation Details](screenshots/details.png)

---

## Code Structure

```
lib/
  ├── main.dart                # App entry point
  ├── home.dart                # Home page and navigation
  ├── my_requests.dart         # User's consultation requests and details
  ├── submit_request.dart      # Form for submitting new consultations
  ├── auth/                    # Authentication logic (login, signup)
  └── ...                      # Other supporting files and widgets
```

- **main.dart**: Initializes Firebase and sets up the app's root widget.
- **home.dart**: Displays the main dashboard and navigation options.
- **my_requests.dart**: Handles fetching and displaying the user's consultation requests, including status and details.
- **submit_request.dart**: Provides a form for users to submit new tattoo consultation requests, including image uploads.
- **auth/**: Contains authentication-related screens and logic.

---

## How It Works

1. **User Authentication:**  
   Users sign up or log in using Firebase Authentication. All user data is securely managed.

2. **Submitting a Request:**  
   Users fill out a form describing their tattoo idea, select placement, size, and style, and upload reference images. The request is saved to Firestore.

3. **Viewing Requests:**  
   Users can view all their submitted requests, each showing a summary, status, and a thumbnail of the reference image(s).

4. **Request Details:**  
   Tapping a request opens a detailed view with all information and an image gallery. Status updates are reflected in real-time.

5. **Navigation:**  
   The app uses a Material Design navigation bar for easy access to all main features.

---

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/inkquest.git
   cd inkquest_tattoo
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   - Create a Firebase project.
   - Add your `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) to the respective directories.
   - Enable Authentication and Firestore in the Firebase console.

4. **Run the app:**
   ```bash
   flutter run
   ```

---

## License

This project is licensed under the MIT License.

---

*For more information or questions, please contact me at Travisesimmons@gmail.com*
