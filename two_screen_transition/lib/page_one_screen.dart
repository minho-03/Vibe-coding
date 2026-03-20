import 'package:flutter/material.dart';

import 'page_two_screen.dart';

/// 스케치 이미지 기준 "Page one" 첫 번째 화면입니다.
///
/// 목표(스케치와 최대한 동일하게):
/// - 화면 중앙에 "카드" 형태(바깥 테두리 2~3px)로 배치
/// - 상단 제목 `Page one` (가운데 정렬, 굵은 폰트)
/// - 제목 아래 청록색 구분선(두께 포함)
/// - Item A~D는 각각 클릭 가능한 래퍼(`InkWell`)로 구성
/// - 아이템 사이에도 청록색 구분선이 들어감
class PageOneScreen extends StatelessWidget {
  const PageOneScreen({super.key});

  static const List<String> itemLabels = <String>[
    'Item A',
    'Item B',
    'Item C',
    'Item D',
  ];

  @override
  Widget build(BuildContext context) {
    // 스케치처럼 "카드"가 화면 전체를 꽉 채우지 않게 고정 느낌을 줍니다.
    // (너비는 화면에 따라 조금 유동적으로 clamp 합니다.)
    final cardWidth = MediaQuery.sizeOf(context).width.clamp(300.0, 420.0);
    final cardHeight = 480.0;

    // 스케치의 바깥 테두리(거의 검정색) / 내부 구분선(청록색)을 분리합니다.
    const outerBorderColor = Color(0xFF111111);
    final dividerColor = Colors.teal.shade700;

    return Scaffold(
      // 스케치 배경은 사실상 흰색에 가까워서 white로 고정합니다.
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
            child: Column(
              children: [
                // 제목 영역. 스케치처럼 위 여백을 조금 둡니다.
                const SizedBox(height: 34.0),
                Text(
                  'Page one',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    height: 1.0,
                  ),
                ),

                const SizedBox(height: 18.0),

                // 제목 아래 구분선.
                // 스케치에서 구분선이 카드 테두리 끝까지 꽉 차지 않아서
                // 좌우 패딩을 줍니다(아이템 텍스트와 정렬을 맞추기 위함).
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Divider(
                    height: 0.0,
                    thickness: 3.0,
                    color: dividerColor,
                  ),
                ),

                // 아이템 목록.
                Expanded(
                  child: Padding(
                    // divider + row 콘텐츠 폭을 동일하게 맞추기 위해
                    // 리스트 영역 전체에 좌우 패딩을 적용합니다.
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemLabels.length,
                      separatorBuilder: (context, index) {
                        // 스케치처럼 아이템 사이에도 동일한 두께의 선을 그립니다.
                        return Divider(
                          height: 0.0,
                          thickness: 3.0,
                          color: dividerColor,
                        );
                      },
                      itemBuilder: (context, index) {
                        final label = itemLabels[index];
                        return _ClickableItemRow(
                          title: label,
                          accentColor: dividerColor,
                          onTap: () {
                            // 표준(간단) 방식: 라우트 이동 + 생성자 인자 전달.
                            // - 클릭된 문자열(label)을 PageTwoScreen(itemName: label)로 전달합니다.
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PageTwoScreen(
                                  itemName: label,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                // 마지막 아이템 아래 선(스케치에서 Item D 아래에도 선이 보입니다).
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Divider(
                    height: 0.0,
                    thickness: 3.0,
                    color: dividerColor,
                  ),
                ),

                // 아래 여백(테두리와의 간격) 느낌을 맞춥니다.
                const SizedBox(height: 18.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 스케치의 각 "Item X" 행을 담당하는 작은 위젯입니다.
///
/// - `InkWell`로 구성해서 나중에 클릭 동작을 쉽게 붙일 수 있습니다.
/// - 스케치처럼 오른쪽에 `>` 아이콘이 보입니다.
class _ClickableItemRow extends StatelessWidget {
  final String title;
  final Color accentColor;
  final VoidCallback onTap;

  const _ClickableItemRow({
    required this.title,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // 스케치의 아이템 높이감에 맞추기 위해 고정 height를 줍니다.
      height: 58.0,
      child: InkWell(
        onTap: onTap,
        // 스케치처럼 배경색 변화가 크게 없도록 설정합니다.
        splashFactory: InkRipple.splashFactory,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 왼쪽 텍스트
            Text(
              title,
              style: const TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                height: 1.0,
              ),
            ),

            // 오른쪽 Chevron(> 형태)
            Icon(
              Icons.chevron_right,
              size: 28.0,
              color: accentColor,
            ),
          ],
        ),
      ),
    );
  }
}

