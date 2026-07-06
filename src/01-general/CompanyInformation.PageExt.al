pageextension 83916 "Company Information TPTE" extends "Company Information"
{
    layout
    {
        modify("Location Code")
        {
            ApplicationArea = All;
        }
        addlast(General)
        {
            field("Alternative Language Code TPTE"; Rec."Alternative Language Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Alternative Language Code field.';
            }
        }
    }
}