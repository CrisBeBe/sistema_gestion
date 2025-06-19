import { DATABASE_CONFIG } from "@/config";
import { AuthOptions } from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";
import { DataSourceOptions } from "typeorm";
import db_pool from "./db";

export const connection: DataSourceOptions = {
  type: "mysql",
  host: DATABASE_CONFIG.host,
  port: DATABASE_CONFIG.port,
  username: DATABASE_CONFIG.user,
  password: DATABASE_CONFIG.password,
  database: DATABASE_CONFIG.database,
};

export const authOptions: AuthOptions = {
  session: {
    strategy: "jwt",
  },
  debug: true,
  providers: [
    CredentialsProvider({
      name: "Credentials",
      credentials: {
        username: { label: "Usuario", type: "text" },
        password: { label: "Contraseña", type: "password" },
      },
      async authorize(credentials) {
        const con = await db_pool.getConnection();

        const [resultado]: any = await con.execute(
          "CALL PA_Loguear_Usuario(?, ?)",
          [credentials?.username, credentials?.password]
        );

        if (!resultado[0][0]) return null;
        const user = resultado[0][0];

        return user;
      },
    }),
  ],
  callbacks: {
    async jwt({ token, user }) {
      // Solo se ejecuta la primera vez que se genera el token
      if (user) {
        token.id = user.id;
        token.name = user.name;
        token.email = user.email;
        token.state = user.state;
        token.id_rol = user.id_rol;
        token.id_apt = user.id_apt;
      }
      return token;
    },
    async session({ session, token }) {
      // Pasamos los datos del token a la sesión
      if (session.user) {
        session.user.id = token.id as string;
        session.user.state = token.state as
          | "activo"
          | "inactivo"
          | "suspendido";
        session.user.id_rol = token.id_rol as number;
        session.user.id_apt = token.id_apt as number;
      }
      return session;
    },
  },
  pages: {
    signIn: "/login",
  },
};
