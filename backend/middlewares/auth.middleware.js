const errorHandler = require("../utils/errorHandler");
const jwt = require("jsonwebtoken");
const userServices = require("../services/user.service");

const protectRoute = async (req, res, next) => {
  try {
    const token = req.headers.authorization
      ? req.headers.authorization
      : req.cookies.jwt;

    if (!token) {
      return next(errorHandler(401, "Unauthorized"));
    }

    const decoded = jwt.decode(token);

    if (!decoded || !decoded.exp) {
      return next(errorHandler(401, "Unauthorized: Invalid token"));
    }

    const currentTime = Math.floor(Date.now() / 1000);
    if (decoded.exp < currentTime) {
      return next(errorHandler(401, "Unauthorized: Token expired"));
    }

    const verified = jwt.verify(token, process.env.JWT_SECRET);

    if (!verified) {
      return next(errorHandler(401, "Unauthorized"));
    }

    const user = await userServices.getUserById(decoded.userId);

    if (user instanceof Error) {
      return next(errorHandler(401, "Unauthorized"));
    }

    if (user.length === 0) {
      return next(errorHandler(404, "User not found"));
    }

    user[0].password = undefined;

    req.user = user[0];

    next();
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
};

module.exports = protectRoute;
