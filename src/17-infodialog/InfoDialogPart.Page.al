page 83858 "Info Dialog Part TPTE"
{
    ApplicationArea = All;
    Caption = 'Info';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Info Dialog TPTE";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                }
                field(Name; Rec.Name)
                {
                    Style = Strong;
                    StyleExpr = Rec.Header;
                }
                field(Value; Rec."Value") { }
                field(Header; Rec.Header)
                {
                    Visible = false;
                }
            }
        }
    }

    procedure ShowData(var InfoBuffer: Codeunit "Info Dialog TPTE")
    begin
        Rec.DeleteAll(false);
        InfoBuffer.TransferInfoDialog(Rec);
        if Rec.FindFirst() then; //Pointer to first
    end;
}