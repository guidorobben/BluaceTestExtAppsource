pageextension 83933 "Sales Quote TPTE" extends "Sales Quote"
{
    layout
    {
        modify("Blocked for Planning CBLC")
        {
            Importance = Standard;
        }
    }

    actions
    {
        addlast("&Quote")
        {
            action(ArchivesTPTE)
            {
                ApplicationArea = All;
                Caption = 'Archives';
                Image = Archive;
                RunObject = page "Sales Quote Archives";
                RunPageLink = "Document Type" = field("Document Type"), "No." = field("No.");
                ToolTip = 'Show Archives.';
            }
        }

        addlast(Category_Category4)
        {
            actionref(ArchivesTPTE_Promoted; ArchivesTPTE) { }
        }
    }
}