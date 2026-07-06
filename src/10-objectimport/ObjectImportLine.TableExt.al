// tableextension 83900 "Object Import Line TPTE" extends "Object Import Line CBLC"
// {
//     fields
//     {
//         field(83900; "Property 83900"; Text[2048])
//         {
//             Caption = 'Property 83900';
//             CaptionClass = GetPropertyCaption(FieldNo("Property 83900"));
//             DataClassification = CustomerContent;
//             ToolTip = 'Specifies the value of the Property 83900 field.';
//             trigger OnValidate()
//             begin
//                 ValidateObjectPropertyValue(FieldNo("Property 83900"), "Property 83900");
//             end;

//             trigger OnLookup()
//             begin
//                 LookupObjectPropertyValue(FieldNo("Property 83900"), "Property 83900");
//             end;

//         }
//         field(83920; "Property 83920"; Text[2048])
//         {
//             Caption = 'Property 83920';
//             CaptionClass = GetPropertyCaption(FieldNo("Property 83920"));
//             DataClassification = CustomerContent;
//             ToolTip = 'Specifies the value of the Property 83920 field.';
//             trigger OnValidate()
//             begin
//                 ValidateObjectPropertyValue(FieldNo("Property 83920"), "Property 83920");
//             end;

//             trigger OnLookup()
//             begin
//                 LookupObjectPropertyValue(FieldNo("Property 83920"), "Property 83920");
//             end;
//         }
//     }
// }