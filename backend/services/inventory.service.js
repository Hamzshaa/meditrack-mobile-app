const { query } = require("../lib/db.js");

const getInventory = async (pharmacyId, queryParams) => {
  const { status, onlyAvailableBatches } = queryParams;

  try {
    let sql = `
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
      WHERE m.pharmacy_id = ?
    `;

    const params = [pharmacyId, pharmacyId];

    if (status === "expired") {
      sql += ` AND i.expiration_date < CURDATE()`;
    }

    if (onlyAvailableBatches) {
      sql += ` AND i.quantity > 0`;
    }

    const results = await query(sql, params);

    // Group medications with inventory batches and total quantity
    const grouped = {};

    results.forEach((row) => {
      const medicationId = row.medication_id;

      if (!grouped[medicationId]) {
        grouped[medicationId] = {
          medication_id: row.medication_id,
          medication_brand_name: row.medication_brand_name,
          medication_generic_name: row.medication_generic_name,
          dosage_form: row.dosage_form,
          strength: row.strength,
          manufacturer: row.manufacturer,
          description: row.description,
          category_id: row.category_id,
          created_at: row.created_at,
          updated_at: row.updated_at,
          pharmacy_id: row.pharmacy_id,
          inventory: [],
          total_quantity: 0,
          reorder_point: row.reorder_point,
        };
      }

      // If inventory exists, add to array and accumulate total quantity
      if (row.inventory_id !== null) {
        grouped[medicationId].inventory.push({
          inventory_id: row.inventory_id,
          batch_number: row.batch_number,
          quantity: row.quantity,
          expiration_date: row.expiration_date,
          last_updated: row.last_updated,
        });

        grouped[medicationId].total_quantity += row.quantity || 0;
      }
    });

    return Object.values(grouped);
  } catch (error) {
    return error;
  }
};

