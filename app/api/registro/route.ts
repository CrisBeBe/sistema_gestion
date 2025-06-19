
import { NextResponse } from "next/server";
import mysql from "mysql2/promise";

export async function POST(request: Request) {
  try {
    const { username, email, password, id_rol, id_apt } = await request.json();

    const connection = await mysql.createConnection({
      host: "localhost",
      user: "root",
      password: "cristhianpool",
      database: "bpm_web",
    });

    // Verificar si ya existe el correo
    const [existing]: any = await connection.execute(
      "SELECT 1 FROM usuarios WHERE nombre = ?",
      [username]
    );

    if (existing.length > 0) {
      await connection.end();
      return NextResponse.json({ message: "El usuario ya se encuentra registrado" }, { status: 400 });
    }

    await connection.execute(
      "CALL PA_crear_usuario(?, ?, ?, ?, ?)",
      [username, email, password, id_rol, id_apt]
    );

    await connection.end();

    return NextResponse.json({ message: "Usuario registrado con éxito" }, { status: 201 });

  } catch (error) {
    console.error("Error en registro:", error);
    return NextResponse.json({ message: "Error interno en el servidor" }, { status: 500 });
  }
}
