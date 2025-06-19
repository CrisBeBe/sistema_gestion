"use client";

import React, { useEffect, useState } from "react";
import { getRoleColor } from "@lib/roleColor";

interface AvatarProps {
  name: string;
  roleId: number;
  size?: number; // Tamaño opcional (por defecto: 32px)
}

export const Avatar: React.FC<AvatarProps> = ({ name, roleId, size = 32 }) => {
  const [bgColor, setBgColor] = useState("bg-gray-500");
  const initial = name.charAt(0).toUpperCase();

  useEffect(() => {
    const fetchColor = async () => {
      const color = await getRoleColor(roleId);
      setBgColor(color);
    };
    fetchColor();
  }, [roleId]);

  return (
    <div
      className={`rounded-full text-white font-extrabold flex items-center justify-center ${bgColor}`}
      style={{ width: size, height: size, fontSize: size / 2 }}
      title={name}
    >
      {initial}
    </div>
  );
};
