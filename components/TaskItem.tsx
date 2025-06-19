"use client";

import { Badge } from "@/components/Badge";
import { TaskItemProps } from "@/types/types";
import { clsx as cn } from "clsx";
import { PencilIcon } from "lucide-react";
import { useRouter } from "next/navigation";
import React from "react";

export const TaskItem: React.FC<TaskItemProps> = ({
  title,
  assignedTo,
  status,
  priority,
  onToggle,
  completed = false,
  taskId,
  projectId,
}) => {
  const router = useRouter();

  const handleEditRedirect = () => {
    router.push(`/dashboard/proyectos/${projectId}/tareas/${taskId}/editar`);
  };

  const getPriorityColor = () => {
    switch (priority) {
      case "alta":
        return "bg-red-500 text-white";
      case "media":
        return "bg-yellow-400 text-black";
      case "baja":
        return "bg-green-500 text-white";
      default:
        return "bg-gray-400 text-white";
    }
  };

  const getStatusColor = () => {
    switch (status) {
      case "pendiente":
        return "text-yellow-600";
      case "en progreso":
        return "text-blue-600";
      case "completado":
        return "text-green-600 line-through";
      default:
        return "text-gray-500";
    }
  };

  return (
    <div className="flex items-center justify-between p-4 rounded-xl border shadow-sm bg-white hover:bg-gray-50 transition-colors">
      <div className="flex items-center gap-3">
        <input
          type="checkbox"
          checked={completed}
          onChange={onToggle}
          className="h-5 w-5 text-blue-600 accent-blue-500"
        />
        <div>
          <h4 className={cn("font-medium text-sm", getStatusColor())}>
            {title}
          </h4>
          <p className="text-xs text-gray-500">Asignado a: {assignedTo}</p>
        </div>
      </div>

      <div className="flex items-center gap-2">
        <Badge className={getPriorityColor()}>{priority}</Badge>

        <button
          onClick={handleEditRedirect}
          className="text-gray-500 hover:text-blue-600 transition-colors"
          title="Editar tarea"
        >
          <PencilIcon className="h-4 w-4" />
        </button>
      </div>
    </div>
  );
};
