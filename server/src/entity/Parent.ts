// src/entity/Parent.ts

import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn } from "typeorm";
import { Student } from "./Student";

@Entity("parents")
export class Parent {
    @PrimaryGeneratedColumn({ type: "int" }) // SERIAL
    id: number;

    // Bidirectional Many-to-One: Links to Student. onDelete: CASCADE (as per SQL)
    @ManyToOne(() => Student, (student) => student.parents, { onDelete: 'CASCADE' })
    @JoinColumn({ name: "student_id" }) // Foreign Key column
    student: Student;

    @Column({
        length: 30,
        enum: ['father', 'mother', 'guardian', 'other'],
    })
    relation: "father" | "mother" | "guardian" | "other";

    @Column({ name: "name_en", length: 200 })
    nameEn: string;
    
    // ... (other columns omitted for brevity: nameMm, nationality, nrc, etc.) ...

    @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
    createdAt: Date;
}