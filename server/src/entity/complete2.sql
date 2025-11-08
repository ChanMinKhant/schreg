
-- ========================================================
-- Student Management Schema (Extended)
-- Includes: students, parents, supporters, accounts, admins,
-- teachers, subject-teacher link, grade_scale with marks,
-- and timetable with class/section.
-- ========================================================

-- 1) ACCOUNTS (for authentication)
CREATE TABLE accounts (
    id              BIGSERIAL PRIMARY KEY,
    username        VARCHAR(100) UNIQUE NOT NULL,
    email           VARCHAR(200) UNIQUE NOT NULL,
    password_hash   TEXT NOT NULL,
    role            VARCHAR(20) NOT NULL CHECK (role IN ('student','teacher','admin','super')),
    last_login_at   TIMESTAMP WITH TIME ZONE,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT now()
);


-- 2) ADMINS
CREATE TABLE admins (
    id              BIGSERIAL PRIMARY KEY,
    account_id      BIGINT UNIQUE REFERENCES accounts(id) ON DELETE SET NULL,
    name            VARCHAR(200) NOT NULL,
    position        VARCHAR(100) DEFAULT 'System Admin',
    phone           VARCHAR(30),
    email           VARCHAR(200),
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 3) TEACHERS
CREATE TABLE teachers (
    id              BIGSERIAL PRIMARY KEY,
    account_id      BIGINT UNIQUE REFERENCES accounts(id) ON DELETE SET NULL,
    name_en         VARCHAR(200) NOT NULL,
    name_mm         VARCHAR(200),
    position        VARCHAR(100),
    department      VARCHAR(100),
    phone           VARCHAR(30),
    email           VARCHAR(200),
    hire_date       DATE,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT now()
);


-- 4) STUDENTS
CREATE TABLE students (
    id              BIGSERIAL PRIMARY KEY,
    account_id      BIGINT UNIQUE REFERENCES accounts(id) ON DELETE SET NULL,
    roll_no         VARCHAR(50) UNIQUE NOT NULL,
    photo_url       TEXT,
    name_en         VARCHAR(200) NOT NULL,
    name_mm         VARCHAR(200),
    major           VARCHAR(20),
    nationality     VARCHAR(100),
    religion        VARCHAR(50),
    birth_place     VARCHAR(100),
    township        VARCHAR(100),
    state_province  VARCHAR(100),
    region          VARCHAR(100),
    nrc             VARCHAR(80) UNIQUE,
    is_nationality  BOOLEAN DEFAULT TRUE,
    birth_date      DATE,
    matric_roll_no  VARCHAR(80),
    matric_year     SMALLINT,
    matric_dept     VARCHAR(200),
    address         TEXT,
    phone           VARCHAR(30),
    gmail           VARCHAR(200) UNIQUE,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 5) PARENTS (multiple per student)
CREATE TABLE parents (
    id              BIGSERIAL PRIMARY KEY,
    student_id      BIGINT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    relation        VARCHAR(30) NOT NULL CHECK (relation IN ('father','mother','guardian','other')),
    name_en         VARCHAR(200) NOT NULL,
    name_mm         VARCHAR(200),
    nationality     VARCHAR(100),
    religion        VARCHAR(50),
    birth_place     VARCHAR(100),
    township        VARCHAR(100),
    state_province  VARCHAR(100),
    region          VARCHAR(100),
    nrc             VARCHAR(80),
    is_nationality  BOOLEAN DEFAULT TRUE,
    job_info        VARCHAR(200),
    phone           VARCHAR(30),
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 6) SUPPORTERS
CREATE TABLE supporters (
    id              BIGSERIAL PRIMARY KEY,
    student_id      BIGINT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    name            VARCHAR(200),
    relationship    VARCHAR(100),
    job             VARCHAR(200),
    address         TEXT,
    phone           VARCHAR(30),
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 7) PAST EXAMS
CREATE TABLE past_exams (
    id              BIGSERIAL PRIMARY KEY,
    student_id      BIGINT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    exam_name       VARCHAR(200) NOT NULL,
    main_subject    VARCHAR(200),
    roll_no         VARCHAR(80),
    exam_year       SMALLINT NOT NULL,
    is_pass         BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 8) SEMESTERS
