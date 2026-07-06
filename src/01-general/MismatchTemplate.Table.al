table 83857 "Mismatch Template TPTE"
{
    Caption = 'Mismatch Template';
    DataClassification = CustomerContent;
    DrillDownPageId = "Mismatch Templates TPTE";
    LookupPageId = "Mismatch Templates TPTE";

    fields
    {
        field(1; "Table ID From"; Integer)
        {
            Caption = 'Table ID From';
            NotBlank = true;

            trigger OnLookup()
            begin
                OnLookupObjectFrom();
            end;
        }
        field(2; "Table ID To"; Integer)
        {
            Caption = 'Table ID To';
            NotBlank = true;

            trigger OnLookup()
            begin
                OnLookupObjectTo();
            end;
        }
        field(10; "Table Name From"; Text[250])
        {
            Caption = 'Table Name From';
            Editable = false;
        }
        field(20; "Table Name To"; Text[250])
        {
            Caption = 'Table Name To';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Table ID From", "Table ID To")
        {
            Clustered = true;
        }
    }

    procedure OnLookupObjectFrom()
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
        if Page.RunModal(Page::"All Objects with Caption", AllObjWithCaption) = Action::LookupOK then begin
            Rec."Table ID From" := AllObjWithCaption."Object ID";
            // TableFromCaption := AllObjWithCaption."Object Caption";
        end;
    end;

    procedure OnLookupObjectTo()
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
        if Page.RunModal(Page::"All Objects with Caption", AllObjWithCaption) = Action::LookupOK then begin
            Rec."Table ID To" := AllObjWithCaption."Object ID";
            // TableToCaption := AllObjWithCaption."Object Caption";
        end;
    end;

}