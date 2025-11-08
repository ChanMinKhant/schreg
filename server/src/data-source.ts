// src/data-source.ts

import dotenv from "dotenv"
dotenv.config()
import "reflect-metadata"
import { DataSource } from "typeorm"
import { User } from "./entity/User"


export const AppDataSource = new DataSource({
    type: "postgres",
    host: process.env.DB_HOST || "localhost",
    port: Number(process.env.DB_PORT) || 5432,
    username: process.env.DB_USER || "user", 
    password: process.env.DB_PASSWORD || "root", 
    database: process.env.DB_NAME || "mydb", 
    synchronize: true,
    logging: true, 
    entities: [User], 
    migrations: [],
    subscribers: [],
    ssl: {
        rejectUnauthorized: false, 
    },
})
