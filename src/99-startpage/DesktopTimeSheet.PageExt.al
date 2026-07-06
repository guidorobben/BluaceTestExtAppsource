pageextension 83963 "Desktop Time Sheet TPTE" extends "Bluace Desktop LIB"
{
    actions
    {
        addfirst(Processing)
        {
            group(TimSheetGroupTPTE)
            {
                Caption = 'Time Sheet';

                action(TimeResourcesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Resources';
                    RunObject = page "Resource List";
                }
                // action(TestTimeSheetTPTE)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Test Time Sheet';
                //     RunObject = codeunit "Time Sheet Test PTE";
                // }
                // action(TestExtTimeSheetTPTE)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Test Ext. Time Sheet';
                //     RunObject = codeunit "UT Ext. Time Sheet TPTE";
                // }
                action(TimeSheetsTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Time Sheets';
                    RunObject = page "Time Sheet List";
                }
                action(TimeSheetDetailsTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Time Sheet Details';
                    RunObject = page "Time Sheet Details TPTE";
                }
                // action(JobPlanningImportLinesTPTE)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Job Planning Import Lines';
                //     RunObject = page "Job Planning Import Lines QPTE";
                // }
                action(JobPlanningLinesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Job Planning Lines';
                    RunObject = page "Job Planning Lines";
                }
                action(AutoTimeSheetApprovalTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Auto. Time Sheet Approval';

                    trigger OnAction()
                    begin
#pragma warning disable LC0003
                        Report.Run(90000);
#pragma warning restore LC00003
                    end;
                }
                action(JobJournalTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Job Journal';
                    RunObject = page "Job Journal";
                    ToolTip = 'Show job journal.';
                }
                action(JobLedgerEntriesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Job Ledger Entries';
                    RunObject = page "Job Ledger Entries";
                    ToolTip = 'Show job ledger entries.';
                }
                // action(ApproverTimeSheetTPTE)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Approver Time Sheet';
                //     RunObject = page "Approver Time Sheet PZS";
                // }
                action(TimeSheetManagerTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Manager per Time Sheet';
                    RunObject = page "Manager Time Sheet by Job";
                }
                // action(TimeSheetTotalsResTPTE)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Time Sheet Totals Res.';

                //     trigger OnAction()
                //     var
                //         Qry: Query "Time Sheet Totals Res. QPTE";
                //     begin
                //         query.
                //     end;
                // }
            }
        }

        addfirst(Promoted)
        {
            group(TimSheetGroupTPTE_PromotedTPTE)
            {
                Caption = 'Time Sheet';
                Image = Timesheet;

                // group(TimSheetGroupTests_PromotedTPTE)
                // {
                //     Caption = 'Tests';
                //     Image = TestDatabase;

                //     actionref(TestExtTimeSheetTPTE_Promoted; TestExtTimeSheetTPTE) { }
                // }
                actionref(TimeResourcesTPTE_Promoted; TimeResourcesTPTE) { }
                actionref(TimeSheets_Promoted; TimeSheetsTPTE) { }
                actionref(TimeSheetDetails_Promoted; TimeSheetDetailsTPTE) { }
                actionref(JobPlanningLines_Promoted; JobPlanningLinesTPTE) { }
                actionref(AutoTimeSheetApproval_Promoted; AutoTimeSheetApprovalTPTE) { }
                actionref(JobJournal_Promoted; JobJournalTPTE) { }
                actionref(JobLedgerEntries_Promoted; JobLedgerEntriesTPTE) { }
                // actionref(ApproverTimeSheetTPTE_Promoted; ApproverTimeSheetTPTE) { }
                actionref(TimeSheetManagerTPTE_Promoted; TimeSheetManagerTPTE) { }
            }
        }
    }
}