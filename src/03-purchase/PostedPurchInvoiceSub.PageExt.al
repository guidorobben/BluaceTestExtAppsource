pageextension 83851 "Posted Purch. Invoice Sub TPTE" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        modify("Job Task No.")
        {
            Visible = true;
        }
    }

    actions
    {
        addlast(processing)
        {
            group(TestExtTPTE)
            {
                Caption = 'Test Ext.';

                action(ItemCardTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Item Card';
                    Image = Item;
                    RunObject = page "Item Card";
                    RunPageLink = "No." = field("No.");
                }
                action(JobPlanningLinesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Job Planning Lines';
                    Image = LinesFromJob;
                    RunObject = page "Job Planning Lines";
                    RunPageLink = "Job No." = field("Job No."), "Job Task No." = field("Job Task No.");
                }
            }
        }
    }
}