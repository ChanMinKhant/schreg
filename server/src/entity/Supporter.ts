// src/entity/Supporter.ts

import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn } from "typeorm";
import { Student } from "./Student";

@Entity("supporters")
export class Supporter {
    @PrimaryGeneratedColumn({ type: "int" }) // SERIAL
    id: number;

    // Bidirectional Many-to-One: Links to Student. onDelete: CASCADE (as per SQL)
    @ManyToOne(() => Student, (student) => student.supporters, { onDelete: 'CASCADE' })
    @JoinColumn({ name: "student_id" }) // Foreign Key column
    student: Student;

    @Column({ nullable: true, length: 200 })
    name: string | null;

    @Column({ nullable: true, length: 100 })
    relationship: string | null;
    
    // ... (other columns omitted for brevity: job, address, phone, etc.) ...

    @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
    createdAt: Date;
}