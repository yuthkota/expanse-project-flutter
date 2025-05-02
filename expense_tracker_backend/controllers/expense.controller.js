import { ExpenseModel } from "../models/expense.model.js"

export const addExpense = async (req, res, next) => {
  try {
    const { amount, category, date, notes } = req.body
    const userId = req.user.id

    // Validate input
    if (!amount || !category || !date) {
      return res.status(400).json({ error: "Amount, category, and date are required" })
    }

    // Create expense
    const expense = await ExpenseModel.create({
      userId,
      amount,
      category,
      date,
      notes,
    })

    res.status(201).json({ message: "Expense added successfully", expenseId: expense.id })
  } catch (error) {
    next(error)
  }
}

export const getAllExpenses = async (req, res, next) => {
  try {
    const userId = req.user.id
    const expenses = await ExpenseModel.findAllByUserId(userId)
    res.json(expenses)
  } catch (error) {
    next(error)
  }
}

export const getMonthlyExpenses = async (req, res, next) => {
  try {
    const userId = req.user.id
    const { year, month } = req.params

    // Validate input
    if (!year || !month) {
      return res.status(400).json({ error: "Year and month are required" })
    }

    const expenses = await ExpenseModel.findByMonth(userId, year, month)
    res.json(expenses)
  } catch (error) {
    next(error)
  }
}

export const getMonthlyStats = async (req, res, next) => {
  try {
    const userId = req.user.id
    const { year, month } = req.params

    // Validate input
    if (!year || !month) {
      return res.status(400).json({ error: "Year and month are required" })
    }

    const stats = await ExpenseModel.getMonthlyStats(userId, year, month)
    res.json(stats)
  } catch (error) {
    next(error)
  }
}

export const updateExpense = async (req, res, next) => {
  try {
    const { id } = req.params
    const { amount, category, date, notes } = req.body
    const userId = req.user.id

    // Validate input
    if (!amount || !category || !date) {
      return res.status(400).json({ error: "Amount, category, and date are required" })
    }

    // Check if expense exists and belongs to user
    const expense = await ExpenseModel.findById(id)
    if (!expense) {
      return res.status(404).json({ error: "Expense not found" })
    }
    if (expense.USER_ID !== userId) {
      return res.status(403).json({ error: "Not authorized to update this expense" })
    }

    // Update expense
    const success = await ExpenseModel.update(id, {
      amount,
      category,
      date,
      notes,
    })

    if (success) {
      res.json({ message: "Expense updated successfully" })
    } else {
      res.status(500).json({ error: "Failed to update expense" })
    }
  } catch (error) {
    next(error)
  }
}

export const deleteExpense = async (req, res, next) => {
  try {
    const { id } = req.params
    const userId = req.user.id

    // Check if expense exists and belongs to user
    const expense = await ExpenseModel.findById(id)
    if (!expense) {
      return res.status(404).json({ error: "Expense not found" })
    }
    if (expense.USER_ID !== userId) {
      return res.status(403).json({ error: "Not authorized to delete this expense" })
    }

    // Delete expense
    const success = await ExpenseModel.delete(id)

    if (success) {
      res.json({ message: "Expense deleted successfully" })
    } else {
      res.status(500).json({ error: "Failed to delete expense" })
    }
  } catch (error) {
    next(error)
  }
}
