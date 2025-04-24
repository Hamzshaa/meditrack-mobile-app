const errorHandler = require("../utils/errorHandler.js");
const medicationServices = require("../services/medication.service.js");

const addMedication = async (req, res, next) => {
  try {
    const response = await medicationServices.addMedication(
      req.body,
      req.user.pharmacy_id
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(201).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const updateMedication = async (req, res, next) => {
  try {
    const response = await medicationServices.updateMedication(
      req.params.id,
      req.body,
      req.user.pharmacy_id
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const getMedications = async (req, res, next) => {
  try {
    const response = await medicationServices.getMedications(
      req.user.pharmacy_id
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const searchMedications = async (req, res, next) => {
  try {
    const response = await medicationServices.searchMedications(req.query);

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const getMedicationById = async (req, res, next) => {
  try {
    const response = await medicationServices.getMedicationById(
      req.params.id,
      req.user.pharmacy_id
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const deleteMedication = async (req, res, next) => {
  try {
    const response = await medicationServices.deleteMedication(
      req.params.id,
      req.user.pharmacy_id
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(204).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

module.exports = {
  addMedication,
  updateMedication,
  getMedications,
  searchMedications,
  getMedicationById,
  deleteMedication,
};
