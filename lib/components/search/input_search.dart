import 'package:flutter/material.dart';

class InputSearch extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const InputSearch({
    @required this.controller,
    this.label,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(50);

    final isSearching = this.controller.text.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
      ),
      child: TextFormField(
        controller: this.controller,
        autocorrect: false,
        style: TextStyle(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              size: 18,
            ),
            onPressed: isSearching ? () => this.controller.text = "" : null,
          ),
          hintText: this.label ?? "pesquise...",
          hintStyle: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
