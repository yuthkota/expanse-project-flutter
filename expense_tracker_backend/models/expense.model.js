import { getDatabase } from "../config/db.js"

export class ExpenseModel {
  /**
   * Create a new expense
   * @param {Object} expenseData - Expense data
   * @param {number} expenseData.userId - User ID
   * @param {number} expenseData.amount - Expense amount
   * @param {string} expenseData.category - Expense category
   * @param {string} expenseData.date - Expense date (YYYY-MM-DD)
   * @param {string|null} expenseData.notes - Optional notes
   * @returns {Promise<Object>} - Created expense data
   */
  static async create(expenseData) {
    const db = await getDatabase()
    const { userId, amount, category, date, notes } = expenseData

    const result = await db.run("INSERT INTO EXPENSE (USER_ID, AMOUNT, CATEGORY, DATE, NOTES) VALUES (?, ?, ?, ?, ?)", [
      userId,
      amount,
      category,
      date,
      notes || null,
    ])

    return {
      id: result.lastID,
      userId,
      amount,
      category,
      date,
      notes,
    }
  }

  /**
   * Get all expenses for a user
   * @param {number} userId - User ID
   * @returns {Promise<Array>} - Array of expenses
   */
  static async findAllByUserId(userId) {
    const db = await getDatabase()
    return await db.all("SELECT * FROM EXPENSE WHERE USER_ID = ? ORDER BY DATE DESC", [userId])
  }

  /**
   * Get expenses for a specific month
   * @param {number} userId - User ID
   * @param {number} year - Year
   * @param {number} month - Month (1-12)
   * @returns {Promise<Array>} - Array of expenses
   */
  static async findByMonth(userId, year, month) {
    const db = await getDatabase()

    // Format month with leading zero if needed
    const formattedMonth = month.toString().padStart(2, "0")

    // SQLite date filtering
    const startDate = `${year}-${formattedMonth}-01`
    const endDate = `${year}-${formattedMonth}-31` // This is simplified; in a real app, calculate the actual end of month

    return await db.all("SELECT * FROM EXPENSE WHERE USER_ID = ? AND DATE >= ? AND DATE <= ? ORDER BY DATE", [
      userId,
      startDate,
      endDate,
    ])
  }

  /**
   * Get expense statistics by category for a specific month
   * @param {number} userId - User ID
   * @param {number} year - Year
   * @param {number} month - Month (1-12)
   * @returns {Promise<Array>} - Array of category statistics
   */
  static async getMonthlyStats(userId, year, month) {
    const db = await getDatabase()

    // Format month with leading zero if needed
    const formattedMonth = month.toString().padStart(2, "0")

    // SQLite date filtering
    const startDate = `${year}-${formattedMonth}-01`
    const endDate = `${year}-${formattedMonth}-31`

    return await db.all(
      `SELECT CATEGORY, SUM(AMOUNT) as TOTAL 
       FROM EXPENSE 
       WHERE USER_ID = ? AND DATE >= ? AND DATE <= ? 
       GROUP BY CATEGORY 
       ORDER BY TOTAL DESC`,
      [userId, startDate, endDate],
    )
  }

  /**
   * Get an expense by ID
   * @param {number} id - Expense ID
   * @returns {Promise<Object|null>} - Expense data or null if not found
   */
  static async findById(id) {
    const db = await getDatabase()
    return await db.get("SELECT * FROM EXPENSE WHERE ID = ?", [id])
  }

  /**
   * Update an expense
   * @param {number} id - Expense ID
   * @param {Object} expenseData - Updated expense data
   * @returns {Promise<boolean>} - True if updated successfully
   */
  static async update(id, expenseData) {
    const db = await getDatabase()
    const { amount, category, date, notes } = expenseData

    const result = await db.run("UPDATE EXPENSE SET AMOUNT = ?, CATEGORY = ?, DATE = ?, NOTES = ? WHERE ID = ?", [
      amount,
      category,
      date,
      notes || null,
      id,
    ])

    return result.changes > 0
  }

  /**
   * Delete an expense
   * @param {number} id - Expense ID
   * @returns {Promise<boolean>} - True if deleted successfully
   */
  static async delete(id) {
    const db = await getDatabase()
    const result = await db.run("DELETE FROM EXPENSE WHERE ID = ?", [id])
    return result.changes > 0
  }
}
