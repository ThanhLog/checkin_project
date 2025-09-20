import { Link } from "react-router-dom";
import AppIcons from "../contanst/app_icons";
import { useState } from "react";

function Menu() {
  const [isOpen, setIsOpen] = useState(false);

  const menuItems = [
    { name: "Tổng quan", icon: AppIcons.home, link: "/" },
    {
      name: "Báo cáo tài chính & thuế",
      icon: AppIcons.checkList,
      link: "/checklist",
    },
    { name: "Quản lý nhân sự", icon: AppIcons.users, link: "/users" },
    { name: "Thông báo quan trọng", icon: AppIcons.notify, link: "/notify" },
  ];

  return (
    <div className="w-fit h-screen bg-[#1976D2] text-white flex flex-col">
      <div className="p-4 text-lg font-bold relative">
        {isOpen ? "SMEs Website" : " "}
        <button
          onClick={() => setIsOpen(!isOpen)}
          className="bg-white rounded-full shadow-2xl absolute right-[-10px] top-1/2 transform -translate-y-1/2"
        >
          <img
            src={isOpen ? AppIcons.arrowLeft : AppIcons.arrowRight}
            alt="Menu"
            width={30}
            height={30}
          />
        </button>
      </div>

      {/* Items menu */}
      <ul className="flex-1 p-2 space-y-2 h-full">
        {menuItems.map((item, index) => (
          <li key={index}>
            <a
              href={item.link}
              className="flex items-center gap-3 p-2 rounded-lg hover:bg-[#2196F3] transition-colors font-semibold"
            >
              <img src={item.icon} alt={item.name} width={30} height={30} />
              {isOpen && <span className="whitespace-nowrap">{item.name}</span>}
            </a>
          </li>
        ))}
      </ul>
      <Link to="" className="flex gap-3 p-3 font-semibold">
        <img src={AppIcons.settings} alt="" width={30} height={30} />{" "}
        {isOpen && <span className="whitespace-nowrap">Cài đặt</span>}
      </Link>
    </div>
  );
}

export default Menu;
