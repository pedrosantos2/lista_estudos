// Tela para adicionar ou editar um tópico
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditScreen extends StatefulWidget {
  final String? topicoId;

  EditScreen({this.topicoId});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  String _nome = '';
  String _descricao = '';
  bool _isLoading = false;

  // Referência à coleção 'topicos' no Firestore
  final CollectionReference topicosRef = FirebaseFirestore.instance.collection('topicos');

  @override
  void initState() {
    super.initState();
    if (widget.topicoId != null) {
      _loadTopico(); // Carrega o tópico existente para edição
    }
  }

  // Carrega o tópico do Firestore para edição
  Future<void> _loadTopico() async {
    setState(() => _isLoading = true);
    var snapshot = await topicosRef.doc(widget.topicoId).get();
    var data = snapshot.data() as Map<String, dynamic>;
    _nome = data['nome'];
    _descricao = data['descricao'];
    setState(() => _isLoading = false);
  }

  // Salva o novo tópico ou atualiza um existente
  void _saveTopico() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.topicoId == null) {
        // Adiciona um novo tópico ao Firestore
        await topicosRef.add({'nome': _nome, 'descricao': _descricao});
      } else {
        // Atualiza o tópico existente
        await topicosRef.doc(widget.topicoId).update({'nome': _nome, 'descricao': _descricao});
      }
      Navigator.pop(context); // Retorna à tela anterior após salvar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicoId == null ? 'Adicionar Tópico' : 'Editar Tópico'), // Define o título conforme a ação
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Exibe o indicador de carregamento
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo de texto para o nome do tópico
                    TextFormField(
                      initialValue: _nome,
                      decoration: InputDecoration(labelText: 'Nome do Tópico'),
                      validator: (value) => value!.isEmpty ? 'Informe o nome do tópico' : null,
                      onSaved: (value) => _nome = value!,
                    ),
                    // Campo de texto para a descrição do tópico
                    TextFormField(
                      initialValue: _descricao,
                      decoration: InputDecoration(labelText: 'Descrição'),
                      validator: (value) => value!.isEmpty ? 'Informe a descrição' : null,
                      onSaved: (value) => _descricao = value!,
                    ),
                    SizedBox(height: 20),
                    // Botão para salvar o tópico
                    ElevatedButton(
                      onPressed: _saveTopico,
                      child: Text('Salvar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}