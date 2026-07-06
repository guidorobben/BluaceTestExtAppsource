// pageextension 83902 "Posted G-Accounts TPTE" extends "Posted G-Accounts GPZS"
// {
//     layout
//     {
//         addbefore("Transaction Mode Code")
//         {
//             field("Source Subtype TPTE CBLC"; Rec."Source Type")
//             {
//                 ApplicationArea = All;
//             }
//             field("Source No. TPTE CBLC"; Rec."Source No.")
//             {
//                 ApplicationArea = All;
//             }
//         }
//     }
// }