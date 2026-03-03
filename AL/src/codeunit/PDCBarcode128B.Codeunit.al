// /// <summary>
// /// Codeunit Barcode 128B (ID 50014) handles procedure to create Code-128 barcode as picture.
// /// </summary>
// Codeunit 50014 "PDC Barcode 128B"
// {
//     // Based on:
//     //   http://en.wikipedia.org/wiki/Code_128
//     // Checksum calculation:
//     //   http://freebarcodefonts.dobsonsw.com/Code128Transformation.htm
//     // BMP writing based on:
//     //   http://en.wikipedia.org/wiki/BMP_file_format


//     trigger OnRun()
//     begin
//     end;

//     var
//         Binary: BigText;
//         Consts: array[108] of Text[30];
//         Barcode: Text[1024];
//         CharsNumerationTxt: label ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~', Locked = true;

//     /// <summary>
//     /// procedure CreateBarcode created barcode in Blob from text value.
//     /// </summary>
//     /// <param name="PictureDestination">Temporary VAR Record TempBlob.</param>
//     /// <param name="TextValue">Text[100].</param>
//     procedure CreateBarcode(var PictureDestination: Codeunit "Temp Blob"; TextValue: Text[100])
//     var
//         Bars: Integer;
//         Lines: Integer;
//         BarLoop: Integer;
//         LineLoop: Integer;
//         ChainFiller: Integer;
//         ByteText: Text[1];
//         CharInt: Char;
//         OutputStream: OutStream;
//     begin
//         InitConsts();

//         Barcode := TextValue;

//         CreateBinaryString();

//         //Bars quantity = length
//         Bars := Binary.Length;

//         //Height, use const, now using 20% of barcode width (Minimum 15%)
//         Lines := ROUND(Bars * 0.2, 1, '>');

//         PictureDestination.CreateOutStream(OutputStream);

//         //Writing header
//         CreateBMPHeader(OutputStream, Bars, Lines);

//         for LineLoop := 1 to Lines do begin
//             for BarLoop := 1 to Binary.Length do begin
//                 Binary.GetSubText(ByteText, BarLoop, 1);
//                 if ByteText = '1' then
//                     CharInt := 0
//                 else
//                     CharInt := 255;

//                 //Putting Pixel: Black or White
//                 OutputStream.Write(CharInt, 1);
//                 OutputStream.Write(CharInt, 1);
//                 OutputStream.Write(CharInt, 1);
//             end;
//             for ChainFiller := 1 to (Bars MOD 4) do begin
//                 //Adding 0 bytes if needed - line end
//                 CharInt := 0;
//                 OutputStream.Write(CharInt, 1);
//             end;
//         end;
//     end;

//     local procedure InitConsts()
//     begin
//         // Constants, read specs from wiki for more info
//         Consts[1] := '212222';
//         Consts[2] := '222122';
//         Consts[3] := '222221';
//         Consts[4] := '121223';
//         Consts[5] := '121322';
//         Consts[6] := '131222';
//         Consts[7] := '122213';
//         Consts[8] := '122312';
//         Consts[9] := '132212';
//         Consts[10] := '221213';
//         Consts[11] := '221312';
//         Consts[12] := '231212';
//         Consts[13] := '112232';
//         Consts[14] := '122132';
//         Consts[15] := '122231';
//         Consts[16] := '113222';
//         Consts[17] := '123122';
//         Consts[18] := '123221';
//         Consts[19] := '223211';
//         Consts[20] := '221132';
//         Consts[21] := '221231';
//         Consts[22] := '213212';
//         Consts[23] := '223112';
//         Consts[24] := '312131';
//         Consts[25] := '311222';
//         Consts[26] := '321122';
//         Consts[27] := '321221';
//         Consts[28] := '312212';
//         Consts[29] := '322112';
//         Consts[30] := '322211';
//         Consts[31] := '212123';
//         Consts[32] := '212321';
//         Consts[33] := '232121';
//         Consts[34] := '111323';
//         Consts[35] := '131123';
//         Consts[36] := '131321';
//         Consts[37] := '112313';
//         Consts[38] := '132113';
//         Consts[39] := '132311';
//         Consts[40] := '211313';
//         Consts[41] := '231113';
//         Consts[42] := '231311';
//         Consts[43] := '112133';
//         Consts[44] := '112331';
//         Consts[45] := '132131';
//         Consts[46] := '113123';
//         Consts[47] := '113321';
//         Consts[48] := '133121';
//         Consts[49] := '313121';
//         Consts[50] := '211331';
//         Consts[51] := '231131';
//         Consts[52] := '213113';
//         Consts[53] := '213311';
//         Consts[54] := '213131';
//         Consts[55] := '311123';
//         Consts[56] := '311321';
//         Consts[57] := '331121';
//         Consts[58] := '312113';
//         Consts[59] := '312311';
//         Consts[60] := '332111';
//         Consts[61] := '314111';
//         Consts[62] := '221411';
//         Consts[63] := '431111';
//         Consts[64] := '111224';
//         Consts[65] := '111422';
//         Consts[66] := '121124';
//         Consts[67] := '121421';
//         Consts[68] := '141122';
//         Consts[69] := '141221';
//         Consts[70] := '112214';
//         Consts[71] := '112412';
//         Consts[72] := '122114';
//         Consts[73] := '122411';
//         Consts[74] := '142112';
//         Consts[75] := '142211';
//         Consts[76] := '241211';
//         Consts[77] := '221114';
//         Consts[78] := '413111';
//         Consts[79] := '241112';
//         Consts[80] := '134111';
//         Consts[81] := '111242';
//         Consts[82] := '121142';
//         Consts[83] := '121241';
//         Consts[84] := '114212';
//         Consts[85] := '124112';
//         Consts[86] := '124211';
//         Consts[87] := '411212';
//         Consts[88] := '421112';
//         Consts[89] := '421211';
//         Consts[90] := '212141';
//         Consts[91] := '214121';
//         Consts[92] := '412121';
//         Consts[93] := '111143';
//         Consts[94] := '111341';
//         Consts[95] := '131141';
//         Consts[96] := '114113';
//         Consts[97] := '114311';
//         Consts[98] := '411113';
//         Consts[99] := '411311';
//         Consts[100] := '113141';
//         Consts[101] := '114131';
//         Consts[102] := '311141';
//         Consts[103] := '411131';
//         Consts[104] := '211412';
//         Consts[105] := '211214';
//         Consts[106] := '211232';
//         Consts[107] := '2331112';
//         Consts[108] := '211133';
//     end;

