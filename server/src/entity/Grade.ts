// src/entity/Grade.ts

import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn, Unique } from "typeorm";
import { Student } from "./Student";
import { Subject } from "./Subject";
import { GradeScale } from "./GradeScale";

// Enforces the UNIQUE (student_id, subject_id) constraint
@Entity("grades")
@Unique(["student", "subject"]) 
export class Grade {
    @PrimaryGeneratedColumn({ type: "int" }) // SERIAL
    id: number;

    // Bidirectional Many-to-One: Links to Student. onDelete: CASCADE
    @ManyToOne(() => Student, (student) => student.grades, { onDelete: 'CASCADE' })
    @JoinColumn({ name: "student_id" })
    student: Student;

    // Bidirectional Many-to-One: Links to Subject. onDelete: CASCADE
    @ManyToOne(() => Subject, (subject) => subject.grades, { onDelete: 'CASCADE' })
    @JoinColumn({ name: "subject_id" })
    subject: Subject;

    @Column({ name: "letter_grade", length: 5 })
    letterGrade: string;

    // Bidirectional Many-to-One: Links to GradeScale
    @ManyToOne(() => GradeScale, (scale) => scale.grades, { onDelete: 'RESTRICT' })
    @JoinColumn({ name: "letter_grade", referencedColumnName: "letter" })
    gradeScale: GradeScale;

    @Column({ name: "grade_points", type: "numeric", precision: 4, scale: 2, nullable: true })
    gradePoints: number | null;

    @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
    createdAt: Date;
}