import express from "express";
import cors from "cors";
import { config } from "dotenv";
import authRoutes from "./routes/auth.routes.js";
import expenseRoutes from "./routes/expense.routes.js";
import { errorHandler } from "./middleware/error.middleware.js";
import { initializeDatabase } from "./config/db.js";

// Load environment variables
config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(cors());

// Define the root route
app.get('/', (req, res) => {
  res.send('API is running');
});

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/expenses", expenseRoutes);

// Error handling middleware
app.use(errorHandler);

// Handle undefined routes (404 errors)
app.use((req, res) => {
  res.status(404).send("Route not found");
});

// Start server
async function startServer() {
  try {
    await initializeDatabase();
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  } catch (error) {
    console.error("Failed to start server:", error);
    process.exit(1);
  }
}

startServer();
