# Futuristic Scoring Management

A secure, streamlined academic scoring system designed for professors and students. This application features a modern, government-style aesthetic with a robust Flask backend and an interactive frontend.

## 🚀 Features

### For Students
*   **Public Student Search**: Search for grades by student name directly from the home page.
*   **Self-Enrollment**: Students can enroll in available courses.

### For Professors
*   **Secure Authentication**: Login using `ProfessorID` and `Email`.
*   **Comprehensive Dashboard**:
    *   **Grade Management**: View and edit student grades via a professional modal interface.
    *   **Enrollment Control**: Enroll students in courses using searchable dropdown menus.
    *   **Course Creation**: Create new courses that are automatically assigned to your profile.
    *   **Roster Overview**: See all students enrolled in your specific courses.
*   **Session-Based Access**: Sensitive management tools are protected by a login-required system.

## 🛠️ Tech Stack

*   **Backend**: Python, Flask
*   **Database**: SQLite3
*   **Frontend**: Vanilla HTML5, CSS3 (Modern Academic Theme), Vanilla JavaScript
*   **Security**: Flask-Session based authentication, `@login_required` decorators

## 📂 Project Structure

```text
├── app.py                # Main Flask application & API routes
├── create_database.py     # Database initialization script
├── schema.sql             # SQL definition for tables and sample data
├── futuristic_scoring.db  # SQLite database (auto-generated)
├── static/
│   ├── css/site.css       # Custom styles and theme
│   └── js/app.js          # Frontend logic and API interaction
├── templates/
│   ├── base.html          # Shared layout template
│   ├── index.html         # Home page (Student Search)
│   └── app.html           # Professor Dashboard & Login
└── pyproject.toml         # Project dependencies and metadata
```

## ⚙️ Installation & Setup

### 1. Prerequisites
*   Python 3.12 or higher

### 2. Setup Environment
```bash
# Create a virtual environment
python -m venv .venv

# Activate the environment (Windows)
.venv\Scripts\activate

# Activate the environment (Mac/Linux)
source .venv/bin/activate

# Install dependencies
pip install flask
```

### 3. Initialize Database
The application will automatically create the database on the first run. However, you can manually initialize or reset it using:
```bash
python create_database.py --force
```

### 4. Run the Application
```bash
python app.py
```
The application will be available at `http://127.0.0.1:5000`.

## 🧪 Testing Credentials
You can use the following sample data from `schema.sql` to test the professor login:
*   **Professor ID**: `P201`
*   **Email**: `asmith@uni.edu`

## 🛡️ Security Note
The application uses a randomly generated secret key for sessions on every restart. For production use, ensure you set a persistent `SECRET_KEY` in your environment variables.
