const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
const { query } = require("../lib/db.js");
const userServices = require("./user.service");
const dotenv = require("dotenv");
const sendEmail = require("../utils/mailsend.js");
dotenv.config();

const registerUser = async (userBody) => {
  try {
    const { first_name, last_name, email, phone, role } = userBody;

    if (!first_name || !last_name || !email || !role || !phone) {
      return new Error("Please provide all required fields");
    }

    if (phone.length < 10 || phone.length > 13) {
      return new Error("Phone number is invalid");
    }

    const emailRegex = /\S+@\S+\.\S+/;

    if (!emailRegex.test(email)) {
      return new Error("Email is invalid");
    }

    if (role !== "admin" && role !== "pharmacy_staff") {
      return new Error("Role is invalid");
    }

    const user = await userServices.getUser(email, phone);

    if (user instanceof Error) {
      return user;
    }

    if (user.length > 0) {
      return new Error("User already exists");
    }

    const generatedPassword = crypto.randomBytes(4).toString("hex");

    const hashedPassword = await bcryptjs.hash(generatedPassword, 10);

    const createUserQuery = `INSERT INTO users (first_name, last_name, email, phone, password, role) VALUES (?, ?, ?, ?, ?, ?)`;

    const result = await query(createUserQuery, [
      first_name,
      last_name,
      email,
      phone,
      hashedPassword,
      role,
    ]);

    const emailBody = `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 20px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">
        <div style="text-align: center; padding: 10px;">
          <h1 style="color: #007bff; font-size: 24px;">Welcome to Drug Tracking System</h1>
          <p style="color: #555; font-size: 16px;">Hi <strong>${first_name} ${last_name}</strong>,</p>
          <p style="color: #555; font-size: 16px;">Your account has been successfully created. Below are your login details:</p>
        </div>
        <div style="background-color: #f1f8ff; padding: 15px; border-radius: 8px; margin: 20px 0;">
          <p><strong>Email:</strong> ${email}</p>
          <p><strong>Role:</strong> ${
            role === "admin" ? "Admin" : "Pharmacy Staff"
          }</p>
          <p><strong>Password:</strong> 
            <span style="background: #e0eafc; padding: 5px 10px; border-radius: 5px; font-family: monospace;">
              ${generatedPassword}
            </span>
          </p>
        </div>
        <p style="color: #555; font-size: 16px;">To get started, click the button below to log in:</p>
        <div style="text-align: center; margin: 20px 0;">
          <a href="${process.env.FRONTEND_URL}/login" 
            style="background-color: #007bff; color: white; text-decoration: none; padding: 10px 20px; border-radius: 5px; font-size: 16px;">
            Log In
          </a>
        </div>
        <p style="color: #555; font-size: 14px;">If you have any questions, feel free to contact our support team.</p>
        <div style="border-top: 1px solid #ddd; margin-top: 20px; padding-top: 10px; text-align: center;">
          <p style="color: #777; font-size: 12px;">&copy; ${new Date().getFullYear()} Drug Tracking System. All rights reserved.</p>
        </div>
      </div>
    `;

    await sendEmail({
      to: email,
      subject: "Welcome to Drug Tracking System",
      content: emailBody,
      isHtml: true,
    });

    return { message: "User registered successfully" };
  } catch (error) {
    return error;
  }
};

