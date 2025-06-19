"use client";

import { Props } from "@/types/types";
import { SessionProvider } from "next-auth/react";

export default function AuthContextProvider({ children }: Props) {
  return <SessionProvider>{children}</SessionProvider>;
}
