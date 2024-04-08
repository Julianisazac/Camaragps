// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:camaragps/screens/camera.dart';
import 'package:camaragps/screens/map.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart'; // Importa la clase CameraDescription

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<void> _cameraInitialization;
  CameraDescription? _firstCamera;

  @override
  void initState() {
    super.initState();
    _cameraInitialization = _initializeFirstCamera();
  }

  Future<void> _initializeFirstCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        _firstCamera = cameras.first;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cámara no disponible'),
          content: const Text(
              'No se encontraron cámaras disponibles.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menú',
          style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
        ),
        backgroundColor: const Color.fromARGB(255, 68, 255, 224),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<void>(
          future: _cameraInitialization,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                _firstCamera != null) {
              return ListView(
                children: [
                  ListTile(
                    title: const Text('GPS'),
                    leading: const Icon(
                      Icons.zoom_in_map,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      final route = MaterialPageRoute(
                        builder: (context) => const MapaScreen(),
                      );
                      Navigator.push(context, route);
                    },
                  ),
                  ListTile(
                    title: const Text('FOTO'),
                    leading: const Icon(
                      Icons.add_a_photo,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      final route = MaterialPageRoute(
                        builder: (context) => const RegistrarProyecto(),
                      );
                      Navigator.push(context, route);
                    },
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
