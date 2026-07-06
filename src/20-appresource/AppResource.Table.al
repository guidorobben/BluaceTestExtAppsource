table 83854 "App Resource TPTE"
{
    Caption = 'App Resource';
    DataClassification = CustomerContent;
    DrillDownPageId = "App Resource List TPTE";
    LookupPageId = "App Resource List TPTE";
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the entry number of the resource.';
        }
        field(10; Name; Text[1024])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the name of the resource.';
        }
        field(20; Folder; Boolean)
        {
            AllowInCustomizations = AsReadWrite;
            Caption = 'Folder';
            ToolTip = 'Specifies if the entry is a folder.';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        AppResourceHelper: Codeunit "App Resource Helper TPTE";
        LastEntryNo: Integer;

    procedure SetNewEntryNo()
    begin
        LastEntryNo += 1;
        "Entry No." := LastEntryNo;
    end;

    procedure Download()
    begin
        AppResourceHelper.DownloadResource(Rec);
    end;

    procedure LoadResources()
    begin
        AppResourceHelper.GetResources(Rec, '');
    end;
}