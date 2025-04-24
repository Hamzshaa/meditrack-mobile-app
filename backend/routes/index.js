const express = require("express");
const authRoute = require("./auth.routes");
const userRoute = require("./user.routes");
const commentRoute = require("./comment.routes");
const pharmacyRoute = require("./pharmacy.routes");
const medicationCategoryRoute = require("./mediactionCategory.routes");
const medicationRoute = require("./medication.routes");
const inventoryRoute = require("./inventory.routes");
const overviewRoute = require("./overview.routes");
const reportRoute = require("./report.routes");

const router = express.Router();

router.use("/auth", authRoute);
router.use("/users", userRoute);
router.use("/comments", commentRoute);
router.use("/pharmacies", pharmacyRoute);
router.use("/medication-categories", medicationCategoryRoute);
router.use("/medications", medicationRoute);
router.use("/inventory", inventoryRoute);
router.use("/overview", overviewRoute);
router.use("/reports", reportRoute);

module.exports = router;
