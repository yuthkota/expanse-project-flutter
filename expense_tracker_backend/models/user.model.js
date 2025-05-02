import { getDatabase } from "../config/db.js"
import bcrypt from "bcrypt"

export class UserModel {
  /**
   * Create a new user
   * @param {Object} userData - User data
   * @param {string} userData.username - Username
   * @param {string} userData.email - Email
   * @param {string} userData.password - Password (will be hashed)
   * @returns {Promise<Object>} - Created user data
   */
  static async create(userData) {
    const db = await getDatabase()
    const { username, email, password } = userData

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10)

    // Insert user into database
    const result = await db.run("INSERT INTO USERS (USERNAME, EMAIL, HASHED_PASS) VALUES (?, ?, ?)", [
      username,
      email,
      hashedPassword,
    ])

    return {
      id: result.lastID,
      username,
      email,
    }
  }

  /**
   * Find a user by username
   * @param {string} username - Username to search for
   * @returns {Promise<Object|null>} - User data or null if not found
   */
  static async findByUsername(username) {
    const db = await getDatabase()
    return await db.get("SELECT * FROM USERS WHERE USERNAME = ?", [username])
  }

  /**
   * Find a user by email
   * @param {string} email - Email to search for
   * @returns {Promise<Object|null>} - User data or null if not found
   */
  static async findByEmail(email) {
    const db = await getDatabase()
    return await db.get("SELECT * FROM USERS WHERE EMAIL = ?", [email])
  }

  /**
   * Find a user by ID
   * @param {number} id - User ID to search for
   * @returns {Promise<Object|null>} - User data or null if not found
   */
  static async findById(id) {
    const db = await getDatabase()
    return await db.get("SELECT * FROM USERS WHERE ID = ?", [id])
  }

  /**
   * Check if username or email already exists
   * @param {string} username - Username to check
   * @param {string} email - Email to check
   * @returns {Promise<boolean>} - True if user exists, false otherwise
   */
  static async exists(username, email) {
    const db = await getDatabase()
    const user = await db.get("SELECT * FROM USERS WHERE USERNAME = ? OR EMAIL = ?", [username, email])
    return !!user
  }

  /**
   * Verify password for a user
   * @param {Object} user - User object with hashed password
   * @param {string} password - Plain text password to verify
   * @returns {Promise<boolean>} - True if password is valid, false otherwise
   */
  static async verifyPassword(user, password) {
    return await bcrypt.compare(password, user.HASHED_PASS)
  }
}
