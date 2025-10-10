import "./../../index.css";
import { Link, useNavigate } from "react-router-dom";
import { useState } from "react";
import { loginUser } from "../../services/authService";

function Login() {
  const navigate = useNavigate();
  const [form, setForm] = useState({ email: "", password: "" });
  const [error, setError] = useState("");

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setError("");

    const result = await loginUser(form.email, form.password);
    if (result.success) {
      console.log("✅ Đăng nhập thành công:", result.user);
      navigate("/"); // hoặc navigate("/dashboard")
    } else {
      setError("❌ Sai email hoặc mật khẩu");
    }
  };

  return (
    <div className=" mx-auto mt-10 p-8">
      <h2 className="text-center text-3xl font-semibold text-[#0D47A1]">
        Đăng nhập
      </h2>
      <form onSubmit={handleSubmit} className=" mt-8">
        <div className=" flex flex-col gap-4">
          <input
            type="email"
            name="email"
            placeholder="Email"
            value={form.email}
            onChange={handleChange}
            className=" p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            type="password"
            name="password"
            placeholder="Mật khẩu"
            value={form.password}
            onChange={handleChange}
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

export default Login;
