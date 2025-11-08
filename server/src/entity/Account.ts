// src/entity/Account.ts

import { Entity, PrimaryGeneratedColumn, Column, OneToOne, CreateDateColumn } from "typeorm";
import { Student } from "./Student";
import { Teacher } from "./Teacher";
import { Admin } from "./Admin";

@Entity("accounts")
export class Account {
    @PrimaryGeneratedColumn({ type: "int" }) // SERIAL
    id: number;

    @Column({ unique: true, length: 100 })
    username: string;

    @Column({ unique: true, length: 200 })
    email: string;

    @Column({ name: "password_hash", type: "text" })
    passwordHash: string;

    @Column({
        type: "varchar",
        length: 20,
        enum: ['student', 'teacher', 'admin', 'super'],
    })
    role: "student" | "teacher" | "admin" | "super";

    @Column({ name: "last_login_at", type: "timestamp with time zone", nullable: true })
    lastLoginAt: Date | null;

    @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
    createdAt: Date;

    // Bidirectional One-to-One Relationships (The "One" side of the profile link)
    @OneToOne(() => Student, (student) => student.account)
    student?: Student;
    
    @OneToOne(() => Teacher, (teacher) => teacher.account)
    teacher?: Teacher;
    
    @OneToOne(() => Admin, (admin) => admin.account)
    admin?: Admin;
}