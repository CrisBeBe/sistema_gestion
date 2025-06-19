"use client";

import { Badge } from "@/components/Badge";
import { Progress } from "@/components/Progress";
import { ProjectCardProps } from "@/types/types";
import { clsx as cn } from "clsx";
import { CalendarIcon } from "lucide-react";
import React from "react";

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
        <span>Fecha límite: {deadline.toLocaleDateString()}</span>
      </div>
    </div>
  );
};
