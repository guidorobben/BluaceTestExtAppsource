codeunit 83856 "DeleteOrphans Meth TPTE"
{
    Permissions =
        tabledata "Tenant Media" = RD,
        tabledata "Tenant Media Orphan TPTE" = RD,
        tabledata "Tenant Media Thumbnails" = RD;

    internal procedure DeleteSelected()
    var
        IsHandled: Boolean;
    begin
        OnBeforeDeleteSelected(IsHandled);
        DoDeleteSelected(IsHandled);
        OnAfterDeleteSelected();
    end;

    local procedure DoDeleteSelected(IsHandled: Boolean)
    var
        TenantMedia: Record "Tenant Media";
        TenantMediaOrphanSYSD: Record "Tenant Media Orphan TPTE";
        TenantMediaOrphanSYSD2: Record "Tenant Media Orphan TPTE";
        TenantMediaThumbnails: Record "Tenant Media Thumbnails";
        I: Integer;
    begin
        if IsHandled then
            exit;

        I := 0;

        TenantMediaOrphanSYSD.SetRange(Select, true);
        if not TenantMediaOrphanSYSD.FindSet() then
            exit;

        repeat
            I += 1;
            if (I mod 1000 = 0) then begin
                Commit(); //Save progress
                Sleep(100);
            end;

            TenantMediaOrphanSYSD2 := TenantMediaOrphanSYSD;

            TenantMedia.Get(TenantMediaOrphanSYSD.MediaID);
            TenantMediaThumbnails.SetRange("Media ID", TenantMedia.ID);

            TenantMedia.Delete(true);
            TenantMediaThumbnails.DeleteAll(true);
            TenantMediaOrphanSYSD2.Delete(true);

        until TenantMediaOrphanSYSD.Next() < 1;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteSelected(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterDeleteSelected()
    begin
    end;
}