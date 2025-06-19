import db_pool from "@/lib/db";
import { NextResponse } from "next/server";

export async function GET() {
  const connection = await db_pool.getConnection();

  try {
    const [rows] = await connection.execute("SELECT id_rol, nombre FROM roles");
    return NextResponse.json(rows);
  } catch (error) {
    console.error("Error al obtener roles:", error);
    return NextResponse.json(
      { message: "Error al obtener roles" },
      { status: 500 }
    );
  } finally {
    connection.release();
  }
}
