page 83852 "Field Info. Part TPTE"
{
    ApplicationArea = All;
    Caption = 'Field Information Part';
    PageType = CardPart;
    SourceTable = "Field";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the ID number of the field in the table.';
                }
                field(FieldName; Rec.FieldName)
                {
                    ToolTip = 'Specifies the name of the field in the table.';
                }
                field(TenentMediaRecordsControl; TenantMediaRecords)
                {
                    Caption = 'Tenant Media Records';
                }
            }
        }
    }

    var
        TenantMediaRecords: Integer;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Type <> Rec.Type::Media then
            exit;

        if Rec.ObsoleteState = Rec.ObsoleteState::Removed then
            exit;

        TenantMediaRecords := 0;
        CountTenentMedia();
    end;

    local procedure CountTenentMedia()
    var
        MediaRecordRef: RecordRef;
        EmptyGuid: Guid;
        FieldValueAsGuid: Guid;
    begin
        MediaRecordRef.Open(Rec.TableNo);
        MediaRecordRef.Field(Rec."No.").SetFilter('<>%1', EmptyGuid);
        if MediaRecordRef.FindSet() then
            repeat
                if Evaluate(FieldValueAsGuid, Format(MediaRecordRef.Field(Rec."No.").Value())) then
                    if MediaTenantExist(FieldValueAsGuid) then
                        TenantMediaRecords += 1;
            until MediaRecordRef.Next() = 0;
    end;

    local procedure MediaTenantExist(MediaGuid: Guid): Boolean
    var
        TenantMedia: Record "Tenant Media";
    begin
        TenantMedia.SetRange(ID, MediaGuid);
        if not TenantMedia.IsEmpty() then
            exit(true);
    end;
}
