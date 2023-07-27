import 'package:flutter/material.dart';

class ExampleAlarmTile extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final void Function()? onDismissed;

  const ExampleAlarmTile({
    Key? key,
    required this.title,
    required this.onPressed,
    this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      direction: onDismissed != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        child: const Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDismissed?.call(),
      child: RawMaterialButton(
        onPressed: onPressed,
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 4),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                new BoxShadow(color: Color(0xffF4FAFE),),
              ],
            ),
            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(image: AssetImage('assets/icon/alarm_.png'), color: Color(0xff0A1933), height: 30,width: 30,),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0A1933)
                  ),
                ),
                Image(image: AssetImage('assets/icon/enter.png'), color: Color(0xff0A1933), height: 20,width: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
