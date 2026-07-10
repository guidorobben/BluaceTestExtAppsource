page 83871 "Mismatch Templates TPTE"
{
    ApplicationArea = All;
    Caption = 'Mismatch Templates';
    PageType = List;
    SourceTable = "Mismatch Template TPTE";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code") { }
                field("Description"; Rec."Description") { }
                field("Table ID From"; Rec."Table ID From") { }
                field("Table ID To"; Rec."Table ID To") { }
                field("Table Name From"; Rec."Table Name From") { }
                field("Table Name To"; Rec."Table Name To") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateTemplates)
            {
                Caption = 'Create Templates';
                Image = AddAction;

                trigger OnAction()
                begin
                    Rec.CreateTemplates();
                end;
            }
        }
    }
}