import 'package:flutter_test/flutter_test.dart';
import 'package:fschool_se1945/main.dart';

void main() {
  testWidgets('HomeScreen renders all menu items and header correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify Header
    expect(find.text('Sổ tay sinh viên'), findsOneWidget);
    expect(find.text('Đồng hành cùng bạn mỗi ngày'), findsOneWidget);
    expect(find.text('Xin chào, Minh Anh!'), findsOneWidget);
    expect(find.text('MA'), findsOneWidget);

    // Verify Section Title
    expect(find.text('Trang chủ'), findsOneWidget);

    // Verify Original Menu Items
    expect(find.text('Lịch học'), findsOneWidget);
    expect(find.text('Xem thời khóa biểu của bạn'), findsOneWidget);

    expect(find.text('Điểm học kỳ'), findsOneWidget);
    expect(find.text('Theo dõi kết quả học tập'), findsOneWidget);

    expect(find.text('Sự kiện'), findsOneWidget);
    expect(find.text('Khám phá hoạt động sinh viên'), findsOneWidget);

    expect(find.text('Đơn từ'), findsOneWidget);
    expect(find.text('Gửi và theo dõi đơn của bạn'), findsOneWidget);

    expect(find.text('Câu lạc bộ'), findsOneWidget);
    expect(find.text('Kết nối với cộng đồng sinh viên'), findsOneWidget);

    // Verify Requested Added Item: News (Tin tức)
    expect(find.text('Tin tức'), findsOneWidget);
    expect(find.text('Cập nhật tin tức & thông báo mới nhất'), findsOneWidget);

    // Verify Logout button
    expect(find.text('Đăng xuất'), findsOneWidget);
  });
}
