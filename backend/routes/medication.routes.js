const express = require("express");
const {
  addMedication,
  updateMedication,
  getMedications,
  searchMedications,
  getMedicationById,
  deleteMedication,
} = require("../controllers/medication.controller");
const authMiddleware = require("../middlewares/auth.middleware");
const isPharmacyStaffMiddleware = require("../middlewares/isPharmacyStaff.middleware");

const router = express.Router();

router.post("/", authMiddleware, isPharmacyStaffMiddleware, addMedication);

router.put("/:id", authMiddleware, isPharmacyStaffMiddleware, updateMedication);

router.get("/", authMiddleware, isPharmacyStaffMiddleware, getMedications);

router.get("/search", searchMedications);

router.get(
  "/:id",
  authMiddleware,
  isPharmacyStaffMiddleware,
  getMedicationById
);

router.delete(
  "/:id",
  authMiddleware,
  isPharmacyStaffMiddleware,
  deleteMedication
);

module.exports = router;
