const express = require("express");
const {
  getUsers,
  getUserById,
  updateUser,
  changePassword,
  deleteUser,
} = require("../controllers/user.controller");
const authMiddleware = require("../middlewares/auth.middleware");
const isAdminMiddleware = require("../middlewares/isAdmin.middleware");
const uploadFile = require("../middlewares/fileUpload.middelware");

const router = express.Router();

router.get("/", authMiddleware, getUsers);

router.get("/:userId", authMiddleware, getUserById);

router.put("/:userId", authMiddleware, updateUser);

router.put("/:userId/password", authMiddleware, changePassword);

router.delete("/:userId", authMiddleware, isAdminMiddleware, deleteUser);

module.exports = router;
