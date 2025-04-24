const { query } = require("../lib/db.js");

// CREATE TABLE IF NOT EXISTS medication_categories (
//     category_id INT PRIMARY KEY AUTO_INCREMENT,
//     category_name VARCHAR(255) NOT NULL UNIQUE,
//     pharmacy_id INT NOT NULL,
//     FOREIGN KEY (pharmacy_id) REFERENCES pharmacies(pharmacy_id) ON DELETE CASCADE
// ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

const addMedicationCategory = async (pharmacyId, data) => {
  try {
    const { category_name } = data;

    if (!category_name) {
      return new Error("Category name is required");
    }

    if (!pharmacyId) {
      return new Error("Pharmacy ID is required");
    }

    const pharmacyExistsQuery = `SELECT * FROM pharmacies WHERE pharmacy_id = ?`;

    const pharmacyExists = await query(pharmacyExistsQuery, [pharmacyId]);

    if (pharmacyExists instanceof Error || pharmacyExists.length === 0) {
      return new Error("Pharmacy not found");
    }

    const addMedicationCategoryQuery = `INSERT INTO medication_categories (category_name, pharmacy_id) VALUES (?, ?)`;

    const result = await query(addMedicationCategoryQuery, [
      category_name,
      pharmacyId,
    ]);

    return result;
  } catch (error) {
    return error;
  }
};

const updateMedicationCategory = async (categoryId, pharmacyId, data) => {
  try {
    const { category_name } = data;

    if (!category_name) {
      return new Error("Category name is required");
    }

    if (!pharmacyId) {
      return new Error("Pharmacy ID is required");
    }

    if (!categoryId) {
      return new Error("Category ID is required");
    }

    const pharmacyExistsQuery = `SELECT * FROM pharmacies WHERE pharmacy_id = ?`;

    const pharmacyExists = await query(pharmacyExistsQuery, [pharmacyId]);

    if (pharmacyExists instanceof Error || pharmacyExists.length === 0) {
      return new Error("Pharmacy not found");
    }

    const checkMedicationCategoryQuery = `SELECT * FROM medication_categories WHERE category_id = ? AND pharmacy_id = ?`;

    const checkMedicationCategory = await query(checkMedicationCategoryQuery, [
      categoryId,
      pharmacyId,
    ]);

    if (
      checkMedicationCategory instanceof Error ||
      checkMedicationCategory.length === 0
    ) {
      return new Error("Medication category not found");
    }

    const updateMedicationCategoryQuery = `UPDATE medication_categories SET category_name = ? WHERE category_id = ? AND pharmacy_id = ?`;

    const result = await query(updateMedicationCategoryQuery, [
      category_name,
      categoryId,
      pharmacyId,
    ]);

    return result;
  } catch (error) {
    return error;
  }
};

const getMedicationCategories = async (pharmacyId) => {
  try {
    if (!pharmacyId) {
      return new Error("Pharmacy ID is required");
    }

    const pharmacyExistsQuery = `SELECT * FROM pharmacies WHERE pharmacy_id = ?`;

    const pharmacyExists = await query(pharmacyExistsQuery, [pharmacyId]);

    if (pharmacyExists instanceof Error || pharmacyExists.length === 0) {
      return new Error("Pharmacy not found");
    }

    const getMedicationCategoriesQuery = `SELECT * FROM medication_categories WHERE pharmacy_id = ?`;

    const result = await query(getMedicationCategoriesQuery, [pharmacyId]);

    return result;
  } catch (error) {
    return error;
  }
};

const deleteMedicationCategory = async (categoryId, pharmacyId) => {
  try {
    if (!pharmacyId) {
      return new Error("Pharmacy ID is required");
    }

    if (!categoryId) {
      return new Error("Category ID is required");
    }

    const pharmacyExistsQuery = `SELECT * FROM pharmacies WHERE pharmacy_id = ?`;

    const pharmacyExists = await query(pharmacyExistsQuery, [pharmacyId]);

    if (pharmacyExists instanceof Error || pharmacyExists.length === 0) {
      return new Error("Pharmacy not found");
    }

    const checkMedicationCategoryQuery = `SELECT * FROM medication_categories WHERE category_id = ? AND pharmacy_id = ?`;

    const checkMedicationCategory = await query(checkMedicationCategoryQuery, [
      categoryId,
      pharmacyId,
    ]);

    if (
      checkMedicationCategory instanceof Error ||
      checkMedicationCategory.length === 0
    ) {
      return new Error("Medication category not found");
    }

    const deleteMedicationCategoryQuery = `DELETE FROM medication_categories WHERE category_id = ? AND pharmacy_id = ?`;

    const result = await query(deleteMedicationCategoryQuery, [
      categoryId,
      pharmacyId,
    ]);

    return result;
  } catch (error) {
    return error;
  }
};

module.exports = {
  addMedicationCategory,
  updateMedicationCategory,
  getMedicationCategories,
  deleteMedicationCategory,
};
