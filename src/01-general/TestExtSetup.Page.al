page 83866 "Test Ext. Setup TPTE"
{
    ApplicationArea = All;
    Caption = 'Test Ext. Setup ';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Test Ext. Setup TPTE";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Last Sales Order Filter"; Rec."Last Sales Order Filter") { }
                field("Enable Run Object"; Rec."Enable Run Object") { }
            }
            group(RunObject)
            {
                Caption = 'Run Object';

                field("Run Object Type 1"; Rec."Run Object Type 1") { }
                field("Run Object ID 1"; Rec."Run Object ID 1") { }
                field("Run Object Type 2"; Rec."Run Object Type 2") { }
                field("Run Object ID 2"; Rec."Run Object ID 2") { }

            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;
}