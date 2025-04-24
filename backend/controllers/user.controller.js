const errorHandler = require("../utils/errorHandler.js");
const userServices = require("../services/user.service.js");

const getUsers = async (req, res, next) => {
  try {
    const response = await userServices.getUsers();

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const getUserById = async (req, res, next) => {
  try {
    const { userId } = req.params;

    const response = await userServices.getUserById(userId);

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const updateUser = async (req, res, next) => {
  try {
    const { userId } = req.params;

    const response = await userServices.updateUser(userId, req.body);

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res
      .status(200)
      .json({ message: "User updated successfully", user: response });
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const changePassword = async (req, res, next) => {
  try {
    const { userId } = req.params;
    const response = await userServices.changePassword(userId, req.body);

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json({ message: "Password updated successfully" });
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const deleteUser = async (req, res, next) => {
  try {
    const { userId } = req.params;
    const response = await userServices.deleteUser(userId, req.user.id);

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json({ message: "User deleted successfully" });
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

module.exports = {
  getUsers,
  getUserById,
  updateUser,
  changePassword,
  deleteUser,
};
