// src/entity/Timetable.ts

import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn, Unique } from "typeorm";
import { Subject } from "./Subject";

// Enforces the UNIQUE (class_name, section_number) constraint
@Entity("timetables")
@Unique(["className", "sectionNumber"])
export class Timetable {
    @PrimaryGeneratedColumn({ type: "int" }) // SERIAL
    id: number;

    // Bidirectional Many-to-One: Links to Subject. onDelete: CASCADE
    @ManyToOne(() => Subject, (subject) => subject.timetables, { onDelete: 'CASCADE' })
    @JoinColumn({ name: "subject_id" })
    subject: Subject;

    @Column({ name: "class_name", length: 1 })
    className: string;

    // Section Number 1-30, mapping to Day/Time slot
    @Column({ name: "section_number", type: "smallint" })
    sectionNumber: number;

    @Column({ length: 100, nullable: true })
    room: string | null;

    @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
    createdAt: Date;
}