const getInventoryById = async (pharmacyId, inventoryId) => {
  try {
    // First, get the medication_id associated with this inventory_id
    const inventoryRow = await query(
      `SELECT medication_id FROM inventory WHERE inventory_id = ? AND pharmacy_id = ?`,
      [inventoryId, pharmacyId]
    );

    if (!inventoryRow.length) {
      return new Error("Inventory item not found.");
    }

    const medicationId = inventoryRow[0].medication_id;

    // Now fetch all inventory records for this medication_id
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
      WHERE m.pharmacy_id = ? AND m.medication_id = ?
    `;

    const results = await query(sql, [pharmacyId, pharmacyId, medicationId]);

    if (!results.length) {
      return new Error("No inventory data found for the given ID.");
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

const addInventory = async (pharmacyId, body) => {
  try {
    const { medication_id, batch_number, quantity, expiration_date } = body;

    if (
      !pharmacyId ||
      !medication_id ||
      !batch_number ||
      !quantity ||
      !expiration_date
    ) {
      return new Error("All fields are required.");
    }

    const pharmacyExist = await query(
      `SELECT * FROM pharmacies WHERE pharmacy_id = ?`,
      [pharmacyId]
    );

    if (pharmacyExist instanceof Error) {
      return pharmacyExist;
    }

    if (pharmacyExist.length === 0) {
      return new Error("Pharmacy does not exist.");
    }

    const checkMedSql = `SELECT * FROM medications WHERE medication_id = ? AND pharmacy_id = ?`;

    const medicationExists = await query(checkMedSql, [
      medication_id,
      pharmacyId,
    ]);

    if (medicationExists.length === 0) {
      return new Error("Medication does not exist in this pharmacy.");
    }

    const sql = `
      INSERT INTO inventory (pharmacy_id, medication_id, batch_number, quantity, expiration_date)
      VALUES (?, ?, ?, ?, ?)
    `;

    const result = await query(sql, [
      pharmacyId,
      medication_id,
      batch_number,
      quantity,
      expiration_date,
    ]);

    return result.affectedRows > 0
      ? {
          message: "Inventory added successfully.",
          inventoryId: result.insertId,
        }
      : new Error("Insertion failed.");
  } catch (error) {
    return error;
  }
};

const updateInventory = async (pharmacyId, inventoryId, body) => {
  try {
    const { batch_number, quantity, expiration_date } = body;

    if (!inventoryId) {
      return new Error("Inventory ID is required.");
    }

    if (!pharmacyId || !batch_number || !quantity || !expiration_date) {
      return new Error("All fields are required.");
    }

    const pharmacyExist = await query(
      `SELECT * FROM pharmacies WHERE pharmacy_id = ?`,
      [pharmacyId]
    );

    if (pharmacyExist instanceof Error) {
      return pharmacyExist;
    }

    if (pharmacyExist.length === 0) {
      return new Error("Pharmacy does not exist.");
    }

    const sql = `
      UPDATE inventory
      SET batch_number = ?, quantity = ?, expiration_date = ?
      WHERE inventory_id = ? AND pharmacy_id = ?
    `;

    const result = await query(sql, [
      batch_number,
      quantity,
      expiration_date,
      inventoryId,
      pharmacyId,
    ]);

    return result.affectedRows > 0
      ? { message: "Inventory updated successfully.", inventoryId }
      : new Error("Update failed.");
  } catch (error) {
    return error;
  }
};

const deleteInventory = async (pharmacyId, inventoryId) => {
  try {
    const sql = `DELETE FROM inventory WHERE inventory_id = ? AND pharmacy_id = ?`;
    const result = await query(sql, [inventoryId, pharmacyId]);
    return result.affectedRows > 0
      ? "Inventory item deleted successfully."
      : new Error("Deletion failed.");
  } catch (error) {
    return error;
  }
};

const addToInventory = async (pharmacyId, body) => {
  try {
    if (!pharmacyId) {
      return new Error("Pharmacy ID is required.");
    }

    const { inventory_id, quantity } = body;

    if (!inventory_id || !quantity) {
      return new Error("Inventory ID and quantity are required.");
    }

    const pharmacyExist = await query(
      `SELECT * FROM pharmacies WHERE pharmacy_id = ?`,
      [pharmacyId]
    );

    if (pharmacyExist instanceof Error) {
      return pharmacyExist;
    }

    if (pharmacyExist.length === 0) {
      return new Error("Pharmacy does not exist.");
    }

    const checkMedSql = `SELECT * FROM inventory WHERE inventory_id = ? AND pharmacy_id = ?`;

    const inventoryExists = await query(checkMedSql, [
      inventory_id,
      pharmacyId,
    ]);

    if (inventoryExists instanceof Error) {
      return inventoryExists;
    }

    if (inventoryExists.length === 0) {
      return new Error("Inventory does not exist in this pharmacy.");
    }

    const inventorySql = `SELECT * FROM inventory WHERE inventory_id = ?`;

    const inventory = await query(inventorySql, [inventory_id]);

    if (inventory instanceof Error) {
      return inventory;
    }

    if (inventory.length === 0) {
      return new Error("Inventory item not found.");
    }

    const newQuantity = parseInt(inventory[0].quantity) + parseInt(quantity);

    const updateInventorySql = `UPDATE inventory SET quantity = ? WHERE inventory_id = ?`;

    const result = await query(updateInventorySql, [newQuantity, inventory_id]);

    if (result?.affectedRows > 0) {
      return "Inventory updated successfully.";
    }

    return result;
  } catch (error) {
    return error;
  }
};

const deductInventory = async (pharmacyId, body) => {
  console.log({ pharmacyId, body });
  try {
    if (!pharmacyId) {
      return new Error("Pharmacy ID is required.");
    }

    const { inventory_id, quantity } = body;

    if (!inventory_id || !quantity) {
      return new Error("Inventory ID and quantity are required.");
    }

    const pharmacyExist = await query(
      `SELECT * FROM pharmacies WHERE pharmacy_id = ?`,
      [pharmacyId]
    );

    if (pharmacyExist instanceof Error) {
      return pharmacyExist;
    }

    if (pharmacyExist.length === 0) {
      return new Error("Pharmacy does not exist.");
    }

    const checkMedSql = `SELECT * FROM inventory WHERE inventory_id = ? AND pharmacy_id = ?`;

    const inventoryExists = await query(checkMedSql, [
      inventory_id,
      pharmacyId,
    ]);

    if (inventoryExists instanceof Error) {
      return inventoryExists;
    }

    if (inventoryExists.length === 0) {
      return new Error("Inventory does not exist in this pharmacy.");
    }

    const inventorySql = `SELECT * FROM inventory WHERE inventory_id = ?`;

    const inventory = await query(inventorySql, [inventory_id]);

    if (inventory instanceof Error) {
      return inventory;
    }

    if (inventory.length === 0) {
      return new Error("Inventory item not found.");
    }

    if (inventory[0].quantity < quantity) {
      return new Error("Insufficient quantity.");
    }

    const newQuantity = inventory[0].quantity - quantity;

    const updateInventorySql = `UPDATE inventory SET quantity = ? WHERE inventory_id = ?`;

    const result = await query(updateInventorySql, [newQuantity, inventory_id]);

    if (result?.affectedRows > 0) {
      return "Inventory updated successfully.";
    }

    return result;
  } catch (error) {
    return error;
  }
};

const getBatches = async (pharmacyId, queryParams) => {
  try {
    const { medicationId } = queryParams;

    if (!pharmacyId) {
      return new Error("Pharmacy ID is required.");
    }

    let getBatchesQuery = `
      SELECT inventory_id, batch_number, expiration_date FROM inventory WHERE pharmacy_id = ?
    `;

    let params = [pharmacyId];

    if (medicationId) {
      getBatchesQuery += ` AND medication_id = ?`;
      params = [...params, medicationId];
    }

    const batchNumbers = await query(getBatchesQuery, params);

    return batchNumbers;
  } catch (error) {
    return error;
  }
};

const getExpiringMedications = async (pharmacyId) => {
  try {
    // 1. Expired medications
    const expiredMedicationsQuery = `
    SELECT 
    m.medication_id,
            m.medication_brand_name,
            i.batch_number,
            i.expiration_date,
            DATEDIFF(CURDATE(), i.expiration_date) AS days_ago
            FROM medications m
            JOIN inventory i ON m.medication_id = i.medication_id
            WHERE i.pharmacy_id = ? 
            AND i.expiration_date < CURDATE()
            `;
    const expiredMedications = await query(expiredMedicationsQuery, [
      pharmacyId,
    ]);

    // 2. Medications expiring in the next 30 days
    const expiringSoonQuery = `
    SELECT 
    m.medication_id,
    m.medication_brand_name,
    i.batch_number,
    i.expiration_date,
    DATEDIFF(i.expiration_date, CURDATE()) AS days_left
    FROM medications m
    JOIN inventory i ON m.medication_id = i.medication_id
    WHERE i.pharmacy_id = ?
    AND i.expiration_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
    `;
    const expiringSoon = await query(expiringSoonQuery, [pharmacyId]);

    return {
      expiredMedications,
      expiringSoon,
    };
  } catch (error) {
    return error;
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
