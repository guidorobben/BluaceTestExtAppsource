codeunit 83864 "Job Plan. Line Helper TPTE"
{
    Permissions =
        tabledata "Job Plan. Line CBLC" = RM;

    procedure AddResourceAndStartTime(var JobPlanLineCBLC: Record "Job Plan. Line CBLC")
    var
        LibraryRandomLIB: Codeunit "Library - Random LIB";
        ResourceNo: Code[20];
        StartDateTime: DateTime;
    begin
        if JobPlanLineCBLC."Resource Group No." = '' then
            exit;

        ResourceNo := LibraryRandomLIB.FindResourceRandom(JobPlanLineCBLC."Resource Group No.");
        if ResourceNo <> '' then
            JobPlanLineCBLC.Validate("Resource No.", ResourceNo);

        StartDateTime := CreateDateTime(Today(), 090000T);
        JobPlanLineCBLC.Validate("Starting Date Time", StartDateTime);
        JobPlanLineCBLC.Modify(true);
    end;

    procedure AddStartDateTime(var JobPlanLineCBLC: Record "Job Plan. Line CBLC")
    var
        StartDateTime: DateTime;
    begin
        if JobPlanLineCBLC."Resource Group No." = '' then
            exit;

        StartDateTime := CreateDateTime(Today(), 090000T);
        JobPlanLineCBLC.Validate("Starting Date Time", StartDateTime);
        JobPlanLineCBLC.Modify(true);
    end;

    procedure AddResource(var JobPlanLineCBLC: Record "Job Plan. Line CBLC")
    var
        LibraryRandomLIB: Codeunit "Library - Random LIB";
        ResourceNo: Code[20];
    begin
        if JobPlanLineCBLC."Resource Group No." = '' then
            exit;

        ResourceNo := LibraryRandomLIB.FindResourceRandom(JobPlanLineCBLC."Resource Group No.");
        if ResourceNo <> '' then begin
            JobPlanLineCBLC.Validate("Resource No.", ResourceNo);
            JobPlanLineCBLC.Modify(true);
        end;
    end;
}
