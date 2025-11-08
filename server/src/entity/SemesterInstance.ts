// src/entity/SemesterInstance.ts

import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn, OneToMany } from "typeorm";
import { Semester } from "./Semester";
import { Subject } from "./Subject";
import { AttendanceRecord } from "./AttendanceRecord";

@Entity("semester_instances")
export class SemesterInstance {
    @PrimaryGeneratedColumn({ type: "int" }) // SERIAL
    id: number;

    // Bidirectional Many-to-One: Links to Semester. onDelete: RESTRICT (as per SQL)
    @ManyToOne(() => Semester, (semester) => semester.instances, { onDelete: 'RESTRICT' })
    @JoinColumn({ name: "semester_id" })
    semester: Semester;

    @Column({ unique: true, length: 50 })
    code: string;

    @Column({ name: "start_date", type: "date" })
    startDate: Date;

    @Column({ name: "end_date", type: "date", nullable: true })
    endDate: Date | null;

    @Column({ type: "text", nullable: true })
    notes: string | null;

    @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
    createdAt: Date;

    // Bidirectional One-to-Many: Links to Subjects
    @OneToMany(() => Subject, (subject) => subject.semesterInstance)
    subjects: Subject[];

    // Bidirectional One-to-Many: Links to AttendanceRecords
    @OneToMany(() => AttendanceRecord, (record) => record.semesterInstance)
    attendanceRecords: AttendanceRecord[];
}