CREATE TABLE semesters (
    id                  BIGSERIAL PRIMARY KEY,
    year_level          SMALLINT NOT NULL CHECK (year_level BETWEEN 1 AND 10),
    semester_number     SMALLINT NOT NULL CHECK (semester_number IN (1,2)),
    description         TEXT,
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE (year_level, semester_number)
);

-- 9) SEMESTER INSTANCES
CREATE TABLE semester_instances (
    id                  BIGSERIAL PRIMARY KEY,
    semester_id         BIGINT REFERENCES semesters(id) ON DELETE RESTRICT,
    code                VARCHAR(50) NOT NULL UNIQUE, -- e.g., '2025-1'
    start_date          DATE NOT NULL,
    end_date            DATE,
    notes               TEXT,
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 10) SUBJECTS
CREATE TABLE subjects (
    id                      BIGSERIAL PRIMARY KEY,
    semester_instance_id    BIGINT NOT NULL REFERENCES semester_instances(id) ON DELETE CASCADE,
    subject_code            VARCHAR(60) NOT NULL,
    subject_name            VARCHAR(250) NOT NULL,
    created_at              TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE (semester_instance_id, subject_code)
);

-- 11) SUBJECT_TEACHERS (many-to-many)
CREATE TABLE subject_teachers (
    subject_id  BIGINT NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    teacher_id  BIGINT NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
    PRIMARY KEY (subject_id, teacher_id)
);

-- 12) GRADE SCALE (with marks range) 
CREATE TABLE grade_scale ( 
    letter VARCHAR(5) PRIMARY KEY, 
    points NUMERIC(4,2) NOT NULL CHECK (points >= 0), 
    min_mark SMALLINT NOT NULL CHECK (min_mark BETWEEN 0 AND 100),
    max_mark SMALLINT NOT NULL CHECK (max_mark BETWEEN 0 AND 100) 
);

INSERT INTO grade_scale(letter, points, min_mark, max_mark) VALUES
  ('A+', 4.00, 90, 100),
  ('A',  4.00, 85, 89),
  ('A-', 3.67, 80, 84),
  ('B+', 3.33, 75, 79),
  ('B',  3.00, 70, 74),
  ('B-', 2.67, 65, 69),
  ('C+', 2.33, 60, 64),
  ('C',  2.00, 55, 59),
  ('C-', 1.67, 50, 54),
  ('D',  1.00, 40, 49),
  ('F',  0.00, 0, 39)
ON CONFLICT DO NOTHING;

-- 13) GRADES
CREATE TABLE grades (
    id              BIGSERIAL PRIMARY KEY,
    student_id      BIGINT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    subject_id      BIGINT NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    letter_grade    VARCHAR(5) NOT NULL,
    grade_points    NUMERIC(4,2),
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE (student_id, subject_id)
);

-- 14) ATTENDANCE RECORDS
CREATE TABLE attendance_records (
    id                      BIGSERIAL PRIMARY KEY,
    student_id              BIGINT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    semester_instance_id    BIGINT NOT NULL REFERENCES semester_instances(id) ON DELETE CASCADE,
    created_at              TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE (student_id, semester_instance_id)
);

-- 15) ATTENDANCE MONTHS
CREATE TABLE attendance_months (
    id                      BIGSERIAL PRIMARY KEY,
    attendance_record_id    BIGINT NOT NULL REFERENCES attendance_records(id) ON DELETE CASCADE,
    month_name_abbr         VARCHAR(3) NOT NULL CHECK (month_name_abbr IN ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')),
    month_order             SMALLINT NOT NULL CHECK (month_order BETWEEN 1 AND 12),
    percentage_attended     NUMERIC(5,2) NOT NULL CHECK (percentage_attended BETWEEN 0 AND 100),
    created_at              TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE (attendance_record_id, month_order)
);

-- 16) TIMETABLE
CREATE TABLE timetables (
    id              BIGSERIAL PRIMARY KEY,
    subject_id      BIGINT NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    class_name      CHAR(1) CHECK (class_name IN ('A','B','C','D')),
    section_number  SMALLINT CHECK (section_number BETWEEN 1 AND 30),
    room            VARCHAR(100),
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE (subject_id, class_name, section_number, day_of_week, start_time)
);
