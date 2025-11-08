// src/entity/Subject.ts

import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn, OneToMany, ManyToMany, JoinTable, Index } from "typeorm";
import { SemesterInstance } from "./SemesterInstance";
import { Teacher } from "./Teacher";
import { Timetable } from "./Timetable";
import { Grade } from "./Grade";

@Entity("subjects")
@Index(["semesterInstance", "subjectCode"], { unique: true }) // Enforces the UNIQUE constraint
export class Subject {
    @PrimaryGeneratedColumn({ type: "int" }) // SERIAL
    id: number;

    // Bidirectional Many-to-One: Links to SemesterInstance. onDelete: CASCADE (as per SQL)
    @ManyToOne(() => SemesterInstance, (instance) => instance.subjects, { onDelete: 'CASCADE' })
    @JoinColumn({ name: "semester_instance_id" })
    semesterInstance: SemesterInstance;

    @Column({ name: "subject_code", length: 60 })
    subjectCode: string;

    @Column({ name: "subject_name", length: 250 })
    subjectName: string;

    @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
    createdAt: Date;

    // Many-to-Many: Links to Teachers (uses the subject_teachers table implicitly)
    // onDelete: CASCADE is handled by TypeORM's ManyToMany implementation
    @ManyToMany(() => Teacher, (teacher) => teacher.subjects, { cascade: true })
    @JoinTable({
        name: "subject_teachers", // The actual junction table name
        joinColumns: [{ name: "subject_id" }],
        inverseJoinColumns: [{ name: "teacher_id" }],
    })
    teachers: Teacher[];

    // Bidirectional One-to-Many: Links to Timetables
    @OneToMany(() => Timetable, (timetable) => timetable.subject)
    timetables: Timetable[];

    // Bidirectional One-to-Many: Links to Grades
    @OneToMany(() => Grade, (grade) => grade.subject)
    grades: Grade[];
}