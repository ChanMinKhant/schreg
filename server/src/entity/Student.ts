// src/entity/Student.ts

import { Entity, PrimaryGeneratedColumn, Column, OneToOne, JoinColumn, CreateDateColumn, UpdateDateColumn, OneToMany } from "typeorm";
import { Account } from "./Account";
import { Parent } from "./Parent";
import { PastExam } from "./PastExam";
import { Grade } from "./Grade";
import { AttendanceRecord } from "./AttendanceRecord";
import { Supporter } from "./Supporter";

@Entity("students")
export class Student {
    @PrimaryGeneratedColumn({ type: "int" }) // SERIAL
    id: number;

    // One-to-One: Links to Account. onDelete: SET NULL (as per SQL)
    @OneToOne(() => Account, (account) => account.student, { onDelete: 'SET NULL' })
    @JoinColumn({ name: "account_id" })
    account: Account | null;

    @Column({ name: "roll_no", unique: true, length: 50 })
    rollNo: string;

    @Column({ name: "photo_url", type: "text", nullable: true })
    photoUrl: string | null;
    
    // ... (many more columns omitted for brevity, using the structure defined in previous turn) ...
    // e.g. nameEn, nameMm, major, nationality, nrc, etc.

    @Column({ name: "name_en", length: 200 })
    nameEn: string;
    
    @Column({ name: "nrc", unique: true, length: 80, nullable: true })
    nrc: string | null;

    @Column({ name: "birth_date", type: "date", nullable: true })
    birthDate: Date | null;

    @Column({ name: "matric_year", type: "smallint", nullable: true })
    matricYear: number | null;
    
    // ... (omitted columns end) ...

    @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
    createdAt: Date;

    @UpdateDateColumn({ name: "updated_at", type: "timestamp with time zone" })
    updatedAt: Date;

    // Bidirectional One-to-Many Relationships (All have onDelete: CASCADE as per SQL)
    @OneToMany(() => Parent, (parent) => parent.student, { cascade: ['insert', 'update'] })
    parents: Parent[];

    @OneToMany(() => Supporter, (supporter) => supporter.student, { cascade: ['insert', 'update'] })
    supporters: Supporter[];

    @OneToMany(() => PastExam, (pastExam) => pastExam.student, { cascade: ['insert', 'update'] })
    pastExams: PastExam[];
    
    @OneToMany(() => Grade, (grade) => grade.student, { cascade: ['insert', 'update'] })
    grades: Grade[];
    
    @OneToMany(() => AttendanceRecord, (attendanceRecord) => attendanceRecord.student, { cascade: ['insert', 'update'] })
    attendanceRecords: AttendanceRecord[];
}