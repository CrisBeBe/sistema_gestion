const DATABASE_CONFIG = {
  host: process.env.DB_HOST || "localhost",
  port: parseInt(process.env.DB_PORT || "3306", 10),
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_DATABASE || "db",
};

const BASE_URL = process.env.BASE_URL || "";
const NEXTAUTH_SECRET = process.env.NEXTAUTH_SECRET || "";

export { BASE_URL, DATABASE_CONFIG, NEXTAUTH_SECRET };
