page 83854 "Sales Segment Users Part TPTE"
{
    ApplicationArea = AreaCBLC;
    Caption = 'Sales Segment Users (Text Ext.)';
    DeleteAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Segment User CBLC";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("User ID"; Rec."User ID") { }
            }
        }
    }
}