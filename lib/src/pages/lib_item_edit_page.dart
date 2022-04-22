import 'package:anitrak/src/models/library_item.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/models/media_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';

class LibItemEditPage extends StatefulWidget {
  const LibItemEditPage({Key? key, required this.libraryItem})
      : super(key: key);

  final LibraryItem libraryItem;

  @override
  _LibItemEditPageState createState() => _LibItemEditPageState();
}

class _LibItemEditPageState extends State<LibItemEditPage> {
  final _formKey = GlobalKey<FormState>();

  late int _rating = widget.libraryItem.mediaEntry.score;
  late MediaEntryStatus _status = widget.libraryItem.mediaEntry.entryStatus;

  final TextEditingController _progressTextController = TextEditingController();
  final TextEditingController _repeatTextController = TextEditingController();
  final FocusNode _progressFocusNode = FocusNode();
  final FocusNode _repeatFocusNode = FocusNode();

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final progress = int.parse(_progressTextController.text);
      final repeat = int.parse(_repeatTextController.text);
      final updatedEntry = widget.libraryItem.mediaEntry.copyWith(
        progress: progress,
        repeat: repeat,
        score: _rating,
        status: _status.index,
        synced: false,
        updatedAt: DateTime.now(),
      );
      Navigator.pop(context, updatedEntry);
    }
  }

  List<MediaEntryStatus> getStatusList() {
    switch (widget.libraryItem.media.mediaStatus) {
      case MediaStatus.tba:
        return [MediaEntryStatus.planned];
      case MediaStatus.current:
        List<MediaEntryStatus> res =
            MediaEntryStatus.values.toList(growable: true);
        res.remove(MediaEntryStatus.completed);
        return res;
      case MediaStatus.finished:
        return MediaEntryStatus.values;
    }
  }

  @override
  void initState() {
    _progressTextController.text =
        widget.libraryItem.mediaEntry.progress.toString();
    _repeatTextController.text =
        widget.libraryItem.mediaEntry.repeat.toString();
    _progressFocusNode.addListener(() {
      if (_progressFocusNode.hasFocus) {
        _progressTextController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _progressTextController.text.length,
        );
      }
    });

    _repeatFocusNode.addListener(() {
      if (_repeatFocusNode.hasFocus) {
        _repeatTextController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _repeatTextController.text.length,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _progressTextController.dispose();
    _repeatTextController.dispose();
    _progressFocusNode.dispose();
    _repeatFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _handleSubmit,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Save"),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.libraryItem.media.title,
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: TextFormField(
                    enabled:
                        widget.libraryItem.media.mediaStatus != MediaStatus.tba,
                    controller: _progressTextController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    focusNode: _progressFocusNode,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: const Text('Progress'),
                        suffixText:
                            'of  ${widget.libraryItem.media.total} Episodes'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a number";
                      }
                      final val = int.parse(value);
                      if (widget.libraryItem.media.total > 0 &&
                          val > widget.libraryItem.media.total) {
                        return "Please enter a number between 0 and ${widget.libraryItem.media.total}";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: DropdownButtonFormField(
                    value: _status,
                    onChanged: (MediaEntryStatus? value) {
                      setState(() {
                        _status = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Status'),
                    ),
                    items: getStatusList()
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(e.displayTitle),
                            value: e,
                          ),
                        )
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Rating',
                      style: Theme.of(context).textTheme.caption?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                NumberPicker(
                  minValue: 0,
                  maxValue: 10,
                  value: _rating,
                  axis: Axis.horizontal,
                  zeroPad: true,
                  itemHeight: 100,
                  selectedTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: TextFormField(
                    controller: _repeatTextController,
                    keyboardType: TextInputType.number,
                    focusNode: _repeatFocusNode,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Repeat'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a number";
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () async {
                    final res = await showDialog<bool>(
                      context: context,
                      builder: (context) => _getAlertDialog(),
                    );
                    if (res != null && res) {
                      Navigator.pop(context, res);
                    }
                  },
                  icon: const Icon(Icons.delete_forever),
                  label: const Text("Delete"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getAlertDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text('Delete'),
      content: const Text('Are you sure you want to delete this entry?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
