// /app/api/login/route.ts

import { NextResponse } from "next/server";
import mysql from "mysql2/promise";

export async function POST(request: Request) {
  try {
    const { username, password } = await request.json();

    // Conexión a la base de datos MySQL
    const connection = await mysql.createConnection({
      host: "localhost",
      user: "root",
      password: "cristhianpool",
      database: "bpm_web",
    });

    const [rows]: any = await connection.execute(
      "SELECT FA_Loguear_Usuario(?, ?) AS resultado",
      [username, password]
    );

    await connection.end();

    if (rows [0].resultado === 1) {
      // Usuario encontrado
      return NextResponse.json({ message: "Login exitoso"}, { status: 200 });
    } else {
      return NextResponse.json({ message: "Usuario o contraseña incorrectos. vuelve a intentar " }, { status: 401 });
    }

  } catch (error) {
    console.error("Error en login:", error);
    return NextResponse.json({ message: "Error interno del servidor" }, { status: 500 });
  }
}
