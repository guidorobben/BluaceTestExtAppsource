page 83925 "Production Order List TPTE"
{
    ApplicationArea = All;
    Caption = 'Production Order List';
    PageType = List;
    SourceTable = "Production Order";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.") { }
                field(Description; Rec.Description) { }
            }
        }
    }
}
