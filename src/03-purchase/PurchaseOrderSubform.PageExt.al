pageextension 83930 "Purchase Order Subform TPTE" extends "Purchase Order Subform"
{
    layout
    {
        modify("Job No.")
        {
            Visible = true;
        }
        modify("Job Task No.")
        {
            Visible = true;
        }
        modify("Job Planning Line No.")
        {
            Visible = true;
        }

        modify("Linked Job No. CBLC")
        {
            Visible = true;
        }
        modify("Linked Job Task No. CBLC")
        {
            Visible = true;
        }
        modify("Linked Job Pl. Line No. CBLC")
        {
            Visible = true;
        }

        addlast(Control1)
        {

            field("Gen. Bus. Posting Group TPTE"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
            }
            field("Gen. Prod. Posting Group TPTE"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                Visible = true;
            }
        }
    }
}
