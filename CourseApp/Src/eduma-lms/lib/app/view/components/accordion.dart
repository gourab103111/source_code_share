import 'package:flutter/material.dart';
import 'package:flutter_app/app/backend/models/lesson-model.dart';

class Accordion extends StatefulWidget {
  final List<LessonModel> data;
  const Accordion({super.key, required this.data});

  @override
  State<Accordion> createState() => _Accordion(data: data);
}

class _Accordion extends State<Accordion> {
  final List<LessonModel> data;
  _Accordion({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          data[index].isExpanded = !isExpanded;
        });
      },
      children: data.map<ExpansionPanel>((LessonModel item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.title!);
          },
          body: Wrap(
              direction: Axis.vertical,
              children: List.generate(
                item.items!.length,
                (index) => Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  // margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                  // padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: GestureDetector(
                      onTap: () => {},
                      child: Text(item.items![index].title!,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ))),
                ),
              )),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
