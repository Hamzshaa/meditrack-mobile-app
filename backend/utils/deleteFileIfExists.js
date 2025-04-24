const fs = require("fs").promises;

const deleteFileIfExists = async (filePath) => {
  try {
    await fs.access(filePath);
    await fs.unlink(filePath);
    console.log(`Deleted file: ${filePath}`);
  } catch (error) {
    if (error.code === "ENOENT") {
      return;
    }
  }
};

module.exports = deleteFileIfExists;
