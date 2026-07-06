pageextension 83957 "Transfer Orders TPTE" extends "Transfer Orders"
{
    layout
    {
        addbefore(Status)
        {
            field("Posting Date TPTE"; Rec."Posting Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the posting date of the transfer order.';
            }
        }
    }
}
