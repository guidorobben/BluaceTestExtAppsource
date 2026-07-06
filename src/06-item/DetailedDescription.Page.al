// page 83915 "Detailed Description TPTE"
// {
//     ApplicationArea = All;
//     Caption = 'Detailed Description TPTE';
//     PageType = List;
//     SourceTable = "Detailed Description DBLC";
//     UsageCategory = Lists;

//     layout
//     {
//         area(content)
//         {
//             repeater(General)
//             {
//                 field("Link-to Table ID"; Rec."Link-to Table ID")
//                 {
//                     ToolTip = 'Specifies the value of the Link-to Table ID field.';
//                 }
//                 field("Link-to Sytem ID"; Rec."Link-to Sytem ID")
//                 {
//                     ToolTip = 'Specifies the value of the Link-to Sytem ID field.';
//                 }
//                 field(Description; Rec.Description)
//                 {
//                     ToolTip = 'Specifies the description of detailed description.';
//                 }
//                 // field("Detailed Description"; Rec."Detailed Description")
//                 // {
//                 //     ToolTip = 'Specifies the value of the Detailed Description field.';
//                 // }
//                 field("Language Code"; Rec."Language Code")
//                 {
//                     ToolTip = 'Specifies the language code of the detailed description.';
//                 }
//                 field("Source Table ID"; Rec."Source Table ID")
//                 {
//                     ToolTip = 'Specifies the value of the Source Table ID field.';
//                 }
//                 field("Source System ID"; Rec."Source System ID")
//                 {
//                     ToolTip = 'Specifies the value of the Source System ID field.';
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
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
//                         // ContentText: Text;
//                         LibraryExtDocumentsLIB: Codeunit "Library - Ext. Documents LIB";
//                     begin
//                         Message(LibraryExtDocumentsLIB.GetFullContent(Rec));
//                     end;
//                 }
//             }
//         }
//     }
// }