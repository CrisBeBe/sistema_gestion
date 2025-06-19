"use client";

import { AvatarProps } from "@/types/types";
import { getRoleColor } from "@lib/roleColor";
import clsx from "clsx";
import { useEffect, useState } from "react";

export default function Avatar({ name, roleId, size = 32 }: AvatarProps) {
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
      className={clsx(
        `rounded-full text-white font-extrabold flex items-center justify-center`,
        bgColor
      )}
      style={{ width: size, height: size, fontSize: size / 2 }}
      title={name}
    >
      {initial}
    </div>
  );
}
