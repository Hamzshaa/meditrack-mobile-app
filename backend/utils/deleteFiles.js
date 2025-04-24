const fs = require("fs");
const path = require("path");

const deleteFiles = (uploadedFiles) => {
  for (const key in uploadedFiles) {
    uploadedFiles[key].forEach((filePath) => {
      const fullPath = path.join(__dirname, "../medias", `${key}s`, filePath);
      fs.unlink(fullPath, (err) => {
        if (err) {
          console.error(
            `Failed to delete file: ${filePath}. Error: ${err.message}`
          );
        } else {
          console.log(`Successfully deleted file: ${filePath}`);
        }
      });
    });
  }
};

module.exports = deleteFiles;
