const multer = require("multer");
const path = require("path");
const fs = require("fs");

const storage = (folderConfig) =>
  multer.diskStorage({
    destination: (req, file, cb) => {
      const folderName = folderConfig[file.fieldname];
      if (!folderName) {
        return cb(
          new Error(`Folder not specified for field: ${file.fieldname}`)
        );
      }

      const uploadPath = path.join(__dirname, `../medias/${folderName}`);

      if (!fs.existsSync(uploadPath)) {
        fs.mkdirSync(uploadPath, { recursive: true });
      }
      cb(null, uploadPath); // Destination folder
    },
    filename: (req, file, cb) => {
      const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
      const filename = uniqueSuffix + path.extname(file.originalname) || ".jpg"; // Default to .jpg if no extension
      cb(null, filename); // Unique file name
    },
  });

const uploadFiles = (folderConfig) => {
  const fieldsConfig = Object.keys(folderConfig).map((fieldName) => ({
    name: fieldName,
    maxCount: 8, // Maximum number of files per field
  }));

  return (req, res, next) => {
    const multerUpload = multer({
      storage: storage(folderConfig),
      limits: { fileSize: 10 * 1024 * 1024 }, // 10 MB limit
      fileFilter: (req, file, cb) => {
        console.log(`File received: ${file.originalname}`);
        console.log(`File MIME type: ${file.mimetype}`);
        console.log(
          `File extension: ${path.extname(file.originalname).toLowerCase()}`
        );

        const isBlob = file.originalname === "blob";
        const isImageMimeType =
          /image\/(jpeg|jpg|png|gif|bmp|webp|tiff|svg\+xml|x-icon)/.test(
            file.mimetype
          );

        if (isImageMimeType || isBlob) {
          console.log("File accepted");
          cb(null, true);
        } else {
          console.log("Unsupported file type");
          cb(new Error("Only image and blob files are allowed"));
        }
      },
    }).fields(fieldsConfig);

    multerUpload(req, res, (err) => {
      if (err) {
        console.error("Multer error:", err.message);
        return next(err); // Pass Multer error to error handler
      }

      // Collect filenames and organize them by field
      const uploadedFiles = {};
      Object.keys(folderConfig).forEach((fieldName) => {
        uploadedFiles[fieldName] =
          req.files[fieldName]?.map((file) => file?.filename) || [];
      });

      // Attach uploadedFiles to req object
      req.uploadedFiles = uploadedFiles;
      console.log("Uploaded files:", uploadedFiles);

      next();
    });
  };
};

module.exports = uploadFiles;
