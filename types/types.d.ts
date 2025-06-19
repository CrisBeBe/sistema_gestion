import { ReactNode } from "react";

interface Props {
  children: Readonly<ReactNode>;
}

interface AvatarProps extends Props {
  name: string;
  roleId: number;
  size?: number;
}

interface BadgeProps extends React.HTMLAttributes<HTMLDivElement> {}

interface ProgressProps extends React.HTMLAttributes<HTMLDivElement> {
  value?: number; // de 0 a 100
}

interface ProjectCardProps {
  title: string;
  status: "activo" | "en proceso" | "completado";
  progress: number; // de 0 a 100
  deadline: Date; // formato fecha ISO o texto
}

interface SidebarProps {
  currentPath?: string;
  isCollapsed?: boolean;
}

interface TaskItemProps {
  title: string;
  assignedTo: string;
  status: "pendiente" | "en progreso" | "completado";
  priority: "alta" | "media" | "baja";
  onToggle: () => void;
  completed?: boolean;
  taskId: string;
  projectId: string;
}

interface TopBarProps {
  userName: string;
}

interface TaskData {
  nombre: string;
  descripcion: string;
  estado:
    | "pendiente"
    | "en progreso"
    | "completada"
    | "rechazada"
    | "cancelada";
  prioridad: "baja" | "media" | "alta";
  fecha_limite: Date | null;
}

interface User {
  id: number;
  name: string;
  email: string;
  state: "activo" | "inactivo" | "suspendido";
  id_rol: number;
  id_apt: number;
}

interface AuthContext {
  user: User | null;
  setUser: (u: User | null) => void;
}

interface APILoginResponse {
  message: string;
  data: User | null;
}
