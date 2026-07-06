// codeunit 83855 "GetMediaOrphans Meth TPTE"
// {
//     internal procedure GetTenantMediaOrphans()
//     var
//         IsHandled: Boolean;
//     begin
//         OnBeforeGetTenantMediaOrphans(IsHandled);
//         DoGetTenantMediaOrphans(IsHandled);
//         OnAfterGetTenantMediaOrphans();
//     end;

//     local procedure DoGetTenantMediaOrphans(IsHandled: Boolean);
//     var
//         TenantMediaOrphan: Record "Tenant Media Orphan TPTE";
//         TenantMedia: Record "Tenant Media";
//         IsTenantMediaOrphanedMeth: Codeunit "IsMediaOrphaned Meth TPTE";
//         i, totalcount : integer;
//         window: Dialog;
//     begin
//         if IsHandled then
//             exit;

//         TenantMediaOrphan.DeleteAll();
//         i := 0;


//         TenantMedia.SetAutoCalcFields(Content);
//         if not TenantMedia.FindSet() then exit;

//         totalcount := TenantMedia.Count;

//         window.Open('Loading Orphans \\ Total: ' + format(totalcount) + ' \\ Current: #1#### ');

//         repeat
//             i += 1;
//             if (i mod 50 = 0) then window.Update(1, i);

//             if IsTenantMediaOrphanedMeth.IsOrphaned(tenantMedia) then begin
//                 TenantMediaOrphan.TransferFields(TenantMedia);
//                 TenantMediaOrphan.Length := TenantMedia.Content.Length;
//                 TenantMediaOrphan.Insert();
//             end;

//             if (i mod 1000 = 0) then commit();

//         until TenantMedia.Next() < 1;

//         window.Close();
//     end;


//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeGetTenantMediaOrphans(var IsHandled: Boolean);
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterGetTenantMediaOrphans();
//     begin
//     end;
// }