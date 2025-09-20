import "./../../index.css";
import { Link } from "react-router-dom";

function register() {
  return (
    <div className=" mx-auto p-4">
      <h2 className="text-center text-3xl font-semibold text-[#0D47A1]">
        Đăng ký
      </h2>
      <form className=" mt-3">
        <div className=" flex flex-col gap-4">
          <input
            type="text"
            placeholder="Họ tên"
            className=" p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            type="text"
            placeholder="Email"
            className=" p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            type="datetime-local"
            placeholder="Ngày sinh"
            className=" p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            type="password"
            placeholder="Mật khẩu"
            className=" p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            type="password"
            placeholder="Xác nhận mật khẩu"
            className="p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 w-full"
          />
        </div>
        <div className=" mt-4 flex items-center gap-2">
          <input type="checkbox" /> Tôi đồng ý với các{" "}
          <Link to="" className=" text-blue-600 hover:underline">
            Điều khoản dịch vụ
          </Link>{" "}
          và{" "}
          <Link to="" className=" text-blue-600 hover:underline">
            Chính sách bảo mật
          </Link>
        </div>
        <button
          type="submit"
          className=" mt-6 w-full bg-blue-600 text-white py-3 rounded-lg hover:bg-blue-700 transition duration-300"
        >
          Đăng ký
        </button>
      </form>
    </div>
  );
}

export default register;
