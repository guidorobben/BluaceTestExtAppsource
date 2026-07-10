table 83857 "Mismatch Template TPTE"
{
    Caption = 'Mismatch Template';
    DataClassification = CustomerContent;
    DrillDownPageId = "Mismatch Templates TPTE";
    LookupPageId = "Mismatch Templates TPTE";
    Permissions =
        tabledata AllObjWithCaption = r,
        tabledata "Mismatch Template TPTE" = ri;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; "Table ID From"; Integer)
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
        field(30; "Table Name From"; Text[250])
        {
            Caption = 'Table Name From';
            Editable = false;
        }
        field(40; "Table Name To"; Text[250])
        {
            Caption = 'Table Name To';
            Editable = false;
        }
        field(100; Description; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; Code)
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

    procedure CreateTemplates()
    begin
        CreateTemplateFromTable('1382-27', '', 1382, 27);
        CreateTemplateFromTable('17-11307', '', 17, 11307);
        CreateTemplateFromTable('36-112', '', 36, 112);
        CreateTemplateFromTable('36-114', '', 36, 114);
        CreateTemplateFromTable('38-122', '', 38, 122);
        CreateTemplateFromTable('38-124', '', 38, 124);
    end;

    local procedure CreateTemplateFromTable(TemplateCode: Code[20]; DescriptionText: Text[100]; TableIDFrom: Integer; TableIDTo: Integer)
    var
        MismatchTemplate: Record "Mismatch Template TPTE";
    begin
        if MismatchTemplate.Get(TemplateCode) then
            exit;

        MismatchTemplate.Init();
        MismatchTemplate.Validate(Code, TemplateCode);
        MismatchTemplate.Validate(Description, DescriptionText);
        MismatchTemplate.Validate("Table ID From", TableIDFrom);
        MismatchTemplate.Validate("Table ID To", TableIDTo);
        MismatchTemplate.Insert(true);
    end;
}