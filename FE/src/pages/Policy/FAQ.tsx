export default function FAQ() {
  const faqs = [
    {
      question: "Làm sao để đăng ký tài khoản?",
      answer: "Bạn có thể đăng ký trực tiếp bằng email hoặc tài khoản Google.",
    },
    {
      question: "Dữ liệu của tôi có an toàn không?",
      answer:
        "Chúng tôi mã hóa dữ liệu và tuân thủ các tiêu chuẩn bảo mật cao nhất.",
    },
    {
      question: "Làm thế nào để liên hệ hỗ trợ?",
      answer:
        "Bạn có thể sử dụng trang Liên hệ hoặc gửi email đến support@smetax.com.",
    },
  ];

  return (
    <div className="min-h-screen bg-gray-50 text-gray-800">
      <header className="bg-[#0D47A1] text-white p-6 text-center text-2xl font-bold">
        Câu hỏi thường gặp
      </header>
      <main className="max-w-3xl mx-auto p-6 space-y-6">
        {faqs.map((faq, index) => (
          <div key={index} className="bg-white p-4 rounded-lg shadow">
            <h3 className="font-semibold text-lg">{faq.question}</h3>
            <p className="mt-2 text-gray-600">{faq.answer}</p>
          </div>
        ))}
      </main>
    </div>
  );
}
