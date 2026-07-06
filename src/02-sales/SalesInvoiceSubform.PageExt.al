pageextension 83924 "Sales Invoice Subform TPTE" extends "Sales Invoice Subform"
{

    layout
    {
        modify("Job No.")
        {
            Visible = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

        // addbefore("VAT Prod. Posting Group")
        // {
        //     // field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
        //     // {
        //     //     ApplicationArea = All;
        //     //     ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.';
        //     //     Visible = true;
        //     // }
        // }

        modify("VAT Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Contract Reference Date CBLC")
        {
            Visible = true;
        }
    }
}
