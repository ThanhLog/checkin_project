import "./../../index.css";
import { Link } from "react-router-dom";

function login() {
  return (
    <div className=" mx-auto mt-10 p-8">
      <h2 className="text-center text-3xl font-semibold text-[#0D47A1]">
        Đăng nhập
      </h2>
      <form className=" mt-8">
        <div className=" flex flex-col gap-4">
          <input
            type="text"
            placeholder="Tên đăng nhập"
            className=" p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            type="password"
            placeholder="Mật khẩu"
            className=" p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>
        <div className=" mt-4 flex justify-end">
          <Link to="" className=" text-blue-600 hover:underline">
            Quên mật khẩu?
          </Link>
        </div>
        <button
          type="submit"
          className=" mt-6 w-full bg-blue-600 text-white py-3 rounded-lg hover:bg-blue-700 transition duration-300"
        >
          Đăng nhập
        </button>

      </form>
    </div>
  );
}

export default login;
