// src/entity/Semester.ts

import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, OneToMany, Index } from "typeorm";
import { SemesterInstance } from "./SemesterInstance";

@Entity("semesters")
@Index(["yearLevel", "semesterNumber"], { unique: true }) // Enforces the UNIQUE constraint
export class Semester {
    @PrimaryGeneratedColumn({ type: "int" }) // SERIAL
    id: number;

    @Column({ name: "year_level", type: "smallint" })
    yearLevel: number;

    @Column({ name: "semester_number", type: "smallint" })
    semesterNumber: number;

    @Column({ type: "text", nullable: true })
    description: string | null;

    @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
    createdAt: Date;

    // Bidirectional One-to-Many: Links to SemesterInstance
    @OneToMany(() => SemesterInstance, (instance) => instance.semester)
    instances: SemesterInstance[];
}