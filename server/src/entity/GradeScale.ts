// src/entity/GradeScale.ts

import { Entity, PrimaryColumn, Column, OneToMany } from "typeorm";
import { Grade } from "./Grade";

@Entity("grade_scale")
export class GradeScale {
    @PrimaryColumn({ length: 5 }) // LETTER is the primary key
    letter: string;

    @Column({ type: "numeric", precision: 4, scale: 2 })
    points: number;

    @Column({ name: "min_mark", type: "smallint" })
    minMark: number;

    @Column({ name: "max_mark", type: "smallint" })
    maxMark: number;

    // Bidirectional One-to-Many: Links to Grades
    @OneToMany(() => Grade, (grade) => grade.gradeScale)
    grades: Grade[];
}