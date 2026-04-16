require("dotenv").config();
const express = require("express");
const cors = require("cors");
const authRoutes = require("./routes/auth");
const feedRoutes = require("./routes/feed");
const articleRoutes = require("./routes/article");
const searchRoutes = require("./routes/search");

const app = express();

app.use(
  cors({
    origin: process.env.CORS_ORIGIN || ["http://localhost:5173", "http://127.0.0.1:5173"],
    credentials: true,
  })
);
app.use(express.json());

app.use("/api", authRoutes);
app.use("/api/feed", feedRoutes);
app.use("/api/articles", articleRoutes);
app.use("/api/search", searchRoutes);

app.listen(Number(process.env.PORT) || 3000, () => {
  console.log("server running at http://localhost:%s", Number(process.env.PORT) || 3000);
});
