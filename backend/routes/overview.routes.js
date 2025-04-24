const express = require("express");
const {
  getPharmacyDashboard,
  getAdminOverview,
} = require("../controllers/overview.controller");
const authMiddleware = require("../middlewares/auth.middleware");
const isPharmacyStaffMiddleware = require("../middlewares/isPharmacyStaff.middleware");
const isAdminMiddleware = require("../middlewares/isAdmin.middleware");

const router = express.Router();

router.get(
  "/pharmacy-dashboard",
  authMiddleware,
  isPharmacyStaffMiddleware,
  getPharmacyDashboard
);

router.get(
  "/admin-dashboard",
  authMiddleware,
  isAdminMiddleware,
  getAdminOverview
);

module.exports = router;
