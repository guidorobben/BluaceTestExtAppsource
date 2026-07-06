// tableextension 83901 "Object Setup TPTE" extends "Object Setup CBLC"
// {
//     fields
//     {
//         field(83900; "Property 83900 Code"; Code[20])
//         {
//             Caption = 'Property 9';
//             DataClassification = CustomerContent;
//             ToolTip = 'Specifies the value of the Property 83900 field.';
//             trigger OnValidate()
//             begin
//                 ValidatePropertyCode("Property 83900 Code");
//                 CalcFields("Property 83900 Description");
//             end;

//             trigger OnLookup()
//             begin
//                 LookupPropertyCode("Property 83900 Code");
//             end;
//         }
//         field(83910; "Property 83900 Description"; Text[100])
//         {
//             CalcFormula = lookup("Property BBLC".Description where(Code = field("Property 83900 Code")));
//             Caption = 'Property 83900 Description';
//             Editable = false;
//             FieldClass = FlowField;
//             ToolTip = 'Specifies the value of the Property 83900 Description field.';
//         }
//         field(83920; "Property 83920 Code"; Code[20])
//         {
//             Caption = 'Property 83920';
//             DataClassification = CustomerContent;
//             ToolTip = 'Specifies the value of the Property 9 field.';
//             trigger OnValidate()
//             begin
//                 ValidatePropertyCode("Property 83920 Code");
//                 CalcFields("Property 83920 Description");
//             end;

//             trigger OnLookup()
//             begin
//                 LookupPropertyCode("Property 83920 Code");
//             end;
//         }
//         field(83930; "Property 83920 Description"; Text[100])
//         {
//             CalcFormula = lookup("Property BBLC".Description where(Code = field("Property 83920 Code")));
//             Caption = 'Property 83920 Description';
//             Editable = false;
//             FieldClass = FlowField;
//             ToolTip = 'Specifies the value of the Property 83920 Description field.';
//         }
//     }
// }
