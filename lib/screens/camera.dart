import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class Http {
  static String url = "https://foto-k2eq.onrender.com/proyecto";
  static postProyectos(Map proyecto) async {
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {'content-Type': 'application/json'},
        body: json.encode(proyecto),
      );
      print('Estado de la respuesta: ${res.statusCode}');
      print('Cuerpo de la respuesta: ${res.body}');
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print('Error en la inserción: ${res.reasonPhrase}');
      }
    } catch (e) {
      print('Error de conexión: $e');
    }
  }
}

class RegistrarProyecto extends StatefulWidget {
  const RegistrarProyecto({super.key});

  @override
  State<RegistrarProyecto> createState() => _RegistrarProyectoState();
}

class _RegistrarProyectoState extends State<RegistrarProyecto> {
  Uint8List? fotoBytes;
  final _formKey = GlobalKey<FormState>();

  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      try {
        final bytes = await pickedFile.readAsBytes();

        final image = img.decodeImage(bytes);
        if (image == null) {
          throw Exception('Error en la imagen');
        }

        final resizedImage = img.copyResize(image, width: 300);

        final compressedBytes = img.encodeJpg(resizedImage, quality: 85);

        setState(() {
          fotoBytes = Uint8List.fromList(compressedBytes);
        });
      } catch (e) {
        print('Error al procesar la imagen: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tomar foto',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        backgroundColor: const Color.fromARGB(255, 68, 255, 224),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _tomarFoto,
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Tomar Foto'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 68, 255, 224),
                  ),
                ),
              ),
              // Visualización de la foto seleccionada
              if (fotoBytes != null)
                Image.memory(
                  fotoBytes!,
                  height: 500,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
