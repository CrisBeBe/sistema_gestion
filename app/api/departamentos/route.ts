import db_pool from "@/lib/db";
import { NextResponse } from "next/server";

export async function GET() {
  const connection = await db_pool.getConnection();

  try {
    const [rows] = await connection.execute(
      "SELECT id_departamento, nombre FROM departamentos"
    );

    return NextResponse.json(rows);
  } catch (error) {
    console.error("Error al obtener departamentos:", error);
    return NextResponse.json(
      { message: "Error al obtener departamentos" },
      { status: 500 }
    );
  } finally {
    connection.release();
  }
}
