const express = require("express");
const {
  addMedicationCategory,
  updateMedicationCategory,
  getMedicationCategories,
  deleteMedicationCategory,
} = require("../controllers/medicationCategory.controller");
const authMiddleware = require("../middlewares/auth.middleware");
const isPharmacyStaffMiddleware = require("../middlewares/isPharmacyStaff.middleware");

const router = express.Router();

router.post(
  "/",
  authMiddleware,
  isPharmacyStaffMiddleware,
  addMedicationCategory
);

router.put(
  "/:id",
  authMiddleware,
  isPharmacyStaffMiddleware,
  updateMedicationCategory
);

router.get(
  "/",
  authMiddleware,
  isPharmacyStaffMiddleware,
  getMedicationCategories
);

router.delete(
  "/:id",
  authMiddleware,
  isPharmacyStaffMiddleware,
  deleteMedicationCategory
);

module.exports = router;
