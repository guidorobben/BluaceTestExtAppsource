codeunit 83865 "Job Realization Helper TPTE"
{
    Permissions =
        tabledata "Job Plan. Line CBLC" = R,
        tabledata "Job Planning Line" = R,
        tabledata "Job Realization CBLC" = RIM,
        tabledata "Resource Group" = R;

    var
        LibraryRandom: Codeunit "Library - Random";

    procedure CreateJobRealization(var JobRealizationCBLC: Record "Job Realization CBLC")
    var
        JobPlanLineCBLC: Record "Job Plan. Line CBLC";
        JobPlanningLine: Record "Job Planning Line";
        ResourceGroup: Record "Resource Group";
        LibraryJobLIB: Codeunit "Library - Job LIB";
        ResourceGroupNo: Code[20];
    begin
        GetJobPlanningLine(JobPlanningLine, JobRealizationCBLC);
        // JobPlanningLine.Get(JobRealizationCBLC.GetFilter("Job No."), JobRealizationCBLC.GetFilter("Job Task No."), JobRealizationCBLC.GetFilter("Job Planning Line No."));

        JobPlanLineCBLC.SetRange("Job No.", JobPlanningLine."Job No.");
        JobPlanLineCBLC.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
        JobPlanLineCBLC.SetRange("Job Planning Line No.", JobPlanningLine."Line No.");
        JobPlanLineCBLC.FindFirst();

        ResourceGroupNo := JobPlanLineCBLC."Resource Group No.";
        ResourceGroup.Get(ResourceGroupNo);

        LibraryJobLIB.InitJobRealization(JobPlanningLine, JobRealizationCBLC, ResourceGroup);
        JobRealizationCBLC.Insert(true);

        //KM
        //        SalesRealizationCBLC.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0));

        //Work
        JobRealizationCBLC.Validate("Work Starting Date Time", JobPlanLineCBLC."Starting Date Time");
        JobRealizationCBLC.Validate("Work Ending Date Time", JobPlanLineCBLC."Ending Date Time");

        JobRealizationCBLC.Modify(true);
        // LibrarySalesLIB.SetSalesRealizationToProcessed(SalesRealizationCBLC);
    end;

    procedure UpdateRealizationWithTravel(var JobRealizationCBLC: Record "Job Realization CBLC")
    var
        EndDateTime, StartDateTime : DateTime;
    begin
        CreateJobRealization(JobRealizationCBLC);
        StartDateTime := CreateDateTime(Today(), 060000T);
        EndDateTime := CreateDateTime(Today(), 080000T);

        JobRealizationCBLC.Validate("Travel Starting Date Time", StartDateTime);
        JobRealizationCBLC.Validate("Travel Ending Date Time", EndDateTime);
        JobRealizationCBLC.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0));

        StartDateTime := CreateDateTime(Today(), 100000T);
        EndDateTime := CreateDateTime(Today(), 130000T);
        JobRealizationCBLC.Validate("Work Starting Date Time", StartDateTime);
        JobRealizationCBLC.Validate("Work Ending Date Time", EndDateTime);

        JobRealizationCBLC.Modify(true);
    end;

    procedure GetJobPlanningLine(var JobPlanningLine: Record "Job Planning Line"; var JobRealizationCBLC: Record "Job Realization CBLC")
    var
        LineNo: Integer;
    begin
        Evaluate(LineNo, JobRealizationCBLC.GetFilter("Job Planning Line No."));
        JobPlanningLine.Get(CopyStr(JobRealizationCBLC.GetFilter("Job No."), 1, 20), CopyStr(JobRealizationCBLC.GetFilter("Job Task No."), 1, 20), LineNo);
    end;
}
