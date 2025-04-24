const express = require("express");
const {
  registerUser,
  loginUser,
  logout,
  checkUser,
  generateResetToken,
  resetPassword,
  forgetPassword,
} = require("../controllers/auth.controller");
const uploadFile = require("../middlewares/fileUpload.middelware");
const authMiddleware = require("../middlewares/auth.middleware");
const isAdminMiddleware = require("../middlewares/isAdmin.middleware");

const router = express.Router();

router.post(
  "/register",
  authMiddleware,
  isAdminMiddleware,
  // uploadFile({
  //   profile_photo: "profile_photos",
  // }),
  registerUser
);

router.post("/login", loginUser);

router.post("/logout", logout);

router.get("/checkuser", authMiddleware, checkUser);

router.post("/password-reset/:token", resetPassword);

router.post("/forget-password", forgetPassword);

module.exports = router;
