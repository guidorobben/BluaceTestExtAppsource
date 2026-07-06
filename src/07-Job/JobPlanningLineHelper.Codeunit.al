codeunit 83860 "Job Planning Line Helper TPTE"
{
    Permissions =
        tabledata "Job Plan. Line CBLC" = RM,
        tabledata "Job Planning Line" = RM,
        tabledata "Job Task" = R,
        tabledata "Object CBLC" = R,
        tabledata "Purch. Inv. Header" = R;

    procedure SetRemainingQyt(var JobPlanningLine: Record "Job Planning Line"; Qty: Decimal)
    begin
        JobPlanningLine."Remaining Qty." := Qty;
        JobPlanningLine.Modify(false);
    end;

    procedure OpenObjectCard(JobPlanningLine: Record "Job Planning Line")
    var
        ObjectCBLC: Record "Object CBLC";
        PageManagement: Codeunit "Page Management";
    begin
        if JobPlanningLine."Object No. CBLC" = '' then
            exit;

        ObjectCBLC.Get(JobPlanningLine."Object No. CBLC");
        PageManagement.PageRun(ObjectCBLC);
    end;

    procedure CreateLineWithPlanningAndRealization(var SourceJobPlanningLine: Record "Job Planning Line")
    var
        JobPlanLineCBLC: Record "Job Plan. Line CBLC";
        JobPlanningLine: Record "Job Planning Line";
        JobRealizationCBLC: Record "Job Realization CBLC";
        JobTask: Record "Job Task";
        LibraryJobLIB: Codeunit "Library - Job LIB";
        LibraryRandomLIB: Codeunit "Library - Random LIB";
        ResourceNo: Code[20];
        EndDateTime, StartDateTime : DateTime;
        LineType: Enum "Job Planning Line Line Type";
        Type: Enum "Job Planning Line Type";
    begin
        GetJobTask(JobTask, SourceJobPlanningLine);
        // JobTask.Get(SourceJobPlanningLine.GetFilter("Job No."), SourceJobPlanningLine.GetFilter("Job Task No."));
        LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, LineType::"Both Budget and Billable", Type::Item, 'TSERVICE1', WorkDate(), 1);
        LibraryJobLIB.GetJobPlanLine(JobPlanLineCBLC, JobPlanningLine);
        if JobPlanLineCBLC."Resource Group No." = '' then
            exit;

        ResourceNo := LibraryRandomLIB.FindResourceRandom(JobPlanLineCBLC."Resource Group No.");
        if ResourceNo <> '' then
            JobPlanLineCBLC.Validate("Resource No.", ResourceNo);

        StartDateTime := CreateDateTime(Today(), 090000T);
        EndDateTime := CreateDateTime(Today(), 110000T);
        JobPlanLineCBLC.Validate("Starting Date Time", StartDateTime);
        JobPlanLineCBLC.Validate("Ending Date Time", EndDateTime);
        JobPlanLineCBLC.Modify(true);

        StartDateTime := CreateDateTime(Today(), 073000T);
        EndDateTime := CreateDateTime(Today(), 090000T);
        LibraryJobLIB.CreateJobRealization(JobRealizationCBLC, JobPlanningLine, JobPlanLineCBLC."Starting Date Time", JobPlanLineCBLC."Ending Date Time", StartDateTime, EndDateTime, 5);
    end;

    local procedure GetJobTask(var JobTask: Record "Job Task"; var JobPlanningLine: Record "Job Planning Line")
    begin
        JobTask.Get(CopyStr(JobPlanningLine.GetFilter("Job No."), 1, 20), CopyStr(JobPlanningLine.GetFilter("Job Task No."), 1, 20));
    end;

    internal procedure OpenPostedPurchaseInvoice(JobPlanningLine: Record "Job Planning Line")
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PageManagement: Codeunit "Page Management";
    begin
        PurchInvHeader.SetRange("No.", JobPlanningLine."Document No.");
        if PurchInvHeader.FindFirst() then
            PageManagement.PageRun(PurchInvHeader);
    end;

    internal procedure OpenJobPlanningLineInvoice(JobPlanningLine: Record "Job Planning Line")
    var
        JobPlanningLineInvoice: Record "Job Planning Line Invoice";
    begin
        if JobPlanningLine."Line No." = 0 then
            exit;

        JobPlanningLine.TestField("Job No.");
        JobPlanningLine.TestField("Job Task No.");

        JobPlanningLineInvoice.SetRange("Job No.", JobPlanningLine."Job No.");
        JobPlanningLineInvoice.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
        JobPlanningLineInvoice.SetRange("Job Planning Line No.", JobPlanningLine."Line No.");
        Page.Run(Page::"Job Planning Line Invoice TPTE", JobPlanningLineInvoice);
    end;
}