//     local procedure CreateBMPHeader(var OutputStream: OutStream; Cols: Integer; Rows: Integer)
//     var
//         CharInt: Char;
//     begin
//         //http://en.wikipedia.org/wiki/BMP_file_format - BMP header w/o any tricks
//         //Can be changed if needed
//         CharInt := 'B';
//         OutputStream.Write(CharInt, 1);
//         CharInt := 'M';
//         OutputStream.Write(CharInt, 1);
//         OutputStream.Write(54 + Rows * Cols * 3, 4);
//         OutputStream.Write(0, 4);
//         OutputStream.Write(54, 4);
//         OutputStream.Write(40, 4);
//         OutputStream.Write(Cols, 4);
//         OutputStream.Write(Rows, 4);
//         OutputStream.Write(65536 * 24 + 1, 4);
//         OutputStream.Write(0, 4);
//         OutputStream.Write(Rows * Cols * 3, 4);
//         OutputStream.Write(2835, 4);
//         OutputStream.Write(2835, 4);
//         OutputStream.Write(0, 4);
//         OutputStream.Write(0, 4);
//     end;

//     local procedure CreateBinaryString()
//     var
//         Counter: Integer;
//         Counter2: Integer;
//         ConstText: Text[10];
//         CharInt: Integer;
//         Bar: Boolean;
//         Times: Integer;
//         Counter3: Integer;
//         CheckSum: Integer;
//     begin
//         //Creating barstring 1/0 (Bar/Space)
//         //Barcode 128B Header
//         CheckSum := 104; //(For START B symbol);
//         Binary.AddText('11010010000');
//         for Counter := 1 to StrLen(Barcode) do begin
//             CharInt := StrPos(CharsNumerationTxt, Format(Barcode[Counter]));
//             if CharInt > 107 then
//                 CharInt := 108;
//             ConstText := Consts[CharInt];
//             Bar := true;
//             for Counter2 := 1 to StrLen(ConstText) do begin
//                 Evaluate(Times, Format(ConstText[Counter2]));
//                 for Counter3 := 1 to Times do
//                     if Bar = true then
//                         Binary.AddText('1')
//                     else
//                         Binary.AddText('0');
//                 Bar := not Bar;
//             end;
//             //Calculating Checksum
//             CheckSum := CheckSum + (CharInt - 1) * Counter; // -1 cz Array starts from 1
//         end;
//         //Writing Checksum
//         CheckSum := CheckSum MOD 103;
//         ConstText := Consts[CheckSum + 1];

//         for Counter2 := 1 to StrLen(ConstText) do begin
//             Evaluate(Times, Format(ConstText[Counter2]));
//             for Counter3 := 1 to Times do
//                 if Bar = true then
//                     Binary.AddText('1')
//                 else
//                     Binary.AddText('0');
//             Bar := not Bar;
//         end;

//         //Barcode128B End
//         Binary.AddText('1100011101011');
//     end;
// }

