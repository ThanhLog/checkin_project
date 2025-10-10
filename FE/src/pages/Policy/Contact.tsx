export default function Contact() {
  return (
    <div className="min-h-screen bg-gray-50 text-gray-800">
      <header className="bg-[#0D47A1] text-white p-6 text-center text-2xl font-bold">
        Liên hệ với chúng tôi
      </header>
      <main className="max-w-3xl mx-auto p-6 space-y-6">
        <p>
          Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ với chúng tôi qua biểu
          mẫu dưới đây hoặc qua email: <strong>support@smetax.com</strong>.
        </p>
        <form className="space-y-4 bg-white p-6 rounded-lg shadow">
          <input
            type="text"
            placeholder="Họ và tên"
            className="w-full border p-3 rounded focus:outline-none focus:ring-2 focus:ring-[#0D47A1]"
          />
          <input
            type="email"
            placeholder="Email"
            className="w-full border p-3 rounded focus:outline-none focus:ring-2 focus:ring-[#0D47A1]"
          />
          <textarea
            placeholder="Nội dung"
            className="w-full border p-3 rounded h-32 focus:outline-none focus:ring-2 focus:ring-[#0D47A1]"
          ></textarea>
          <button className="px-6 py-3 bg-[#0D47A1] text-white rounded-lg hover:bg-blue-900 transition">
            Gửi liên hệ
          </button>
        </form>
      </main>
    </div>
  );
}
