// codeunit 83870 "UT GAccount Helper TPTE"
// {
//     Permissions =
//         tabledata "G-Account GPZS" = RM,
//         tabledata "Posted G-Account GPZS" = RM;

//     procedure ClearGAccountSourceAccountNo()
//     var
//         GAccountGPZS: Record "G-Account GPZS";
//     begin
//         GAccountGPZS.ModifyAll("Source Account No.", '', false);
//     end;

//     procedure ClearPostedGAccountPercetage()
//     var
//         PostedGAccountGPZS: Record "Posted G-Account GPZS";
//     begin
//         PostedGAccountGPZS.ModifyAll(Percentage, 0, false);
//     end;
// }