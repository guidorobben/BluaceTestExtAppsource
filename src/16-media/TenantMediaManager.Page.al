page 83920 "Tenant Media Manager TPTE"
{
    ApplicationArea = All;
    Caption = 'Tenant Media Manager';
    PageType = List;
    SourceTable = "Tenant Media";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies a unique identifier for this media.';
                }
                field(WhereUsed; WhereUsed)
                {
                    Caption = 'Where Used';
                    ToolTip = 'Specifies the table where this record is used.';
                    Visible = IsWhereUsedVisible;

                    trigger OnAssistEdit()
                    var
                        WhereMediaUsedMeth: Codeunit "Where Media Used Meth TPTE";
                    begin
                        Message(WhereMediaUsedMeth.GetWhereUsed(Rec));
                    end;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description of the media.';
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the name of the file.';
                }
                field("Mime Type"; Rec."Mime Type")
                {
                    ToolTip = 'Specifies the file type.';
                }
                field(Width; Rec.Width)
                {
                    ToolTip = 'Specifies the value of the Width field.', Comment = '%';
                }
                field(Height; Rec.Height)
                {
                    ToolTip = 'Specifies the value of the Height field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(Content1; Rec.Content)
                {
                    ToolTip = 'Specifies the picture of the media.';
                }
            }
        }

        area(FactBoxes)
        {
            part("Media Cleanup FactBox"; "Media Cleanup FactBox")
            {
                SubPageLink = ID = field(ID);
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ToggleWhereUsed)
            {
                Caption = 'Toggle Where Used';
                Image = ToggleBreakpoint;
                ToolTip = 'Executes the Toggle Where Used action.';

                trigger OnAction()
                begin
                    IsWhereUsedVisible := not IsWhereUsedVisible;
                end;
            }
            action(GetOrphans)
            {
                Caption = 'Get Orphans';
                Image = VoidExpiredCheck;
                RunObject = page "Detached Media Cleanup";
                ToolTip = 'Searches for Orphans, displays them, for you to handle them.';

                // trigger OnAction()
                // var
                //     GetTenantMediaOrphansMeth: Codeunit "GetMediaOrphans Meth TPTE";
                // begin
                //     GetTenantMediaOrphansMeth.GetTenantMediaOrphans();

                //     page.Run(page::"Tenant Media Orphans TPTE");
                // end;
            }
            action(ShowOrphans)
            {
                Caption = 'Show Orphans';
                Image = VoidExpiredCheck;
                ToolTip = 'Shows the Orphaned records which were previously loaded.';

                trigger OnAction()
                begin
                    Page.Run(Page::"Tenant Media Orphans TPTE");
                end;
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(ToggleWhereUsed_Promoted; ToggleWhereUsed) { }
                group(Orphans)
                {
                    ShowAs = SplitButton;
                    actionref(ShowOrphans_Promoted; ShowOrphans) { }
                    actionref(GetOrphans_Promoted; GetOrphans) { }
                }
            }
        }
    }

    var

    var


        IsWhereUsedVisible: Boolean;
        WhereUsed: Text;

    trigger OnAfterGetRecord()
    var
        WhereMediaUsedFirstMeth: Codeunit "WhereMediaUsed First Meth TPTE";
    begin
        if not IsWhereUsedVisible then
            exit;

        WhereUsed := WhereMediaUsedFirstMeth.GetWhereUsedFirst(Rec);
    end;
}