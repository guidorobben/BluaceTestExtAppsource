pageextension 83958 "Purchase Invoice TPTE" extends "Purchase Invoice"
{
    layout
    {
        modify("On Hold")
        {
            Importance = Promoted;
            Visible = true;
        }
    }
}