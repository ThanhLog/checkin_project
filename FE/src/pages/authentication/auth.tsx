import { useState } from "react";
import AppImages from "../../contanst/app_images";
import "./../../index.css";
import Login from "./login";
import Register from "./register";

function auth() {
  const [isLogin, setIsLogin] = useState(true);

  const toggleAuthMode = () => {
    setIsLogin(!isLogin);
  };

  return (
    <div className="h-screen w-full flex">
      <div className=" flex-1 justify-center items-center flex flex-col">
        <h2 className=" text-3xl font-semibold text-[#0D47A1]">
          {isLogin ? "Đăng nhập vào hệ thống" : "Đăng ký vào hệ thống"}
        </h2>
        <img src={AppImages.bgAuth} alt="Auth" />
      </div>

      {/* Form Authentication */}
      <div className=" flex-1 shadow-2xl p-2 rounded-bl-3xl rounded-br-3xl">
        {isLogin ? <Login /> : <Register />}
        <p className="text-center mt-4">
          {isLogin ? "Bạn chưa có tài khoản?" : "Bạn đã có tài khoản?"}{" "}
          <button
            onClick={toggleAuthMode}
            className="text-blue-600 hover:underline"
          >
            {isLogin ? "Đăng ký" : "Đăng nhập"}
          </button>
        </p>
      </div>
    </div>
  );
}
export default auth;
