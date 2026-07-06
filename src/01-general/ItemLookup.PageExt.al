pageextension 83860 "Item Lookup TPTE" extends "Item Lookup"
{
    layout
    {
        addafter(Description)
        {
            field("Item Category Code TPTE"; Rec."Item Category Code")
            {
                ApplicationArea = All;
            }
        }
    }
}