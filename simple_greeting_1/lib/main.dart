import 'dart:developer' show log;

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
      title: 'Greeting App',
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
      home: const MyHomePage(title: 'Greeting App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // `Form` 위젯을 위한 키입니다.
  // - 이번 구현에서는 버튼에서 빈 문자열 체크로 유효성을 판단하므로,
  //   여기의 key는 폼 구조를 유지하기 위한 용도입니다(확장 여지).
  final _formKey = GlobalKey<FormState>();

  // 입력값을 제어하기 위한 컨트롤러입니다.
  // - "인사하기" 버튼을 눌렀을 때 값을 읽거나 초기화할 때 사용합니다.
  final _nameController = TextEditingController();

  // 텍스트 입력의 "현재 값"을 상태로 캐싱해두는 필드입니다.
  // - 매번 버튼을 누를 때마다 `nameController.text`를 읽어도 되지만,
  //   학습 목적으로 "리스너 -> setState"로 현재 값을 동기화하는 패턴을 보여줍니다.
  // - 이렇게 해두면 버튼 클릭 시 `_currentName`만 보면 됩니다.
  String _currentName = '';

  // 버튼 아래에 표시할 메시지(인사말 or 에러)를 관리합니다.
  // - 동일한 영역을 재사용하면서 내용만 바꿉니다.
  String _message = '안녕하세요';
  bool _isError = false;

  @override
  void initState() {
    super.initState();

    // TextEditingController에 리스너를 달아 입력이 변경될 때마다
    // `_currentName`을 최신 값으로 업데이트합니다.
    //
    // - listener 콜백은 "매 입력 변화"마다 호출됩니다.
    // - 값이 바뀌었을 때만 setState 하도록 비교를 넣어 불필요한 리빌드를 줄였습니다.
    _nameController.addListener(() {
      final nextValue = _nameController.text;
      if (nextValue == _currentName) return;
      setState(() {
        _currentName = nextValue;
      });
    });
  }

  // 버튼 클릭 시 실행되는 동작입니다.
  void _handleGreetPressed() {
    // 포커스를 해제해서 키보드를 내립니다(모바일 UX 개선).
    FocusManager.instance.primaryFocus?.unfocus();

    // 버튼이 눌릴 때 "현재 입력된 값"을 가져옵니다.
    // - 여기서는 controller를 기준으로 읽습니다(가장 직접적).
    // - trimmed로 앞/뒤 공백을 제거합니다.
    final name = _nameController.text.trim();

    // 가장 간단한 유효성 검사: 빈 문자열 체크
    if (name.isEmpty) {
      setState(() {
        _isError = true;
        _message = '이름을 입력해 주세요';
      });
      return;
    }

    // 입력값이 비어있지 않으면 인사말을 생성합니다.
    final greeting = '안녕하세요, ${name}님!';

    setState(() {
      _isError = false;
      _message = greeting;
    });
  }

  @override
  void dispose() {
    // TextEditingController는 메모리를 잡고 있으므로
    // State가 소멸될 때 반드시 해제해야 합니다.
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 스케치의 상단 제목(고정 텍스트)
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              // 입력 필드 + 버튼을 감싸는 폼 구조
              _GreetingFormCard(
                formKey: _formKey,
                nameController: _nameController,
                onGreetPressed: _handleGreetPressed,
                message: _message,
                isError: _isError,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreetingFormCard extends StatelessWidget {
  const _GreetingFormCard({
    required this.formKey,
    required this.nameController,
    required this.onGreetPressed,
    required this.message,
    required this.isError,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final VoidCallback onGreetPressed;
  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          // 폼은 입력 위젯들을 묶어서 구조를 잡기 위한 용도입니다.
          // (실제 유효성 판단은 버튼에서 빈 문자열 체크로 처리합니다.)
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 이름 입력 필드
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  // 요구사항: 플레이스 홀더(안내 문구)
                  hintText: '이름을 입력하세요',
                  border: OutlineInputBorder(),
                ),
                // 한글 입력은 대문자/소문자 개념이 없으므로 기본값 대신 명시적으로 끄는 편이 안전합니다.
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,

                // 키보드에서 Enter/Done을 눌렀을 때도 동일한 동작 수행
                onFieldSubmitted: (_) => onGreetPressed(),
              ),
              const SizedBox(height: 16),

              // "인사하기" 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onGreetPressed,
                  child: const Text('인사하기'),
                ),
              ),

              const SizedBox(height: 24),

              // 요구사항: 버튼 아래 영역은 "인사말 또는 에러 메시지"를
              // 입력 상태에 따라 동일한 위치에서 교체해서 표시합니다.
              SelectableText.rich(
                TextSpan(
                  text: message,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: isError ? Colors.red : null,
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
