import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const TestApplication());

class TestApplication extends StatelessWidget {
  const TestApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('비만도 계산기')),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '신장',
                ),
                controller: _heightController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value is String && value.trim().isEmpty) {
                    return '신장(cm)을 입력해 주시기 바랍니다.';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '체중',
                ),
                controller: _weightController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value is String && value.trim().isEmpty) {
                    return '체중(kg)을 입력해 주시기 바랍니다.';
                  }
                  return null;
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    print(_formKey.currentState!.validate());
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(
                            double.parse(_heightController.text.trim()),
                            double.parse(_weightController.text.trim()),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('결과'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final double height;
  final double weight;

  const ResultPage(this.height, this.weight, {super.key});

  @override
  Widget build(BuildContext context) {
    final double bmi = weight / ((height / 100) * (height / 100));

    return Scaffold(
      appBar: AppBar(title: const Text('비만도 계산기')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _getText(bmi),
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(
              height: 16,
            ),
            _getIcon(bmi),
          ],
        ),
      ),
    );
  }

  String _getText(double bmi) {
    String result = '저체중';

    if (bmi >= 35) {
      result = '고도 비만';
    } else if (bmi >= 30) {
      result = '2단계 비만';
    } else if (bmi >= 25) {
      result = '1단계 비만';
    } else if (bmi >= 23) {
      result = '과체중';
    } else if (bmi >= 18.5) {
      result = '정상';
    }

    return result;
  }

  Widget _getIcon(double bmi) {
    if (bmi >= 23) {
      return const Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.red,
        size: 100,
      );
    } else if (bmi >= 18.5) {
      return const Icon(
        Icons.sentiment_satisfied,
        color: Colors.green,
        size: 100,
      );
    } else {
      return const Icon(
        Icons.sentiment_dissatisfied,
        color: Colors.orange,
        size: 100,
      );
    }
  }
}
