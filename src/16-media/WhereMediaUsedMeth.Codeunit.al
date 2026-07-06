codeunit 83852 "Where Media Used Meth TPTE"
{
    internal procedure GetWhereUsed(var TenantMedia: Record "Tenant Media") Result: Text
    var
        IsHandled: Boolean;
    begin
        OnBeforeGetWhereUsed(TenantMedia, Result, IsHandled);
        DoGetWhereUsed(TenantMedia, Result, IsHandled);
        OnAfterGetWhereUsed(TenantMedia, Result);
    end;

    local procedure DoGetWhereUsed(var TenantMedia: Record "Tenant Media"; var Result: Text; IsHandled: Boolean)
    var
        Company: Record Company;
        Fld: Record Field;
    begin
        if IsHandled then
            exit;

        Fld.SetRange(ObsoleteState, Fld.ObsoleteState::No);
        Fld.SetRange(Type, Fld.Type::Media);
        if not Fld.FindSet() then exit;

        repeat

            if not Company.FindSet() then
                exit;

            repeat
                if ProcessTable(Fld.TableNo) then
                    if ContainsReference(TenantMedia.ID, Fld.TableNo, Fld."No.", Company.Name) then
                        if Result = '' then
                            Result := Fld.TableName + '(' + Format(Fld.TableNo) + ') - (' + Company.Name + ')'
                        else
                            Result += '\' + Fld.TableName + '(' + Format(Fld.TableNo) + ') - (' + Company.Name + ')';

            until Company.Next() < 1;

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
    local procedure OnBeforeGetWhereUsed(var TenantMedia: Record "Tenant Media"; var Result: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetWhereUsed(var TenantMedia: Record "Tenant Media"; var Result: Text)
    begin
    end;
}