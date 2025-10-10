import { useState } from "react";
import "./../../index.css";
import { Link, useNavigate } from "react-router-dom";
import { registerUser } from "../../services/authService";

function Register() {
  const [form, setForm] = useState({
    name: "",
    email: "",
    birthDate: "",
    password: "",
    confirmPassword: "",
  });

  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setError("");

    if (form.password !== form.confirmPassword) {
      setError("Mật khẩu xác nhận không khớp!");
      return;
    }

    const result = await registerUser(
      form.name,
      form.email,
      form.password,
      form.birthDate
    );

    if (result.success) {
      alert("Đăng ký thành công!");
      navigate("/authencation");
    } else {
      setError(result.error);
    }
  };

  return (
    <div className=" mx-auto p-4">
      <h2 className="text-center text-3xl font-semibold text-[#0D47A1]">
        Đăng ký
      </h2>
      <form className=" mt-3" onSubmit={handleSubmit}>
        <div className=" flex flex-col gap-4">
          <input
            type="text"
            name="name"
            placeholder="Họ tên"
            value={form.name}
            onChange={handleChange}
            required
            className=" p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            type="text"
            placeholder="Email"
            name="email"
            onChange={handleChange}
            required
            className=" p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            type="datetime-local"
            name="birthDate"
            placeholder="Ngày sinh"
            value={form.birthDate}
            onChange={handleChange}
            required
            className=" p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            type="password"
            name="password"
            placeholder="Mật khẩu"
            value={form.password}
            onChange={handleChange}
            required
            className=" p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            type="password"
            name="confirmPassword"
            placeholder="Xác nhận mật khẩu"
            value={form.confirmPassword}
            onChange={handleChange}
            required
            className="p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 w-full"
          />
        </div>
        <div className=" mt-4 flex items-center gap-2">
          <input type="checkbox" required /> Tôi đồng ý với các{" "}
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

export default Register;
