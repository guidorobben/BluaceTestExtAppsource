pageextension 83922 "Purchase Order TPTE" extends "Purchase Order"
{
    layout
    {
        modify("No.")
        {
            Importance = Standard;
            Visible = true;
        }
        modify("Posting Date")
        {
            Importance = Standard;
        }
        modify("Posting Description")
        {
            Importance = Standard;
            Visible = true;
        }
        modify("Order Date")
        {
            Importance = Standard;
        }

        addlast(General)
        {
            field("Language Code TPTE"; Rec."Language Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Language Code field. (Test Ext.).';
            }
        }
    }
}