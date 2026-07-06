table 83908 "XML Buffer Attachment TPTE"
{
    Caption = 'XML Buffer Attachment';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
        }

        field(2; "Import ID"; Guid)
        {
            AllowInCustomizations = AsReadWrite;
            Caption = 'Import ID';
        }
        field(10; Filename; Text[100])
        {
            Caption = 'Filename';
            ToolTip = 'Specifies the value of the Filename field.', Comment = '%';
        }
        field(20; "File Type"; Text[10])
        {
            Caption = 'File Type';
            ToolTip = 'Specifies the value of the File Type field.', Comment = '%';
        }
        field(30; URL; Text[100])
        {
            AllowInCustomizations = AsReadWrite;
            Caption = 'URL';
        }
        field(40; "Attached Data"; Blob)
        {
            Caption = 'Attached Data';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure GetValue(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Attached Data");
        if not "Attached Data".HasValue() then
            exit;

        "Attached Data".CreateInStream(InStream, TextEncoding::Windows);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator()));
    end;

    procedure SetValue(NewValue: Text)
    begin
        SetValueWithoutModifying(NewValue);
        // Modify();
    end;

    procedure SetValueWithoutModifying(NewValue: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Attached Data");
        // NormalizeElementValue(NewValue);
        // Rec.Value := CopyStr(NewValue, 1, MaxStrLen(Rec.Value));
        // OnSetValueWithoutModifyingOnAfterAssignValue(Rec, NewValue);
        // if StrLen(NewValue) <= MaxStrLen(Value) then
        //     exit; // No need to store anything in the blob
        if NewValue = '' then
            exit;

        "Attached Data".CreateOutStream(OutStream, TextEncoding::Windows);
        OutStream.WriteText(NewValue);
    end;
}
