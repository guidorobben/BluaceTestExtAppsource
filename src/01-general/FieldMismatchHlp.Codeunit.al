codeunit 83883 "Field Mismatch Hlp. TPTE"
{
    Access = Internal;
    Permissions =
        tabledata Field = R,
        tabledata "Field Mismatch TPTE" = RIMD;

    procedure BuildFieldList(var FieldMismatch: Record "Field Mismatch TPTE"; TableIDFrom: Integer; TableIDTo: Integer)
    begin
        FieldMismatch.Reset();
        FieldMismatch.DeleteAll(false);

        BuildFromFieldList(FieldMismatch, TableIDFrom);
        BuildToFieldList(FieldMismatch, TableIDTo);
        FindMismatch(FieldMismatch);

        FieldMismatch.Reset();
        if FieldMismatch.FindFirst() then; // Pointer
    end;

    local procedure BuildFromFieldList(var FieldMismatch: Record "Field Mismatch TPTE"; TableID: Integer)
    var
        Fields: Record Field;
        TableRecordRef: RecordRef;
        EntryNo: Integer;
    begin
        EntryNo := 0;
        TableRecordRef.Open(TableID);

        Fields.Reset();
        Fields.SetRange(TableNo, TableID);
        Fields.SetLoadFields("App Package ID", Enabled, FieldName, "No.", ObsoleteState, Type, "Type Name");
        if Fields.FindSet() then
            repeat
                EntryNo := EntryNo + 100;

                FieldMismatch.Init();
                FieldMismatch."Entry No." := EntryNo;
                FieldMismatch."Field Id From" := Fields."No.";
                FieldMismatch."Field Name From" := Fields.FieldName;
                FieldMismatch."Field Type From" := Fields.Type;
                FieldMismatch."Field Type Name From" := Fields."Type Name";
                if Fields.Type = Fields.Type::Option then
                    if fields.ObsoleteState <> fields.ObsoleteState::Removed then
                        if TableRecordRef.Field(Fields."No.").IsEnum() then
                            FieldMismatch."Field Type Name From" := 'Enum';
                //TODO option value fields
                FieldMismatch."Enabled From" := Fields.Enabled;
                FieldMismatch."ObsoleteState From" := Fields.ObsoleteState;
                FieldMismatch."App Package ID From" := Fields."App Package ID";
                GetAppInfoFrom(FieldMismatch);
                FieldMismatch.Insert(false);
            until Fields.Next() = 0;
    end;

    local procedure GetAppInfoFrom(var FieldMismatch: Record "Field Mismatch TPTE")
    var
        NAVAppInstalledApp: Record "NAV App Installed App";
    begin
        NAVAppInstalledApp.SetRange("Package ID", FieldMismatch."App Package ID From");
        NAVAppInstalledApp.SetLoadFields(Name, Publisher);
        if NAVAppInstalledApp.FindFirst() then begin
            FieldMismatch."App Name From" := NAVAppInstalledApp.Name;
            FieldMismatch."Publisher From" := NAVAppInstalledApp.Publisher;
        end;
    end;

    local procedure BuildToFieldList(var FieldMismatch: Record "Field Mismatch TPTE"; TableID: Integer)
    var
        Fields: Record Field;
        TableRecordRef: RecordRef;
    begin
        TableRecordRef.Open(TableID);

        Fields.Reset();
        Fields.SetRange(TableNo, TableID);
        Fields.SetLoadFields();
        Fields.SetLoadFields("App Package ID", Enabled, FieldName, "No.", ObsoleteState, Type, "Type Name");
        if Fields.FindSet() then
            repeat
                FieldMismatch.Reset();
                FieldMismatch.SetRange("Field Id From", Fields."No.");
                if FieldMismatch.FindFirst() then begin
                    FieldMismatch."Field Id To" := Fields."No.";
                    FieldMismatch."Field Name To" := Fields.FieldName;
                    FieldMismatch."Field Type To" := Fields.Type;
                    FieldMismatch."Field Type Name To" := Fields."Type Name";
                    if Fields.Type = Fields.Type::Option then
                        if fields.ObsoleteState <> fields.ObsoleteState::Removed then
                            if TableRecordRef.Field(Fields."No.").IsEnum() then
                                FieldMismatch."Field Type Name To" := 'Enum';
                    FieldMismatch."Enabled To" := Fields.Enabled;
                    FieldMismatch."ObsoleteState To" := Fields.ObsoleteState;
                    FieldMismatch."App Package ID To" := Fields."App Package ID";
                    GetAppInfoTo(FieldMismatch);
                    FieldMismatch.Modify(false);
                end;
            until Fields.Next() = 0;
    end;

    local procedure GetAppInfoTo(var FieldMismatch: Record "Field Mismatch TPTE")
    var
        NAVAppInstalledApp: Record "NAV App Installed App";
    begin
        NAVAppInstalledApp.SetRange("Package ID", FieldMismatch."App Package ID To");
        NAVAppInstalledApp.SetLoadFields(Name, Publisher);
        if NAVAppInstalledApp.FindFirst() then begin
            FieldMismatch."App Name To" := NAVAppInstalledApp.Name;
            FieldMismatch."Publisher To" := NAVAppInstalledApp.Publisher;
        end;
    end;

    local procedure FindMismatch(var FieldMismatch: Record "Field Mismatch TPTE")
    var
        IsMismatch: Boolean;
    begin
        FieldMismatch.Reset();
        if FieldMismatch.FindSet() then
            repeat
                IsMismatch := false;

                if FieldMismatch."Field Id To" = 0 then
                    continue;

                if FieldMismatch."Field Name From" <> FieldMismatch."Field Name To" then
                    IsMismatch := true;

                if FieldMismatch."Field Type Name From" <> FieldMismatch."Field Type Name To" then
                    IsMismatch := true;


                if IsMismatch then begin
                    FieldMismatch.Mismatch := true;
                    FieldMismatch.Modify(false);
                end;
            until FieldMismatch.Next() = 0;
    end;

}