import db_pool from "@/lib/db";
import { NextRequest, NextResponse } from "next/server";

export async function PUT(
  req: NextRequest,
  { params }: { params: { taskId: string } }
) {
  const { taskId } = params;
  const body = await req.json();
  const { nombre, descripcion, estado, prioridad, fecha_limite } = body;
  const connection = await db_pool.getConnection();

  try {
    const [] = await connection.execute(
      `CALL PA_actualizar_tarea(?,?,?,?,?,?)`,
      [taskId, nombre, descripcion, estado, prioridad, fecha_limite || null]
    );

    return NextResponse.json(
      { success: true, message: "Tarea actualizada correctamente" },
      { status: 200 }
    );
  } catch (error) {
    console.error("Error al actualizar la tarea:", error);
    return NextResponse.json(
      { success: false, message: "Error al actualizar la tarea" },
      { status: 500 }
    );
  } finally {
    connection.release();
  }
}

export async function GET(
  _req: NextRequest,
  { params }: { params: { taskId: string } }
) {
  const { taskId } = params;
  const connection = await db_pool.getConnection();

  try {
    const [rows]: any[] = await connection.execute(`CAll PA_obtener_tarea(?)`, [
      taskId,
    ]);

    if (!rows || rows.length === 0) {
      return NextResponse.json(
        { message: "Tarea no encontrada" },
        { status: 404 }
      );
    }

    return NextResponse.json(rows[0], { status: 200 });
  } catch (error) {
    console.error("Error al obtener la tarea:", error);
    return NextResponse.json(
      { message: "Error interno del servidor" },
      { status: 500 }
    );
  } finally {
    connection.release();
  }
}
