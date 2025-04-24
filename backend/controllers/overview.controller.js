const errorHandler = require("../utils/errorHandler.js");
const overviewServices = require("../services/overview.service.js");

const getPharmacyDashboard = async (req, res, next) => {
  try {
    const response = await overviewServices.getPharmacyDashboard(
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

const getAdminOverview = async (req, res, next) => {
  try {
    const response = await overviewServices.getAdminOverview(req.user.user_id);

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response);
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

module.exports = {
  getPharmacyDashboard,
  getAdminOverview,
};
