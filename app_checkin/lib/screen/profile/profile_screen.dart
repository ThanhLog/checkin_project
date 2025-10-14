import 'package:app_checkin/components/dialog/app_dialod.dart';
import 'package:app_checkin/contants/app_icon.dart';
import 'package:app_checkin/contants/router_path.dart';
import 'package:app_checkin/models/user_model.dart';
import 'package:app_checkin/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                if (authProvider.errorMessage != null)
                  Center(child: Text("Lỗi: ${authProvider.errorMessage}"))
                else if (authProvider.isLoading)
                  Center(child: CircularProgressIndicator())
                else
                  _itemProfile(context, authProvider.userData!),
                SizedBox(height: 20),
                Text(
                  "Cài đặt ứng dụng",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                SizedBox(height: 10),
                _itemSettings(
                  title: 'Thông báo',
                  icon: AppIcons.notification,
                  context: context,
                ),
                _itemSettings(
                  title: 'Trợ giúp & hỗ trợ',
                  icon: AppIcons.question,
                  context: context,
                ),
              ],
            ),

            _itemSettings(
              title: 'Đăng xuất',
              icon: AppIcons.logout,
              color: Colors.red,
              context: context,
              onTap: () {
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Xác nhận đăng xuất'),
                    content: const Text(
                      'Bạn có chắc chắn muốn đăng xuất không?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Hủy'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pushNamed(context, RoutePaths.splashScreen);
                          await authProvider.logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Đăng xuất',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemProfile(BuildContext context, UserModel userInfo) {
    print("UserInfo: ${userInfo.toJson()}");
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 0)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFBFDBFE),
              ),
              padding: EdgeInsets.all(8),
              child: SvgPicture.asset(
                AppIcons.user,
                colorFilter: ColorFilter.mode(
                  Color(0xFF2563EB),
                  BlendMode.srcIn,
                ),
                width: 40,
                height: 40,
              ),
            ),
          ),
          SizedBox(height: 16),
          // User ID
          Text(
            'User ID: ${userInfo.userId}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          // Name
          Text(
            userInfo.personalInfo.fullName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          // Email
          Text(
            userInfo.personalInfo.email,
            style: TextStyle(fontSize: 16, color: Color(0xFF1E3A8A)),
          ),
          SizedBox(height: 20),
          // Edit Profile Button
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RoutePaths.editProfile,
                arguments: userInfo,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Color(0xFF1D4ED8)),
                borderRadius: BorderRadius.circular(100),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Chỉnh sửa hồ sơ',
                style: TextStyle(
                  color: Color(0xFF1D4ED8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemSettings({
    required String title,
    required String icon,
    Color? color,
    VoidCallback? onTap,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: color == null ? EdgeInsets.zero : null,
        leading: SvgPicture.asset(
          icon,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            color == null ? Colors.black : Colors.white,
            BlendMode.srcIn,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: color == null ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap:
            onTap ??
            () {
              AppDialog.showChildWidgetBottomSheet(
                context: context,
                child: Text('Chức năng "$title" đang được phát triển'),
              );
            },
      ),
    );
  }
}
