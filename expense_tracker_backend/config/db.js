import sqlite3 from "sqlite3"
import { open } from "sqlite"

let db

export async function getDatabase() {
  if (!db) {
    db = await open({
      filename: "./database.sqlite",
      driver: sqlite3.Database,
    })
  }
  return db
}

export async function initializeDatabase() {
  const db = await getDatabase()

  // Create tables if they don't exist
  await db.exec(`
    CREATE TABLE IF NOT EXISTS USERS (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      USERNAME TEXT UNIQUE NOT NULL,
      EMAIL TEXT UNIQUE NOT NULL,
      HASHED_PASS TEXT NOT NULL
    );
    
    CREATE TABLE IF NOT EXISTS EXPENSE (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      USER_ID INTEGER NOT NULL,
      AMOUNT DECIMAL NOT NULL,
      CATEGORY TEXT NOT NULL,
      DATE TEXT NOT NULL,
      NOTES TEXT,
      FOREIGN KEY (USER_ID) REFERENCES USERS(ID)
    );
  `)

  console.log("Database setup completed")
  return db
}
