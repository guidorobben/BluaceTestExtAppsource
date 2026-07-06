reportextension 83900 "Batch Post Sales Orders TPTE" extends "Batch Post Sales Orders"
{
    requestpage
    {
        layout
        {
            modify(Ship)
            {
                Enabled = false;
            }
            modify(Invoice)
            {
                Enabled = false;
            }
        }

        trigger OnOpenPage()
        begin
            ShipReq := true;
            InvReq := true;
        end;
    }
}