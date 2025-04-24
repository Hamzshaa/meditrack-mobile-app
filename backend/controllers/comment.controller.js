const errorHandler = require("../utils/errorHandler.js");
const commentServices = require("../services/comment.service.js");

const sendComment = async (req, res, next) => {
  try {
    const response = await commentServices.sendComment(req.body);

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json({ message: "Comment sent successfully" });
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

const getComments = async (req, res, next) => {
  try {
    const response = await commentServices.getComments();

    if (response instanceof Error) {
      return next(errorHandler(400, response.message));
    }

    res.status(200).json(response?.reverse());
  } catch (error) {
    next(errorHandler(500, "Internal server error"));
  }
};

module.exports = {
  getComments,
  sendComment,
};
