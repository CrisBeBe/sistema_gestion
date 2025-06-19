"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

const LoginPage = () => {
  const router = useRouter();
  const [username, setUsername] = useState<string>("");
  const [password, setPassword] = useState<string>("");
  const [error, setError] = useState<string>("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      const res = await fetch("http://localhost:3000/api/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ username, password }),
      });

      const data = await res.json();

      if (res.ok) {
        // Aquí podrías guardar el token si tu backend lo devuelve
        // localStorage.setItem("token", data.token);
        router.push("/dashboard");
      } else {
        setError(data.message || "Usuario o contraseña incorrectos");
      }
    } catch (err) {
      setError("Error del servidor. Inténtalo más tarde.");
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-r from-blue-50 to-blue-200 flex items-center justify-center">
      <div className="w-full max-w-md bg-white p-8 rounded-2xl shadow-lg">
        <h2 className="text-2xl font-bold text-center text-gray-800 mb-6">
          Iniciar Sesión
        </h2>

        <form onSubmit={handleSubmit} className="space-y-5">
          <div>
            <label htmlFor="username" className="block text-sm font-medium text-black">
              Nombre Usuario : 
            </label>
            <input
              type="text"
              id="username"
              value={username}
              required
              onChange={(e) => setUsername(e.target.value)}
              className="mt-1 w-full text-black px-4 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div>
            <label htmlFor="password" className="block text-sm font-medium text-black">
              Contraseña
            </label>
            <input
              type="password"
              id="password"
              value={password}
              required
              onChange={(e) => setPassword(e.target.value)}
              className="mt-1 text-black w-full px-4 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <button
            type="submit"
            className="w-full bg-blue-600 text-white font-semibold py-2 rounded-lg hover:bg-blue-700 transition duration-300"
          >
            Iniciar sesión
          </button>

          {error && (
            <p className="text-red-500 text-sm mt-2 text-center">{error}</p>
          )}
        </form>

        <div className="mt-6 text-center text-sm text-gray-600">
          ¿No tienes cuenta?{" "}
          <a href="/registro" className="text-blue-600 hover:underline">
            Regístrate aquí
          </a>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
