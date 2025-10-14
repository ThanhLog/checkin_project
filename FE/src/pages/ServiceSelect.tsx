import { useNavigate } from "react-router-dom";
import {
  Building2,
  Hospital,
  Plane,
  Store,
  GraduationCap,
  Car,
  Coffee,
  Home,
} from "lucide-react";

const services = [
  { id: "hotel", name: "Khách sạn", icon: Building2, color: "bg-blue-500" },
  { id: "hospital", name: "Bệnh viện", icon: Hospital, color: "bg-green-500" },

  // 🧩 Các dịch vụ fake thêm
  { id: "airport", name: "Sân bay", icon: Plane, color: "bg-indigo-500" },
  {
    id: "shopping",
    name: "Trung tâm thương mại",
    icon: Store,
    color: "bg-pink-500",
  },
  {
    id: "university",
    name: "Trường đại học",
    icon: GraduationCap,
    color: "bg-yellow-500",
  },
  { id: "parking", name: "Bãi đỗ xe", icon: Car, color: "bg-gray-600" },
  { id: "cafe", name: "Quán cà phê", icon: Coffee, color: "bg-orange-500" },
  { id: "apartment", name: "Chung cư", icon: Home, color: "bg-purple-500" },
];

const ServiceSelect = () => {
  const navigate = useNavigate();

  const handleSelect = (serviceId: string) => {
    // 🔗 Nếu là fake service thì chỉ cảnh báo tạm thời
    if (!["hotel", "hospital"].includes(serviceId)) {
      alert("🚧 Dịch vụ này đang được phát triển!");
      return;
    }
    navigate(`/checkin/${serviceId}`);
  };

  return (
    <div className="min-h-screen w-screen flex flex-col items-center justify-center bg-gradient-to-br from-gray-50 to-gray-200">
      <h1 className="text-3xl font-extrabold mb-10 text-gray-800 tracking-wide">
        Chọn dịch vụ Check-in
      </h1>

      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-8 px-6">
        {services.map((s) => (
          <button
            key={s.id}
            onClick={() => handleSelect(s.id)}
            className={`relative group flex flex-col items-center justify-center p-8 rounded-2xl shadow-lg bg-gradient-to-br ${s.color} text-white font-semibold transition-all duration-300 hover:scale-105 hover:shadow-2xl`}
          >
            <div className="bg-white/20 p-4 rounded-full mb-4 group-hover:bg-white/30 transition-all duration-200">
              <s.icon size={48} />
            </div>

            <span className="text-lg tracking-wide text-center">{s.name}</span>

            <div className="absolute inset-0 rounded-2xl bg-white/10 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
          </button>
        ))}
      </div>

      <p className="mt-10 text-gray-500 text-sm">
        Vui lòng chọn loại dịch vụ bạn muốn check-in
      </p>
    </div>
  );
};

export default ServiceSelect;