const loginUser = async (userBody) => {
  try {
    const { email, password } = userBody;

    if (!email || !password) {
      return new Error("Please provide all required fields");
    }

    const user = await userServices.getUser(email, null);

    if (user instanceof Error) {
      return user;
    }

    if (user.length === 0) {
      return new Error("User not found");
    }

    if (user[0].is_active == 0) {
      return new Error("User account is not active");
    }

    const hashedPassword = user[0].password;

    const isPasswordMatch = await bcryptjs.compare(password, hashedPassword);

    if (!isPasswordMatch) {
      return new Error("Invalid credentials");
    }

    const updateLastLoginQuery = `UPDATE users SET last_login = NOW() WHERE user_id = ?`;
    await query(updateLastLoginQuery, [user[0].user_id]);

    const selectUserQuery = `SELECT user_id, role, first_name, last_name, phone, email, last_login  FROM users WHERE user_id = ?`;

    const userResult = await query(selectUserQuery, [user[0].user_id]);

    if (userResult.length === 0) {
      return new Error("User not found");
    }

    const token = jwt.sign(
      { userId: user[0].user_id, role: user[0].role },
      process.env.JWT_SECRET,
      {
        expiresIn: "30d",
      }
    );

    return {
      message: "User logged in successfully",
      token,
      user: userResult[0],
    };
  } catch (error) {
    return error;
  }
};

const resetPassword = async (body, token) => {
  try {
    const { new_password } = body;

    if (!new_password) {
      return new Error("Please provide a new password");
    }

    if (new_password.length < 6) {
      return new Error("Password should be at least 6 characters");
    }

    if (!token) {
      return new Error("Please provide a token");
    }

    const checkTokenQuery = `
      SELECT * FROM password_reset_tokens 
      WHERE token = ? AND is_active = TRUE AND expires_at > NOW()
    `;

    const tokenResult = await query(checkTokenQuery, [token]);

    if (tokenResult instanceof Error) {
      return tokenResult;
    }

    if (tokenResult.length === 0) {
      return new Error("Invalid or expired token");
    }

    const resetToken = tokenResult[0];

    const hashedPassword = await bcryptjs.hash(new_password, 10);

    await query("UPDATE users SET password = ? WHERE user_id = ?", [
      hashedPassword,
      resetToken.user_id,
    ]);

    await query(
      "UPDATE password_reset_tokens SET is_active = FALSE WHERE token = ?",
      [token]
    );

    return { message: "Password reset successfully" };
  } catch (error) {
    return error;
  }
};

const forgetPassword = async (body) => {
  try {
    const { email } = body;

    if (!email) {
      return new Error("Please provide an email");
    }

    const user = await query("SELECT * FROM users WHERE email = ?", [email]);

    if (user instanceof Error) {
      return user;
    }

    if (user.length === 0) {
      return new Error("User with this email does not exist");
    }

    const token = crypto.randomBytes(32).toString("hex");
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000);

    await query(
      "INSERT INTO password_reset_tokens (user_id, token, expires_at) VALUES (?, ?, ?)",
      [user[0].user_id, token, expiresAt]
    );

    const resetLink = `${process.env.FRONTEND_URL}/password-reset/${token}`;

    const subject = "Drug Tracking System - Password Reset Request";

    const htmlContent = `
      <div style="font-family: 'Arial', sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9; border-radius: 8px;">
          <h2 style="color: #007bff; text-align: center;">Password Reset Request</h2>
          <p style="font-size: 16px; color: #333;">
            Hi <strong>${user[0].first_name} ${
      user[0].last_name || "User"
    }</strong>,
          </p>
          <p style="font-size: 16px; color: #333;">
            We received a request to reset your password for your Drug Tracking System account. Click the button below to reset your password:
          </p>
          <div style="text-align: center; margin: 20px 0;">
            <a href="${resetLink}" target="_blank" style="background-color: #007bff; color: white; padding: 12px 20px; text-decoration: none; border-radius: 5px; font-weight: bold;">
              Reset Password
            </a>
          </div>
          <p style="font-size: 14px; color: #555;">
            If you did not request this, please ignore this email. This link will expire in 24 hours.
          </p>
          <p style="font-size: 14px; color: #555;">
            Thanks,<br>
            The Drug Tracking System Team
          </p>
        </div>
      `;

    await sendEmail({
      to: email,
      subject,
      content: htmlContent,
      isHtml: true,
    });

    return { message: "Password reset email sent successfully" };
  } catch (error) {
    return error;
  }
};

module.exports = {
  registerUser,
  loginUser,
  resetPassword,
  forgetPassword,
};
