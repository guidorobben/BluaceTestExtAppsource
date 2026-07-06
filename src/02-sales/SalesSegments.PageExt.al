pageextension 83855 "Sales Segments TPTE" extends "Sales Segments CBLC"
{
    layout
    {
        modify("No. of Records")
        {
            trigger OnDrillDown()
            var
                LibrarySalesSegmentsLIB: Codeunit "Library - Sales Segments LIB";
            begin
                LibrarySalesSegmentsLIB.OpenSalesSegmentRecords(Rec);
            end;
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(SalesSegmentSetupTPTE)
            {
                ApplicationArea = All;
                Caption = 'Segment Setup';
                Image = Setup;
                RunObject = page "Sales Segment Setup CBLC";
            }
        }

        addlast(Promoted)
        {
            actionref(SalesSegmentSetupTPTE_Promoted; SalesSegmentSetupTPTE) { }
        }
    }
}
