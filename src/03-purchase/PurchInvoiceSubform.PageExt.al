pageextension 83850 "Purch. Invoice Subform TPTE" extends "Purch. Invoice Subform"
{
    layout
    {
        modify("Job Line Type")
        {
            Visible = true;
        }
        modify("Job No.")
        {
            Visible = true;
        }
        modify("Job Task No.")
        {
            Visible = true;
        }
        modify("Deferral Code")
        {
            Visible = true;
        }
    }
}