import * as React from "react";
import { clsx as cn } from "clsx";

export interface BadgeProps extends React.HTMLAttributes<HTMLDivElement> {}

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
