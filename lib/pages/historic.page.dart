import 'package:flutter/material.dart';

class HistoricPage extends StatelessWidget {
  const HistoricPage({super.key, required this.historic});
  final List<String> historic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        backgroundColor: const Color.fromARGB(255, 243, 239, 242),
      ),
      body: Center(
        child: historic.isEmpty
            ? Text(
                textAlign: TextAlign.center,
                "Nenhum cálculo realizado",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'serif',
                  height: 25,
                ),
              )
            : ListView.builder(
                itemCount: historic.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(child: Text("${index + 1}")),
                      title: Text(
                        historic[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
