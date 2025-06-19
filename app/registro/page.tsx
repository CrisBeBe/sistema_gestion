"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";

interface Rol {
  id_rol: number;
  nombre: string;
}

interface Departamento {
  id_departamento: number;
  nombre: string;
}

const RegistroPage = () => {
  const router = useRouter();

  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [rol, setRol] = useState<Rol>();
  const [apt, setApt] = useState<Departamento>();
  const [mensaje, setMensaje] = useState("");

  const [roles, setRoles] = useState<Rol[]>([]);
  const [departamentos, setDepartamentos] = useState<Departamento[]>([]);

  // Fetch roles y departamentos al cargar
  useEffect(() => {
    const fetchDatos = async () => {
      const resRoles = await fetch("/api/roles");
      const rolesData = await resRoles.json();
      setRoles(rolesData);

      const resDept = await fetch("/api/departamentos");
      const deptData = await resDept.json();
      setDepartamentos(deptData);
    };

    fetchDatos();
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const res = await fetch("/api/registro", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        username,
        email,
        password,
        id_rol: rol?.id_rol,
        id_apt: apt?.id_departamento,
      }),
    });

    const data = await res.json();

    if (res.ok) {
      setMensaje("Usuario registrado con éxito");
      setTimeout(() => router.push("/login"), 1500);
    } else {
      setMensaje(data.message || "Error al registrar");
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-r from-green-100 to-blue-100">
      <div className="bg-white p-8 rounded-2xl shadow-lg w-full max-w-md">
        <h2 className="text-2xl font-bold text-center mb-6 text-gray-800">Registro</h2>

        <form onSubmit={handleSubmit} className="space-y-5">
          <div>
            <label className="text-black block text-sm font-medium">Nombre completo</label>
            <input
              type="text"
              required
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              className="w-full mt-1 px-4 py-2 border rounded-lg text-black"
            />
          </div>

          <div>
            <label className="text-black block text-sm font-medium">Correo electrónico</label>
            <input
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full mt-1 px-4 py-2 border rounded-lg text-black"
            />
          </div>

          <div>
            <label className="text-black block text-sm font-medium">Contraseña</label>
            <input
              type="password"
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full mt-1 px-4 py-2 border rounded-lg text-black"
            />
          </div>

          <div>
            <label className="text-black block text-sm font-medium">Rol</label>
            <select
              required
              value={rol?.id_rol}
              onChange={(e) => 
                setRol(roles.find(r => r.id_rol === parseInt(e.target.value)))
            }
              className="w-full mt-1 px-4 py-2 border rounded-lg text-black"
            >
              <option value="">Seleccione un rol</option>
              {roles.map((rol) => (
                <option key={rol.id_rol} value={rol.id_rol}>
                  {rol.nombre}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="text-black block text-sm font-medium">Departamento</label>
            <select
              required
              value={apt?.id_departamento}
              onChange={(e) => setApt(departamentos.find(d => d.id_departamento === parseInt(e.target.value)))}
              className="w-full mt-1 px-4 py-2 border rounded-lg text-black"
            >
              <option value="">Seleccione un departamento</option>
              {departamentos.map((d) => (
                <option key={d.id_departamento} value={d.id_departamento}>
                  {d.nombre}
                </option>
              ))}
            </select>
          </div>

          <button
            type="submit"
            className="w-full bg-green-600 text-white py-2 rounded-lg hover:bg-green-700 disabled:opacity-70 transition-colors"
            disabled={!rol || !apt || !username || !email || !password}
          >
            Registrarse
          </button>
        </form>

        {mensaje && <p className="mt-4 text-center text-red-600">{mensaje}</p>}

        <div className="mt-4 text-center text-sm text-black">
          ¿Ya tienes una cuenta?{" "}
          <a href="/login" className="text-green-600 hover:underline">
            Inicia sesión
          </a>
        </div>
      </div>
    </div>
  );
};

export default RegistroPage;
