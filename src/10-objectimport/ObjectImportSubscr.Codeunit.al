// //TODO Voorbeeld codeunit voor extensie om in te haken op import
// codeunit 83918 "Object Import Subscr. TPTE"
// {
//     Permissions =
//         tabledata Customer = R,
//         tabledata "Object Import Line CBLC" = R,
//         tabledata "Object Setup CBLC" = R,
//         tabledata "Object CBLC" = R;

//     //TEST TBV TM-NL
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Check Object Import Meth. CBLC", OnBeforeValidateAddress, '', true, true)]
//     local procedure OnBeforeValidateAddress(var ObjectImportLineCBLC: Record "Object Import Line CBLC")
//     begin
//         exit;
//         // if ObjectImportLineCBLC.Address = '' then begin
//         //     ObjectImportLineCBLC.Address := 'Event straat 15';
//         // end;
//     end;

//     // //TEST
//     // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Check Object Import Meth. CBLC", OnBeforeCustomValidateContractImportLine, '', true, true)]
//     // local procedure OnBeforeCustomValidateContractImportLine(var ObjectImportLine: Record "Object Import Line CBLC"; var TempErrorLog: Record "Error Log CBLC" temporary)
//     // begin

//     //     if ObjectImportLine."Line No." = 30000 then
//     //         TempErrorLog.AddError(ObjectImportLine.SystemId, 'Error From extension 1');
//     // end;

//     //TEST
//     // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Check Object Import Meth. CBLC", OnBeforeCustomValidateObjectImportLine, '', true, true)]
//     // local procedure OnBeforeCustomValidateContractImportLine2(var ObjectImportLine: Record "Object Import Line CBLC"; var TempErrorLog: Record "Error Log CBLC" temporary)
//     // var
//     //     Customer: Record Customer;
//     // begin
//     //     if ObjectImportLine."Line No." = 50000 then begin
//     //         Customer.FindFirst();
//     //         TempErrorLog.AddError(ObjectImportLine.SystemId, 'Error Customer From extension 2', Customer.RecordId);
//     //     end;
//     // end;

//     //Voor EXT
//     // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Object Import Line Helper CBLC", OnGetCustomSetupPropertyDescription, '', true, true)]
//     // local procedure OnGetCustomSetupPropertyDescription(PropertyFieldId: Integer; var PropertyDescription: Text[100])
//     // var
//     //     ObjectImportLineCBLC: Record "Object Import Line CBLC";
//     //     ObjectSetupCBLC: Record "Object Setup CBLC";
//     // begin
//     //     ObjectSetupCBLC.Get();

//     //     case PropertyFieldId of
//     //         ObjectImportLineCBLC.FieldNo("Property 83900"):
//     //             begin
//     //                 ObjectSetupCBLC.CalcFields("Property 83900 Description");
//     //                 PropertyDescription := ObjectSetupCBLC."Property 83900 Description";
//     //             end;
//     //         ObjectImportLineCBLC.FieldNo("Property 83920"):
//     //             begin
//     //                 ObjectSetupCBLC.CalcFields("Property 83920 Description");
//     //                 PropertyDescription := ObjectSetupCBLC."Property 83920 Description";
//     //             end;

//     //     end;
//     // end;


//     //VOOR EXT
//     // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Object Import Functions CBLC", OnCustomGetSetupPropertyCodeFieldId, '', true, true)]
//     // local procedure OnCustomGetSetupPropertyCodeFieldId(PropertyFieldId: Integer; var PropertyCode: Code[20])
//     // var
//     //     ObjectImportLineCBLC: Record "Object Import Line CBLC";
//     //     ObjectSetupCBLC: Record "Object Setup CBLC";
//     // begin
//     //     ObjectSetupCBLC.Get(); //Niet vergeten

//     //     case PropertyFieldId of
//     //         ObjectImportLineCBLC.FieldNo("Property 83900"):
//     //             PropertyCode := ObjectSetupCBLC."Property 83900 Code";
//     //         ObjectImportLineCBLC.FieldNo("Property 83920"):
//     //             PropertyCode := ObjectSetupCBLC."Property 83920 Code";
//     //     end;
//     // end;

//     //VOOR EXT
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Proc. Object Import Meth. CBLC", OnBeforeCustomProcessObjectImportLine, '', true, true)]
//     local procedure OnBeforeCustomProcessObjectImportLine(var ObjectImportLine: Record "Object Import Line CBLC")
//     begin
//         //Process Objectproperties
//         if ObjectImportLine."Created Object No." <> '' then
//             ProcessObject(ObjectImportLine);

//         //TODO ERROR TEST
//         // if ObjectImportLineCBLC."Line No." = 70000 then
//         //     Error('Error vanuit Extensie voor regel 70000');
//     end;

//     //VOOR EXT
//     procedure ProcessObject(var ObjectImportLineCBLC: Record "Object Import Line CBLC")
//     var
//         ObjectCBLC: Record "Object CBLC";
//         ProcObjectImportMethCBLC: Codeunit "Proc. Object Import Meth. CBLC";
//     begin
//         //Misschien aan Object koppelen
//         if ObjectCBLC.Get(ObjectImportLineCBLC."Created Object No.") then
//             ProcObjectImportMethCBLC.ProcessObjectPropetiesFieldRange(ObjectImportLineCBLC, ObjectCBLC, ObjectImportLineCBLC.FieldNo("Property 83900"), ObjectImportLineCBLC.FieldNo("Property 83920"), ObjectImportLineCBLC."Installation Date");
//     end;
// }