pageextension 83853 "Sales Segment Setup TPTE" extends "Sales Segment Setup CBLC"
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

    actions
    {
        addlast(Processing)
        {
            action(SalesSegmentsTPTE)
            {
                ApplicationArea = All;
                Caption = 'Sales Segments';
                RunObject = page "Sales Segments CBLC";
            }
        }

        addlast(Promoted)
        {
            actionref(SalesSegmentsTPTE_Promoted; SalesSegmentsTPTE) { }
        }
    }
}