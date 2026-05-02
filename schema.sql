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
('G501', 'S301', 'C401', 70, 'C'), ('G502', 'S301', 'C402', 75, 'C'), ('G503', 'S301', 'C403', 66, 'D'), ('G504', 'S301', 'C404', 72, 'C'), ('G505', 'S301', 'C405', 77, 'C'),
('G506', 'S301', 'C406', 97, 'A'), ('G507', 'S301', 'C407', 98, 'A'), ('G508', 'S301', 'C408', 98, 'A'), ('G509', 'S301', 'C409', 69, 'D'), ('G510', 'S301', 'C410', 95, 'A'),

-- Grades for Bob Thompson (S302)
('G511', 'S302', 'C401', 81, 'B'), ('G512', 'S302', 'C402', 72, 'C'), ('G513', 'S302', 'C403', 83, 'B'), ('G514', 'S302', 'C404', 97, 'A'), ('G515', 'S302', 'C405', 94, 'A'),
('G516', 'S302', 'C406', 83, 'B'), ('G517', 'S302', 'C407', 84, 'B'), ('G518', 'S302', 'C408', 98, 'A'), ('G519', 'S302', 'C409', 72, 'C'), ('G520', 'S302', 'C410', 71, 'C'),

-- Grades for Clara Oswald (S303)
('G521', 'S303', 'C401', 96, 'A'), ('G522', 'S303', 'C402', 68, 'D'), ('G523', 'S303', 'C403', 90, 'A'), ('G524', 'S303', 'C404', 87, 'B'), ('G525', 'S303', 'C405', 65, 'D'),
('G526', 'S303', 'C406', 72, 'C'), ('G527', 'S303', 'C407', 72, 'C'), ('G528', 'S303', 'C408', 84, 'B'), ('G529', 'S303', 'C409', 95, 'A'), ('G530', 'S303', 'C410', 79, 'C'),

-- Grades for Daniel Craig (S304)
('G531', 'S304', 'C401', 98, 'A'), ('G532', 'S304', 'C402', 79, 'C'), ('G533', 'S304', 'C403', 79, 'C'), ('G534', 'S304', 'C404', 70, 'C'), ('G535', 'S304', 'C405', 82, 'B'),
('G536', 'S304', 'C406', 88, 'B'), ('G537', 'S304', 'C407', 98, 'A'), ('G538', 'S304', 'C408', 80, 'B'), ('G539', 'S304', 'C409', 97, 'A'), ('G540', 'S304', 'C410', 93, 'A'),

-- Grades for Emma Watson (S305)
('G541', 'S305', 'C401', 89, 'B'), ('G542', 'S305', 'C402', 77, 'C'), ('G543', 'S305', 'C403', 84, 'B'), ('G544', 'S305', 'C404', 93, 'A'), ('G545', 'S305', 'C405', 88, 'B'),
('G546', 'S305', 'C406', 70, 'C'), ('G547', 'S305', 'C407', 74, 'C'), ('G548', 'S305', 'C408', 84, 'B'), ('G549', 'S305', 'C409', 96, 'A'), ('G550', 'S305', 'C410', 95, 'A'),

-- Grades for Frank Miller (S306)
('G551', 'S306', 'C401', 72, 'C'), ('G552', 'S306', 'C402', 72, 'C'), ('G553', 'S306', 'C403', 88, 'B'), ('G554', 'S306', 'C404', 97, 'A'), ('G555', 'S306', 'C405', 65, 'D'),
('G556', 'S306', 'C406', 86, 'B'), ('G557', 'S306', 'C407', 84, 'B'), ('G558', 'S306', 'C408', 67, 'D'), ('G559', 'S306', 'C409', 84, 'B'), ('G560', 'S306', 'C410', 87, 'B'),

-- Grades for Grace Hopper (S307)
('G561', 'S307', 'C401', 68, 'D'), ('G562', 'S307', 'C402', 70, 'C'), ('G563', 'S307', 'C403', 67, 'D'), ('G564', 'S307', 'C404', 82, 'B'), ('G565', 'S307', 'C405', 76, 'C'),
('G566', 'S307', 'C406', 88, 'B'), ('G567', 'S307', 'C407', 82, 'B'), ('G568', 'S307', 'C408', 81, 'B'), ('G569', 'S307', 'C409', 93, 'A'), ('G570', 'S307', 'C410', 90, 'A'),

-- Grades for Henry Cavill (S308)
('G571', 'S308', 'C401', 74, 'C'), ('G572', 'S308', 'C402', 78, 'C'), ('G573', 'S308', 'C403', 84, 'B'), ('G574', 'S308', 'C404', 71, 'C'), ('G575', 'S308', 'C405', 95, 'A'),
('G576', 'S308', 'C406', 77, 'C'), ('G577', 'S308', 'C407', 66, 'D'), ('G578', 'S308', 'C408', 74, 'C'), ('G579', 'S308', 'C409', 96, 'A'), ('G580', 'S308', 'C410', 87, 'B'),

-- Grades for Iris West (S309)
('G581', 'S309', 'C401', 86, 'B'), ('G582', 'S309', 'C402', 73, 'C'), ('G583', 'S309', 'C403', 72, 'C'), ('G584', 'S309', 'C404', 82, 'B'), ('G585', 'S309', 'C405', 88, 'B'),
('G586', 'S309', 'C406', 97, 'A'), ('G587', 'S309', 'C407', 65, 'D'), ('G588', 'S309', 'C408', 89, 'B'), ('G589', 'S309', 'C409', 81, 'B'), ('G590', 'S309', 'C410', 90, 'A'),

-- Grades for Jack Sparrow (S310)
('G591', 'S310', 'C401', 82, 'B'), ('G592', 'S310', 'C402', 82, 'B'), ('G593', 'S310', 'C403', 73, 'C'), ('G594', 'S310', 'C404', 93, 'A'), ('G595', 'S310', 'C405', 73, 'C'),
('G596', 'S310', 'C406', 65, 'D'), ('G597', 'S310', 'C407', 71, 'C'), ('G598', 'S310', 'C408', 88, 'B'), ('G599', 'S310', 'C409', 70, 'C'), ('G600', 'S310', 'C410', 77, 'C');