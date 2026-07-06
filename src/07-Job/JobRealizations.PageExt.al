pageextension 83934 "Job Realizations TPTE" extends "Job Realizations CBLC"
{
    actions
    {
        addlast(Processing)
        {
            group(TextExtTPTE)
            {
                Caption = 'Test Ext.';

                action(CreateRealizationTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Create realization';
                    Image = Recalculate;
                    ToolTip = 'Create realization.';

                    trigger OnAction()
                    begin
                        CreateJobRealizationTPTE();
                    end;
                }
                action(CreateRealizationWithTravelTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Create realization with travel';
                    Image = Recalculate;
                    ToolTip = 'Create realization with travel.';

                    trigger OnAction()
                    begin
                        UpdateRealizationWithTravelTPTE();
                    end;
                }
            }
        }

        addlast(Promoted)
        {
            group(TestExtTPTE_Promoted)
            {
                Caption = 'Test Ext.';
                Image = TestReport;

                actionref(CreateRealizationTPTE_Promoted; CreateRealizationTPTE) { }
                actionref(CreateRealizationWithTravelTPTE_Promoted; CreateRealizationWithTravelTPTE) { }
            }
        }
    }

    var
        JobRealizationHelper: Codeunit "Job Realization Helper TPTE";

    trigger OnOpenPage()
    begin
        CurrPage.Editable := true;
    end;

    local procedure CreateJobRealizationTPTE()
    // var
    //     JobPlanLineCBLC: Record "Job Plan. Line CBLC";
    //     JobPlanningLine: Record "Job Planning Line";
    //     ResourceGroup: Record "Resource Group";
    //     LibraryJobLIB: Codeunit "Library - Job LIB";
    //     ResourceGroupNo: Code[20];
    begin
        JobRealizationHelper.CreateJobRealization(Rec);
        // JobPlanningLine.Get(Rec.GetFilter("Job No."), Rec.GetFilter("Job Task No."), Rec.GetFilter("Job Planning Line No."));

        // JobPlanLineCBLC.SetRange("Job No.", JobPlanningLine."Job No.");
        // JobPlanLineCBLC.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
        // JobPlanLineCBLC.SetRange("Job Planning Line No.", JobPlanningLine."Line No.");
        // JobPlanLineCBLC.FindFirst();

        // ResourceGroupNo := JobPlanLineCBLC."Resource Group No.";
        // ResourceGroup.Get(ResourceGroupNo);

        // LibraryJobLIB.InitJobRealization(JobPlanningLine, Rec, ResourceGroup);
        // Rec.Insert(true);

        // //KM
        // //        SalesRealizationCBLC.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0));

        // //Work
        // Rec.Validate("Work Starting Date Time", JobPlanLineCBLC."Starting Date Time");
        // Rec.Validate("Work Ending Date Time", JobPlanLineCBLC."Ending Date Time");

        // Rec.Modify(true);
        // // LibrarySalesLIB.SetSalesRealizationToProcessed(SalesRealizationCBLC);
    end;

    local procedure UpdateRealizationWithTravelTPTE()
    // var
    //     EndDateTime, StartDateTime : DateTime;
    begin
        JobRealizationHelper.UpdateRealizationWithTravel(Rec);
        // CreateJobRealizationTPTE();
        // StartDateTime := CreateDateTime(Today(), 060000T);
        // EndDateTime := CreateDateTime(Today(), 080000T);

        // Rec.Validate("Travel Starting Date Time", StartDateTime);
        // Rec.Validate("Travel Ending Date Time", EndDateTime);
        // Rec.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0));

        // StartDateTime := CreateDateTime(Today(), 100000T);
        // EndDateTime := CreateDateTime(Today(), 130000T);
        // Rec.Validate("Work Starting Date Time", StartDateTime);
        // Rec.Validate("Work Ending Date Time", EndDateTime);

        // Rec.Modify(true);
    end;
}