import jwt from "jsonwebtoken"
import { UserModel } from "../models/user.model.js"

export const register = async (req, res, next) => {
  try {
    const { username, email, password } = req.body

    // Validate input
    if (!username || !email || !password) {
      return res.status(400).json({ error: "All fields are required" })
    }

    // Check if user already exists
    const userExists = await UserModel.exists(username, email)
    if (userExists) {
      return res.status(409).json({ error: "Username or email already exists" })
    }

    // Create user
    const user = await UserModel.create({ username, email, password })

    res.status(201).json({ message: "User registered successfully", userId: user.id })
  } catch (error) {
    next(error)
  }
}

export const login = async (req, res, next) => {
  try {
    const { username, password } = req.body

    // Validate input
    if (!username || !password) {
      return res.status(400).json({ error: "Username and password are required" })
    }

    // Find user
    const user = await UserModel.findByUsername(username)
    if (!user) {
      return res.status(401).json({ error: "Invalid credentials" })
    }

    // Verify password
    const validPassword = await UserModel.verifyPassword(user, password)
    if (!validPassword) {
      return res.status(401).json({ error: "Invalid credentials" })
    }

    // Generate JWT token
    const token = jwt.sign({ id: user.ID, username: user.USERNAME }, process.env.JWT_SECRET, { expiresIn: "24h" })

    res.json({
      message: "Login successful",
      token,
      userId: user.ID,
      username: user.USERNAME,
    })
  } catch (error) {
    next(error)
  }
}
