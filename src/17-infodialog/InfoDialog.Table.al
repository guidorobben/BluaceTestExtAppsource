table 83852 "Info Dialog TPTE"
{
    Caption = 'Info Buffer';
    DataClassification = SystemMetadata;
    DrillDownPageId = "Info Dialog TPTE";
    LookupPageId = "Info Dialog TPTE";
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
        }
        field(10; Name; Text[100])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the value of the Variable Name field.', Comment = '%';
        }
        field(20; Value; Text[100])
        {
            Caption = 'Value';
            ToolTip = 'Specifies the value of the Variable Value field.', Comment = '%';
        }
        field(30; "Event Code"; Enum "Info Dialog Event Code TPTE")
        {
            AllowInCustomizations = AsReadWrite;
            Caption = 'Event Code';
            ToolTip = 'Specifies the Event Code for the record.';
        }
        field(100; Header; Boolean)
        {
            Caption = 'Header';
            ToolTip = 'Specifies the value of the Header field.', Comment = '%';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure ActivateEventCode()
    var
        InfoDialogHelper: Codeunit "Info Dialog Helper TPTE";
    begin
        InfoDialogHelper.ActivateEventCode(Rec);
    end;

    procedure GetValueAsGuid() Result: Guid
    begin
        if Evaluate(Result, Value) then; //No Error
    end;
}
