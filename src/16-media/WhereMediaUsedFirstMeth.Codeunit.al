codeunit 83853 "WhereMediaUsed First Meth TPTE"
{
    internal procedure GetWhereUsedFirst(var TenantMedia: Record "Tenant Media") Result: Text
    var
        IsHandled: Boolean;
    begin
        OnBeforeGetWhereUsedFirst(TenantMedia, Result, IsHandled);
        DoGetWhereUsedFirst(TenantMedia, Result, IsHandled);
        OnAfterGetWhereUsedFirst(TenantMedia, Result);
    end;

    local procedure DoGetWhereUsedFirst(var TenantMedia: Record "Tenant Media"; var Result: Text; IsHandled: Boolean)
    var
        Fld: Record Field;
    begin
        if IsHandled then
            exit;

        Fld.SetRange(ObsoleteState, Fld.ObsoleteState::No);
        Fld.SetRange(Type, Fld.Type::Media);
        if not Fld.FindSet() then exit;

        repeat
            if ProcessTable(Fld.TableNo) then
                if ContainsReference(TenantMedia.ID, Fld.TableNo, Fld."No.", TenantMedia."Company Name") then begin
                    Result := Fld.TableName + ' (' + Format(Fld.TableNo) + ')';
                    exit;
                end
        until Fld.Next() < 1;
    end;

    local procedure ProcessTable(TableId: Integer): Boolean
    begin
        if TableId in [2000000206, 2000000172, 2000000180] then
            exit;

        exit(true);
    end;

    local procedure ContainsReference(TenantMediaId: Guid; TableNo: Integer; FieldNo: Integer; CompanyName: Text[30]): Boolean
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        RecRef.Open(TableNo);
        RecRef.ChangeCompany(CompanyName);
        FldRef := RecRef.Field(FieldNo);
        FldRef.SetRange(TenantMediaId);

        exit(not RecRef.IsEmpty());
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetWhereUsedFirst(var TenantMedia: Record "Tenant Media"; var Result: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetWhereUsedFirst(var TenantMedia: Record "Tenant Media"; var Result: Text)
    begin
    end;
}