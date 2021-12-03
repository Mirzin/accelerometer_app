import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

void createExcel(List xaxis, List yaxis, List zaxis,List time, String id) async {
    id = id.replaceAll(':', ".");
    final Workbook workbook = Workbook();
    final Worksheet sheetx = workbook.worksheets[0];
    final Worksheet sheety = workbook.worksheets[0];
    final Worksheet sheetz = workbook.worksheets[0];
    final Worksheet sheett = workbook.worksheets[0];
    sheetx.getRangeByName('A1').setText("Xaxis");
    sheety.getRangeByName('B1').setText("Yaxis");
    sheetz.getRangeByName('C1').setText("Zaxis");
    sheett.getRangeByName('D1').setText("Time");
    sheetx.importList(xaxis, 2, 1, true);
    sheety.importList(yaxis, 2, 2, true);
    sheetz.importList(zaxis, 2, 3, true);
    sheett.importList(time, 2, 4, true);
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    const path = '/storage/emulated/0/Download';
    File file = File('$path/$id.xlsx');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$id.xlsx');
  }