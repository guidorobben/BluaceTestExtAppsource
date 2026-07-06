page 83850 "Tenant Media Orphans TPTE"
{
    ApplicationArea = All;
    Caption = 'Tenant Media Orphans';
    PageType = List;
    SourceTable = "Tenant Media Orphan TPTE";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Select; Rec.Select) { }
                field(MediaID; Rec.MediaID)
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field(Length; Rec.Length)
                {
                    Editable = false;
                }
                field(Height; Rec.Height)
                {
                    Editable = false;
                }
                field(Width; Rec.Width)
                {
                    Editable = false;
                }
                field("Company Name"; Rec."Company Name")
                {
                    Editable = false;
                }
                field("Creating User"; Rec."Creating User")
                {
                    Editable = false;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    Editable = false;
                }
                field("File Name"; Rec."File Name")
                {
                    Editable = false;
                }
                field("Mime Type"; Rec."Mime Type")
                {
                    Editable = false;
                }
                field("Prohibit Cache"; Rec."Prohibit Cache")
                {
                    Editable = false;
                }
                field("Security Token"; Rec."Security Token")
                {
                    Editable = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
            }
        }

        area(FactBoxes)
        {
            part(picture; "Media Cleanup FactBox")
            {
                SubPageLink = ID = field(MediaID);
            }
        }
    }
    actions
    {
        area(Processing)
        {
            // action(GetOrphans)
            // {
            //     Caption = 'Get Orphans';
            //     Image = VoidExpiredCheck;
            //     ApplicationArea = All;
            //     ToolTip = 'Searches for Orphans, displays them, for you to handle them';

            //     trigger OnAction()
            //     var
            //         GetTenantMediaOrphansMeth: Codeunit "GetMediaOrphans Meth TPTE";
            //     begin
            //         GetTenantMediaOrphansMeth.GetTenantMediaOrphans();
            //     end;
            // }
            action(SelectAll)
            {
                Caption = 'Select All';
                Image = SelectMore;
                ToolTip = 'Executes the SelectAll action.';
                trigger OnAction()
                begin
                    Rec.ModifyAll(Select, true, false);
                end;
            }
            action(UnSelectAll)
            {
                Caption = 'Unselect All';
                Image = Undo;
                ToolTip = 'Executes the UnSelectAll action.';
                trigger OnAction()
                begin
                    Rec.ModifyAll(Select, false, false);
                end;
            }
            action(DeleteSelected)
            {
                Caption = 'Delete Selected';
                Image = DeleteRow;
                ToolTip = 'Executes the Delete Selected action.';
                trigger OnAction()
                var
                    DeleteOrphansMethSYSD: Codeunit "DeleteOrphans Meth TPTE";
                begin
                    if not Confirm('Are you sure? Make sure you have a backup!', false) then exit;

                    DeleteOrphansMethSYSD.DeleteSelected();
                end;
            }
        }
        area(Promoted)
        {
            // actionref(GetOrphansRef; GetOrphans) { }
            group(SelectRecords)
            {
                ShowAs = SplitButton;
                actionref(SelectAllRef; SelectAll) { Visible = true; }
                actionref(UnSelectAllRef; UnSelectAll) { Visible = true; }
            }
            actionref(DeleteSelectedRef; DeleteSelected) { Visible = true; }
        }
    }
}