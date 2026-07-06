pageextension 83921 "Req. Worksheet TPTE" extends "Req. Worksheet"
{
    layout
    {
        modify("Sell-to Customer No.")
        {
            Visible = true;
        }
        modify("Order Date")
        {
            Visible = true;
        }

        addlast(Control1)
        {
            field("Purchasing Code"; Rec."Purchasing Code")
            {
                ApplicationArea = All;
            }

            field("Gen. Business Posting Group TPTE"; Rec."Gen. Business Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code of the general business posting group to be used for the item when you post the planning worksheet.';
            }
            field("Gen. Prod. Posting Group TPTE"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
            }
        }
    }

    actions
    {
        addlast(Category_Process)
        {
            actionref(GetSpecialOrdersTPTE_Promoted; Action53) { }
        }
    }
}