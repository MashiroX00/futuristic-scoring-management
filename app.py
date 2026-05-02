from flask import Flask, request, jsonify, session, g
import sqlite3
import os
from pathlib import Path
from functools import wraps

app = Flask(__name__)
app.secret_key = os.urandom(24)  # For session management
DATABASE = 'futuristic_scoring.db'

# --- CORS Setup ---
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE')
    return response

# --- Database initialization ---
def init_db(auto_create=False):
    if not os.path.exists(DATABASE):
        if auto_create:
            from create_database import create_database
            schema_path = Path(__file__).parent / 'schema.sql'
            db_path = Path(DATABASE)
            create_database(schema_path=schema_path, db_path=db_path, force=True)
        else:
            raise FileNotFoundError(f"Database file '{DATABASE}' not found. Please run create_database.py to initialize the database.")

init_db(auto_create=True)
# --- Database Connection ---
def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
        db.row_factory = sqlite3.Row
    return db

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'professor_id' not in session:
            return jsonify({"error": "Unauthorized"}), 401
        return f(*args, **kwargs)
    return decorated_function

# --- Auth Routes ---

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    professor_id = data.get('ProfessorID')
    email = data.get('Email')

    if not professor_id or not email:
        return jsonify({"error": "Missing ProfessorID or Email"}), 400

    db = get_db()
    cur = db.execute('SELECT * FROM Professors WHERE ProfessorID = ? AND Email = ?', (professor_id, email))
    professor = cur.fetchone()

    if professor:
        session['professor_id'] = professor['ProfessorID']
        session['name'] = professor['Name']
        return jsonify({"message": "Login successful", "professor": dict(professor)}), 200
    else:
        return jsonify({"error": "Invalid credentials"}), 401

@app.route('/logout', methods=['POST'])
def logout():
    session.clear()
    return jsonify({"message": "Logout successful"}), 200

# --- Professor CRUD Routes ---

@app.route('/professors', methods=['GET'])
@login_required
def get_professors():
    db = get_db()
    cur = db.execute('SELECT * FROM Professors')
    professors = cur.fetchall()
    return jsonify([dict(p) for p in professors]), 200

@app.route('/professors/<id>', methods=['GET'])
@login_required
def get_professor(id):
    db = get_db()
    cur = db.execute('SELECT * FROM Professors WHERE ProfessorID = ?', (id,))
    professor = cur.fetchone()
    if professor:
        return jsonify(dict(professor)), 200
    return jsonify({"error": "Professor not found"}), 404

@app.route('/professors', methods=['POST'])
@login_required
def create_professor():
    data = request.get_json()
    professor_id = data.get('ProfessorID')
    name = data.get('Name')
    dept_id = data.get('DepartmentID')
    email = data.get('Email')

    if not all([professor_id, name, dept_id, email]):
        return jsonify({"error": "Missing required fields"}), 400

    db = get_db()
    try:
        db.execute('INSERT INTO Professors (ProfessorID, Name, DepartmentID, Email) VALUES (?, ?, ?, ?)',
                   (professor_id, name, dept_id, email))
        db.commit()
    except sqlite3.IntegrityError:
        return jsonify({"error": "ProfessorID already exists"}), 409

    return jsonify({"message": "Professor created successfully"}), 201

@app.route('/professors/<id>', methods=['PUT'])
@login_required
def update_professor(id):
    data = request.get_json()
    name = data.get('Name')
    dept_id = data.get('DepartmentID')
    email = data.get('Email')

    if not any([name, dept_id, email]):
        return jsonify({"error": "No fields to update"}), 400

    db = get_db()
    fields = []
    params = []
    if name:
        fields.append("Name = ?")
        params.append(name)
    if dept_id:
        fields.append("DepartmentID = ?")
        params.append(dept_id)
    if email:
        fields.append("Email = ?")
        params.append(email)
    
    params.append(id)
    query = f"UPDATE Professors SET {', '.join(fields)} WHERE ProfessorID = ?"
    cur = db.execute(query, params)
    db.commit()

    if cur.rowcount == 0:
        return jsonify({"error": "Professor not found"}), 404
    return jsonify({"message": "Professor updated successfully"}), 200

@app.route('/professors/<id>', methods=['DELETE'])
@login_required
def delete_professor(id):
    db = get_db()
    cur = db.execute('DELETE FROM Professors WHERE ProfessorID = ?', (id,))
    db.commit()
    if cur.rowcount == 0:
        return jsonify({"error": "Professor not found"}), 404
    return jsonify({"message": "Professor deleted successfully"}), 200

# --- Department CRUD Routes ---

@app.route('/departments', methods=['GET'])
def get_departments():
    db = get_db()
    cur = db.execute('SELECT * FROM Departments')
    return jsonify([dict(row) for row in cur.fetchall()]), 200

