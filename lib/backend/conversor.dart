import 'dart:io';

Future<String?> _detectPythonExecutable() async {
  final candidates = ['python', 'python3', 'py'];
  for (final cmd in candidates) {
    try {
      final r = await Process.run(cmd, ['--version'], runInShell: true);
      if (r.exitCode == 0) {
        return cmd;
      }
    } catch (_) {
    }
  }
  return null;
}

Future<ProcessResult> runPythonConversor({
  String? pythonExecutable,
  required String scriptPath,
  required String inputPath,
  required String outputDir,
  List<String>? extraArgs,
}) async {
  final exe = pythonExecutable ?? await _detectPythonExecutable();
  if (exe == null) {
    throw Exception('Nenhum executável Python encontrado. Instale Python no sistema ou forneça pythonExecutable.');
  }

  final args = [scriptPath, inputPath, outputDir];
  if (extraArgs != null && extraArgs.isNotEmpty) args.addAll(extraArgs);

  print('Executando conversor: $exe ${args.join(' ')}');

  try {
    final result = await Process.run(exe, args, runInShell: true);
    print('[Conversor] STDOUT:\n${result.stdout}');
    print('[Conversor] STDERR:\n${result.stderr}');
    return result;
  } catch (e) {
    print('FALHA ao executar conversor: $e');
    rethrow;
  }
}