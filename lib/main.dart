import 'package:flutter/material.dart';
import 'package:planetas/controles/controle_planeta.dart';
import 'package:planetas/modelos/planeta.dart';
import 'telas/tela_planeta.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planetas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Planetas',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Planeta> _planetas = [];

  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  @override
  void initState() {
    super.initState();
    _atualizarPlanetas();
  }

  Future<void> _atualizarPlanetas() async {
    final resultado = await _controlePlaneta.lerPlaneta();
    setState(() {
      _planetas = resultado;
    });
  }

  void _incluirPlaneta(BuildContext content) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TelaPlaneta(
                  isIncluir: true,
                  planeta: Planeta.vazio(),
                  onFinalizado: () {
                    _atualizarPlanetas();
                  },
                )));
  }

  void _excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    _atualizarPlanetas();
  }

  void _alterarPlaneta(BuildContext content, Planeta planeta) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TelaPlaneta(
                  isIncluir: false,
                  planeta: planeta,
                  onFinalizado: () {
                    _atualizarPlanetas();
                  },
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _planetas.length,
        itemBuilder: (context, index) {
          final planeta = _planetas[index];
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.deepPurpleAccent,
                  width: 2), // Define a cor e a largura da borda
              borderRadius: BorderRadius.circular(
                  8), // Adiciona cantos arredondados à borda
            ),
            margin: EdgeInsets.all(8), // Define a margem entre os itens
            child: ListTile(
                title: Text(planeta.nome),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tamanho: ${planeta.tamanho} km'),
                    Text('Distância: ${planeta.distancia} km'),
                    Text('Apelido: ${planeta.apelido!}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _alterarPlaneta(context, planeta),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _excluirPlaneta(planeta.id!),
                    ),
                  ],
                )),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incluirPlaneta(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
