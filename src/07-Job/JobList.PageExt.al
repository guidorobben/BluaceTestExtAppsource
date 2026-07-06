pageextension 83906 "Job List TPTE" extends "Job List"
{
    actions
    {

        addfirst("&Job")
        {
            action(JobPlanningLinesTPTE)
            {
                ApplicationArea = Jobs;
                Caption = 'Job &Planning Lines (Test Ext.)';
                Image = JobLines;
                Promoted = true;
                PromotedCategory = Category6;
#pragma warning disable AC0017
                ToolTip = 'View all planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (Budget) or you can specify what you actually agreed with your customer that he should pay for the job (Billable).';
#pragma warning restore AC0017

                trigger OnAction()
                var
                    JobPlanningLine: Record "Job Planning Line";
                    JobPlanningLines: Page "Job Planning Lines";
                begin
                    Rec.TestField("No.");
                    JobPlanningLine.FilterGroup(2);
                    JobPlanningLine.SetRange("Job No.", Rec."No.");
                    JobPlanningLine.FilterGroup(0);
                    JobPlanningLines.SetJobTaskNoVisible(true);
                    JobPlanningLines.SetTableView(JobPlanningLine);
                    JobPlanningLines.Editable := true;
                    JobPlanningLines.Run();
                end;
            }
        }
    }
}
