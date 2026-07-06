codeunit 83920 "UT Job Realization TPTE"
{
    Permissions =
        tabledata Job = R,
        tabledata "Job Plan. Line CBLC" = RM,
        tabledata "Job Planning Line" = RM,
        tabledata "Job Realization CBLC" = RIM,
        tabledata "Job Task" = R,
        tabledata Resource = R,
        tabledata "Resource Group" = R;
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Job: Record Job;
        // SalesHeader: Record "Sales Header";
        JobPlanningLine: Record "Job Planning Line";
        JobTask: Record "Job Task";
        Resource: Record Resource;
        ResourceGroup: Record "Resource Group";
        LibraryJob: Codeunit "Library - Job";
        // LibraryTimeSheetBLC: Codeunit "Library - Time Sheet LIB";
        LibraryRandom: Codeunit "Library - Random";
        LibraryResourceLIB: Codeunit "Library - Resource LIB";
    // LibraryResource: Codeunit "Library - Resource";

    [Test]
    procedure CreatJob()
    begin
        Job.Get('P00040');
    end;

    [Test]
    procedure CreateJobPlanningLine()
    var
        LineType: Enum "Job Planning Line Line Type";
        Type: Enum "Job Planning Line Type";
    begin
        JobTask.Get(Job."No.", 'OMZET');
        LibraryJob.CreateJobPlanningLine(LineType::"Both Budget and Billable", Type::Item, JobTask, JobPlanningLine);
        JobPlanningLine.Validate("No.", '1001');
        JobPlanningLine.Validate(Quantity, 1);
        JobPlanningLine.Validate("Unit Cost", 100);
        JobPlanningLine.Modify(true);
    end;

    [Test]
    procedure UpdateJobPlanLine()
    var
    begin
        Resource.Get('ARNOUD'); //UUR  
        // Resource.Get('R0010'); //MINUUT      
        ResourceGroup.Get('MONTEURS');
        LibraryResourceLIB.CreateResourceUnitOfMeasureTravelKm(Resource);
        UpdateJobPlanLineWithResource();
    end;

    [Test]
    procedure CreateJobRealizationWithTravel()
    var
        JobRealizationCBLC: Record "Job Realization CBLC";
        WorkDate: Date;
        DT: DateTime;
        T: Time;
    begin
        InitJobRealizationCBLC(JobRealizationCBLC);
        JobRealizationCBLC.Insert(true);

        WorkDate := WorkDate();
        // LibraryTimeSheetBLC.CreateTimeSheetForResource(Resource, WorkDate);

        //Reis
        T := 090000T;
        WorkDate += 2;
        DT := CreateDateTime(WorkDate, T);
        JobRealizationCBLC.Validate("Travel Starting Date Time", DT);

        T := 104000T;
        DT := CreateDateTime(WorkDate, T);
        JobRealizationCBLC.Validate("Travel Ending Date Time", DT);

        //KM
        JobRealizationCBLC.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0));

        //Work
        T := 110000T;
        DT := CreateDateTime(WorkDate, T);
        JobRealizationCBLC.Validate("Work Starting Date Time", DT);

        T := 134000T;
        DT := CreateDateTime(WorkDate, T);
        JobRealizationCBLC.Validate("Work Ending Date Time", DT);

        JobRealizationCBLC.Modify(true);

        SetJobRealizationToProcessed(JobRealizationCBLC);
    end;

    //3
    [Test]
    procedure CreateJobPlanningLine3()
    var
        LineType: Enum "Job Planning Line Line Type";
        Type: Enum "Job Planning Line Type";
    begin
        JobTask.Get(Job."No.", 'OMZET');
        LibraryJob.CreateJobPlanningLine(LineType::"Both Budget and Billable", Type::Item, JobTask, JobPlanningLine);
        JobPlanningLine.Validate("No.", '1001');
        JobPlanningLine.Validate(Quantity, 1);
        JobPlanningLine.Validate("Unit Cost", 100);
        JobPlanningLine.Modify(true);
    end;

    [Test]
    procedure UpdateJobPlanLine3()
    var
    begin
        // Resource.Get('ARNOUD'); //UUR  
        Resource.Get('R0010'); //MINUUT      
        ResourceGroup.Get('MONTEURS');
        LibraryResourceLIB.CreateResourceUnitOfMeasureTravelKm(Resource);
        UpdateJobPlanLineWithResource();
    end;

    [Test]
    procedure CreateJobRealizationWithTravel3()
    var
        JobRealizationCBLC: Record "Job Realization CBLC";
        WorkDate: Date;
        DT: DateTime;
        T: Time;
    begin
        InitJobRealizationCBLC(JobRealizationCBLC);
        JobRealizationCBLC.Insert(true);

        WorkDate := WorkDate();
        // LibraryTimeSheetBLC.CreateTimeSheetForResource(Resource, WorkDate);

        //Reis
        T := 090000T;
        WorkDate += 1;
        DT := CreateDateTime(WorkDate, T);
        JobRealizationCBLC.Validate("Travel Starting Date Time", DT);

        T := 100000T;
        DT := CreateDateTime(WorkDate, T);
        JobRealizationCBLC.Validate("Travel Ending Date Time", DT);

        //KM
        JobRealizationCBLC.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 10, 0));

        //Work
        T := 110000T;
        DT := CreateDateTime(WorkDate, T);
        JobRealizationCBLC.Validate("Work Starting Date Time", DT);

        T := 130000T;
        DT := CreateDateTime(WorkDate, T);
        JobRealizationCBLC.Validate("Work Ending Date Time", DT);

        JobRealizationCBLC.Modify(true);

        SetJobRealizationToProcessed(JobRealizationCBLC);
    end;


    local procedure UpdateJobPlanLineWithResource()
    var
        JobPlanLineCBLC: Record "Job Plan. Line CBLC";
    begin
        JobPlanLineCBLC.SetRange("Job No.", JobPlanningLine."Job No.");
        JobPlanLineCBLC.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
        JobPlanLineCBLC.SetRange("Job Planning Line No.", JobPlanningLine."Line No.");

        JobPlanLineCBLC.FindFirst();

        JobPlanLineCBLC.Validate("Resource Group No.", ResourceGroup."No.");
        JobPlanLineCBLC.Validate("Resource No.", Resource."No.");

        JobPlanLineCBLC.Modify(true);
    end;

    local procedure InitJobRealizationCBLC(var JobRealizationCBLC: Record "Job Realization CBLC")
    begin
        JobRealizationCBLC.Init();
        JobRealizationCBLC.Validate("Job No.", JobPlanningLine."Job No.");
        JobRealizationCBLC.Validate("Job Task No.", JobPlanningLine."Job Task No.");
        JobRealizationCBLC.Validate("Job Planning Line No.", JobPlanningLine."Line No.");
        JobRealizationCBLC.Validate("Resource Group No.", ResourceGroup."No.");
    end;

    local procedure SetJobRealizationToProcessed(var JobRealizationCBLC: Record "Job Realization CBLC")
    begin
        JobRealizationCBLC.Validate("Realization Status Code", 'UITGEVOERD');
        JobRealizationCBLC.Modify(true);
    end;
}
