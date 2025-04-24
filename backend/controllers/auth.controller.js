const authSerivces = require("../services/auth.service");
const deleteFiles = require("../utils/deleteFiles");
const errorHandler = require("../utils/errorHandler");

const registerUser = async (req, res, next) => {
  try {
    const response = await authSerivces.registerUser(req.body);
    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(201).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const loginUser = async (req, res, next) => {
  try {
    const response = await authSerivces.loginUser(req.body);

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res
      .status(200)
      .cookie("jwt", response.token, {
        httpOnly: true,
        maxAge: 30 * 24 * 60 * 60 * 1000,
        secure: process.env.NODE_ENV == "production",
        sameSite: "lax",
      })
      .json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const logout = async (req, res, next) => {
  try {
    res.clearCookie("jwt");

    res.status(200).json({ message: "Logged out successfully" });
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const checkUser = async (req, res, next) => {
  try {
    res.status(200).json({ success: true, user: req.user });
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const resetPassword = async (req, res, next) => {
  try {
    const response = await authSerivces.resetPassword(
      req.body,
      req.params.token
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const forgetPassword = async (req, res, next) => {
  try {
    const response = await authSerivces.forgetPassword(req.body);

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

module.exports = {
  registerUser,
  loginUser,
  logout,
  checkUser,
  resetPassword,
  forgetPassword,
};
