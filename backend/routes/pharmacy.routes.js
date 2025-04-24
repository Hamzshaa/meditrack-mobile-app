const express = require("express");
const {
  registerPharmacy,
  getPharmacies,
  getPharmacyById,
  updatePharmacy,
  deletePharmacy,
} = require("../controllers/pharmacy.controller");
const authMiddleware = require("../middlewares/auth.middleware");
const isAdminMiddleware = require("../middlewares/isAdmin.middleware");
const uploadFile = require("../middlewares/fileUpload.middelware");

const router = express.Router();

router.post(
  "/",
  authMiddleware,
  isAdminMiddleware,
  uploadFile({
    pharmacy_image: "pharmacy_images",
  }),
  registerPharmacy
);

router.get("/", authMiddleware, isAdminMiddleware, getPharmacies);

router.get("/:pharmacyId", getPharmacyById);

router.put(
  "/:pharmacyId",
  authMiddleware,
  uploadFile({
    pharmacy_image: "pharmacy_images",
  }),
  updatePharmacy
);

router.delete(
  "/:pharmacyId",
  authMiddleware,
  isAdminMiddleware,
  deletePharmacy
);

module.exports = router;
