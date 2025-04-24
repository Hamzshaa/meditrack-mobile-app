const pharmacySerivces = require("../services/pharmacy.service");
const deleteFiles = require("../utils/deleteFiles");
const errorHandler = require("../utils/errorHandler");

const registerPharmacy = async (req, res, next) => {
  try {
    const { pharmacy_image } = req.uploadedFiles;
    const response = await pharmacySerivces.registerPharmacy(
      req.body,
      pharmacy_image
    );
    if (response instanceof Error) {
      deleteFiles(req.uploadedFiles);
      return next(errorHandler(400, response.message));
    }

    res.status(201).json(response);
  } catch (error) {
    deleteFiles(req.uploadedFiles);
    next(errorHandler(500, "Internal server error"));
  }
};

const getPharmacies = async (req, res, next) => {
  try {
    const response = await pharmacySerivces.getPharmacies();

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response?.reverse());
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const getPharmacyById = async (req, res, next) => {
  try {
    const response = await pharmacySerivces.getPharmacyById(
      req.params.pharmacyId
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const updatePharmacy = async (req, res, next) => {
  try {
    const { pharmacy_image } = req.uploadedFiles;
    const response = await pharmacySerivces.updatePharmacy(
      req.params.pharmacyId,
      req.body,
      pharmacy_image
    );

    if (response instanceof Error) {
      deleteFiles(req.uploadedFiles);
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    deleteFiles(req.uploadedFiles);
    next(errorHandler(500, "Internal server error"));
  }
};

const deletePharmacy = async (req, res, next) => {
  try {
    const response = await pharmacySerivces.deletePharmacy(
      req.params.pharmacyId
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

module.exports = {
  registerPharmacy,
  getPharmacies,
  getPharmacyById,
  updatePharmacy,
  deletePharmacy,
};
