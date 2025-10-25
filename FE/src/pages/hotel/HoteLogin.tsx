import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { hotelLogin } from "../../api/hotelBookingApi";

export function HotelLogin() {
  const navigate = useNavigate();
  const [id, setId] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setIsLoading(true);
    setMessage("");

    try {
      const hotelData = await hotelLogin(id, password);

      localStorage.setItem("hotelData", JSON.stringify(hotelData));
      localStorage.setItem("hotel_id", hotelData.id);

      setMessage(`Đăng nhập thành công! Chào mừng ${hotelData.name}`);
      navigate("/checkin/hotel");
    } catch (err: any) {
      setMessage(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-900 flex items-center justify-center p-4 font-sans">
      <div className="w-full max-w-md bg-white/10 backdrop-blur-md p-8 rounded-xl shadow-2xl border border-gray-700">
        <h2 className="text-3xl font-extrabold text-white text-center mb-8 flex items-center justify-center">
          Đăng Nhập Khách Sạn
        </h2>

        <form onSubmit={handleSubmit} className="space-y-6">
          {/* ID Input */}
          <div>
            <label
              htmlFor="id"
              className="block text-sm font-medium text-gray-300 mb-1"
            >
              ID Đăng Nhập
            </label>
            <input
              id="id"
              name="id"
              type="text"
              required
              value={id}
              onChange={(e) => setId(e.target.value)}
              className="appearance-none block w-full px-4 py-3 border border-gray-600 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 bg-gray-700 text-white transition duration-150 ease-in-out"
              placeholder="Nhập ID khách sạn"
            />
          </div>

          {/* Password Input */}
          <div>
            <label
              htmlFor="password"
              className="block text-sm font-medium text-gray-300 mb-1"
            >
              Mật khẩu
            </label>
            <input
              id="password"
              name="password"
              type="password"
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="appearance-none block w-full px-4 py-3 border border-gray-600 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 bg-gray-700 text-white transition duration-150 ease-in-out"
              placeholder="Nhập Mật khẩu"
            />
          </div>

          {/* Status Message */}
          {message && (
            <div
              className={`p-3 rounded-lg text-sm text-center font-medium ${
                message.includes("thành công")
                  ? "bg-green-500/20 text-green-300"
                  : "bg-red-500/20 text-red-300"
              }`}
            >
              {message}
            </div>
          )}

          {/* Submit Button */}
          <div>
            <button
              type="submit"
              disabled={isLoading}
              className={`w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-lg text-lg font-bold text-white transition duration-300 ease-in-out transform hover:scale-[1.01] ${
                isLoading
                  ? "bg-indigo-600/70 cursor-not-allowed"
                  : "bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 focus:ring-offset-gray-900"
              }`}
            >
              {isLoading ? (
                <svg
                  className="animate-spin -ml-1 mr-3 h-5 w-5 text-white"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <circle
                    className="opacity-25"
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="currentColor"
                    strokeWidth="4"
                  ></circle>
                  <path
                    className="opacity-75"
                    fill="currentColor"
                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                  ></path>
                </svg>
              ) : (
                "Đăng Nhập"
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
