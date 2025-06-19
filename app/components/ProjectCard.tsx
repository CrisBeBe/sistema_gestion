"use client";

import React from "react";
import { clsx as cn } from "clsx";
import { Progress } from "@components/Progress";
import { Badge } from "@components/Badge";
import { CalendarIcon } from "lucide-react";

interface ProjectCardProps {
  title: string;
  status: "activo" | "en proceso" | "completado";
  progress: number; // de 0 a 100
  deadline: string; // formato fecha ISO o texto
}

export const ProjectCard: React.FC<ProjectCardProps> = ({
  title,
  status,
  progress,
  deadline,
}) => {
  const getStatusColor = () => {
    switch (status) {
      case "activo":
        return "bg-green-500";
      case "en proceso":
        return "bg-yellow-500";
      case "completado":
        return "bg-blue-600";
      default:
        return "bg-gray-500";
    }
  };

  return (
    <div className="rounded-2xl border p-4 shadow-md bg-white w-full max-w-md">
      <div className="flex justify-between items-start mb-3">
        <h3 className="text-lg font-semibold text-gray-800">{title}</h3>
        <Badge className={cn(getStatusColor(), "text-white capitalize")}>
          {status}
        </Badge>
      </div>

      <div className="mb-4">
        <Progress value={progress} />
        <p className="text-sm text-gray-600 mt-1">{progress}% completado</p>
      </div>

      <div className="flex items-center gap-2 text-sm text-gray-500">
        <CalendarIcon className="w-4 h-4" />
        <span>Fecha límite: {deadline}</span>
      </div>
    </div>
  );
};
