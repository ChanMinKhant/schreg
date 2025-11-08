// src/entity/AttendanceMonth.ts

import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn, Unique } from "typeorm";
import { AttendanceRecord } from "./AttendanceRecord";

// Enforces the UNIQUE (attendance_record_id, month_order) constraint
@Entity("attendance_months")
@Unique(["attendanceRecord", "monthOrder"]) 
export class AttendanceMonth {
    @PrimaryGeneratedColumn({ type: "int" }) // SERIAL
    id: number;

    // Bidirectional Many-to-One: Links to AttendanceRecord. onDelete: CASCADE
    @ManyToOne(() => AttendanceRecord, (record) => record.months, { onDelete: 'CASCADE' })
    @JoinColumn({ name: "attendance_record_id" })
    attendanceRecord: AttendanceRecord;

    @Column({ name: "month_name_abbr", length: 3 })
    monthNameAbbr: string;

    @Column({ name: "month_order", type: "smallint" })
    monthOrder: number;

    @Column({ name: "percentage_attended", type: "numeric", precision: 5, scale: 2 })
    percentageAttended: number;

    @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
    createdAt: Date;
}