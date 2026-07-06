page 83905 "Time Sheet Details TPTE"
{
    ApplicationArea = All;
    Caption = 'Time Sheet Details TEST';
    PageType = List;
    SourceTable = "Time Sheet Detail";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Assembly Order Line No."; Rec."Assembly Order Line No.")
                {
                    ToolTip = 'Specifies the value of the Assembly Order Line No. field.';
                }
                field("Assembly Order No."; Rec."Assembly Order No.")
                {
                    ToolTip = 'Specifies the value of the Assembly Order No. field.';
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    ToolTip = 'Specifies the value of the Cause of Absence Code field.';
                }
                field(Date; Rec.Date)
                {
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ToolTip = 'Specifies the value of the Dimension Set ID field.';
                }
                field("Job Id"; Rec."Job Id")
                {
                    ToolTip = 'Specifies the value of the Job Id field.';
                }
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the value of the Job No. field.';
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ToolTip = 'Specifies the value of the Job Task No. field.';
                }
                field("Last Modified DateTime"; Rec."Last Modified DateTime")
                {
                    ToolTip = 'Specifies the value of the Last Modified DateTime field.';
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Posted Quantity"; Rec."Posted Quantity")
                {
                    ToolTip = 'Specifies the value of the Posted Quantity field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies the value of the Resource No. field.';
                }
                field("Sales Order Line No. CBLC"; Rec."Sales Order Line No. CBLC")
                {
                    ToolTip = 'Specifies the value of the Sales Order Line No. field.';
                }
                field("Sales Order No. CBLC"; Rec."Sales Order No. CBLC")
                {
                    ToolTip = 'Specifies the value of the Sales Order No. field.';
                }
                field("Service Order Line No."; Rec."Service Order Line No.")
                {
                    ToolTip = 'Specifies the value of the Service Order Line No. field.';
                }
                field("Service Order No."; Rec."Service Order No.")
                {
                    ToolTip = 'Specifies the value of the Service Order No. field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
                field("Time Sheet Line No."; Rec."Time Sheet Line No.")
                {
                    ToolTip = 'Specifies the value of the Time Sheet Line No. field.';
                }
                field("Time Sheet No."; Rec."Time Sheet No.")
                {
                    ToolTip = 'Specifies the value of the Time Sheet No. field.';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
            }
        }
    }
}
