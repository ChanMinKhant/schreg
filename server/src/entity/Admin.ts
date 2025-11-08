// src/entity/Admin.ts

import { Entity, PrimaryGeneratedColumn, Column, OneToOne, JoinColumn, CreateDateColumn } from "typeorm";
import { Account } from "./Account";

@Entity("admins")
export class Admin {
    @PrimaryGeneratedColumn({ type: "int" }) // SERIAL
    id: number;

    // One-to-One: Links to Account. onDelete: SET NULL (as per SQL)
    @OneToOne(() => Account, (account) => account.admin, { onDelete: 'SET NULL' })
    @JoinColumn({ name: "account_id" })
    account: Account | null;

    @Column({ length: 200 })
    name: string;

    @Column({ length: 100, default: 'System Admin' })
    position: string;

    @Column({ nullable: true, length: 30 })
    phone: string | null;

    @Column({ nullable: true, length: 200 })
    email: string | null;

    @CreateDateColumn({ name: "created_at", type: "timestamp with time zone" })
    createdAt: Date;
}