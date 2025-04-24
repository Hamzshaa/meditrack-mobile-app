const { query } = require("../lib/db.js");
const haversineDistance = require("../utils/haversineDistance.js");

const addMedication = async (body, pharmacyId) => {
  try {
    const {
      medication_brand_name,
      medication_generic_name,
      dosage_form,
      strength,
      manufacturer,
      description,
      category_id,
      reorder_point,
    } = body;

    if (
      !medication_brand_name ||
      !medication_generic_name ||
      !dosage_form ||
      !strength ||
      !manufacturer ||
      !reorder_point
    ) {
      return new Error("Please provide all required fields");
    }

    if (
      dosage_form !== "tablet" &&
      dosage_form !== "capsule" &&
      dosage_form !== "liquid" &&
      dosage_form !== "injection" &&
      dosage_form !== "cream" &&
      dosage_form !== "ointment" &&
      dosage_form !== "syrup"
    ) {
      return new Error("Invalid dosage form");
    }

    const checkCategoryQuery = `SELECT * FROM medication_categories WHERE category_id = ?`;

    const category = await query(checkCategoryQuery, [category_id]);

    if (category instanceof Error || category.length === 0) {
      return new Error("Invalid category");
    }

    const insertQuery = `
      INSERT INTO medications (
        medication_brand_name, 
        medication_generic_name, 
        dosage_form, 
        strength, 
        manufacturer, 
        reorder_point,
        description, 
        category_id, 
        pharmacy_id
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`;

    const result = await query(insertQuery, [
      medication_brand_name,
      medication_generic_name,
      dosage_form,
      strength,
      manufacturer,
      reorder_point,
      description,
      category_id,
      pharmacyId,
    ]);

    if (result instanceof Error) {
      return new Error("Failed to add medication!");
    }

    return {
      message: "Medication added successfully",
    };
  } catch (error) {
    return error;
  }
};

const updateMedication = async (id, body, pharmacyId) => {
  try {
    const {
      medication_brand_name,
      medication_generic_name,
      dosage_form,
      strength,
      manufacturer,
      reorder_point,
      description,
      category_id,
    } = body;

    const updateQuery = `
      UPDATE medications
      SET
        medication_brand_name = ?,
        medication_generic_name = ?,
        dosage_form = ?,
        strength = ?,
        manufacturer = ?,
        reorder_point = ?,
        description = ?,
        category_id = ?
      WHERE medication_id = ? AND pharmacy_id = ?`;

    if (
      dosage_form !== "tablet" &&
      dosage_form !== "capsule" &&
      dosage_form !== "liquid" &&
      dosage_form !== "injection" &&
      dosage_form !== "cream" &&
      dosage_form !== "ointment" &&
      dosage_form !== "syrup"
    ) {
      return new Error("Invalid dosage form");
    }

    const checkCategoryQuery = `SELECT * FROM medication_categories WHERE category_id = ?`;

    const category = await query(checkCategoryQuery, [category_id]);

    if (category instanceof Error || category.length === 0) {
      return new Error("Invalid category");
    }

    const result = await query(updateQuery, [
      medication_brand_name,
      medication_generic_name,
      dosage_form,
      strength,
      manufacturer,
      reorder_point,
      description,
      category_id,
      id,
      pharmacyId,
    ]);

    if (result instanceof Error) {
      return new Error("Failed to update medication!");
    }

    if (result.affectedRows === 0) {
      return new Error("Medication not found or unauthorized to update");
    }

    return { message: "Medication updated successfully" };
  } catch (error) {
    return new Error(error.message);
  }
};

const getMedications = async (pharmacyId) => {
  try {
    const getMedicationsQuery = `SELECT * FROM medications INNER JOIN medication_categories ON medications.category_id = medication_categories.category_id WHERE medications.pharmacy_id = ?`;
    const medications = await query(getMedicationsQuery, [pharmacyId]);

    if (medications.length === 0) {
      return new Error("No medications found for this pharmacy");
    }

    return medications;
  } catch (error) {
    return new Error(error.message);
  }
};

