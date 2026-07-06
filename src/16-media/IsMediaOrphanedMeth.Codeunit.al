codeunit 83854 "IsMediaOrphaned Meth TPTE"
{
    internal procedure IsOrphaned(var TenantMedia: Record "Tenant Media") IsOrphanedResult: Boolean
    var
        IsHandled: Boolean;
    begin
        OnBeforeIsOrphaned(TenantMedia, IsOrphanedResult, IsHandled);
        DoIsOrphaned(TenantMedia, IsOrphanedResult, IsHandled);
        OnAfterIsOrphaned(TenantMedia, IsOrphanedResult);
    end;

    local procedure DoIsOrphaned(var TenantMedia: Record "Tenant Media"; var IsOrphanedResult: Boolean; IsHandled: Boolean)
    begin
        if IsHandled then
            exit;

        IsOrphanedResult := not ContainsReferenceForAllTables(TenantMedia)
    end;

    local procedure ContainsReferenceForAllTables(var TenantMedia: Record "Tenant Media"): Boolean
    var
        Company: Record Company;
        Fld: Record Field;
    begin
        Fld.SetRange(ObsoleteState, Fld.ObsoleteState::No);
        Fld.SetRange(Type, Fld.Type::Media);
        if not Fld.FindSet() then exit;

        repeat
            if ContainsReferenceForCompany(TenantMedia, Fld, TenantMedia."Company Name") then
                exit(true);

            Company.FindSet();
            repeat
                if Company.Name <> TenantMedia."Company Name" then
                    if ContainsReferenceForCompany(TenantMedia, Fld, Company.Name) then
                        exit(true);
            until Company.Next() < 1;

        until Fld.Next() < 1;

        exit(false);
    end;

    local procedure ContainsReferenceForCompany(var TenantMedia: Record "Tenant Media"; Fld: Record Field; CompanyName: Text): Boolean
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        RecRef.Open(Fld.TableNo);
        RecRef.ChangeCompany(CompanyName);
        FldRef := RecRef.Field(Fld."No.");
        FldRef.SetRange(TenantMedia.ID);

        exit(not RecRef.IsEmpty());
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeIsOrphaned(var TenantMedia: Record "Tenant Media"; var IsOrphanedResult: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterIsOrphaned(var TenantMedia: Record "Tenant Media"; var IsOrphanedResult: Boolean)
    begin
    end;
}