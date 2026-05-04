-- 1. Department Info Table
CREATE TABLE Departments (
    DepartmentID VARCHAR(10) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL,
    Building VARCHAR(100)
);

INSERT INTO Departments (DepartmentID, DepartmentName, Building) VALUES
('D101', 'Computer Science', 'Turing Hall'),
('D102', 'Mathematics', 'Euler Building'),
('D103', 'Physics', 'Newton Lab'),
('D104', 'Biology', 'Darwin Center'),
('D105', 'History', 'Heritage Wing'),
('D106', 'Chemistry', 'Curie Lab'),
('D107', 'Economics', 'Smith Hall'),
('D108', 'Philosophy', 'Plato Annex'),
('D109', 'Literature', 'Shakespeare Hall'),
('D110', 'Art', 'Da Vinci Studio');

-- 2. Professor Info Table
CREATE TABLE Professors (
    ProfessorID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DepartmentID VARCHAR(10),
    Email VARCHAR(100),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Professors (ProfessorID, Name, DepartmentID, Email) VALUES
('P201', 'Dr. Alan Smith', 'D101', 'asmith@uni.edu'),
('P202', 'Dr. Maria Garcia', 'D102', 'mgarcia@uni.edu'),
('P203', 'Dr. Robert Chen', 'D103', 'rchen@uni.edu'),
('P204', 'Dr. Sarah Jones', 'D104', 'sjones@uni.edu'),
('P205', 'Dr. James Wilson', 'D105', 'jwilson@uni.edu'),
('P206', 'Dr. Linda Brown', 'D106', 'lbrown@uni.edu'),
('P207', 'Dr. David Miller', 'D107', 'dmiller@uni.edu'),
('P208', 'Dr. Susan Davis', 'D108', 'sdavis@uni.edu'),
('P209', 'Dr. Michael Lee', 'D109', 'mlee@uni.edu'),
('P210', 'Dr. Karen White', 'D110', 'kwhite@uni.edu');

-- 3. Student Info Table
CREATE TABLE Students (
    StudentID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DepartmentID VARCHAR(10),
    EnrollmentYear INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Students (StudentID, Name, DepartmentID, EnrollmentYear) VALUES
('S301', 'Alice Johnson', 'D101', 2024),
('S302', 'Bob Thompson', 'D101', 2024),
('S303', 'Clara Oswald', 'D102', 2025),
('S304', 'Daniel Craig', 'D103', 2023),
('S305', 'Emma Watson', 'D104', 2024),
('S306', 'Frank Miller', 'D105', 2025),
('S307', 'Grace Hopper', 'D101', 2023),
('S308', 'Henry Cavill', 'D107', 2024),
('S309', 'Iris West', 'D109', 2025),
('S310', 'Jack Sparrow', 'D110', 2023);

-- 4. Course Info Table
CREATE TABLE Courses (
    CourseID VARCHAR(10) PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    ProfessorID VARCHAR(10),
    Credits INT,
    FOREIGN KEY (ProfessorID) REFERENCES Professors(ProfessorID)
);

INSERT INTO Courses (CourseID, CourseName, ProfessorID, Credits) VALUES
('C401', 'Database Systems', 'P201', 4),
('C402', 'Calculus I', 'P202', 3),
('C403', 'Quantum Mechanics', 'P203', 4),
('C404', 'Genetics', 'P204', 3),
('C405', 'World History', 'P205', 3),
('C406', 'Organic Chemistry', 'P206', 4),
('C407', 'Macroeconomics', 'P207', 3),
('C408', 'Ethics', 'P208', 2),
('C409', 'Modern Literature', 'P209', 3),
('C410', 'Digital Arts', 'P210', 3);

-- 5. Grade Info Table
CREATE TABLE Grades (
    GradeID VARCHAR(10) PRIMARY KEY,
    StudentID VARCHAR(10),
    CourseID VARCHAR(10),
    NumericScore INT,
    LetterGrade CHAR(1),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Grades (GradeID, StudentID, CourseID, NumericScore, LetterGrade) VALUES
-- Grades for Alice Johnson (S301)
('G501', 'S301', 'C401', 70, 'B'), ('G502', 'S301', 'C402', 75, 'B+'), ('G503', 'S301', 'C403', 66, 'C+'), ('G504', 'S301', 'C404', 72, 'B'), ('G505', 'S301', 'C405', 77, 'B+'),
('G506', 'S301', 'C406', 97, 'A'), ('G507', 'S301', 'C407', 98, 'A'), ('G508', 'S301', 'C408', 98, 'A'), ('G509', 'S301', 'C409', 69, 'C+'), ('G510', 'S301', 'C410', 95, 'A'),

-- Grades for Bob Thompson (S302)
('G511', 'S302', 'C401', 81, 'A'), ('G512', 'S302', 'C402', 72, 'B'), ('G513', 'S302', 'C403', 83, 'A'), ('G514', 'S302', 'C404', 97, 'A'), ('G515', 'S302', 'C405', 94, 'A'),
('G516', 'S302', 'C406', 83, 'A'), ('G517', 'S302', 'C407', 84, 'A'), ('G518', 'S302', 'C408', 98, 'A'), ('G519', 'S302', 'C409', 72, 'B'), ('G520', 'S302', 'C410', 71, 'B'),

-- Grades for Clara Oswald (S303)
('G521', 'S303', 'C401', 96, 'A'), ('G522', 'S303', 'C402', 68, 'C+'), ('G523', 'S303', 'C403', 90, 'A'), ('G524', 'S303', 'C404', 87, 'A'), ('G525', 'S303', 'C405', 65, 'C+'),
('G526', 'S303', 'C406', 72, 'B'), ('G527', 'S303', 'C407', 72, 'B'), ('G528', 'S303', 'C408', 84, 'A'), ('G529', 'S303', 'C409', 95, 'A'), ('G530', 'S303', 'C410', 79, 'B+'),

-- Grades for Daniel Craig (S304)
('G531', 'S304', 'C401', 98, 'A'), ('G532', 'S304', 'C402', 79, 'B+'), ('G533', 'S304', 'C403', 79, 'B+'), ('G534', 'S304', 'C404', 70, 'B'), ('G535', 'S304', 'C405', 82, 'A'),
('G536', 'S304', 'C406', 88, 'A'), ('G537', 'S304', 'C407', 98, 'A'), ('G538', 'S304', 'C408', 80, 'A'), ('G539', 'S304', 'C409', 97, 'A'), ('G540', 'S304', 'C410', 93, 'A'),

-- Grades for Emma Watson (S305)
('G541', 'S305', 'C401', 89, 'A'), ('G542', 'S305', 'C402', 77, 'B+'), ('G543', 'S305', 'C403', 84, 'A'), ('G544', 'S305', 'C404', 93, 'A'), ('G545', 'S305', 'C405', 88, 'A'),
('G546', 'S305', 'C406', 70, 'B'), ('G547', 'S305', 'C407', 74, 'B'), ('G548', 'S305', 'C408', 84, 'A'), ('G549', 'S305', 'C409', 96, 'A'), ('G550', 'S305', 'C410', 95, 'A'),

-- Grades for Frank Miller (S306)
('G551', 'S306', 'C401', 72, 'B'), ('G552', 'S306', 'C402', 72, 'B'), ('G553', 'S306', 'C403', 88, 'A'), ('G554', 'S306', 'C404', 97, 'A'), ('G555', 'S306', 'C405', 65, 'C+'),
('G556', 'S306', 'C406', 86, 'A'), ('G557', 'S306', 'C407', 84, 'A'), ('G558', 'S306', 'C408', 67, 'C+'), ('G559', 'S306', 'C409', 84, 'A'), ('G560', 'S306', 'C410', 87, 'A'),

-- Grades for Grace Hopper (S307)
('G561', 'S307', 'C401', 68, 'C+'), ('G562', 'S307', 'C402', 70, 'B'), ('G563', 'S307', 'C403', 67, 'C+'), ('G564', 'S307', 'C404', 82, 'A'), ('G565', 'S307', 'C405', 76, 'B+'),
('G566', 'S307', 'C406', 88, 'A'), ('G567', 'S307', 'C407', 82, 'A'), ('G568', 'S307', 'C408', 81, 'A'), ('G569', 'S307', 'C409', 93, 'A'), ('G570', 'S307', 'C410', 90, 'A'),

-- Grades for Henry Cavill (S308)
('G571', 'S308', 'C401', 74, 'B'), ('G572', 'S308', 'C402', 78, 'B+'), ('G573', 'S308', 'C403', 84, 'A'), ('G574', 'S308', 'C404', 71, 'B'), ('G575', 'S308', 'C405', 95, 'A'),
('G576', 'S308', 'C406', 77, 'B+'), ('G577', 'S308', 'C407', 66, 'C+'), ('G578', 'S308', 'C408', 74, 'B'), ('G579', 'S308', 'C409', 96, 'A'), ('G580', 'S308', 'C410', 87, 'A'),

-- Grades for Iris West (S309)
('G581', 'S309', 'C401', 86, 'A'), ('G582', 'S309', 'C402', 73, 'B'), ('G583', 'S309', 'C403', 72, 'B'), ('G584', 'S309', 'C404', 82, 'A'), ('G585', 'S309', 'C405', 88, 'A'),
('G586', 'S309', 'C406', 97, 'A'), ('G587', 'S309', 'C407', 65, 'C+'), ('G588', 'S309', 'C408', 89, 'A'), ('G589', 'S309', 'C409', 81, 'A'), ('G590', 'S309', 'C410', 90, 'A'),

-- Grades for Jack Sparrow (S310)
('G591', 'S310', 'C401', 82, 'A'), ('G592', 'S310', 'C402', 82, 'A'), ('G593', 'S310', 'C403', 73, 'B'), ('G594', 'S310', 'C404', 93, 'A'), ('G595', 'S310', 'C405', 73, 'B'),
('G596', 'S310', 'C406', 65, 'C+'), ('G597', 'S310', 'C407', 71, 'B'), ('G598', 'S310', 'C408', 88, 'A'), ('G599', 'S310', 'C409', 70, 'A'), ('G600', 'S310', 'C410', 77, 'B+');