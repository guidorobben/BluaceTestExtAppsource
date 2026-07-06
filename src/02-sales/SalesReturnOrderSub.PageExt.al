pageextension 83858 "Sales Return Order Sub TPTE" extends "Sales Return Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Vendor No. CBLC TPTE"; Rec."Vendor No. CBLC")
            {
                ApplicationArea = All;
            }
        }
    }
}