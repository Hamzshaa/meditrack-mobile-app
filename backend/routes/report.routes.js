const express = require("express");
const { getReport } = require("../controllers/report.controller");
const authMiddleware = require("../middlewares/auth.middleware");
const isPharmacyStaffMiddleware = require("../middlewares/isPharmacyStaff.middleware");

const router = express.Router();

router.get("/pharmacy", authMiddleware, isPharmacyStaffMiddleware, getReport);

module.exports = router;
