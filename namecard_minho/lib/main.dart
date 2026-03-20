import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Digital Name Card'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Container(
        // 배경 Container:
        // - 스케치처럼 카드 영역 바깥에 배경색을 깔아
        //   카드가 더 도드라져 보이게 해줍니다.
        color: const Color(0xFFF6F7FB),
        child: SafeArea(
          // SafeArea:
          // - 상태바/노치 영역을 피해 콘텐츠를 안전하게 배치합니다.
          child: Center(
            // Center:
            // - 자식 위젯을 가운데 정렬합니다.
            child: Padding(
              // Padding:
              // - 화면 가장자리와 카드 사이 간격을 확보합니다.
              padding: const EdgeInsets.all(16),
              child: const NameCardView(),
            ),
          ),
        ),
      ),
    );
  }
}

// =========================
// 내보낼 위젯(Export Widget)
// =========================

/// 스케치 기반 "디지털 명함" UI.
///
/// 요구사항 반영:
/// - `StatelessWidget`만 사용합니다.
/// - `Scaffold`, 배경 `Container`, 내부 `Card` 틀을 구성합니다.
/// - 상단 영역에 프로필 사진 + 이름/직책을 배치합니다.
class NameCardView extends StatelessWidget {
  const NameCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      // ConstrainedBox:
      // - 자식 위젯의 크기를 "제한"합니다.
      // - 예: 명함이 너무 커져도 보기 좋게 유지하기 위해 maxWidth를 줍니다.
      constraints: const BoxConstraints(
        maxWidth: 420,
      ),
      child: const _BusinessCardFrame(),
    );
  }
}

// =========================
// 하위 위젯(Private Widgets)
// =========================

class _BusinessCardFrame extends StatelessWidget {
  const _BusinessCardFrame();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      // Card:
      // - 둥근 테두리 + 그림자(elevation)를 쉽게 만들 수 있습니다.
      elevation: 6,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        // 명함 높이가 내용에 맞게 자연스럽게 늘어나도록 고정 비율 대신
        // 최소 높이만 주었습니다.
        constraints: const BoxConstraints(minHeight: 240),
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ProfileHeader(),
            const SizedBox(height: 18),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _ContactSection(
              textTheme: textTheme,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      // Row:
      // - 가로 레이아웃. 프로필 사진(왼쪽) + 텍스트(오른쪽) 구성에 적합합니다.
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _Avatar(
          imageAssetPath: _NameCardStatic.avatarAssetPath,
        ),
        const SizedBox(width: 14),
        Expanded(
          // Expanded:
          // - Row 안에서 남는 가로 공간을 텍스트가 차지하도록 합니다.
          // - 길이가 길어도 레이아웃이 깨지지 않게 도와줍니다.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _NameCardStatic.name,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _NameCardStatic.role,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.imageAssetPath});

  final String imageAssetPath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: ClipOval(
        // ClipOval:
        // - 직사각형 이미지를 타원(원) 형태로 "잘라" 보여줍니다.
        child: Image.asset(
          imageAssetPath,
          fit: BoxFit.cover,
          // Image.asset:
          // - 프로젝트에 포함된 로컬 이미지를 표시합니다.
          // - asset 경로가 잘못되어도 UI가 깨지지 않도록 errorBuilder를 둡니다.
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFFE9EEF7),
            alignment: Alignment.center,
            child: const Icon(
              Icons.person,
              size: 30,
              color: Color(0xFF5A6B85),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      // Column:
      // - 연락처 항목들을 세로로 나열합니다.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContactRow(
          icon: Icons.phone,
          text: _NameCardStatic.phone,
          textStyle: textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        _ContactRow(
          icon: Icons.email_outlined,
          text: _NameCardStatic.email,
          textStyle: textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        _ContactRow(
          icon: Icons.public,
          text: _NameCardStatic.website,
          textStyle: textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        _ContactRow(
          icon: Icons.location_on_outlined,
          text: _NameCardStatic.location,
          textStyle: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.text,
    required this.textStyle,
  });

  final IconData icon;
  final String text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      // Row:
      // - 아이콘(왼쪽) + 텍스트(오른쪽)를 한 줄에 배치합니다.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF4B5B76),
        ),
        const SizedBox(width: 10),
        Expanded(
          // Expanded:
          // - 긴 텍스트가 있어도 적절히 줄바꿈/공간 분배가 되도록 합니다.
          child: SelectableText(
            // SelectableText:
            // - 명함 정보(전화/이메일 등)를 사용자가 복사할 수 있게 합니다.
            text,
            style: textStyle?.copyWith(
              color: const Color(0xFF273042),
            ),
          ),
        ),
      ],
    );
  }
}

// =========================
// 정적 콘텐츠(Static Content)
// =========================

class _NameCardStatic {
  // 실제 앱에서는 서버/Supabase에서 내려받은 값으로 바꾸세요.
  static const String name = 'MINHO Park';
  static const String role = 'Professor';
  static const String phone = '010-1234-5678';
  static const String email = '2026110415@hycu.ac.kr';
  static const String website = 'www.hycu.ac.kr';
  static const String location = 'Seoul, Korea';

  // 프로젝트 assets에 넣어둔 실제 프로필 이미지 경로입니다.
  static const String avatarAssetPath = 'assets/images/profile_dog.png';
}

