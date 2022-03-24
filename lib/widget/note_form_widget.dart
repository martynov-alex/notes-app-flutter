import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({
    Key? key,
    this.isImportant = false,
    this.number = 0,
    this.title = '',
    this.description = '',
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      '⭐',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('🟩', style: TextStyle(fontSize: 25)),
                        Text('🟦‍', style: TextStyle(fontSize: 25)),
                        Text('🟧', style: TextStyle(fontSize: 25)),
                        Text('🟪', style: TextStyle(fontSize: 25)),
                        Text('🟥', style: TextStyle(fontSize: 25)),

                        // Text(
                        //   'Choose card color',
                        //   style: TextStyle(fontSize: 20, color: Colors.white),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Switch(
                      activeColor: Colors.yellow,
                      value: isImportant ?? false,
                      onChanged: onChangedImportant,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white,
                        thumbColor: thumbColor(number ?? 0),
                        trackShape: RectangularSliderTrackShape(),
                        trackHeight: 1,
                        valueIndicatorColor: Colors.white,
                        valueIndicatorTextStyle: TextStyle(color: Colors.black),
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 10,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 30,
                        ),
                      ),
                      child: Slider(
                        value: (number ?? 0).toDouble(),
                        min: 0,
                        max: 4,
                        divisions: 4,
                        label: 'Card color',
                        onChanged: (number) => onChangedNumber(number.toInt()),
                      ),
                    ),
                  )
                ],
              ),
              buildTitle(),
              SizedBox(height: 8),
              buildDescription(),
              SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 2,
        initialValue: title,
        style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        initialValue: description,
        style: TextStyle(color: Colors.white60, fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The description cannot be empty'
            : null,
        onChanged: onChangedDescription,
      );

  Color thumbColor(num number) {
    switch (number.toInt()) {
      case 0:
        return Colors.lightGreen.shade300;
      case 1:
        return Colors.lightBlue.shade300;
      case 2:
        return Colors.orange.shade300;
      case 3:
        return Colors.purpleAccent.shade100;
      case 4:
        return Colors.redAccent.shade100;
      default:
        return Colors.white;
    }
  }
}
