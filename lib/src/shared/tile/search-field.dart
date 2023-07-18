import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final Function() onTap;
  final Function(String)? onChange;
  final String searchInput;
  final TextEditingController controller;
  final double width;
  const SearchField(
      {super.key,
      required this.onTap,
      required this.searchInput,
      required this.controller,
      required this.width,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: TextFormField(
          controller: controller,
          onChanged: onChange,
          decoration: InputDecoration(
              filled: true,
              hintText: 'Search',
              fillColor: Theme.of(context).cardColor,
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 0, color: Theme.of(context).cardColor)),
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 0, color: Theme.of(context).cardColor)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 0, color: Theme.of(context).cardColor)),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchInput.isEmpty
                  ? null
                  : GestureDetector(
                      onTap: onTap,
                      child: const Icon(Icons.clear),
                    )),
        ),
      ),
    );
  }
}
