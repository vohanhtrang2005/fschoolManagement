import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';
import '../vn.edu.fpt.service/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  // Mục đang được chọn/active (mặc định là 'lich_hoc' để trùng với ảnh mẫu)
  String _activeId = 'lich_hoc';

  final List<Map<String, dynamic>> _menuItems = [
    {
      'id': 'lich_hoc',
      'title': 'Lịch học',
      'subtitle': 'Xem thời khóa biểu của bạn',
      'icon': Icons.calendar_month_outlined,
    },
    {
      'id': 'diem_hoc_ky',
      'title': 'Điểm học kỳ',
      'subtitle': 'Theo dõi kết quả học tập',
      'icon': Icons.bar_chart_rounded,
    },
    {
      'id': 'su_kien',
      'title': 'Sự kiện',
      'subtitle': 'Khám phá hoạt động sinh viên',
      'icon': Icons.event_available_outlined,
    },
    {
      'id': 'don_tu',
      'title': 'Đơn từ',
      'subtitle': 'Gửi và theo dõi đơn của bạn',
      'icon': Icons.description_outlined,
    },
    {
      'id': 'cau_lac_bo',
      'title': 'Câu lạc bộ',
      'subtitle': 'Kết nối với cộng đồng sinh viên',
      'icon': Icons.people_outline_rounded,
    },
    // Mục Tin tức mới được thêm theo yêu cầu của bạn
    {
      'id': 'tin_tuc',
      'title': 'Tin tức',
      'subtitle': 'Cập nhật tin tức & thông báo mới nhất',
      'icon': Icons.newspaper_outlined,
    },
  ];

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Xác nhận đăng xuất',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi tài khoản không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF225FEA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                _authService.logout().whenComplete(() {
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                });
              },
              child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Đảm bảo icon trên thanh trạng thái (status bar) màu sáng (trắng)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== 1. HEADER XANH =====
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1647C9),
                    Color(0xFF2260E6),
                    Color(0xFF286BF0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      // Tiêu đề: Sổ tay sinh viên
                      const Text(
                        'Sổ tay sinh viên',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      // Dòng phụ đề
                      Text(
                        'Đồng hành cùng bạn mỗi ngày',
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.white.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      // Thẻ thông tin sinh viên (Avatar + Lời chào)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Biểu tượng mũ cử nhân 3D
                          Icon(
                            Icons.school_rounded,
                            size: 46,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                          const SizedBox(width: 14),
                          // Chữ chào mừng
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Xin chào, Minh Anh!',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Chúc bạn một ngày học tập tốt.',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: Colors.white.withValues(alpha: 0.82),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Avatar tròn chữ "MA"
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'MA',
                              style: TextStyle(
                                color: Color(0xFF1E4FB8),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ===== 2. NỘI DUNG CHÍNH (TRANG CHỦ) =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  // Tiêu đề mục: Trang chủ
                  const Text(
                    'Trang chủ',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Danh sách các thẻ chức năng
                  ..._menuItems.map((item) {
                    final isHighlighted = item['id'] == _activeId;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildMenuCard(
                        id: item['id'] as String,
                        title: item['title'] as String,
                        subtitle: item['subtitle'] as String,
                        icon: item['icon'] as IconData,
                        isHighlighted: isHighlighted,
                      ),
                    );
                  }),

                  const SizedBox(height: 8),

                  // ===== 3. NÚT ĐĂNG XUẤT =====
                  InkWell(
                    onTap: _handleLogout,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1.2,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            size: 20,
                            color: Color(0xFF374151),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Đăng xuất',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget dựng từng thẻ chức năng
  Widget _buildMenuCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isHighlighted,
  }) {
    final cardColor = isHighlighted ? const Color(0xFF225FEA) : const Color(0xFFF6F7F9);
    final titleColor = isHighlighted ? Colors.white : const Color(0xFF1F2937);
    final subtitleColor = isHighlighted ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF6B7280);
    final iconColor = isHighlighted ? Colors.white : const Color(0xFF225FEA);
    final arrowColor = isHighlighted ? Colors.white : const Color(0xFF9CA3AF);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: const Color(0xFF225FEA).withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _activeId = id;
            });
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã chọn: $title'),
                duration: const Duration(seconds: 1),
                backgroundColor: const Color(0xFF225FEA),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                // Icon bên trái
                Icon(
                  icon,
                  size: 28,
                  color: iconColor,
                ),
                const SizedBox(width: 16),
                // Cụm chữ (Tiêu đề + Phụ đề)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Icon mũi tên bên phải
                Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
                  color: arrowColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
