pageextension 83852 "Job Queue Entry Card TPTE" extends "Job Queue Entry Card"
{
    actions
    {
        addlast(processing)
        {
            group(TextExtTPTE)
            {
                Caption = 'Test Ext.', Locked = true;
                Image = TestDatabase;

                action(ShowParametersTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Show RequestPage parameters';
                    ToolTip = 'Show the content of the RequestPage parameters.';

                    trigger OnAction()
                    begin
                        Message(Rec.GetXmlContent());
                    end;
                }
                action(ReportInboxTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Report Inbox';
                    RunObject = page "Report Inbox";
                }
            }
        }

        addlast(Promoted)
        {
            group(TextExtTPTE_Promoted)
            {
                Caption = 'Test Ext.', Locked = true;

                actionref(ShowParametersTPTE_Promoted; ShowParametersTPTE) { }
                actionref(ReportInboxTPTE_Promoted; ReportInboxTPTE) { }
            }
        }
    }
}