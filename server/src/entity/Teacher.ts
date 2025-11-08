// src/entity/Teacher.ts

import { Entity, PrimaryGeneratedColumn, Column, OneToOne, JoinColumn, CreateDateColumn, ManyToMany } from "typeorm";
import { Account } from "./Account";
import { Subject } from "./Subject";

@Entity("teachers")
export class Teacher {
    @PrimaryGeneratedColumn({ type: "int" }) // SERIAL
    id: number;

    // One-to-One: Links to Account. onDelete: SET NULL (as per SQL)
    @OneToOne(() => Account, (account) => account.teacher, { onDelete: 'SET NULL' })
    @JoinColumn({ name: "account_id" })
    account: Account | null;

    @Column({ name: "name_en", length: 200 })
    nameEn: string;

    @Column({ name: "name_mm", length: 200, nullable: true })
    nameMm: string | null;

    @Column({ nullable: true, length: 100 })
    position: string | null;

    @Column({ nullable: true, length: 100 })
    department: string | null;

    @Column({ nullable: true, length: 30 })
    phone: string | null;

    @Column({ nullable: true, length: 200 })
    email: string | null;

    @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
    createdAt: Date;

    // Bidirectional Many-to-Many with Subject (uses the subject_teachers table implicitly)
    @ManyToMany(() => Subject, (subject) => subject.teachers)
    subjects: Subject[];
}