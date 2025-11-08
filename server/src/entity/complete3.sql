-- ========================================================
-- ✅ STUDENT MANAGEMENT SYSTEM DATABASE (Final Version)
-- Includes accounts, admins, teachers, students, parents,
-- supporters, exams, semesters, subjects, grades,
-- attendance, timetables, graduates, and photos.
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
    account_id      BIGINT UNIQUE REFERENCES accounts(id) ON DELETE CASCADE,
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

-- 5) PARENTS
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
    code                VARCHAR(50) NOT NULL UNIQUE,
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

-- 11) SUBJECT_TEACHERS
CREATE TABLE subject_teachers (
    subject_id  BIGINT NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    teacher_id  BIGINT NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
    PRIMARY KEY (subject_id, teacher_id)
);

-- 12) GRADE SCALE
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
    day_of_week     VARCHAR(10) NOT NULL CHECK (day_of_week IN ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')),
    start_time      TIME NOT NULL,
    end_time        TIME NOT NULL,
    room            VARCHAR(100),
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE (subject_id, class_name, section_number, day_of_week, start_time)
);

-- 17) GRADUATES
CREATE TABLE graduates (
    id                      BIGSERIAL PRIMARY KEY,
    student_id              BIGINT UNIQUE REFERENCES students(id) ON DELETE CASCADE,
    full_name               VARCHAR(250) NOT NULL,
    father_name             VARCHAR(200),
    mother_name             VARCHAR(200),
    date_of_birth           DATE,
    gender                  CHAR(10),
    nrc_number              VARCHAR(100),
    phone_number            VARCHAR(30),
    email                   VARCHAR(255),
    address                 VARCHAR(255),
    photo_url               VARCHAR(255),
    degree_type             VARCHAR(500),
    graduate_code           VARCHAR(500),
    start_year              VARCHAR(50),
    end_year                VARCHAR(50),
    graduation_date         VARCHAR(255),
    GPA                     VARCHAR(100),
    degree_class            VARCHAR(255),
    internship_company_name VARCHAR(255),
    job_title               VARCHAR(255),
    start_date              VARCHAR(100),
    end_date                TEXT,
    internship_project_title TEXT,
    supervisor_name         VARCHAR(255),
    scholarship             BOOLEAN DEFAULT FALSE,
    created_at              TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 18) PHOTOS
CREATE TABLE photos (
    id                              BIGSERIAL PRIMARY KEY,
    student_id                      BIGINT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    one_inch_photo                  VARCHAR(255),
    passport_photo                  VARCHAR(255),
    house_registration_photo_front  VARCHAR(255),
    matriculation_mark_photo        VARCHAR(255),
    matriculation_certificate       VARCHAR(255),
    police_approved_letter          VARCHAR(255),
    quarter_approved_letter         VARCHAR(255),
    student_nrc_photo_front         VARCHAR(255),
    student_nrc_photo_back          VARCHAR(255),
    covid_photo                     VARCHAR(255),
    fath_nrc_photo_front            VARCHAR(255),
    fath_nrc_photo_back             VARCHAR(255),
    moth_nrc_photo_front            VARCHAR(255),
    moth_nrc_photo_back             VARCHAR(255),
    payment_screenshot              VARCHAR(255),
    created_at                      TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE (student_id)
);

-- ========================================================
-- ✅ PERFORMANCE INDEXES
-- ========================================================
CREATE INDEX idx_students_account_id ON students(account_id);
CREATE INDEX idx_parents_student_id ON parents(student_id);
CREATE INDEX idx_supporters_student_id ON supporters(student_id);
CREATE INDEX idx_past_exams_student_id ON past_exams(student_id);
CREATE INDEX idx_subjects_semester_instance_id ON subjects(semester_instance_id);
CREATE INDEX idx_grades_student_id ON grades(student_id);
CREATE INDEX idx_attendance_records_student_id ON attendance_records(student_id);
CREATE INDEX idx_attendance_months_attendance_record_id ON attendance_months(attendance_record_id);
CREATE INDEX idx_graduates_student_id ON graduates(student_id);
CREATE INDEX idx_photos_student_id ON photos(student_id);
