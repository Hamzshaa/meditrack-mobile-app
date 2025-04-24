const { query } = require("../lib/db.js");
const bcryptjs = require("bcryptjs");

const getUsers = async (email, phone) => {
  try {
    const getUserQuerys = `SELECT * FROM users`;

    const users = await query(getUserQuerys);

    return users;
  } catch (error) {
    return error;
  }
};

const getUser = async (email, phone) => {
  try {
    if (email) {
      const getUserQuery = `SELECT * FROM users WHERE email = ?`;

      const users = await query(getUserQuery, [email]);

      return users;
    } else {
      const getUserQuery = `SELECT * FROM users WHERE phone = ?`;

      const users = await query(getUserQuery, [phone]);

      return users;
    }
  } catch (error) {
    return error;
  }
};

const getUserById = async (userId, showPassword) => {
  try {
    const getUserQuery = `SELECT * FROM users WHERE user_id = ?`;

    const users = await query(getUserQuery, [userId]);

    if (users.length === 0) {
      return new Error("User not found");
    }

    if (!showPassword) {
      users[0].password = undefined;
    }

    return users;
  } catch (error) {
    return error;
  }
};

const updateUser = async (userId, data, profilePhoto) => {
  try {
    const { first_name, last_name, email, phone } = data;

    const user = await getUserById(userId);

    if (user instanceof Error) {
      return user;
    }

    if (user.length === 0) {
      return new Error("User not found");
    }

    const updateQuery = `UPDATE users SET first_name = ?, last_name = ?, email = ?, phone = ? WHERE user_id = ?`;

    const result = await query(updateQuery, [
      first_name || user[0].first_name,
      last_name || user[0].last_name,
      email || "",
      phone || user[0].phone,
      userId,
    ]);

    const updatedUser = await getUserById(userId);

    if (updatedUser instanceof Error) {
      return updatedUser;
    }

    return updatedUser[0];
  } catch (error) {
    return error;
  }
};

const changePassword = async (userId, data) => {
  try {
    const { old_password, new_password } = data;

    const user = await getUserById(userId, true);

    if (user instanceof Error) {
      return user;
    }

    if (user.length === 0) {
      return new Error("User not found");
    }

    const isMatch = await bcryptjs.compare(old_password, user[0].password);

    if (!isMatch) {
      return new Error("Old password is incorrect");
    }

    const hashedPassword = await bcryptjs.hash(new_password, 10);

    const updateQuery = `UPDATE users SET password = ? WHERE user_id = ?`;

    const result = await query(updateQuery, [hashedPassword, userId]);

    return result;
  } catch (error) {
    return error;
  }
};

const deleteUser = async (userId, currentUser) => {
  try {
    const user = await getUserById(userId);

    if (user instanceof Error) {
      return user;
    }

    if (user.length === 0) {
      return new Error("User not found");
    }

    if (user[0].role === "admin" && currentUser !== user[0].created_by) {
      return new Error("Unauthorized to delete this user");
    }

    const deleteQuery = `DELETE FROM users WHERE user_id = ?`;

    const result = await query(deleteQuery, [userId]);

    return result;
  } catch (error) {
    return error;
  }
};

module.exports = {
  getUsers,
  getUser,
  getUserById,
  updateUser,
  changePassword,
  deleteUser,
};
