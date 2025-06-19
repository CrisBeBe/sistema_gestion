"use client";

import React from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { clsx as cn } from "clsx";


import {
  Home,
  FolderKanban,
  Users,
  BarChart3,
  MessageSquare,
  Settings,
  LogOut,
} from "lucide-react";

interface SidebarProps {
  currentPath?: string;
  isCollapsed?: boolean;
}

const links = [
  { name: "Dashboard", href: "/dashboard", icon: Home },
  { name: "Proyectos", href: "/dashboard/proyectos", icon: FolderKanban },
  { name: "Colaboradores", href: "/dashboard/colaboradores", icon: Users },
  { name: "Estadísticas", href: "/dashboard/estadisticas", icon: BarChart3 },
  { name: "Comentarios", href: "/dashboard/comentarios", icon: MessageSquare },
  { name: "Configuración", href: "/dashboard/configuracion", icon: Settings },
];

export const Sidebar: React.FC<SidebarProps> = ({ currentPath, isCollapsed = false }) => {
  const pathname = usePathname();
  const activePath = currentPath || pathname;

  return (
    <aside
      className={cn(
        "h-screen bg-gray-900 text-white flex flex-col justify-between transition-all duration-300",
        isCollapsed ? "w-16" : "w-64"
      )}
    >
      <div className="p-4">
        <h2 className={cn("text-xl font-bold mb-6 transition-opacity", isCollapsed && "opacity-0")}>
          BPM System
        </h2>
        <nav className="flex flex-col gap-2">
          {links.map(({ name, href, icon: Icon }) => (
            <Link
              key={name}
              href={href}
              className={cn(
                "flex items-center gap-3 px-4 py-2 rounded hover:bg-gray-700 transition-all",
                activePath === href && "bg-gray-800"
              )}
            >
              <Icon size={20} />
              {!isCollapsed && <span>{name}</span>}
            </Link>
          ))}
        </nav>
      </div>
      <div className="p-4">
        <button className="flex items-center gap-3 w-full text-left hover:text-red-400">
          <LogOut size={20} />
          {!isCollapsed && <span>Cerrar sesión</span>}
        </button>
      </div>
    </aside>
  );
};
