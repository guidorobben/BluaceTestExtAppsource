page 83872 "Field Mismatch TPTE"
{
    ApplicationArea = All;
    Caption = 'Field Mismatch';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    Permissions =
        tabledata AllObjWithCaption = R,
        tabledata "Field Mismatch TPTE" = RIMD,
        tabledata "Mismatch Template TPTE" = R;
    SourceTable = "Field Mismatch TPTE";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(Template)
            {
                Caption = 'Template';

                field(MismatchTemplateCode; MismatchTemplateCode)
                {
                    Caption = 'Mismatch Template Code';
                    TableRelation = "Mismatch Template TPTE".Code;
                    ToolTip = 'Specifies the value of the Mismatch Template Code field.';

                    trigger OnValidate()
                    begin
                        ValidateMismatchTemplateCode(MismatchTemplateCode);
                    end;
                }
            }
            group(Tables)
            {
                Caption = 'Tables';

                field(TableIDFrom; TableIDFrom)
                {
                    Caption = 'Table ID From';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        OnLookupObjectFrom();
                    end;

                    trigger OnValidate()
                    begin
                        OnValidateTableIDFrom();
                    end;
                }
                field(TableIDTo; TableIDTo)
                {
                    Caption = 'Table ID To';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        OnLookupObjectTo();
                    end;

                    trigger OnValidate()
                    begin
                        OnValidateTableIDTo();
                    end;

                }
                field(TableNameFrom; TableFromCaption)
                {
                    Caption = 'Table Name From';
                    Editable = false;
                }
                field(TableNameTo; TableToCaption)
                {
                    Caption = 'Table Name To';
                    Editable = false;
                }
            }
            repeater(General)
            {
                Editable = false;

                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                }

                // From
                field("Field Id From"; Rec."Field Id From")
                {
                    Style = Strong;
                }
                field("Field Name From"; Rec."Field Name From")
                {
                    StyleExpr = FieldNameFromStyleExpr;
                }
                field("Field Type Name From"; Rec."Field Type Name From")
                {
                    StyleExpr = FieldTypeNameFromStyleExpr;
                }
                field("Enabled From"; Rec."Enabled From") { }
                field("ObsoleteState From"; Rec."ObsoleteState From")
                {
                    Caption = 'ObsoleteState';
                    StyleExpr = ObsoleteStateFromStyleExpr;
                }
                field("App Name From"; Rec."App Name From") { }
                field("Publisher From"; Rec."Publisher From")
                {
                    StyleExpr = PublisherFromStyleExpr;
                }

                // To
                field("Field Id To"; Rec."Field Id To")
                {
                    Style = Strong;
                }
                field("Field Name To"; Rec."Field Name To")
                {
                    StyleExpr = FieldNameToStyleExpr;
                }
                field("Field Type Name To"; Rec."Field Type Name To")
                {
                    StyleExpr = FieldTypeNameToStyleExpr;
                }
                field("Enabled To"; Rec."Enabled To") { }
                field("ObsoleteState To"; Rec."ObsoleteState To")
                {
                    Caption = 'ObsoleteState';
                    StyleExpr = ObsoleteStateToStyleExpr;
                }
                field("App Name To"; Rec."App Name To") { }
                field("Publisher To"; Rec."Publisher To")
                {
                    StyleExpr = PublisherToStyleExpr;
                }

                field(Mismatch; Rec.Mismatch)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(BuildList)
            {
                Caption = 'Build List';
                Image = "1099Form";

                trigger OnAction()
                begin
                    BuildFieldList();
                end;
            }
            action(ToggleMismatch)
            {
                Caption = 'Mismatch';
                Image = "1099Form";

                trigger OnAction()
                begin
                    if Rec.GetFilter(Mismatch) = '' then
                        Rec.SetRange(Mismatch, true)
                    else
                        Rec.SetRange(Mismatch);
                end;
            }
        }
        area(Navigation)
        {
            action(ShowMismatchTemplates)
            {
                Caption = 'Mismatch Templates';
                Image = "1099Form";

                trigger OnAction()
                begin
                    Page.Run(Page::"Mismatch Templates TPTE");
                end;
            }
        }

        area(Promoted)
        {
            actionref(BuildList_Promoted; BuildList) { }
            actionref(ToggleMismatch_Promoted; ToggleMismatch) { }
            actionref(ShowMismatchTemplates_Promoted; ShowMismatchTemplates) { }
        }
    }

    views
    {
        view(ViewName)
        {
            Caption = 'Mismatch';
            Filters = where(Mismatch = const(true));
            SharedLayout = true;
        }
    }
    var
        FieldMismatchHlp: Codeunit "Field Mismatch Hlp. TPTE";
        MismatchTemplateCode: Code[20];
        TableIDFrom, TableIDTo : Integer;
        FieldNameFromStyleExpr, FieldNameToStyleExpr : Text;
        FieldTypeNameFromStyleExpr, FieldTypeNameToStyleExpr : Text;
        ObsoleteStateFromStyleExpr, ObsoleteStateToStyleExpr : Text;
        PublisherFromStyleExpr, PublisherToStyleExpr : Text;
        TableFromCaption, TableToCaption : Text[249];

    trigger OnOpenPage()
    begin
        MismatchTemplateCode := '1382-27';
        ValidateMismatchTemplateCode(MismatchTemplateCode);
    end;

    trigger OnAfterGetRecord()
    begin
        FindMismatch(Rec);
    end;

    local procedure BuildFieldList()
    begin
        FieldMismatchHlp.BuildFieldList(Rec, TableIDFrom, TableIDTo);
    end;

    local procedure FindMismatch(FieldMismatch: Record "Field Mismatch TPTE")
    begin
        FieldNameFromStyleExpr := Format(PageStyle::Standard);
        FieldNameToStyleExpr := Format(PageStyle::Standard);
        FieldTypeNameFromStyleExpr := Format(PageStyle::Standard);
        FieldTypeNameToStyleExpr := Format(PageStyle::Standard);
        ObsoleteStateFromStyleExpr := Format(PageStyle::Standard);
        ObsoleteStateToStyleExpr := Format(PageStyle::Standard);
        PublisherFromStyleExpr := Format(PageStyle::Standard);
        PublisherToStyleExpr := Format(PageStyle::Standard);

        if FieldMismatch."Publisher From" in ['Bluace', 'Bluace BV'] then
            PublisherFromStyleExpr := Format(PageStyle::StrongAccent);

        if FieldMismatch."Publisher To" in ['Bluace', 'Bluace BV'] then
            PublisherToStyleExpr := Format(PageStyle::StrongAccent);

        if FieldMismatch."ObsoleteState From" = FieldMismatch."ObsoleteState From"::Removed then
            ObsoleteStateFromStyleExpr := Format(PageStyle::Unfavorable);

        if FieldMismatch."Field Id To" = 0 then
            exit;

        if FieldMismatch."Field Name From" <> FieldMismatch."Field Name To" then begin
            FieldNameFromStyleExpr := Format(PageStyle::Attention);
            FieldNameToStyleExpr := FieldNameFromStyleExpr;
        end;

        if FieldMismatch."Field Type Name From" <> FieldMismatch."Field Type Name To" then begin
            FieldTypeNameFromStyleExpr := Format(PageStyle::Unfavorable);
            FieldTypeNameToStyleExpr := FieldTypeNameFromStyleExpr;
        end;

        if FieldMismatch."ObsoleteState From" <> FieldMismatch."ObsoleteState To" then begin
            ObsoleteStateFromStyleExpr := Format(PageStyle::Unfavorable);
            ObsoleteStateToStyleExpr := ObsoleteStateFromStyleExpr;
        end;
    end;

    procedure OnLookupObjectFrom()
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
        if Page.RunModal(Page::"All Objects with Caption", AllObjWithCaption) = Action::LookupOK then begin
            TableIDFrom := AllObjWithCaption."Object ID";
            TableFromCaption := AllObjWithCaption."Object Caption";
        end;
    end;

    procedure OnLookupObjectTo()
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
        if Page.RunModal(Page::"All Objects with Caption", AllObjWithCaption) = Action::LookupOK then begin
            TableIDTo := AllObjWithCaption."Object ID";
            TableToCaption := AllObjWithCaption."Object Caption";
        end;
    end;

    local procedure OnValidateTableIDFrom()
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        if Rec."Field Id From" = 0 then begin
            TableFromCaption := '';
            exit;
        end;

        AllObjWithCaption.SetLoadFields("Object Caption");
        AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Table, TableIDFrom);
        TableFromCaption := AllObjWithCaption."Object Caption";
    end;

    local procedure OnValidateTableIDTo()
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        if Rec."Field Id To" = 0 then begin
            TableToCaption := '';
            exit;
        end;

        AllObjWithCaption.SetLoadFields("Object Caption");
        AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Table, TableIDTo);
        TableToCaption := AllObjWithCaption."Object Caption";
    end;

    local procedure ValidateMismatchTemplateCode(CurrMismatchTemplateCode: Code[20])
    var
        MismatchTemplate: Record "Mismatch Template TPTE";
    begin
        MismatchTemplate.SetLoadFields("Table ID From", "Table ID To");
        if MismatchTemplate.Get(CurrMismatchTemplateCode) then begin
            TableIDFrom := MismatchTemplate."Table ID From";
            OnValidateTableIDFrom();
            TableIDTo := MismatchTemplate."Table ID To";
            OnValidateTableIDTo();
            BuildFieldList();
        end;
    end;
}