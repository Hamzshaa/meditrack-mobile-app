const errorHandler = require("../utils/errorHandler.js");
const reportServices = require("../services/report.service.js");

const getReport = async (req, res, next) => {
  try {
    const response = await reportServices.getReport(
      req.user.pharmacy_id,
      req.params
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
  getReport,
};
