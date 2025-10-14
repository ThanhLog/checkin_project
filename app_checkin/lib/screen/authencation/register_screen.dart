import 'package:app_checkin/components/input/custom_input_field.dart';
import 'package:app_checkin/contants/app_icon.dart';
import 'package:app_checkin/contants/router_path.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      // Xử lý đăng nhập
      final name = nameController.text;
      final email = emailController.text;
      final tel = phoneController.text;

      if (name.isNotEmpty && email.isNotEmpty && tel.isNotEmpty) {
        Navigator.pushNamed(
          context,
          RoutePaths.faceRegistration,
          arguments: {'fullName': name, 'email': email, 'tel': tel},
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SvgPicture.asset(
                AppIcons.face,
                width: 100,
                height: 100,
                colorFilter: ColorFilter.mode(
                  const Color(0xFF1C274C),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Đăng ký",
                style: TextStyle(
                  color: const Color(0xFF1C274C),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 30),
              ListTile(
                title: Center(
                  child: Text(
                    "Tạo tài khoản mới",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Center(
                  child: Text(
                    "Nhập thông tin đăng ký",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 25),

              CustomInputField(
                label: "Họ tên",
                hint: "Nhập họ tên của bạn",
                inputType: CustomInputType.text,
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Họ tên không được để trống";
                  }
                  return null;
                },
              ),
              CustomInputField(
                label: "Số điện thoại",
                hint: "Nhập số điện thoại của bạn",
                inputType: CustomInputType.phone,
                controller: phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Số điện thoại không được để trống";
                  }
                  return null;
                },
              ),
              CustomInputField(
                label: "Email",
                hint: "Nhập email của bạn",
                inputType: CustomInputType.email,
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email không được để trống";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Email không hợp lệ";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C274C),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text(
                  "Đăng ký",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: "Bạn đã có tài khoản? ",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                  children: [
                    TextSpan(
                      text: "Đăng nhập",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      // Sự kiện khi nhấn vào "Đăng ký"
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, RoutePaths.login);
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
