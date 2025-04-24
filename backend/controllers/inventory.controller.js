const errorHandler = require("../utils/errorHandler.js");
const inventoryServices = require("../services/inventory.service.js");

const getInventory = async (req, res, next) => {
  try {
    const response = await inventoryServices.getInventory(
      req.user.pharmacy_id,
      req.query
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response?.reverse());
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const getInventoryById = async (req, res, next) => {
  try {
    const response = await inventoryServices.getInventoryById(
      req.user.pharmacy_id,
      req.params.id
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const addInventory = async (req, res, next) => {
  try {
    const response = await inventoryServices.addInventory(
      req.user.pharmacy_id,
      req.body
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const updateInventory = async (req, res, next) => {
  try {
    const response = await inventoryServices.updateInventory(
      req.user.pharmacy_id,
      req.params.id,
      req.body
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const deleteInventory = async (req, res, next) => {
  try {
    const response = await inventoryServices.deleteInventory(
      req.user.pharmacy_id,
      req.params.id
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json({ message: "Inventory deleted successfully" });
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const addToInventory = async (req, res, next) => {
  try {
    const response = await inventoryServices.addToInventory(
      req.user.pharmacy_id,
      req.body
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json({ message: "Inventory quanitiy added successfully" });
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const deductInventory = async (req, res, next) => {
  try {
    const response = await inventoryServices.deductInventory(
      req.user.pharmacy_id,
      req.body
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json({ message: "Inventory deducted successfully" });
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const getBatches = async (req, res, next) => {
  try {
    const response = await inventoryServices.getBatches(
      req.user.pharmacy_id,
      req.query
    );

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response?.reverse());
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const getExpiringMedications = async (req, res, next) => {
  try {
    const response = await inventoryServices.getExpiringMedications(
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

module.exports = {
  getInventory,
  getInventoryById,
  addInventory,
  updateInventory,
  deleteInventory,
  addToInventory,
  deductInventory,
  getBatches,
  getExpiringMedications,
};
