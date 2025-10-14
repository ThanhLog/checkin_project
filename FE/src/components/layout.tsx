import { Outlet } from "react-router-dom";
import Menu from "./menu";

function Layout() {
  return (
    <div className="flex h-screen relative">
      <Menu />
      <div className="flex-1 bg-gray-100 p-4">
        <Outlet />
      </div>
    </div>
  );
}
export default Layout;
