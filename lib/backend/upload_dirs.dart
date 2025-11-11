
import 'dart:io';

Future<void> ensureUploadDirs() async {
  final dirGrupos = Directory('uploads/grupos');
  if (!await dirGrupos.exists()) {
    await dirGrupos.create(recursive: true);
  }

  final dirTecidos = Directory('uploads/tecidos');
  if (!await dirTecidos.exists()) {
    await dirTecidos.create(recursive: true);
  }
}
