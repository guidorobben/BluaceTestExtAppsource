pageextension 83854 "Sales Segment Card TPTE" extends "Sales Segment Card CBLC"
{
    layout
    {
        addlast(FactBoxes)
        {
            part("Sales Segment Users Part TPTE"; "Sales Segment Users Part TPTE")
            {
                ApplicationArea = All;
                SubPageLink = "Sales Segment Code" = field(Code);
            }
        }
    }
}
