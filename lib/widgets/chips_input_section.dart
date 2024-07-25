import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:Linguify/Constants/Constants.dart';

class ChipsInputSection extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final List<String> list;
  final List<String> idList;
  final List<Map<String, String>> suggestions;
  final Function(String, String) onSuggestionSelected;
  final Function() onAddChip;

  const ChipsInputSection({
    Key? key,
    required this.title,
    required this.controller,
    required this.list,
    required this.idList,
    required this.suggestions,
    required this.onSuggestionSelected,
    required this.onAddChip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TypeAheadFormField<Map<String, String>>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    hintText: title,
                    contentPadding: EdgeInsets.only(left: 20, top: 30),
                  ),
                  style: TextStyle(color: PRIMARY_COLOR),
                ),
                suggestionsCallback: (pattern) {
                  return suggestions.where((item) => item['hobby']!.toLowerCase().contains(pattern.toLowerCase()));
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion['hobby']!),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  onSuggestionSelected(suggestion['hobby']!, suggestion['id']!);
                  controller.clear();
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, color: FIFTH_COLOR),
              onPressed: onAddChip,
            ),
          ],
        ),
        SizedBox(height: 8),
        _buildChips(list, idList),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildChips(List<String> list, List<String> idList) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Wrap(
        spacing: 10,
        children: list.map((item) {
          return Chip(
            label: Text(item),
            deleteIcon: Icon(Icons.cancel, size: 25, color: FIFTH_COLOR),
            deleteIconColor: SECONDARY_COLOR,
            onDeleted: () {
              int index = list.indexOf(item);
              list.removeAt(index);
              idList.removeAt(index);
            },
            backgroundColor: SECONDARY_COLOR,
            padding: EdgeInsets.symmetric(horizontal: 1),
            labelStyle: TextStyle(color: PRIMARY_COLOR),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
              side: BorderSide(color: FIFTH_COLOR, width: 1),
            ),
          );
        }).toList(),
      ),
    );
  }
}
