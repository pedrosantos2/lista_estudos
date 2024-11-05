// Tela principal que exibe os tópicos de estudo
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_screen.dart';

class HomeScreen extends StatelessWidget {
  // Referência à coleção 'topicos' no Firestore
  final CollectionReference topicosRef = FirebaseFirestore.instance.collection('topicos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Estudos'), // Título da tela
      ),
      // Exibe os dados em tempo real com StreamBuilder
      body: StreamBuilder(
        stream: topicosRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator()); // Indicador de carregamento

          // ListView para exibir os tópicos
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var topico = snapshot.data!.docs[index];
              return ListTile(
                title: Text(topico['nome']), // Nome do tópico
                subtitle: Text(topico['descricao']), // Descrição do tópico
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red), // Botão para deletar o tópico
                  onPressed: () => topico.reference.delete(),
                ),
                onTap: () {
                  // Abre a tela de edição ao tocar no tópico
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditScreen(topicoId: topico.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      // Botão flutuante para adicionar um novo tópico
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}