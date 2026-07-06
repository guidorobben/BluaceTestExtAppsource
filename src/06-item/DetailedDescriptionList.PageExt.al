// pageextension 83921 "Detailed Description List TPTE" extends "Detailed Description List DBLC"
// {
//     actions
//     {
//         addlast(Processing)
//         {
//             group(TextExtTPE)
//             {
//                 Caption = 'Text Ext.';

//                 action(ShowTextTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Show Text (Text Ext.)';

//                     trigger OnAction()
//                     var
//                         ContentText: Text;
//                     begin
//                         ContentText := Rec.GetContent(Rec."Link-to Table ID", Rec."Link-to Sytem ID", Rec."Language Code");
//                         Message(ContentText);
//                     end;
//                 }
//                 action(ShowFullTextTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Show Full Text (Text Ext.)';

//                     trigger OnAction()
//                     var
//                         LibraryExtDocumentsLIB: Codeunit "Library - Ext. Documents LIB";
//                     // ContentText: Text;
//                     begin
//                         Message(LibraryExtDocumentsLIB.GetFullContent(Rec));
//                     end;
//                 }
//             }
//         }
//     }
// }
