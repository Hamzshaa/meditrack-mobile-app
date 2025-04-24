const { query } = require("../lib/db.js");

const isPharmacyStaffMiddleware = async (req, res, next) => {
  user = req.user;

  if (!user) {
    return res.status(401).json({ message: "Unauthorized" });
  }

  if (user.role !== "pharmacy_staff") {
    return res.status(403).json({ message: "Forbidden" });
  }

  try {
    const getPharmacyStaffQuery = `SELECT pharmacy_id FROM pharmacies WHERE manager_id = ?`;

    const pharmacyStaff = await query(getPharmacyStaffQuery, [user.user_id]);

    if (pharmacyStaff?.length < 1) {
      return res.status(403).json({ message: "Forbidden" });
    }

    req.user.pharmacy_id = pharmacyStaff[0].pharmacy_id;
  } catch (error) {
    return res.status(403).json({ message: "Forbidden" });
  }

  next();
};

module.exports = isPharmacyStaffMiddleware;
