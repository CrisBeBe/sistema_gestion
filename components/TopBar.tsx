"use client";

import { Bell, ChevronDown } from "lucide-react";
import { useSession } from "next-auth/react";

export default function TopBar() {
  const { data } = useSession();
  const userName = data?.user?.name || "";
  const initial = userName.charAt(0).toUpperCase() || "?";

  return (
    <header className="w-full h-16 bg-white border-b shadow-sm flex items-center justify-between px-4 md:px-6">
      {/* Bienvenida */}
      <div className="text-lg font-semibold text-gray-800">
        Bienvenido, {userName}
      </div>

      {/* Iconos y avatar */}
      <div className="flex items-center gap-4">
        {/* Notificación */}
        <button className="relative hover:text-blue-600 transition">
          <Bell className="w-5 h-5" />
          <span className="absolute -top-1 -right-1 w-2 h-2 bg-red-500 rounded-full" />
        </button>

        {/* Avatar CSS */}
        <div className="flex items-center gap-2 cursor-pointer">
          <div className="w-8 h-8 rounded-full bg-blue-600 text-white font-extrabold flex items-center justify-center text-sm">
            {initial}
          </div>
          <ChevronDown className="w-4 h-4 text-gray-600" />
        </div>
      </div>
    </header>
  );
}
