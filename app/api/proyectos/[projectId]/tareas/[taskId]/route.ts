import { NextRequest, NextResponse } from "next/server";
import mysql from "mysql2/promise";

// ⚙️ Configuración de la conexión
const dbConfig = {
  host: "localhost",
  user: "root",
  password: "cristhianpool",
  database: "bpm_web",
};

export async function PUT(req: NextRequest, { params }: { params: { taskId: string } }) {
  const { taskId } = params;

  try {
    const body = await req.json();
    const { nombre, descripcion, estado, prioridad, fecha_limite } = body;

    const connection = await mysql.createConnection(dbConfig);

    const [result] = await connection.execute(
      `CALL PA_actualizar_tarea(?,?,?,?,?,?)`,
      [taskId,nombre, descripcion, estado, prioridad, fecha_limite || null]
    );

    await connection.end();

    return NextResponse.json({ success: true, message: "Tarea actualizada correctamente" }, { status: 200 });
  } catch (error) {
    console.error("Error al actualizar la tarea:", error);
    return NextResponse.json({ success: false, message: "Error al actualizar la tarea" }, { status: 500 });
  }
}






export async function GET(
  req: NextRequest,
  { params }: { params: {  taskId: string } }
) {
  const {  taskId } = params;

  try {
    const connection = await mysql.createConnection(dbConfig);

    const [rows]: any[] = await connection.execute(
      `CAll PA_obtener_tarea(?)`,
      [taskId ]
    );

    await connection.end();
   
    if (!rows || rows.length === 0) {
      return NextResponse.json({ message: "Tarea no encontrada" }, { status: 404 });
    }

    return NextResponse.json(rows[0], { status: 200 });
  } catch (error) {
    console.error("Error al obtener la tarea:", error);
    return NextResponse.json({ message: "Error interno del servidor" }, { status: 500 });
  }
}
