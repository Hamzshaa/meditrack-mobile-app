const { query } = require("../lib/db.js");

const sendComment = async (data) => {
  try {
    const { full_name, email, comment } = data;

    if (!full_name || !email || !comment) {
      return new Error("All fields are required");
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!emailRegex.test(email)) {
      return new Error("Invalid email");
    }

    if (comment.length < 10) {
      return new Error("Comment must be at least 10 characters long");
    }

    const sendCommentQuery = `INSERT INTO comments (full_name, email, comment) VALUES (?, ?, ?)`;

    const result = await query(sendCommentQuery, [full_name, email, comment]);

    return result;
  } catch (error) {
    return error;
  }
};

const getComments = async () => {
  try {
    const getCommentsQuerys = `SELECT * FROM comments`;

    const comments = await query(getCommentsQuerys);

    return comments;
  } catch (error) {
    return error;
  }
};

module.exports = {
  sendComment,
  getComments,
};
