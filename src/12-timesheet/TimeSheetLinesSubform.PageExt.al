pageextension 83911 "Time Sheet Lines Subform TPTE" extends "Time Sheet Lines Subform"
{
    layout
    {
        modify(Type)
        {
            Visible = true;
        }
        modify("Job No.")
        {
            Visible = true;
        }
        modify("Job Task No.")
        {
            Caption = 'Job Task No. (BC)';
            Visible = true;
        }
        modify(Status)
        {
            Visible = true;
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        AllowEdit := true;
    end;
}