pageextension 83940 "Sales Order Archive Sub TPTE" extends "Sales Order Archive Subform"
{
    layout
    {
        modify("Contract Reference Date CBLC")
        {
            Visible = true;
        }
        modify("Vendor No. CBLC")
        {
            Visible = true;
        }
    }
}
