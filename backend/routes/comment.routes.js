const express = require("express");
const {
  sendComment,
  getComments,
} = require("../controllers/comment.controller");
const authMiddleware = require("../middlewares/auth.middleware");
const isAdminMiddleware = require("../middlewares/isAdmin.middleware");

const router = express.Router();

router.post("/", sendComment);

router.get("/", authMiddleware, isAdminMiddleware, getComments);

module.exports = router;
