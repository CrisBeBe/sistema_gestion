import { BadgeProps } from "@/types/types";
import { clsx as cn } from "clsx";
import * as React from "react";

export const Badge = React.forwardRef<HTMLDivElement, BadgeProps>(
  ({ className, children, ...props }, ref) => {
    return (
      <div
        ref={ref}
        className={cn(
          "inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold",
          className
        )}
        {...props}
      >
        {children}
      </div>
    );
  }
);

Badge.displayName = "Badge";
