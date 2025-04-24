const { query } = require("../lib/db.js");
const bcryptjs = require("bcryptjs");
const crypto = require("crypto");
const sendEmail = require("../utils/mailsend.js");

const registerPharmacy = async (data, pharmacyImages) => {
  try {
    const {
      first_name,
      last_name,
      manager_email,
      manager_phone,
      pharmacy_name,
      pharmacy_email,
      pharmacy_phone,
      address,
      latitude,
      longitude,
    } = data;

    if (
      (!first_name,
      !last_name,
      !manager_email,
      !manager_phone,
      !pharmacy_name,
      !pharmacy_email,
      !pharmacy_phone,
      !address,
      !latitude,
      !longitude)
    ) {
      return new Error("Please provide all required fields.");
    }

    const existingUser = await query("SELECT * FROM users WHERE email = ?", [
      manager_email,
    ]);

    if (existingUser.length > 0) {
      return new Error("Manager with this email already exists.");
    }

    const existingPharmacy = await query(
      "SELECT * FROM pharmacies WHERE email = ?",
      [pharmacy_email]
    );

    if (existingPharmacy.length > 0) {
      return new Error("Pharmacy with this email already exists.");
    }

    const emailRegex = /\S+@\S+\.\S+/;

    if (!emailRegex.test(manager_email)) {
      return new Error("Manager email is invalid.");
    }

    if (!emailRegex.test(pharmacy_email)) {
      return new Error("Pharmacy email is invalid.");
    }

    if (manager_phone.length < 10 || manager_phone.length > 13) {
      return new Error("Manager phone number is invalid.");
    }

    if (pharmacy_phone.length < 10 || pharmacy_phone.length > 13) {
      return new Error("Pharmacy phone number is invalid.");
    }

    if (longitude < -180 || longitude > 180) {
      return new Error("Longitude is invalid.");
    }

    if (latitude < -90 || latitude > 90) {
      return new Error("Latitude is invalid.");
    }

    const generatedPassword = crypto.randomBytes(4).toString("hex");
    const hashedPassword = await bcryptjs.hash(generatedPassword, 10);

    // Insert manager (pharmacy_staff role)
    const userResult = await query(
      `INSERT INTO users (first_name, last_name, email, phone, password, role) 
       VALUES (?, ?, ?, ?, ?, ?)`,
      [
        first_name,
        last_name,
        manager_email,
        manager_phone,
        hashedPassword,
        "pharmacy_staff",
      ]
    );

    if (userResult.affectedRows === 0) {
      return new Error("Failed to register manager.");
    }

    const manager_id = userResult.insertId;

    const pharmacyResult = await query(
      `INSERT INTO pharmacies (name, address, latitude, longitude, phone_number, email, manager_id) 
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [
        pharmacy_name,
        address,
        latitude,
        longitude,
        pharmacy_phone,
        pharmacy_email,
        manager_id,
      ]
    );

    if (pharmacyResult.affectedRows === 0) {
      return new Error("Failed to register pharmacy.");
    }

    const pharmacy_id = pharmacyResult.insertId;

    if (pharmacyImages && pharmacyImages.length > 0) {
      const imageInsertPromises = pharmacyImages.map((imageUrl) =>
        query(
          `INSERT INTO pharmacy_images (pharmacy_id, image_url) VALUES (?, ?)`,
          [pharmacy_id, `medias/pharmacy_images/${imageUrl}`]
        )
      );

      await Promise.all(imageInsertPromises);
    }

    const emailBody = `
        <div style="font-family: Arial, sans-serif; padding: 20px; max-width: 600px; margin: auto;">
            <h2 style="color: #007bff; text-align: center;">Welcome to Drug Tracking System</h2>
            <p>Hello ${first_name} ${last_name},</p>
            <p>Your pharmacy <strong>${pharmacy_name}</strong> has been successfully registered.</p>
            <p>Here are the details:</p>
            <h3 style="color: #007bff;">Manager Details:</h3>
            <ul>
                <li><strong>Name:</strong> ${first_name} ${last_name}</li>
                <li><strong>Email:</strong> ${manager_email}</li>
                <li><strong>Phone Number:</strong> ${manager_phone}</li>
                <li><strong>Temporary Password:</strong> ${generatedPassword}</li>
            </ul>
            <h3 style="color: #007bff;">Pharmacy Details:</h3>
            <ul>
                <li><strong>Pharmacy Name:</strong> ${pharmacy_name}</li>
                <li><strong>Address:</strong> ${address}</li>
                <li><strong>Phone Number:</strong> ${pharmacy_phone}</li>
                <li><strong>Email:</strong> ${pharmacy_email}</li>
                <li><strong>Latitude:</strong> ${latitude}</li>
                <li><strong>Longitude:</strong> ${longitude}</li>
            </ul>
            <p>You can now log in using your manager email <strong>${manager_email}</strong> and the temporary password provided above.</p>
            <p style="text-align: center; margin-top: 20px;">
                <a href="https://yourwebsite.com/login" style="background-color: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Login Now</a>
            </p>
            <p>Best regards, <br><strong>Drug Tracking System Team</strong></p>
        </div>
    `;

    await sendEmail({
      to: manager_email,
      subject: "Welcome to Drug Tracking System",
      content: emailBody,
      isHtml: true,
    });

    const createdPharmacy = await getPharmacyById(pharmacy_id);

    return {
      success: true,
      message:
        "Pharmacy registered successfully, and email sent to the manager.",
      pharmacy: createdPharmacy,
    };
  } catch (error) {
    return { success: false, message: "Error registering pharmacy." };
  }
};

const getPharmacies = async () => {
  try {
    //
    const pharmacies = await query(
      `SELECT p.*, 
              u.first_name AS manager_first_name, 
              u.last_name AS manager_last_name, 
              u.email AS manager_email, 
              u.phone AS manager_phone
       FROM pharmacies p
       LEFT JOIN users u ON p.manager_id = u.user_id`
    );

    if (pharmacies.length === 0) return [];

    const pharmaciesWithImages = await Promise.all(
      pharmacies.map(async (pharmacy) => {
        const images = await query(
          `SELECT image_id, image_url FROM pharmacy_images WHERE pharmacy_id = ?`,
          [pharmacy.pharmacy_id]
        );

        return {
          ...pharmacy,
          images: images.length > 0 ? images : [],
        };
      })
    );

    return pharmaciesWithImages;
  } catch (error) {
    return error;
  }
};

const getPharmacyById = async (pharmacyId) => {
  try {
    const pharmacy = await query(
      `SELECT p.*, 
              u.first_name AS manager_first_name, 
              u.last_name AS manager_last_name, 
              u.email AS manager_email, 
              u.phone AS manager_phone
       FROM pharmacies p
       LEFT JOIN users u ON p.manager_id = u.user_id
       WHERE p.pharmacy_id = ?`,
      [pharmacyId]
    );

    if (pharmacy.length === 0) {
      return new Error("Pharmacy not found.");
    }

    const [images] = await Promise.all([
      query(
        `SELECT image_id, image_url FROM pharmacy_images WHERE pharmacy_id = ?`,
        [pharmacyId]
      ),
    ]);

    return {
      ...pharmacy[0],
      images: images.length > 0 ? images : [],
    };
  } catch (error) {
    return error;
  }
};

const updatePharmacy = async (pharmacyId, data, pharmacyImages) => {
  try {
    const {
      pharmacy_name,
      address,
      latitude,
      longitude,
      pharmacy_phone,
      pharmacy_email,
      first_name,
      last_name,
      manager_email,
      manager_phone,
      removed_images,
    } = data;

    const emailRegex = /\S+@\S+\.\S+/;
    if (!emailRegex.test(pharmacy_email)) {
      return new Error("Pharmacy email is invalid.");
    }

    if (!emailRegex.test(manager_email)) {
      return new Error("Manager email is invalid.");
    }

    if (pharmacy_phone.length < 10 || pharmacy_phone.length > 13) {
      return new Error("Pharmacy phone number is invalid.");
    }

    if (manager_phone.length < 10 || manager_phone.length > 13) {
      return new Error("Manager phone number is invalid.");
    }

    if (longitude < -180 || longitude > 180) {
      return new Error("Longitude is invalid.");
    }

    if (latitude < -90 || latitude > 90) {
      return new Error("Latitude is invalid.");
    }

    const existingPharmacy = await query(
      `SELECT * FROM pharmacies WHERE pharmacy_id = ?`,
      [pharmacyId]
    );

    if (existingPharmacy.length === 0) {
      return new Error("Pharmacy not found.");
    }

    const existingManager = await query(
      `SELECT * FROM users WHERE user_id = ?`,
      [existingPharmacy[0].manager_id]
    );

    if (existingManager.length === 0) {
      return new Error("Manager not found.");
    }

    const emailExists = await query(
      `SELECT * FROM pharmacies WHERE email = ? AND pharmacy_id != ?`,
      [pharmacy_email, pharmacyId]
    );

    if (emailExists.length > 0) {
      return new Error("Pharmacy with this email already exists.");
    }

    const managerEmailExists = await query(
      `SELECT * FROM users WHERE email = ? AND user_id != ?`,
      [manager_email, existingPharmacy[0].manager_id]
    );

    if (managerEmailExists.length > 0) {
      return new Error("Manager with this email already exists.");
    }

    const updateResult = await query(
      `UPDATE pharmacies 
       SET name = ?, address = ?, latitude = ?, longitude = ?, phone_number = ?, email = ?
       WHERE pharmacy_id = ?`,
      [
        pharmacy_name,
        address,
        latitude,
        longitude,
        pharmacy_phone,
        pharmacy_email,
        pharmacyId,
      ]
    );

    if (updateResult instanceof Error) {
      return new Error("Failed to update pharmacy.");
    }

    if (removed_images && removed_images.length > 0) {
      const deleteImagePromises = removed_images.map((imageId) =>
        query(`DELETE FROM pharmacy_images WHERE image_id = ?`, [imageId])
      );

      await Promise.all(deleteImagePromises);
    }

    if (pharmacyImages && pharmacyImages.length > 0) {
      const imageInsertPromises = pharmacyImages.map((imageUrl) =>
        query(
          `INSERT INTO pharmacy_images (pharmacy_id, image_url) VALUES (?, ?)`,
          [pharmacyId, `medias/pharmacy_images/${imageUrl}`]
        )
      );

      await Promise.all(imageInsertPromises);
    }

    const updatedManager = await query(
      `UPDATE users 
       SET first_name = ?, last_name = ?, email = ?, phone = ?
       WHERE user_id = ?`,
      [
        first_name,
        last_name,
        manager_email,
        manager_phone,
        existingPharmacy[0].manager_id,
      ]
    );

    if (updatedManager instanceof Error) {
      return new Error("Failed to update manager.");
    }

    const updatePharmacy = await getPharmacyById(pharmacyId);

    return {
      success: true,
      message: "Pharmacy updated successfully.",
      pharmacy: updatePharmacy,
    };
  } catch (error) {
    return error;
  }
};

const deletePharmacy = async (pharmacyId) => {
  try {
    const pharmacy = await query(
      `SELECT manager_id FROM pharmacies WHERE pharmacy_id = ?`,
      [pharmacyId]
    );

    if (pharmacy.length === 0) {
      return new Error("Pharmacy not found.");
    }

    const managerId = pharmacy[0].manager_id;

    const deletePharmacyResult = await query(
      `DELETE FROM pharmacies WHERE pharmacy_id = ?`,
      [pharmacyId]
    );

    if (deletePharmacyResult.affectedRows === 0) {
      return new Error("Failed to delete pharmacy.");
    }

    const managerExists = await query(
      `SELECT pharmacy_id FROM pharmacies WHERE manager_id = ? LIMIT 1`,
      [managerId]
    );

    if (managerExists.length === 0) {
      await query(`DELETE FROM users WHERE user_id = ?`, [managerId]);
    }

    return {
      success: true,
      message: "Pharmacy deleted successfully.",
    };
  } catch (error) {
    return error;
  }
};

module.exports = {
  registerPharmacy,
  getPharmacies,
  getPharmacyById,
  updatePharmacy,
  deletePharmacy,
};
