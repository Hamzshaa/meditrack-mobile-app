const errorHandler = require("../utils/errorHandler.js");
const medicationCategoryServices = require("../services/medicationCategory.service.js");

const addMedicationCategory = async (req, res, next) => {
  try {
    const response = await medicationCategoryServices.addMedicationCategory(
      req.user.pharmacy_id,
      req.body
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json({ message: "Medication category added successfully" });
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const updateMedicationCategory = async (req, res, next) => {
  try {
    const response = await medicationCategoryServices.updateMedicationCategory(
      req.params.id,
      req.user.pharmacy_id,
      req.body
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res
      .status(200)
      .json({ message: "Medication category updated successfully" });
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const getMedicationCategories = async (req, res, next) => {
  try {
    const response = await medicationCategoryServices.getMedicationCategories(
      req.user.pharmacy_id
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response?.reverse());
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const deleteMedicationCategory = async (req, res, next) => {
  try {
    const response = await medicationCategoryServices.deleteMedicationCategory(
      req.params.id,
      req.user.pharmacy_id
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res
      .status(200)
      .json({ message: "Medication category deleted successfully" });
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

module.exports = {
  addMedicationCategory,
  updateMedicationCategory,
  getMedicationCategories,
  deleteMedicationCategory,
};
