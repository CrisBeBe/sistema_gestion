import TopBar from "@/components/TopBar";
import { Props } from "@/types/types";
import Sidebar from "@components/Sidebar";
import { getServerSession } from "next-auth";
import { redirect } from "next/navigation";

export default async function DashboardLayout({ children }: Props) {
  const session = await getServerSession();

  if (!session) {
    redirect("/login");
  }

  return (
    <div className="grid grid-cols-[250px_1fr] grid-rows-[60px_1fr] h-full">
      <div className="row-start-1 col-start-2">
        <TopBar />
      </div>
      <div className="row-span-2 col-start-1">
        <Sidebar />
      </div>
      <div className="row-start-2 col-start-2">{children}</div>
    </div>
  );
}
