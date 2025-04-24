const swaggerJsDoc = require("swagger-jsdoc");
const swaggerUi = require("swagger-ui-express");
const path = require("path");

const swaggerOptions = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "MediTrack Drug Tracking System API",
      version: "1.0.0",
      description: "API documentation for the MediTrack Drug Tracking System",
    },
    servers: [{ url: "http://localhost:5000" }],
  },
  apis: [path.join(__dirname, "../routes/*.js")],
};

const swaggerDocs = swaggerJsDoc(swaggerOptions);

module.exports = { swaggerDocs, swaggerUi };
