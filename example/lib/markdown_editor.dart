import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart'; // To access prefs

class MarkdownEditor extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const MarkdownEditor({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  List<String> _files = [];
  String? _selectedFile;

  bool _hasOverride = false;
  String _originalContent = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadManifest();
    });
  }

  Future<void> _loadManifest() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final files =
        manifest
            .listAssets()
            .where((k) => k.startsWith('assets/mds/') && k.endsWith('.md'))
            .map((k) => k.split('/').last)
            .toList()
          ..sort();

    final lastOpened = prefs.getString('md_last_opened');
    final selected = (lastOpened != null && files.contains(lastOpened))
        ? lastOpened
        : files.first;

    setState(() {
      _files = files;
      _selectedFile = selected;
    });
    await _loadFile(selected);
  }

  Future<void> _loadFile(String filename) async {
    await prefs.setString('md_last_opened', filename);
    try {
      _originalContent = await rootBundle.loadString('assets/mds/$filename');
    } catch (e) {
      _originalContent = 'Error loading file: $e';
    }

    final prefsKey = 'md_content_$filename';
    final saved = prefs.getString(prefsKey);

    setState(() {
      if (saved != null && saved != _originalContent) {
        widget.controller.text = saved;
        _hasOverride = true;
      } else {
        widget.controller.text = _originalContent;
        _hasOverride = false;
      }
    });
    widget.onChanged();
  }

  Future<void> _resetFile(String filename) async {
    final prefsKey = 'md_content_$filename';
    await prefs.remove(prefsKey);
    setState(() {
      widget.controller.text = _originalContent;
      _hasOverride = false;
    });
    widget.onChanged();
  }

  void _onTextChanged(String text) {
    final prefsKey = 'md_content_$_selectedFile';
    if (text != _originalContent) {
      prefs.setString(prefsKey, text);
      if (!_hasOverride) setState(() => _hasOverride = true);
    } else {
      prefs.remove(prefsKey);
      if (_hasOverride) setState(() => _hasOverride = false);
    }
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedFile == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Row(
            children: [
              const Text('File: '),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedFile,
                  items: _files
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedFile = val);
                      _loadFile(val);
                    }
                  },
                ),
              ),
              if (_hasOverride) ...[
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Reset to original',
                  child: IconButton(
                    onPressed: () => _resetFile(_selectedFile!),
                    icon: const Icon(Icons.refresh),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: TextField(
            controller: widget.controller,
            autofocus: true,
            maxLines: null,
            expands: true,
            style: const TextStyle(fontFamily: 'monospace'),
            onChanged: _onTextChanged,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(12),
              hintText: 'Type markdown here...',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
