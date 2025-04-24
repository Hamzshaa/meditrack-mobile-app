# MediTrack - Pharmacy Inventory & Medication Search

MediTrack is a comprehensive application designed to bridge the gap between users seeking medication information and pharmacies managing their inventory. It features a user-friendly interface for searching nearby medications, leveraging location services to provide distance-sorted results and map integration. Pharmacies benefit from a robust inventory management system, while administrators have tools for pharmacy oversight. Normal users can access medication search features without needing an account.

## Features

- **Medication Search (for Users):**
  - Search for medications by brand or generic name.
  - Results sorted by distance using user's current location and pharmacy coordinates.
  - View pharmacy details, stock availability (implicitly via search results), address, and contact information.
  - Integrated map view for pharmacy locations and directions (via Google Maps).
  - No login required for basic search functionality.
- **Inventory Management (for Pharmacies):**
  - Manage medication catalog (add, edit, delete).
  - Track inventory levels across different batches.
  - Manage medication categories.
  - Receive warnings for expiring or low-stock items.
  - Adjust stock quantities (add/deduct).
  - (Implied) Secure login for pharmacy staff.
- **Pharmacy Management (for Admins):**
  - Add, edit, and delete pharmacy profiles (including location, contact, manager details).
  - View overview dashboards and reports.
  - (Implied) Manage user roles and permissions.
- **General:**
  - User authentication (for pharmacy staff/admins).
  - Theme switching (Light/Dark mode).
  - Responsive UI for different screen sizes.

## Tech Stack

- **Backend:** Node.js with Express.js (JavaScript)
- **Database:** MySQL
- **Frontend (Mobile):** Flutter (Dart)

## Core Libraries Used

### Backend (Node.js/Express)

- `express`: Web framework
- `mysql2`: MySQL database driver
- `bcryptjs`: Password hashing
- `jsonwebtoken`: JWT for authentication/authorization
- `cookie-parser`: Parse cookies
- `cors`: Enable Cross-Origin Resource Sharing
- `dotenv`: Environment variable management
- `multer`: Handle multipart/form-data (for file uploads like images)
- `nodemailer`: Send emails (potentially for password resets, etc.)
- `crypto`: Cryptographic functionality (potentially for tokens, etc.)

### Frontend (Flutter)

- **State Management:** `flutter_riverpod`, `riverpod_annotation`
- **Routing:** `go_router`
- **HTTP Client:** `dio`
- **UI & Utilities:**
  - `google_fonts`: Custom fonts
  - `intl`: Internationalization and formatting (dates, numbers)
  - `url_launcher`: Launch external URLs (maps, calls)
  - `cached_network_image`: Display and cache network images
  - `carousel_slider`: Image carousel/slider widget
  - `image_picker`: Select images from gallery/camera
  - `geolocator`: Get device location
- **Data Handling & Models:** `equatable`, `json_annotation`
- **Persistence:** `shared_preferences` (Used for theme preference)
- **Development:** `build_runner`, `riverpod_generator`, `json_serializable`, `flutter_lints`, `custom_lint`, `riverpod_lint`

## Setup and Running

### Prerequisites

- Node.js (v18.x or later recommended)
- npm (usually comes with Node.js) or yarn
- MySQL Server installed and running
- Flutter SDK (latest stable version recommended)
- An IDE/Editor (like VS Code, Android Studio)
- Git

### Installation

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/Hamzshaa/meditrack-mobile-app.git
    cd meditrack-mobile-app
    ```

### Backend Setup (Node.js/Express)

1.  **Navigate to Backend Directory:**
    ```bash
    cd backend
    ```
2.  **Install Dependencies:**
    ```bash
    npm install
    ```
3.  **Database Setup (Using a GUI Tool):**
    - Ensure your MySQL server is running.
    - Open your preferred MySQL GUI tool (e.g., MySQL Workbench, DBeaver).
    - Connect to your local MySQL server instance.
    - **Manually create a new database** (schema) named exactly `drug_tracking-db`.
4.  **Environment Variables:**
    - In the `backend` directory, find or create a `.env` file (you might need to copy `.env.example` if it exists).
    - Edit the `.env` file with your specific MySQL connection details and other required variables:
    ```dotenv
    # .env example
    DB_HOST=localhost     # Or 127.0.0.1
    DB_USER=your_mysql_user # Replace with your MySQL username
    DB_PASSWORD=your_mysql_password # Replace with your MySQL password
    DB_DATABASE=drug_tracking-db
    DB_PORT=3306          # Default MySQL port
    JWT_SECRET=replace_this_with_a_very_strong_secret_key # IMPORTANT: Change this!
    # Add other necessary variables (e.g., PORT, EMAIL_USER, EMAIL_PASS if applicable)
    ```
5.  **Import Initial Schema:**
    - In your MySQL GUI tool, select the `drug_tracking-db` database you created.
    - Find the option to **run/import an SQL script** (often under "File", "Server", or by right-clicking the database).
    - Select the `docs/inital_queries.sql` file located within the cloned project directory.
    - Execute the script. This will create the necessary tables and initial structure. Verify that the tables were created successfully within your GUI tool.
6.  **Run the Backend Server:**
    ```bash
    npm run dev
    ```
    This command (defined in your `package.json`'s `scripts` section) usually starts the server using `nodemon` for development, which automatically restarts on file changes. Check your `package.json` if the command is different. The server should now be running (typically on a port like 3000 or specified in your `.env`).

### Frontend Setup (Flutter)

1.  **Navigate to Flutter Directory:**
    ```bash
    # If you are in the 'backend' directory:
    cd ../flutter
    # If you are in the root directory:
    # cd flutter
    ```
2.  **Get Dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Generate Code:** If the project uses code generation (like Riverpod Generator, Freezed, JSON Serializable), run the build runner:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
4.  **Configure Backend URL:**
    - Locate the file where the base URL for the backend API is defined (`lib/core/constants.dart`).
    - Ensure the URL points to where your backend server is running (e.g., `http://localhost:5000/api/v1`).
5.  **Run the App:**
    - Ensure you have an emulator running or a physical device connected.
    - Select the target device in your IDE or terminal.
    - Run the app:
      ```bash
      flutter run
      ```

## Project Structure (High-Level)

```plaintext
meditrack-mobile-app/
├── backend/ # Node.js/Express backend code
│   ├── node_modules/ # (Ignored by git)
│   ├── src/ # Source code (controllers, routes, models, services)
│   ├── .env # Local environment variables (Ignored by git)
│   ├── .env.example # Example environment file
│   ├── package.json
│   └── ... # Other backend files/folders
├── flutter/ # Flutter frontend code
│   ├── build/ # (Ignored by git)
│   ├── lib/ # Dart source code
│   │   ├── main.dart
│   │   ├── config/ # Theme, constants
│   │   ├── core/
│   │   ├── data/ # Services, repositories
│   │   ├── models/ # Data models
│   │   ├── presentation/ # UI (pages, widgets)
│   │   ├── providers/ # Riverpod providers
│   │   └── router/ # GoRouter setup
│   ├── test/ # Unit/widget tests
│   ├── pubspec.yaml
│   └── ... # Other Flutter files/folders
├── docs/ # Documentation, SQL files
│   └── inital_queries.sql
├── .gitignore # Files and directories ignored by Git
└── README.md # This file
```
