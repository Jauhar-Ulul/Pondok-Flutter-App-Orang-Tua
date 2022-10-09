import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Akademik extends StatefulWidget {
  const Akademik({super.key});

  @override
  State<Akademik> createState() => _AkademikState();
}

class _AkademikState extends State<Akademik> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Akademik'),
    );
  }
}
