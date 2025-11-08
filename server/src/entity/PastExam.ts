// src/entity/PastExam.ts

import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn } from "typeorm";
import { Student } from "./Student";

@Entity("past_exams")
export class PastExam {
    @PrimaryGeneratedColumn({ type: "int" }) // SERIAL
    id: number;

    // Bidirectional Many-to-One: Links to Student. onDelete: CASCADE (as per SQL)
    @ManyToOne(() => Student, (student) => student.pastExams, { onDelete: 'CASCADE' })
    @JoinColumn({ name: "student_id" }) // Foreign Key column
    student: Student;

    @Column({ name: "exam_name", length: 200 })
    examName: string;

    @Column({ name: "exam_year", type: "smallint" })
    examYear: number;

    @Column({ name: "is_pass", default: false })
    isPass: boolean;
    
    // ... (other columns omitted for brevity: mainSubject, rollNo) ...

    @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
    createdAt: Date;
}