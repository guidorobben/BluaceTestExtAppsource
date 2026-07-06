table 83853 "Test Ext. Setup TPTE"
{
    Caption = 'Test Ext. Setup';
    DataClassification = CustomerContent;
    Permissions =
        tabledata AllObjWithCaption = R,
        tabledata "Test Ext. Setup TPTE" = R;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
            NotBlank = false;
        }
        field(10; "Run Object Type 1"; Enum "Object Type TPTE")
        {
            Caption = 'Run Object Type 1';
        }
        field(20; "Run Object ID 1"; Integer)
        {
            Caption = 'Run Object ID 1';

            trigger OnLookup()
            begin
                OnLookupObject1();
            end;
        }
        field(30; "Enable Run Object"; Boolean)
        {
            Caption = 'Enable Run Object';
        }
        field(40; "Last Sales Order Filter"; Text[250])
        {
            Caption = 'Last Sales Order Filter';
        }
        field(50; "Run Object Type 2"; Enum "Object Type TPTE")
        {
            Caption = 'Run Object Type 2';
        }
        field(60; "Run Object ID 2"; Integer)
        {
            Caption = 'Run Object ID 2';

            trigger OnLookup()
            begin
                OnLookupObject2();
            end;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    internal procedure InsertIfNotExists()
    var
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;

    local procedure OnLookupObject1()
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange("Object Type", "Run Object Type 1");
        if Page.RunModal(Page::"All Objects with Caption", AllObjWithCaption) = Action::LookupOK then
            Validate("Run Object ID 1", AllObjWithCaption."Object ID");
    end;

    local procedure OnLookupObject2()
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange("Object Type", "Run Object Type 2");
        if Page.RunModal(Page::"All Objects with Caption", AllObjWithCaption) = Action::LookupOK then
            Validate("Run Object ID 2", AllObjWithCaption."Object ID");
    end;

    procedure GetStartupObjects(var RunObjectNo: array[5] of Integer; var RunObjectType: array[5] of Enum "Object Type TPTE")
    begin
        if not Rec.Get() then
            exit;

        RunObjectType[1] := Rec."Run Object Type 1";
        RunObjectNo[1] := Rec."Run Object ID 1";
        RunObjectType[2] := Rec."Run Object Type 2";
        RunObjectNo[2] := Rec."Run Object ID 2";
    end;
}