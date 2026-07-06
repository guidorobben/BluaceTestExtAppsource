pageextension 83861 "Transfer Order TPTE" extends "Transfer Order"
{
    layout
    {
        modify(Control1905767507)
        {
            Visible = false;
        }
        modify(Control1900383207)
        {
            Visible = false;
        }

        addfirst(factboxes)
        {
            part(ContainerInfoTPTE; "Container Info TPTE")
            {
                ApplicationArea = All;
                Provider = TransferLines;
                SubPageLink = "Container Item No." = field("Item No.");
            }
        }
    }
}