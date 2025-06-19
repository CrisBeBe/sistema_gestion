import { DATABASE_CONFIG } from "@/config";
import { createPool } from "mysql2/promise";

const db_pool = createPool({
  host: DATABASE_CONFIG.host,
  port: DATABASE_CONFIG.port,
  user: DATABASE_CONFIG.user,
  password: DATABASE_CONFIG.password,
  database: DATABASE_CONFIG.database,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

export default db_pool;
