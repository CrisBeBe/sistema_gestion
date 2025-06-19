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

    const [rows] = await connection.execute("SELECT id_departamento, nombre FROM departamentos");
    await connection.end();

    return NextResponse.json(rows);
  } catch (error) {
    console.error("Error al obtener departamentos:", error);
    return NextResponse.json({ message: "Error al obtener departamentos" }, { status: 500 });
  }
}
