import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../services/project_service.dart';
import 'add_project_screen.dart';
import 'project_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Project>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = ProjectService().fetchProjects();
  }

  void _refreshProjects() {
    setState(() {
      _projectsFuture = ProjectService().fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Proyectos'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Project>>(
        future: _projectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar datos'),
            );
          }

          final projects = snapshot.data ?? [];

          if (projects.isEmpty) {
            return const Center(
              child: Text('No hay proyectos registrados'),
            );
          }

          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: project.imageUrl != null
                      ? Image.network(
                          project.imageUrl!,
                          width: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.folder),
                  title: Text(project.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.description),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: project.progress / 100,
                      ),
                      Text('${project.progress}% completado'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProjectDetailScreen(project: project),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddProjectScreen(),
            ),
          );

          if (result == true) {
            _refreshProjects();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}