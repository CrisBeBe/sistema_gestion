"use client";

import { ProgressProps } from "@/types/types";
import { clsx as cn } from "clsx";
import * as React from "react";

export const Progress = React.forwardRef<HTMLDivElement, ProgressProps>(
  ({ className, value = 0, ...props }, ref) => {
    return (
      <div
        ref={ref}
        className={cn("h-3 w-full rounded-full bg-gray-200", className)}
        {...props}
      >
        <div
          className="h-full rounded-full bg-blue-600 transition-all duration-300"
          style={{ width: `${value}%` }}
        />
      </div>
    );
  }
);

Progress.displayName = "Progress";
