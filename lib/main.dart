import 'package:flutter/material.dart';
import 'password_generator.dart';
import 'password_database.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gerador de Senhas',
      home: PasswordHome(),
    );
  }
}

class PasswordHome extends StatefulWidget {
  const PasswordHome({super.key});

  @override
  State<PasswordHome> createState() => _PasswordHomeState();
}

class _PasswordHomeState extends State<PasswordHome> {
  int letters = 4, numbers = 2, specials = 2;
  List<String> savedPasswords = [];

  Future<void> generateAndSave() async {
    final password = PasswordGenerator.generate(
      letters: letters,
      numbers: numbers,
      special: specials,
    );
    await PasswordDatabase.insertPassword(password);
    loadPasswords();
  }

  Future<void> loadPasswords() async {
    final list = await PasswordDatabase.getPasswords();
    setState(() {
      savedPasswords = list;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPasswords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerador de Senhas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SliderInput(
              label: "Letras: $letters",
              value: letters.toDouble(),
              onChanged: (v) => setState(() => letters = v.toInt()),
            ),
            SliderInput(
              label: "Números: $numbers",
              value: numbers.toDouble(),
              onChanged: (v) => setState(() => numbers = v.toInt()),
            ),
            SliderInput(
              label: "Especiais: $specials",
              value: specials.toDouble(),
              onChanged: (v) => setState(() => specials = v.toInt()),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: generateAndSave,
              child: const Text("Gerar Senha"),
            ),
            const SizedBox(height: 20),
            const Text("Senhas Geradas:"),
            Expanded(
              child: savedPasswords.isEmpty
                  ? const Center(child: Text("Nenhuma senha gerada ainda"))
                  : ListView.builder(
                      itemCount: savedPasswords.length,
                      itemBuilder: (_, i) => ListTile(
                        title: Text(
                          savedPasswords[i],
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: savedPasswords[i]));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Senha copiada!')),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class SliderInput extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const SliderInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value,
          min: 0,
          max: 16,
          divisions: 16,
          label: value.round().toString(),
          onChanged: onChanged,
        )
      ],
    );
  }
}