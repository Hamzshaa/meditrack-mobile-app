const { query } = require("../lib/db.js");

const getReport = async (pharmacyId, queryParams) => {
  try {
    const { start_date, end_date } = queryParams;

    const buildDateCondition = (column) => {
      if (start_date && end_date) {
        return `AND ${column} BETWEEN '${start_date}' AND '${end_date}'`;
      } else if (start_date) {
        return `AND ${column} >= '${start_date}'`;
      } else if (end_date) {
        return `AND ${column} <= '${end_date}'`;
      }
      return "";
    };

    // 1. Low stock medications
    const lowStockQuery = `
      SELECT 
        m.medication_id,
        m.medication_brand_name,
        SUM(i.quantity) AS total_quantity,
        m.reorder_point
      FROM medications m
      JOIN inventory i ON m.medication_id = i.medication_id
      WHERE i.pharmacy_id = ?
      GROUP BY m.medication_id, m.medication_brand_name, m.reorder_point
      HAVING total_quantity <= m.reorder_point
      ${
        start_date || end_date
          ? `AND ${buildDateCondition("MAX(i.updated_at)")}`
          : ""
      }
    `;
    const lowStock = await query(lowStockQuery, [pharmacyId]);

    // 2. Expired medications
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

    // 3. Medications expiring in the next 30 days
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

    // 4. Total medications in stock
    const totalMedicationsQuery = `
      SELECT 
        m.medication_id,
        m.medication_brand_name,
        SUM(i.quantity) AS total_quantity
      FROM medications m
      JOIN inventory i ON m.medication_id = i.medication_id
      WHERE i.pharmacy_id = ?
        ${buildDateCondition("i.updated_at")}
      GROUP BY m.medication_id, m.medication_brand_name
    `;
    const totalMedications = await query(totalMedicationsQuery, [pharmacyId]);

    // 5. Medications grouped by category
    const groupedByCategoryQuery = `
      SELECT 
        c.category_name,
        COUNT(m.medication_id) AS total_medications
      FROM medication_categories c
      LEFT JOIN medications m ON c.category_id = m.category_id
      WHERE c.pharmacy_id = ?
      GROUP BY c.category_id, c.category_name
    `;
    const medicationsByCategory = await query(groupedByCategoryQuery, [
      pharmacyId,
    ]);

    return {
      lowStock,
      expiredMedications,
      expiringSoon,
      totalMedications,
      medicationsByCategory,
    };
  } catch (error) {
    return error;
  }
};

module.exports = {
  getReport,
};