const searchMedications = async (queryParams) => {
  try {
    const { searchQuery, lat, lon } = queryParams;

    const sql = `
      SELECT 
          m.medication_id, 
          m.medication_brand_name, 
          m.medication_generic_name, 
          m.dosage_form, 
          m.strength, 
          m.manufacturer, 
          m.reorder_point,
          m.description, 
          c.category_name,
          p.pharmacy_id, 
          p.name AS pharmacy_name, 
          p.address AS pharmacy_address,
          p.phone_number AS pharmacy_phone, 
          p.email AS pharmacy_email,
          p.latitude, 
          p.longitude, 
          i.quantity, 
          i.batch_number, 
          i.expiration_date, 
          (SELECT JSON_ARRAYAGG(image_url) FROM pharmacy_images pi WHERE pi.pharmacy_id = p.pharmacy_id) AS pharmacy_images
      FROM medications m
      JOIN inventory i ON m.medication_id = i.medication_id
      JOIN pharmacies p ON i.pharmacy_id = p.pharmacy_id
      LEFT JOIN medication_categories c ON m.category_id = c.category_id
      WHERE (m.medication_brand_name LIKE ? OR m.medication_generic_name LIKE ?) 
      AND i.quantity > 0
    `;

    const result = await query(sql, [`%${searchQuery}%`, `%${searchQuery}%`]);

    if (result instanceof Error) {
      return result;
    }

    if (result.length === 0) {
      return [];
    }

    return result
      .map((med) => ({
        medication_id: med.medication_id,
        medication_brand_name: med.medication_brand_name,
        medication_generic_name: med.medication_generic_name,
        dosage_form: med.dosage_form,
        strength: med.strength,
        manufacturer: med.manufacturer,
        description: med.description,
        pharmacy_name: med.pharmacy_name,
        pharmacy_address: med.pharmacy_address,
        pharmacy_phone: med.pharmacy_phone,
        pharmacy_email: med.pharmacy_email,
        images: Array.isArray(med.pharmacy_images)
          ? med.pharmacy_images
          : JSON.parse(med.pharmacy_images || "[]"),
        expiration_date: med.expiration_date,
        distance: haversineDistance(lat, lon, med.latitude, med.longitude),
        googleMapsUrl: `https://www.google.com/maps/dir/?api=1&origin=${lat},${lon}&destination=${med.latitude},${med.longitude}&travelmode=driving`,
      }))
      .sort((a, b) => a.distance - b.distance);
  } catch (error) {
    return error;
  }
};

const getMedicationById = async (id, pharmacyId) => {
  try {
    const sql = `
      SELECT 
        m.medication_id,
        m.medication_brand_name,
        m.medication_generic_name,
        m.dosage_form,
        m.strength,
        m.manufacturer,
        m.reorder_point,
        m.description,
        m.category_id,
        m.created_at,
        m.updated_at,
        m.pharmacy_id,

        i.inventory_id,
        i.batch_number,
        i.quantity,
        i.expiration_date,
        i.last_updated
      FROM medications m
      LEFT JOIN inventory i ON m.medication_id = i.medication_id AND i.pharmacy_id = ?
      WHERE m.medication_id = ? AND m.pharmacy_id = ?
      `;

    const results = await query(sql, [pharmacyId, id, pharmacyId]);

    if (!results || results.length === 0) {
      return new Error("Medication not found or unauthorized to access");
    }

    const medication = {
      medication_id: results[0].medication_id,
      medication_brand_name: results[0].medication_brand_name,
      medication_generic_name: results[0].medication_generic_name,
      dosage_form: results[0].dosage_form,
      strength: results[0].strength,
      manufacturer: results[0].manufacturer,
      description: results[0].description,
      category_id: results[0].category_id,
      created_at: results[0].created_at,
      updated_at: results[0].updated_at,
      pharmacy_id: results[0].pharmacy_id,
      reorder_point: results[0].reorder_point,
      inventory: [],
      total_quantity: 0,
    };

    results.forEach((row) => {
      if (row.inventory_id !== null) {
        medication.inventory.push({
          inventory_id: row.inventory_id,
          batch_number: row.batch_number,
          quantity: row.quantity,
          expiration_date: row.expiration_date,
          last_updated: row.last_updated,
        });

        medication.total_quantity += row.quantity || 0;
      }
    });

    return medication;
  } catch (error) {
    return error;
  }
};

const deleteMedication = async (id, pharmacyId) => {
  try {
    const deleteQuery = `DELETE FROM medications WHERE medication_id = ? AND pharmacy_id = ?`;
    const result = await query(deleteQuery, [id, pharmacyId]);

    if (result instanceof Error) {
      return new Error("Failed to delete medication!");
    }

    if (result.affectedRows === 0) {
      return new Error("Medication not found or unauthorized to delete");
    }

    return { message: "Medication deleted successfully" };
  } catch (error) {
    return new Error(error.message);
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
