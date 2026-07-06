pageextension 83952 "Purchase Order List TPTE" extends "Purchase Order List"
{
    layout
    {
        modify("Posting Date")
        {
            Visible = true;
        }
        moveafter("Document Date"; "Posting Date")

        addafter("Document Date")
        {
            field("Order Date TPTE"; Rec."Order Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
