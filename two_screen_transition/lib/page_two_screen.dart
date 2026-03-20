import 'package:flutter/material.dart';

/// 두 번째 화면(상세 정보) 기본 구조입니다.
///
/// TODO(다음 단계):
/// - `itemName`이 라우트 파라미터/arguments/Provider 등으로
///   주입되도록 연결할 수 있습니다.
///
/// 현재는 "UI 골격"만 제공하므로, `itemName`은 생성자로
/// 기본값을 받아 표시합니다.
class PageTwoScreen extends StatelessWidget {
  const PageTwoScreen({
    super.key,
    this.itemName = _defaultItemName,
  });

  /// 첫 화면(`PageOneScreen`)에서 전달받는 아이템 이름입니다.
  ///
  /// 이 값은 "표준적인 방식"으로 `Navigator.push` 시에
  /// `PageTwoScreen(itemName: label)`처럼 위젯의 생성자 인자로 전달됩니다.
  /// 따라서 이 화면에서는 별도 route parsing 없이 바로 `itemName`을
  /// 렌더링하면 됩니다.
  final String itemName;

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.sizeOf(context).width.clamp(300.0, 420.0);
    final cardHeight = 560.0;

    const outerBorderColor = Color(0xFF111111);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: outerBorderColor,
                width: 3.0,
              ),
            ),
            child: _PageTwoBody(
              itemName: itemName,
              onBackPressed: () {
                // TODO: 라우팅 구조가 정해지면 더 구체적으로 조정하세요.
                Navigator.of(context).maybePop();
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// PageTwo의 내부 레이아웃만 담당하는 위젯입니다.
class _PageTwoBody extends StatelessWidget {
  const _PageTwoBody({
    required this.itemName,
    required this.onBackPressed,
  });

  final String itemName;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 화면 상단: "back" 버튼
        Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
            right: 18.0,
            top: 16.0,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: onBackPressed,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: _BackLabel(),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10.0),

        // 가운데 큰 제목: "Page two"
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'Page two',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 42.0,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              height: 1.0,
            ),
          ),
        ),

        const SizedBox(height: 34.0),

        // 본문: "Item A" 크게
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Text(
            itemName,
            // 전달받은 문자열을 그대로 화면 중앙의 큰 타이틀로 렌더링합니다.
            // (다음 단계에서 item 상세 설명/이미지 등도 이 값을 기반으로 확장합니다.)
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ),

        const SizedBox(height: 18.0),

        // 본문 설명(현재는 샘플 고정 텍스트)
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.0),
          child: _DescriptionText(),
        ),
      ],
    );
  }
}

/// `< back` 라벨을 스케치 톤에 맞춰 표현합니다.
class _BackLabel extends StatelessWidget {
  const _BackLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '<',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 1.0,
          ),
        ),
        const SizedBox(width: 6.0),
        const Text(
          'back',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

/// 화면 중간 아래 샘플 설명 문구입니다.
/// (다음 단계에서 item 상세 설명을 함께 받게 되면
///  이 부분도 유동 데이터로 바꿀 수 있습니다.)
class _DescriptionText extends StatelessWidget {
  const _DescriptionText();

  @override
  Widget build(BuildContext context) {
    return Text(
      _defaultDescription,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.35,
      ),
    );
  }
}

// 정적 콘텐츠(고정 샘플).
const String _defaultItemName = 'Item A';

const String _defaultDescription =
    '우리는 현재, 두 화면을\n구성하고 연결하는\n앱을 만들고 있습니다.';

