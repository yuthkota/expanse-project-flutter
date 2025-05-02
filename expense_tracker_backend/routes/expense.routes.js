import express from "express"
import { authenticateToken } from "../middleware/auth.middleware.js"
import { addExpense, getAllExpenses, getMonthlyExpenses, getMonthlyStats } from "../controllers/expense.controller.js"

const router = express.Router()

// Apply authentication middleware to all expense routes
router.use(authenticateToken)

router.post("/", addExpense)
router.get("/", getAllExpenses)
router.get("/month/:year/:month", getMonthlyExpenses)
router.get("/stats/:year/:month", getMonthlyStats)

export default router
