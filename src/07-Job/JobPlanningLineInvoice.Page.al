page 83861 "Job Planning Line Invoice TPTE"
{
    ApplicationArea = All;
    Caption = 'Project Planning Line Invoice';
    Editable = false;
    PageType = List;
    SourceTable = "Job Planning Line Invoice";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the value of the Project No. field.', Comment = '%';
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ToolTip = 'Specifies the value of the Project Task No. field.', Comment = '%';
                }
                field("Job Planning Line No."; Rec."Job Planning Line No.")
                {
                    ToolTip = 'Specifies the value of the Project Planning Line No. field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the line number that is linked to the document. Numbers are created sequentially.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the information about the type of document. There are four options.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the number associated with the document. For example, if you have created an invoice, the field Specifies the invoice number.';
                }
                field("Invoiced Date"; Rec."Invoiced Date")
                {
                    ToolTip = 'Specifies the date on which the invoice or credit memo was posted.';
                }
                field("Invoiced Amount (LCY)"; Rec."Invoiced Amount (LCY)")
                {
                    ToolTip = 'Specifies the amount (LCY) that was posted from the invoice or credit memo. The amount is calculated based on Quantity, Line Discount %, and Unit Price.';
                }
                field("Invoiced Cost Amount (LCY)"; Rec."Invoiced Cost Amount (LCY)")
                {
                    ToolTip = 'Specifies the amount of the unit costs that has been posted from the invoice or credit memo. The amount is calculated based on Quantity, Unit Cost, and Line Discount %.';
                }
                field("Quantity Transferred"; Rec."Quantity Transferred")
                {
                    ToolTip = 'Specifies the quantity transferred from the project planning line to the invoice or credit memo.';
                }
                field("Job Ledger Entry No."; Rec."Job Ledger Entry No.")
                {
                    ToolTip = 'Specifies a link to the project ledger entry that was created when the document was posted.';
                }
                field("Transferred Date"; Rec."Transferred Date")
                {
                    ToolTip = 'Specifies the date on which the invoice or credit document was created. The date is set to the posting date you specified when you created the invoice or credit memo.';
                }
            }
        }
    }
}