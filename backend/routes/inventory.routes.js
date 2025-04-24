const express = require("express");
const {
  getInventory,
  getInventoryById,
  addInventory,
  updateInventory,
  deleteInventory,
  deductInventory,
  getBatches,
  addToInventory,
  getExpiringMedications,
} = require("../controllers/inventory.controller");
const authMiddleware = require("../middlewares/auth.middleware");
const isPharmacyStaffMiddleware = require("../middlewares/isPharmacyStaff.middleware");

const router = express.Router();

router.get("/", authMiddleware, isPharmacyStaffMiddleware, getInventory);

router.get("/batches", authMiddleware, isPharmacyStaffMiddleware, getBatches);

router.get(
  "/expired",
  authMiddleware,
  isPharmacyStaffMiddleware,
  getExpiringMedications
);

router.get("/:id", authMiddleware, isPharmacyStaffMiddleware, getInventoryById);

router.post("/", authMiddleware, isPharmacyStaffMiddleware, addInventory);

router.put(
  "/deduct",
  authMiddleware,
  isPharmacyStaffMiddleware,
  deductInventory
);

router.put(
  "/addtoinventory",
  authMiddleware,
  isPharmacyStaffMiddleware,
  addToInventory
);

router.put("/:id", authMiddleware, isPharmacyStaffMiddleware, updateInventory);

router.delete(
  "/:id",
  authMiddleware,
  isPharmacyStaffMiddleware,
  deleteInventory
);

module.exports = router;
