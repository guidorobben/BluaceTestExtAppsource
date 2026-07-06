page 83869 "Value Entry Relations TPTE"
{
    ApplicationArea = All;
    Caption = 'Value Entry Relations';
    PageType = List;
    SourceTable = "Value Entry Relation";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Value Entry No."; Rec."Value Entry No.") { }
                field("Source RowId"; Rec."Source RowId") { }
            }
        }
    }
}