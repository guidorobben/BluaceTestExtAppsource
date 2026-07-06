page 83904 "Run Object TPTE"
{
    ApplicationArea = All;
    Caption = 'Run Object';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Run Object History TPTE";
    SourceTableView = sorting("Last Run") order(descending);
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            field(goObjectType; ObjectType)
            {
                Caption = 'Object Type';
                OptionCaption = ' ,Table,,Report,,Codeunit,XMLport,,Page,Query', Comment = ',Table,,Report,,Codeunit,XMLport,,Page,Query';
            }
            field(giObjectID; ObjectID)
            {
                Caption = 'Object ID';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    OnLookupObject();
                end;
            }

            repeater(General)
            {
                Editable = false;

                field(Type; Rec.Type) { }
                field(ID; Rec.ID) { }
                field("Object Caption"; Rec."Object Caption") { }
                field("Last Run"; Rec."Last Run") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Run)
            {
                Caption = 'Run';
                Image = Start;

                trigger OnAction()
                begin
                    RunObjectHelper.SaveHistory(ObjectType, ObjectID);
                    RunObjectHelper.RunObject(ObjectType, ObjectID);
                end;
            }
        }
        area(Promoted)
        {
            actionref(Run_Promoted; Run) { }
        }
    }

    var
        RunObjectHelper: Codeunit "Run Object Helper TPTE";

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.ID = 0 then
            exit;

        ObjectType := Rec.Type;
        ObjectID := Rec.ID;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("User ID", UserId());
    end;

    var
        ObjectID: Integer;
        // Text10000: Label 'Tables are not supported.';
        // NoQueriesErr: Label 'Queries are not supported.';
        ObjectType: Option " ","Table",,"Report",,"Codeunit","XMLport",,"Page","Query";

    // ObjectType: enum type
    // Object: Record Object;

    procedure OnLookupObject()
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange("Object Type", ObjectType);
        if Page.RunModal(Page::"All Objects with Caption", AllObjWithCaption) = Action::LookupOK then
            ObjectID := AllObjWithCaption."Object ID";
    end;
}
