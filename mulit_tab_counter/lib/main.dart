import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// 앱 루트 위젯입니다.
/// `MultiTapCounterScreen`를 첫 화면으로 보여줍니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Tab Counter',
      debugShowCheckedModeBanner: false,
      home: const MultiTapCounterScreen(),
    );
  }
}

/// 요청하신 기본 화면입니다.
///
/// 왜 StatefulWidget을 사용하나요?
/// - 이 화면은 탭별 카운터 값(숫자)이 바뀌는 "상태(state)"를 가집니다.
/// - 다음 스텝에서 버튼 이벤트를 연결하면 숫자가 변경되고, UI를 다시 그려야 합니다.
/// - 이런 "변경 가능한 값 + 화면 재빌드"가 필요할 때 StatefulWidget이 적합합니다.
class MultiTapCounterScreen extends StatefulWidget {
  const MultiTapCounterScreen({super.key});

  @override
  State<MultiTapCounterScreen> createState() => _MultiTapCounterScreenState();
}

class _MultiTapCounterScreenState extends State<MultiTapCounterScreen> {
  /// Tab 1 카운터 상태값 (정수), 0으로 초기화
  int tab1Count = 0;

  /// Tab 2 카운터 상태값 (정수), 0으로 초기화
  int tab2Count = 0;

  /// Tab 3 카운터 상태값 (정수), 0으로 초기화
  int tab3Count = 0;

  /// 현재 선택된 탭 인덱스 (UI 표시용)
  /// 0: Tab 1, 1: Tab 2, 2: Tab 3
  int selectedTabIndex = 0;

  /// 현재 탭에 해당하는 카운터 값을 읽어오는 getter입니다.
  /// (다음 스텝에서 이벤트 로직을 붙이기 쉽게 분리해 둔 구조입니다.)
  int get currentCount {
    switch (selectedTabIndex) {
      case 0:
        return tab1Count;
      case 1:
        return tab2Count;
      case 2:
        return tab3Count;
      default:
        return 0;
    }
  }

  /// 탭을 선택하는 메서드입니다.
  ///
  /// [tabIndex]를 현재 선택 탭으로 바꾸고 `setState()`를 호출합니다.
  /// `setState()`를 호출해야 변경된 선택 상태가 화면(Tab 하이라이트, 숫자)에
  /// 즉시 반영됩니다.
  void selectTab(int tabIndex) {
    setState(() {
      selectedTabIndex = tabIndex;
    });
  }

  /// 현재 선택된 탭의 카운터를 1 증가시키는 메서드입니다.
  ///
  /// 각 탭은 서로 다른 상태 변수(tab1Count/tab2Count/tab3Count)를 사용하므로
  /// 값이 독립적으로 저장됩니다.
  void increaseCurrentTabCount() {
    setState(() {
      switch (selectedTabIndex) {
        case 0:
          tab1Count++;
          break;
        case 1:
          tab2Count++;
          break;
        case 2:
          tab3Count++;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black54,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Multi Tab Counter',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _TabButton(
                    title: 'Tab 1',
                    isSelected: selectedTabIndex == 0,
                    onPressed: () => selectTab(0),
                  ),
                  _TabButton(
                    title: 'Tab 2',
                    isSelected: selectedTabIndex == 1,
                    onPressed: () => selectTab(1),
                  ),
                  _TabButton(
                    title: 'Tab 3',
                    isSelected: selectedTabIndex == 2,
                    onPressed: () => selectTab(2),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Text(
                '$currentCount',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 220,
                height: 58,
                child: ElevatedButton(
                  // 현재 선택된 탭의 카운터만 1 증가시킵니다.
                  onPressed: increaseCurrentTabCount,
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Increase',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 탭 텍스트를 클릭 가능한 버튼 형태로 만든 작은 재사용 위젯입니다.
///
/// - [isSelected]가 true면 파란색으로 강조
/// - false면 기본 검은색 텍스트
class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onPressed,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.blue : Colors.black,
        ),
      ),
    );
  }
}
