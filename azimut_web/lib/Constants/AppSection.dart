import 'package:flutter/material.dart';

enum AppSection {
  home('Главная', Icons.grid_view_rounded, 'Найдите свой путь в образование'),
  universities('Вузы', Icons.account_balance_outlined, 'Университеты и программы высшего образования'),
  colleges('Колледжи', Icons.school_outlined, 'Варианты поступления после 9-го и 11-го класса'),
  calculator('Калькулятор баллов', Icons.calculate_outlined, 'Ваши результаты экзаменов и средний балл аттестата'),
  matching('Подбор по результатам', Icons.tune_rounded, 'Программы с учётом ваших баллов и предпочтений'),
  favorites('Избранное', Icons.favorite_border_rounded, 'Программы, к которым хочется вернуться'),
  comparison('Сравнение программ', Icons.compare_arrows_rounded, 'Баллы, стоимость, места и условия обучения'),
  admissions('Моё поступление', Icons.checklist_rounded, 'Ваш список программ, сроки и этапы поступления');

  const AppSection(this.title, this.icon, this.description);
  final String title;
  final IconData icon;
  final String description;
}


