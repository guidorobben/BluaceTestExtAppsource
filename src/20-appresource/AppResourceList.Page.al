page 83860 "App Resource List TPTE"
{
    ApplicationArea = All;
    Caption = 'App Resources';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "App Resource TPTE";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    StyleExpr = LineStyle;
                    Visible = false;
                }
                field("Resource Name"; Rec.Name)
                {
                    StyleExpr = LineStyle;
                }
                field(Folder; Rec.Folder) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DownloadResource)
            {
                Caption = 'Download';
                Enabled = not Rec.Folder;
                Image = Download;
                Visible = ActionsVisible;

                trigger OnAction()
                begin
                    Rec.Download();
                end;
            }
            action(LoadResources)
            {
                Caption = 'Load Resources';
                Enabled = ActionsEnabled;
                Image = Resource;
                Visible = ActionsVisible;

                trigger OnAction()
                begin
                    Rec.LoadResources();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Home';

                actionref(DownloadResource_Promoted; DownloadResource) { }
                actionref(LoadResources_Promoted; LoadResources) { }
            }
        }
    }

    var
        ActionsEnabled, ActionsVisible : Boolean;
        LineStyle: Text;

    trigger OnOpenPage()
    begin
        ActionsVisible := true;
        ActionsEnabled := true;
    end;

    trigger OnAfterGetRecord()
    begin
        SetLineStyle();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetLineStyle();
    end;

    local procedure SetLineStyle()
    begin
        LineStyle := Format(PageStyle::Standard);
        if Rec.Folder then
            LineStyle := Format(PageStyle::Strong);
    end;
}