@app.route('/departments', methods=['POST'])
@login_required
def create_department():
    data = request.get_json()
    db = get_db()
    try:
        db.execute('INSERT INTO Departments (DepartmentID, DepartmentName, Building) VALUES (?, ?, ?)',
                   (data.get('DepartmentID'), data.get('DepartmentName'), data.get('Building')))
        db.commit()
    except sqlite3.IntegrityError:
        return jsonify({"error": "DepartmentID already exists"}), 409
    return jsonify({"message": "Department created"}), 201

# --- Student CRUD Routes ---

@app.route('/students', methods=['GET'])
@login_required
def get_students():
    db = get_db()
    cur = db.execute('SELECT * FROM Students')
    return jsonify([dict(row) for row in cur.fetchall()]), 200

@app.route('/students', methods=['POST'])
@login_required
def create_student():
    data = request.get_json()
    db = get_db()
    try:
        db.execute('INSERT INTO Students (StudentID, Name, DepartmentID, EnrollmentYear) VALUES (?, ?, ?, ?)',
                   (data.get('StudentID'), data.get('Name'), data.get('DepartmentID'), data.get('EnrollmentYear')))
        db.commit()
    except sqlite3.IntegrityError:
        return jsonify({"error": "StudentID already exists"}), 409
    return jsonify({"message": "Student created"}), 201

# --- Course CRUD Routes ---

@app.route('/courses', methods=['GET'])
def get_courses():
    db = get_db()
    cur = db.execute('SELECT * FROM Courses')
    return jsonify([dict(row) for row in cur.fetchall()]), 200

@app.route('/courses', methods=['POST'])
@login_required
def create_course():
    data = request.get_json()
    db = get_db()
    try:
        db.execute('INSERT INTO Courses (CourseID, CourseName, ProfessorID, Credits) VALUES (?, ?, ?, ?)',
                   (data.get('CourseID'), data.get('CourseName'), data.get('ProfessorID'), data.get('Credits')))
        db.commit()
    except sqlite3.IntegrityError:
        return jsonify({"error": "CourseID already exists"}), 409
    return jsonify({"message": "Course created"}), 201

# --- Grade & Enrollment Management ---

@app.route('/grades', methods=['GET'])
@login_required
def get_all_grades():
    db = get_db()
    cur = db.execute('''
        SELECT g.*, s.Name as StudentName, c.CourseName 
        FROM Grades g
        JOIN Students s ON g.StudentID = s.StudentID
        JOIN Courses c ON g.CourseID = c.CourseID
    ''')
    return jsonify([dict(row) for row in cur.fetchall()]), 200

@app.route('/enroll', methods=['POST'])
def enroll_student():
    """Allows a student to select a course (creates a Grade entry with null scores)"""
    data = request.get_json()
    student_id = data.get('StudentID')
    course_id = data.get('CourseID')
    grade_id = f"G{os.urandom(4).hex()}"

    db = get_db()
    try:
        db.execute('INSERT INTO Grades (GradeID, StudentID, CourseID) VALUES (?, ?, ?)',
                   (grade_id, student_id, course_id))
        db.commit()
    except sqlite3.IntegrityError:
        return jsonify({"error": "Enrollment failed (invalid ID or already enrolled)"}), 400
    return jsonify({"message": "Enrolled successfully", "GradeID": grade_id}), 201

@app.route('/grades/<id>', methods=['PUT'])
@login_required
def edit_grade(id):
    """Professor edits student grade"""
    data = request.get_json()
    score = data.get('NumericScore')
    letter = data.get('LetterGrade')

    db = get_db()
    cur = db.execute('UPDATE Grades SET NumericScore = ?, LetterGrade = ? WHERE GradeID = ?',
                     (score, letter, id))
    db.commit()
    if cur.rowcount == 0:
        return jsonify({"error": "Grade entry not found"}), 404
    return jsonify({"message": "Grade updated successfully"}), 200

@app.route('/grades/<id>', methods=['DELETE'])
@login_required
def remove_enrollment(id):
    """Professor removes a student from a course"""
    db = get_db()
    cur = db.execute('DELETE FROM Grades WHERE GradeID = ?', (id,))
    db.commit()
    if cur.rowcount == 0:
        return jsonify({"error": "Entry not found"}), 404
    return jsonify({"message": "Enrollment removed"}), 200

# --- Student Search ---

@app.route('/student/search', methods=['GET'])
def search_student_grades():
    """Search student by name to see their grades"""
    name = request.args.get('name')
    if not name:
        return jsonify({"error": "Name parameter is required"}), 400

    db = get_db()
    cur = db.execute('''
        SELECT s.Name, c.CourseName, g.NumericScore, g.LetterGrade
        FROM Students s
        JOIN Grades g ON s.StudentID = g.StudentID
        JOIN Courses c ON g.CourseID = c.CourseID
        WHERE s.Name LIKE ?
    ''', (f'%{name}%',))
    
    results = cur.fetchall()
    if not results:
        return jsonify({"message": "No student found or no grades available"}), 404
    
    return jsonify([dict(row) for row in results]), 200

if __name__ == '__main__':
    app.run(debug=True)
