page 83903 "Import Info TPTE"
{
    ApplicationArea = All;
    Caption = 'Import - Info';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Import Data TPTE";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Editable = EditMode;

                field(Section; Rec.Section)
                {
                    Editable = false;
                }
                field(Category; Rec.Category)
                {
                    Editable = false;
                }
                field(Name; Rec.Name) { }
                field(Description; Rec.Description) { }
                field(Header; Rec.Header) { }
                field(Value; Rec.Value) { }
                field(Import; Rec.Import) { }
                field(Records; Rec.Records) { }
                field("Table ID"; Rec."Table ID")
                {
                    Editable = false;
                }
                field("Parent Table ID"; Rec."Parent Table ID")
                {
                    Editable = false;
                }
                field(Show; Rec.Show) { }
                field(Warning; Rec.Warning) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("To Import")
            {
                Caption = 'To Import';
                Image = "Filter";
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.SetRange(Import, true);
                end;
            }
            action(Edit)
            {
                Caption = 'Edit';
                Image = EditLines;

                trigger OnAction()
                begin
                    EditMode := not EditMode;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        EditMode := false;
    end;

    var
        EditMode: Boolean;
}

