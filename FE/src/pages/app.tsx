import { useState } from "react";
import { Link } from "react-router-dom";
import { FaFileInvoice, FaChartBar, FaBell } from "react-icons/fa";

export default function App() {
  const [message, setMessage] = useState("");

  const handleInput = (e: React.FormEvent<HTMLTextAreaElement>) => {
    const target = e.target as HTMLTextAreaElement;
    setMessage(target.value);
    target.style.height = "auto";
    target.style.height = target.scrollHeight + "px";
  };

  return (
    <div className="min-h-screen bg-[#0D47A1] text-white">
      {/* Header */}
      <header className="flex justify-between items-center px-6 py-4 bg-[#0D47A1] fixed top-0 left-0 right-0 z-50 shadow">
        <h1 className="text-xl font-bold">SME Tax Manager</h1>
        <Link
          to={"/authencation"}
          className="px-4 py-2 bg-white text-[#0D47A1] rounded-lg hover:bg-gray-100 transition"
        >
          Đăng nhập / Đăng ký
        </Link>
      </header>

      <main className="pt-20">
        {/* Giới thiệu */}
        <section className="text-center py-20 px-4 bg-gradient-to-b from-[#0D47A1] to-[#1565C0]">
          <h2 className="text-4xl font-bold mb-4 animate-fadeIn">
            Giải pháp quản lý thuế thông minh
          </h2>
          <p className="text-gray-200 mb-6 max-w-2xl mx-auto animate-fadeIn">
            Quản lý báo cáo thuế, hóa đơn và nghĩa vụ tài chính một cách đơn
            giản, tiết kiệm thời gian và chi phí với SME Tax Manager.
          </p>
          <Link to={'/authencation'} className="px-6 py-3 bg-orange-400 text-white rounded-lg text-lg hover:bg-orange-500 transition transform hover:scale-105 animate-bounce">
            Bắt đầu ngay
          </Link>
        </section>

        {/* Đánh giá */}
        <section className="bg-white text-[#0D47A1] py-20 px-6 text-center">
          <h2 className="text-3xl font-bold mb-6">Khách hàng nói gì?</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-6xl mx-auto">
            {[
              {
                text: "Hệ thống giúp tôi tiết kiệm 50% thời gian kê khai thuế!",
                name: "Nguyễn Văn A - CEO Công ty X",
              },
              {
                text: "Giao diện dễ sử dụng, hỗ trợ tuyệt vời!",
                name: "Trần Thị B - Kế toán trưởng",
              },
              {
                text: "Rất hài lòng với tính năng báo cáo thông minh.",
                name: "Phạm Văn C - Giám đốc Tài chính",
              },
            ].map((item, index) => (
              <div
                key={index}
                className="p-6 shadow rounded-lg bg-gray-50 hover:shadow-xl transition"
              >
                <p>"{item.text}"</p>
                <h4 className="mt-4 font-semibold">{item.name}</h4>
              </div>
            ))}
          </div>
        </section>

        {/* Phản hồi */}
        <section className="py-20 px-6 text-center">
          <h2 className="text-3xl font-bold mb-6">
            Gửi phản hồi cho chúng tôi
          </h2>
          <form className="max-w-lg mx-auto space-y-4">
            <input
              type="text"
              placeholder="Họ và tên"
              className="w-full bg-white p-3 rounded text-black border border-gray-300 focus:outline-none focus:ring-2 focus:ring-orange-400"
            />
            <input
              type="email"
              placeholder="Email"
              className="w-full bg-white p-3 rounded text-black border border-gray-300 focus:outline-none focus:ring-2 focus:ring-orange-400"
            />
            <textarea
              placeholder="Nội dung phản hồi"
              value={message}
              onInput={handleInput}
              className="w-full bg-white p-3 rounded text-black border border-gray-300 focus:outline-none focus:ring-2 focus:ring-orange-400 overflow-hidden resize-none"
              rows={1}
            ></textarea>
            <button className="px-6 py-3 bg-orange-400 text-white rounded-lg hover:bg-orange-500 transition transform hover:scale-105">
              Gửi phản hồi
            </button>
          </form>
        </section>

        {/* Tính năng */}
        <section className="bg-white text-[#0D47A1] py-20 px-6 text-center">
          <h2 className="text-3xl font-bold mb-6">Tính năng nổi bật</h2>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-6 max-w-6xl mx-auto">
            {[
              {
                icon: <FaFileInvoice size={40} className="mx-auto mb-2" />,
                title: "Tự động kê khai thuế",
                desc: "Kết nối với hệ thống thuế điện tử.",
              },
              {
                icon: <FaFileInvoice size={40} className="mx-auto mb-2" />,
                title: "Quản lý hóa đơn",
                desc: "Lưu trữ và tra cứu hóa đơn thuận tiện.",
              },
              {
                icon: <FaChartBar size={40} className="mx-auto mb-2" />,
                title: "Báo cáo tài chính",
                desc: "Biểu đồ, thống kê trực quan.",
              },
              {
                icon: <FaBell size={40} className="mx-auto mb-2" />,
                title: "Nhắc nhở thông minh",
                desc: "Không bỏ lỡ hạn nộp thuế quan trọng.",
              },
            ].map((item, index) => (
              <div
                key={index}
                className="p-6 shadow rounded-lg bg-gray-50 hover:shadow-xl transition"
              >
                {item.icon}
                <h3 className="text-xl font-semibold mb-2">{item.title}</h3>
                <p>{item.desc}</p>
              </div>
            ))}
          </div>
        </section>

        {/* AI */}
        <section className="py-20 px-6 text-center">
          <h2 className="text-3xl font-bold mb-6">Tích hợp AI thông minh</h2>
          <p className="max-w-2xl mx-auto mb-6 text-gray-200">
            Hệ thống AI giúp dự đoán và tối ưu hóa kế hoạch nộp thuế, đưa ra gợi
            ý để giảm thiểu rủi ro và tiết kiệm chi phí.
          </p>
          <button className="px-6 py-3 bg-orange-400 text-white rounded-lg hover:bg-orange-500 transition transform hover:scale-105">
            Khám phá AI
          </button>
        </section>
      </main>

      {/* Footer */}
      <footer className="bg-[#0D47A1] text-center py-6 text-gray-200 text-sm">
        <div className="space-x-4 mb-2">
          <Link to="/privacy" className="hover:underline">
            Chính sách
          </Link>
          <Link to="/contact" className="hover:underline">
            Liên hệ
          </Link>
          <Link to="/faq" className="hover:underline">
            FAQ
          </Link>
        </div>
        © 2025 SME Tax Manager. All rights reserved.
      </footer>
    </div>
  );
}
