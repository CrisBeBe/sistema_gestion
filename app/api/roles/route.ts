import { NextResponse } from "next/server";
import mysql from "mysql2/promise";

export async function GET() {
  try {
    const connection = await mysql.createConnection({
      host: "localhost",
      user: "root",
      password: "cristhianpool",
      database: "bpm_web",
    });

    const [rows] = await connection.execute("SELECT id_rol, nombre FROM roles");
    await connection.end();

    return NextResponse.json(rows);
  } catch (error) {
    console.error("Error al obtener roles:", error);
    return NextResponse.json({ message: "Error al obtener roles" }, { status: 500 });
  }
}
