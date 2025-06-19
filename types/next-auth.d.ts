import "next-auth";

declare module "next-auth" {
  interface Session {
    user?: {
      id: string;
      name: string;
      email: string;
      state: "activo" | "inactivo" | "suspendido";
      id_rol: number;
      id_apt: number;
    };
  }

  interface User {
    id: string;
    name: string;
    email: string;
    state: "activo" | "inactivo" | "suspendido";
    id_rol: number;
    id_apt: number;
  }
}
