import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Tabungan extends StatefulWidget {
  const Tabungan({super.key});

  @override
  State<Tabungan> createState() => _TabunganState();
}

class _TabunganState extends State<Tabungan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Tabungan'),
    );
  }
}
