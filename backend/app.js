const express = require("express");
const cors = require("cors");
const cookieParser = require("cookie-parser");
const dotenv = require("dotenv");
const path = require("path");
const routes = require("./routes/index.js");
const { swaggerDocs, swaggerUi } = require("./lib/swagger.js");

dotenv.config();

const app = express();

const allowedOrigins = [
  "http://localhost:5173",
  "http://localhost:5000",
  "http://localhost:58722",
];

app.use(
  cors({
    origin: (origin, callback) => {
      // if (!origin || allowedOrigins.includes(origin)) {
      if (
        !origin ||
        allowedOrigins.includes(origin) ||
        !allowedOrigins.includes(origin)
      ) {
        callback(null, true);
      } else {
        callback(new Error("Not allowed by CORS"));
      }
    },
    credentials: true,
  })
);
app.use("/medias", express.static(path.join(__dirname, "medias")));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());

app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocs));

app.use("/api/v1", routes);

app.listen(process.env.PORT, () => {
  console.log(`Server is running on port ${process.env.PORT}`);
});

app.use((err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  const message = err.message || "Internal server error";

  console.log(statusCode, message);
  res.status(statusCode).json({ success: false, statusCode, message });
});
