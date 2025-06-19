"use client";

import { TaskData } from "@/types/types";
import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

const EditTaskPage = () => {
  const { projectId, taskId } = useParams();
  const [formData, setFormData] = useState<TaskData>({
    nombre: "",
    descripcion: "",
    estado: "pendiente",
    prioridad: "media",
    fecha_limite: null,
  });

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchTask = async () => {
      try {
        const res = await fetch(`/api/proyectos/${projectId}/tareas/${taskId}`);
        const data = await res.json();
        setFormData({
          nombre: data.nombre,
          descripcion: data.descripcion,
          estado: data.estado,
          prioridad: data.prioridad,
          fecha_limite: data.fecha_limite,
        });
        setLoading(false);
      } catch (err) {
        setError("Error al cargar los datos de la tarea.");
        setLoading(false);
      }
    };

    fetchTask();
  }, [projectId, taskId]);

  const handleChange = (
    e: React.ChangeEvent<
      HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement
    >
  ) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    try {
      const res = await fetch(`/api/proyectos/${projectId}/tareas/${taskId}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(formData),
      });

      if (!res.ok) throw new Error("Error al guardar los cambios.");

      alert("Tarea actualizada correctamente.");
    } catch (err) {
      alert("Hubo un error al actualizar la tarea.");
    } finally {
      setSaving(false);
    }
  };

  if (loading)
    return <p className="p-6 text-sm text-gray-500">Cargando tarea...</p>;
  if (error) return <p className="p-6 text-red-600">{error}</p>;

  return (
    <div className="p-6 max-w-2xl mx-auto">
      <h1 className="text-2xl font-bold mb-4">Editar Tarea</h1>
      <form
        onSubmit={handleSubmit}
        className="space-y-5 bg-white p-6 rounded-xl shadow-sm"
      >
        <div>
          <label className="text-sm font-medium">Nombre de la tarea</label>
          <input
            type="text"
            name="nombre"
            value={formData.nombre}
            onChange={handleChange}
            className="w-full border px-4 py-2 rounded-lg mt-1 text-sm"
            required
          />
        </div>

        <div>
          <label className="text-sm font-medium">Descripción</label>
          <textarea
            name="descripcion"
            value={formData.descripcion}
            onChange={handleChange}
            className="w-full border px-4 py-2 rounded-lg mt-1 text-sm"
            rows={4}
          />
        </div>

        <div>
          <label className="text-sm font-medium">Estado</label>
          <select
            name="estado"
            value={formData.estado}
            onChange={handleChange}
            className="w-full border px-4 py-2 rounded-lg mt-1 text-sm"
          >
            <option value="pendiente">Pendiente</option>
            <option value="en progreso">En progreso</option>
            <option value="completada">Completada</option>
            <option value="rechazada">Rechazada</option>
            <option value="cancelada">Cancelada</option>
          </select>
        </div>

        <div>
          <label className="text-sm font-medium">Prioridad</label>
          <select
            name="prioridad"
            value={formData.prioridad}
            onChange={handleChange}
            className="w-full border px-4 py-2 rounded-lg mt-1 text-sm"
          >
            <option value="baja">Baja</option>
            <option value="media">Media</option>
            <option value="alta">Alta</option>
          </select>
        </div>

        <div>
          <label className="text-sm font-medium">Fecha límite</label>
          <input
            type="datetime-local"
            name="fecha_limite"
            value={formData.fecha_limite?.toLocaleDateString()}
            onChange={handleChange}
            className="w-full border px-4 py-2 rounded-lg mt-1 text-sm"
          />
        </div>

        <button
          type="submit"
          disabled={saving}
          className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition"
        >
          {saving ? "Guardando..." : "Guardar Cambios"}
        </button>
      </form>
    </div>
  );
};

export default EditTaskPage;
