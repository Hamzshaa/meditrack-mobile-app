const { query } = require("../lib/db.js");

const getPharmacyDashboard = async (pharmacyId) => {
  try {
    // Get pharmacy basic info
    const [pharmacy] = await query(
      `SELECT name, address, phone_number, email FROM pharmacies WHERE pharmacy_id = ?`,
      [pharmacyId]
    );
    if (!pharmacy) throw new Error("Pharmacy not found");

    // Total medications
    const [{ totalMedications }] = await query(
      `SELECT COUNT(*) AS totalMedications FROM medications WHERE pharmacy_id = ?`,
      [pharmacyId]
    );

    // Total inventory batches & quantity
    const [{ totalBatches, totalQuantity }] = await query(
      `SELECT COUNT(*) AS totalBatches, SUM(quantity) AS totalQuantity 
       FROM inventory WHERE pharmacy_id = ?`,
      [pharmacyId]
    );

    // Expired batches
    const [{ expiredBatches }] = await query(
      `SELECT COUNT(*) AS expiredBatches 
       FROM inventory 
       WHERE pharmacy_id = ? AND expiration_date < CURDATE()`,
      [pharmacyId]
    );

    // Reorder needed medications
    const [{ reorderNeeded }] = await query(
      `SELECT COUNT(*) AS reorderNeeded
       FROM medications m
       LEFT JOIN (
         SELECT medication_id, SUM(quantity) AS total_quantity
         FROM inventory
         WHERE pharmacy_id = ?
         GROUP BY medication_id
       ) i ON m.medication_id = i.medication_id
       WHERE m.pharmacy_id = ? AND (i.total_quantity IS NULL OR i.total_quantity < m.reorder_point)`,
      [pharmacyId, pharmacyId]
    );

    // Out of stock medications
    const [{ outOfStock }] = await query(
      `SELECT COUNT(*) AS outOfStock
       FROM medications m
       LEFT JOIN (
         SELECT medication_id, SUM(quantity) AS total_quantity
         FROM inventory
         WHERE pharmacy_id = ?
         GROUP BY medication_id
       ) i ON m.medication_id = i.medication_id
       WHERE m.pharmacy_id = ? AND (i.total_quantity IS NULL OR i.total_quantity = 0)`,
      [pharmacyId, pharmacyId]
    );

    // Batches near expiry (within 30 days)
    const [{ nearExpiry }] = await query(
      `SELECT COUNT(*) AS nearExpiry
       FROM inventory 
       WHERE pharmacy_id = ? 
         AND expiration_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
         AND quantity > 0`,
      [pharmacyId]
    );

    // Active medications (if you track status)
    // const [{ activeMedications }] = await query(
    //   `SELECT COUNT(*) AS activeMedications
    //    FROM medications
    //    WHERE pharmacy_id = ? AND status = 'active'`,
    //   [pharmacyId]
    // );

    // Latest 5 medications
    const recentMedications = await query(
      `SELECT medication_id, medication_brand_name, strength, manufacturer, created_at
       FROM medications 
       WHERE pharmacy_id = ? 
       ORDER BY created_at DESC 
       LIMIT 5`,
      [pharmacyId]
    );

    // Next 5 expiring batches
    const expiringSoon = await query(
      `SELECT i.inventory_id, i.batch_number, i.expiration_date, i.quantity, 
              m.medication_brand_name, m.strength
       FROM inventory i
       JOIN medications m ON i.medication_id = m.medication_id
       WHERE i.pharmacy_id = ? AND i.expiration_date >= CURDATE() AND i.quantity > 0
       ORDER BY i.expiration_date ASC
       LIMIT 5`,
      [pharmacyId]
    );

    return {
      pharmacy,
      stats: {
        totalMedications,
        totalBatches,
        totalQuantity: totalQuantity || 0,
        expiredBatches,
        reorderNeeded,
        outOfStock,
        nearExpiry,
        // activeMedications,
      },
      recentMedications,
      expiringSoon,
    };
  } catch (error) {
    return error;
  }
};

const getAdminOverview = async (userId) => {
  try {
    // 1. Total users grouped by role
    const userRolesQuery = `
      SELECT role, COUNT(*) AS count
      FROM users
      GROUP BY role
    `;
    const userRoles = await query(userRolesQuery);

    // 2. Total comments
    const commentsQuery = `
      SELECT COUNT(*) AS total_comments FROM comments
    `;
    const [{ total_comments }] = await query(commentsQuery);

    // 3. Total pharmacies
    const totalPharmaciesQuery = `
      SELECT COUNT(*) AS total_pharmacies FROM pharmacies
    `;
    const [{ total_pharmacies }] = await query(totalPharmaciesQuery);

    // 4. User profile info
    const userProfileQuery = `
      SELECT user_id, first_name, last_name, email, role
      FROM users
      WHERE user_id = ?
    `;

    const [userProfile] = await query(userProfileQuery, [userId]);

    // 5. Recent Contact Us comments

    const recentCommentsQuery = `
      SELECT *
      FROM comments
      ORDER BY created_at DESC
      LIMIT 5
    `;

    const recentComments = await query(recentCommentsQuery);

    return {
      userRoles,
      total_comments,
      total_pharmacies,
      userProfile,
      recentComments,
    };
  } catch (error) {
    throw error;
  }
};

module.exports = {
  getPharmacyDashboard,
  getAdminOverview,
};
