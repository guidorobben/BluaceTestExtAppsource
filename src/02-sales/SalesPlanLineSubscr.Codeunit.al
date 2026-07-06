// codeunit 83901 "Sales Plan. Line Subscr. TPTE"
// {

//     [EventSubscriber(ObjectType::Table, database::"Sales Plan. Line CBLC", 'OnAfterModifyEvent', '', false, false)]
//     local procedure MyProcedure(var Rec: Record "Sales Plan. Line CBLC"; var xRec: Record "Sales Plan. Line CBLC")
//     var
//         ObjectNo: Code[20];
//     begin
//         objectno := rec."Object No.";
//     end;


//     [EventSubscriber(ObjectType::Table, database::"Sales Plan. Line CBLC", 'OnBeforeValidateEvent', 'Object No.', false, false)]
//     local procedure MyProcedure2(var Rec: Record "Sales Plan. Line CBLC"; var xRec: Record "Sales Plan. Line CBLC")
//     var
//         ObjectNo: Code[20];
//     begin
//         objectno := rec."Object No.";
//     end;


// }