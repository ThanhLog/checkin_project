import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int index;
  final bool isHome;
  final List<Map<String, dynamic>> items;
  final Function(int index)? onClick;
  const CustomBottomNavigation({
    super.key,
    required this.index,
    required this.items,
    this.isHome = false,
    this.onClick,
  });
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.topCenter,
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              currentIndex: index,
              onTap: onClick,
              useLegacyColorScheme: false,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.black,
              selectedFontSize: 10,
              unselectedItemColor: Colors.grey,
              items: items.map((item) {
                return _buildBottomBarItem(
                  icon: item['icon'],
                  label: item['label'],
                  size: item['size'],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomBarItem({
    required String icon,
    required String label,
    required double size,
  }) {
    return BottomNavigationBarItem(
      icon: _buildContent(
        icon: icon,
        label: label,
        size: size,
        height: kBottomNavigationBarHeight,
        color: Colors.grey,
        fontWeight: FontWeight.w600,
      ),
      activeIcon: _buildContent(
        icon: icon,
        label: label,
        size: size,
        height: kBottomNavigationBarHeight,
        color: Colors.blue,
        fontWeight: FontWeight.w600,
      ),
      label: '',
    );
  }

  Widget _buildContent({
    required String icon,
    required String label,
    required double size,
    required double height,
    required Color color,
    required FontWeight fontWeight,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ignore: deprecated_member_use
          SvgPicture.asset(icon, color: color, height: size),
          SizedBox(height: 2),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
