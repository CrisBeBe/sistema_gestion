import mysql from "mysql2/promise";

export async function getRoleColor(roleId: number): Promise<string> {
  try {
    const connection = await mysql.createConnection({
      host: "localhost",
      user: "root",
      password: "cristhianpool",
      database: "bpm_web",
    });

    const [rows] = await connection.execute(
      "SELECT color FROM roles WHERE id_rol = ?",
      [roleId]
    );

    await connection.end();

    const result = Array.isArray(rows) && rows[0] ? (rows[0] as any) : null;

    return result?.color || "bg-gray-500"; // valor por defecto
  } catch (error) {
    console.error("Error al obtener el color del rol:", error);
    return "bg-gray-500";
  }
}
