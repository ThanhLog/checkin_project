import 'package:app_checkin/components/bottom/custom_icon_button.dart';
import 'package:app_checkin/contants/app_icon.dart';
import 'package:app_checkin/contants/router_path.dart';
import 'package:app_checkin/models/user_model.dart';
import 'package:app_checkin/provider/auth_provider.dart';
import 'package:app_checkin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.user});
  final UserModel user;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController cccdController;
  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController genderController;
  late TextEditingController regDateController;
  late TextEditingController emailController;
  late TextEditingController telController;
  late TextEditingController cityController;
  late TextEditingController districtController;
  late TextEditingController wardController;
  late TextEditingController streetController;

  String selectedGender = "Nam";

  @override
  void initState() {
    super.initState();
    cccdController = TextEditingController(
      text: widget.user.identification.idNumber,
    );
    nameController = TextEditingController(
      text: widget.user.personalInfo.fullName,
    );
    dobController = TextEditingController(
      text: widget.user.personalInfo.dateOfBirth,
    );
    genderController = TextEditingController(
      text: widget.user.personalInfo.gender,
    );
    cityController = TextEditingController(
      text: widget.user.personalInfo.address.city,
    );
    districtController = TextEditingController(
      text: widget.user.personalInfo.address.district,
    );
    wardController = TextEditingController(
      text: widget.user.personalInfo.address.ward,
    );
    streetController = TextEditingController(
      text: widget.user.personalInfo.address.street,
    );

    regDateController = TextEditingController(
      text: widget.user.identification.issueDate,
    );
    emailController = TextEditingController(
      text: widget.user.personalInfo.email,
    );
    telController = TextEditingController(text: widget.user.personalInfo.tel);

    if (widget.user.personalInfo.gender == "Nam" ||
        widget.user.personalInfo.gender == "Nữ") {
      selectedGender = widget.user.personalInfo.gender;
    } else {
      selectedGender = "Nam";
    }
  }

  @override
  void dispose() {
    cccdController.dispose();
    nameController.dispose();
    dobController.dispose();
    genderController.dispose();
    regDateController.dispose();
    emailController.dispose();
    telController.dispose();
    cityController = TextEditingController();
    districtController = TextEditingController();
    wardController = TextEditingController();
    streetController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Face Data: ${widget.user.faceData.toJson()}");
    print("Images: ${widget.user.images.length}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa hồ sơ"),
        actions: [
          CustomIconButton(
            icon: AppIcons.scan,
            onClick: () {
              Navigator.pushNamed(
                context,
                RoutePaths.scanCccd,
                arguments: widget.user,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _itemInfo("CCCD", cccdController, false),
            _itemInfo("Họ và Tên", nameController, true),
            _itemInfo(
              "Ngày sinh",
              dobController,
              true,
              keyboardType: TextInputType.datetime,
            ),

            /// Giới tính
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Giới tính",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Nam", child: Text("Nam")),
                      DropdownMenuItem(value: "Nữ", child: Text("Nữ")),
                      DropdownMenuItem(value: "Khác", child: Text("Khác")),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedGender = val;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            /// Địa chỉ
            _itemInfo("Thôn", wardController, true),
            _itemInfo("Phường/Xã", wardController, true),
            _itemInfo("Quận/Huyện", districtController, true),
            _itemInfo("Thành phố", cityController, true),

            /// Ngày đăng ký (readonly)
            _itemInfo("Ngày đăng ký", regDateController, false),

            /// Email (readonly)
            _itemInfo(
              "Email",
              emailController,
              false,
              note: "Liên hệ hỗ trợ để thay đổi email.",
            ),

            _itemInfo(
              "Số điện thoại",
              telController,
              true,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                // Lấy instance provider
                final userProvider = context.read<AuthProvider>();

                // Tạo bản copy của user với dữ liệu mới
                final updatedUser = UserModel(
                  personalInfo: PersonalInfo(
                    fullName: nameController.text,
                    dateOfBirth: dobController.text,
                    gender: selectedGender,
                    tel: telController.text,
                    address: Address(
                      street: streetController.text,
                      ward: wardController.text,
                      district: districtController.text,
                      city: cityController.text,
                    ),
                    email: widget.user.personalInfo.email,
                  ),
                  identification: Identification(
                    idNumber: cccdController.text,
                    issueDate: Utils.convertToIso8601(regDateController.text),
                  ),
                  id: widget.user.id,
                  userId: widget.user.userId,
                  faceData: widget.user.faceData,
                );

                print("User Update: ${updatedUser.toJson()}");
                await userProvider.updateUser(updatedUser);

                if (userProvider.errorMessage != null) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Lỗi: ${userProvider.errorMessage}"),
                    ),
                  );
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Cập nhật thành công!")),
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, RoutePaths.splashScreen);
                }
              },
              child: const Text("Lưu thay đổi"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemInfo(
    String title,
    TextEditingController controller,
    bool enabled, {
    String? note,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            enabled: enabled,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: !enabled,
              fillColor: enabled ? null : Colors.grey.shade200,
            ),
          ),
          if (note != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                note,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
