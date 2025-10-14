import { Link } from "react-router-dom";
import AppIcons from "../contanst/app_icons";
import { useState } from "react";

function Menu() {
  const [isOpen, setIsOpen] = useState(false);
  // role: ADMIN, ACCOUNTANT
  const role = localStorage.getItem("role") || "ADMIN";

  const adminMenu = [
    { name: "Tổng quan", icon: AppIcons.home, link: "/" },
    {
      name: "Báo cáo tài chính & thuế",
      icon: AppIcons.checkList,
      link: "/",
    },
    { name: "Quản lý nhân sự", icon: AppIcons.users, link: "/" },
    { name: "Thông báo quan trọng", icon: AppIcons.notify, link: "/" },
  ];

  const userMenu = [
    { name: "Tổng quan", icon: AppIcons.home, link: "/" },
    { name: "Quản lý tài liệu", icon: AppIcons.document, link: "" },
    { name: "Tính thuế", icon: AppIcons.caculator, link: "" },
    { name: "Khai thuế & nộp thuế", icon: AppIcons.payment, link: "" },
  ];

  // Lấy menu theo role
  const menuItems = role === "ADMIN" ? adminMenu : userMenu;

  return (
    <div
      className={` w-fit h-screen bg-[#1976D2] text-white flex flex-col overflow-hidden transition-all duration-500 ease-in-out ${
        isOpen ? "absolute top-0 left-0" : ""
      }`}
      onMouseEnter={() => setIsOpen(true)}
      onMouseLeave={() => setIsOpen(false)}
    >
      <div className="p-4 text-lg font-bold relative">
        {isOpen ? "SMEs Website" : " "}
      </div>

      {/* Items menu */}
      <ul className="flex-1 p-2 space-y-2 h-full">
        {menuItems.map((item, index) => (
          <li key={index}>
            <Link
              to={item.link}
              className="flex items-center gap-3 p-2 rounded-lg hover:bg-[#2196F3] transition-colors font-semibold"
            >
              <item.icon className=" w-12" />

              <span
                className={`whitespace-nowrap text-xl transition-all duration-500 ease-in-out ${
                  isOpen ? "opacity-100 ml-2 block" : "opacity-0 ml-0 hidden"
                }`}
              >
                {item.name}
              </span>
            </Link>
          </li>
        ))}
      </ul>

      <Link
        to="/settings"
        className="flex gap-3 p-3 font-semibold items-center"
      >
        <AppIcons.settings className="w-12 h-12" />
        {isOpen && <span className="whitespace-nowrap text-2xl">Cài đặt</span>}
      </Link>
    </div>
  );
}

export default Menu;
