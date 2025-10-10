
export default function Privacy() {
  return (
    <div className="min-h-screen bg-gray-50 text-gray-800">
      {/* Header */}
      <header className="bg-[#0D47A1] text-white p-6 text-center">
        <h1 className="text-3xl font-bold">Chính sách bảo mật</h1>
        <p className="text-sm mt-2 opacity-80">Cập nhật lần cuối: 26/09/2025</p>
      </header>

      {/* Intro Section */}
      <section className="bg-white shadow-md rounded-lg p-6 max-w-4xl mx-auto mt-6 text-center">
        {/* <ShieldCheck className="mx-auto mb-4 text-blue-600" size={50} /> */}
        <h2 className="text-2xl font-semibold mb-2">Cam kết bảo mật</h2>
        <p className="text-gray-600">
          Chúng tôi cam kết bảo vệ thông tin cá nhân và dữ liệu doanh nghiệp của
          bạn bằng những tiêu chuẩn bảo mật cao nhất.
        </p>
      </section>

      {/* Content Sections */}
      <main className="max-w-4xl mx-auto mt-10 space-y-10 px-6 leading-relaxed">
        {/* Thu thập thông tin */}
        <div className="bg-white p-6 rounded-lg shadow-md">
          <div className="flex items-center gap-3 mb-3">
            {/* <UserCheck className="text-blue-600" /> */}
            <h2 className="text-xl font-semibold">1. Thu thập thông tin</h2>
          </div>
          <p>
            Chúng tôi thu thập dữ liệu để phục vụ việc quản lý thuế và cải thiện
            dịch vụ. Thông tin bao gồm:
          </p>
          <ul className="list-disc pl-6 mt-2 text-gray-700">
            <li>Họ và tên, email, số điện thoại</li>
            <li>Thông tin doanh nghiệp: Tên công ty, mã số thuế</li>
            <li>Dữ liệu giao dịch và sử dụng hệ thống</li>
          </ul>
        </div>

        {/* Mục đích sử dụng */}
        <div className="bg-white p-6 rounded-lg shadow-md">
          <div className="flex items-center gap-3 mb-3">
            {/* <Mail className="text-blue-600" /> */}
            <h2 className="text-xl font-semibold">
              2. Mục đích sử dụng thông tin
            </h2>
          </div>
          <p>Chúng tôi sử dụng thông tin để:</p>
          <ul className="list-disc pl-6 mt-2 text-gray-700">
            <li>Cung cấp và duy trì hệ thống quản lý thuế</li>
            <li>Gửi thông báo và hỗ trợ khách hàng</li>
            <li>Nâng cao trải nghiệm người dùng</li>
          </ul>
        </div>

        {/* Bảo mật thông tin */}
        <div className="bg-white p-6 rounded-lg shadow-md">
          <div className="flex items-center gap-3 mb-3">
            {/* <Lock className="text-blue-600" /> */}
            <h2 className="text-xl font-semibold">3. Bảo mật thông tin</h2>
          </div>
          <p>
            Chúng tôi áp dụng công nghệ mã hóa tiên tiến, kiểm tra bảo mật định
            kỳ và phân quyền chặt chẽ để đảm bảo dữ liệu luôn an toàn.
          </p>
        </div>

        {/* Quyền và liên hệ */}
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h2 className="text-xl font-semibold mb-3">
            4. Quyền của người dùng
          </h2>
          <p>
            Bạn có quyền yêu cầu truy cập, chỉnh sửa hoặc xóa thông tin cá nhân
            bất kỳ lúc nào.
          </p>
          <p className="mt-3">
            Liên hệ qua email:{" "}
            <a
              href="mailto:support@taxmanager.vn"
              className="text-blue-600 underline"
            >
              support@taxmanager.vn
            </a>
          </p>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-gray-200 mt-10 p-4 text-center text-sm text-gray-600">
        © 2025 Tax Manager. Mọi quyền được bảo lưu.
      </footer>
    </div>
  );
}
