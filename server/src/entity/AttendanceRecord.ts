// src/entity/AttendanceRecord.ts

import { Entity, PrimaryGeneratedColumn, ManyToOne, JoinColumn, CreateDateColumn, OneToMany, Unique } from "typeorm";
import { Student } from "./Student";
import { SemesterInstance } from "./SemesterInstance";
import { AttendanceMonth } from "./AttendanceMonth";

// Enforces the UNIQUE (student_id, semester_instance_id) constraint
@Entity("attendance_records")
@Unique(["student", "semesterInstance"]) 
export class AttendanceRecord {
    @PrimaryGeneratedColumn({ type: "int" }) // SERIAL
    id: number;

    // Bidirectional Many-to-One: Links to Student. onDelete: CASCADE
    @ManyToOne(() => Student, (student) => student.attendanceRecords, { onDelete: 'CASCADE' })
    @JoinColumn({ name: "student_id" })
    student: Student;

    // Bidirectional Many-to-One: Links to SemesterInstance. onDelete: CASCADE
    @ManyToOne(() => SemesterInstance, (instance) => instance.attendanceRecords, { onDelete: 'CASCADE' })
    @JoinColumn({ name: "semester_instance_id" })
    semesterInstance: SemesterInstance;

    @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
    createdAt: Date;

    // Bidirectional One-to-Many: Links to AttendanceMonths
    @OneToMany(() => AttendanceMonth, (month) => month.attendanceRecord)
    months: AttendanceMonth[];
}