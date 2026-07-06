// codeunit 83927 "UT Ext. Time Sheet TPTE"
// {
//     Permissions =
//         tabledata "Absence Job PZS" = R,
//         tabledata Job = RM,
//         tabledata "Job Resource PZS" = R,
//         tabledata "Job Task" = R,
//         tabledata Resource = R,
//         tabledata "Time Sheet Header" = R,
//         tabledata "Time Sheet Line" = RMD;
//     Subtype = Test;
//     TestPermissions = Disabled;

//     var
//         LibraryExtTimeSheetLIB: Codeunit "Library - Ext. Time Sheet LIB";
//         LibraryJobLIB: Codeunit "Library - Job LIB";
//         LibraryRandom: Codeunit "Library - Random";
//         LibraryTimeSheet: Codeunit "Library - Time Sheet";
//         LibraryTimeSheetLIB: Codeunit "Library - Time Sheet LIB";
//         LibraryUserLIB: Codeunit "Library - User LIB";

//     [Test]
//     procedure CreateAbseceJob()
//     var
//         // AbsenceJobPZS: Record "Absence Job PZS";
//         FirstJob: Record Job;
//         SecondJob: Record Job;
//     begin
//         // [WHEN]
//         Initialize();
//         LibraryExtTimeSheetLIB.DeleteAllJobAbsence(true);

//         // [WHEN] Create first Job
//         LibraryJobLIB.CreateJob(FirstJob);
//         FirstJob.TestField("No.");
//         FirstJob.Validate(Description, 'Absence Year 2022');
//         FirstJob.Modify(true);
//         LibraryJobLIB.SetTimeSheetApproverToUser(FirstJob, UserId());

//         // [WHEN] Create Absence Job
//         LibraryExtTimeSheetLIB.CreateAbsenceJob(FirstJob."No.", 20220101D, 20221231D);

//         // [WHEN] Create Second Job
//         LibraryJobLIB.CreateJob(SecondJob);
//         SecondJob.TestField("No.");
//         SecondJob.TestField("No.");
//         SecondJob.Validate(Description, 'Absence Year 2023');
//         SecondJob.Modify(true);
//         LibraryJobLIB.SetTimeSheetApproverToUser(SecondJob, UserId());

//         // [WHEN] Create Absence Job
//         LibraryExtTimeSheetLIB.CreateAbsenceJob(SecondJob."No.", 20230101D, 20231231D);
//     end;

//     [Test]
//     [HandlerFunctions('ConfirmHandler')]
//     procedure CreateJobAbsenceBudget()
//     var
//         AbsenceJobPZS: Record "Absence Job PZS";
//         CurrentYearJob, NextYearJob : Record Job;
//         JobPlanningLine: Record "Job Planning Line";
//         JobTask: Record "Job Task";
//         Resource: Record Resource;
//         JobPlanningLineLineType: Enum "Job Planning Line Line Type";
//         JobPlanningLineType: Enum "Job Planning Line Type";
//     begin
//         // [WHEN]
//         Initialize();
//         LibraryExtTimeSheetLIB.DeleteAllJobAbsence(true);

//         // [WHEN] Create Absence Jobs
//         CreateAbseceJob();
//         // [WHEN] Get jobs
//         AbsenceJobPZS.FindFirst();
//         CurrentYearJob.Get(AbsenceJobPZS."Job No.");

//         AbsenceJobPZS.FindLast();
//         NextYearJob.Get(AbsenceJobPZS."Job No.");

//         // [WHEN] Create Budget Job Task
//         LibraryJobLIB.CreateJobTask(CurrentYearJob, JobTask, 'FEESTDAG', 'Feestdag');
//         LibraryJobLIB.CreateJobTask(CurrentYearJob, JobTask, 'VERLOF', 'Verlof');

//         // [WHEN] Create Resources 1 And Budget
//         LibraryJobLIB.CreateResourceAsJobResource(Resource, CurrentYearJob."No.");
//         LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Resource, Resource."No.", 20220101D, 224);
//         LibraryJobLIB.CreateJobResource(Resource."No.", NextYearJob."No.");

//         // [WHEN] Create Resources 2 And Budget
//         LibraryJobLIB.CreateResourceAsJobResource(Resource, CurrentYearJob."No.");
//         LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Resource, Resource."No.", 20220101D, 224);
//         LibraryJobLIB.CreateJobResource(Resource."No.", NextYearJob."No.");

//         // [WHEN] Job Task for next year
//         LibraryJobLIB.CreateJobTask(NextYearJob, JobTask, 'FEESTDAG', 'Feestdag');
//         LibraryJobLIB.CreateJobTask(NextYearJob, JobTask, 'VERLOF', 'Verlof');

//         // [WHEN] Release job for Time Sheets
//         LibraryJobLIB.ReleaseJobForTimeSheets(CurrentYearJob);

//         //TODO [THEN] Check Budget Lines
//     end;

//     [Test]
//     procedure TransferAbsenceJob()
//     var
//         AbsenceJobPZS: Record "Absence Job PZS";
//         CurrentYearJob, NextYearJob : Record Job;
//         // JobPlanningLine: Record "Job Planning Line";
//         JobResourcePZS: Record "Job Resource PZS";
//         JobTask: Record "Job Task";
//         Resource: Record Resource;
//         // JobPlanningLineLineType: Enum "Job Planning Line Line Type";
//         // JobPlanningLineType: Enum "Job Planning Line Type";

//         TimeSheetHeader: Record "Time Sheet Header";
//     begin
//         // [WHEN] Create Budget
//         CreateJobAbsenceBudget();

//         // [WHEN] Get jobs
//         AbsenceJobPZS.FindFirst();
//         CurrentYearJob.Get(AbsenceJobPZS."Job No.");

//         AbsenceJobPZS.FindLast();
//         NextYearJob.Get(AbsenceJobPZS."Job No.");

//         // [THEN]
//         CurrentYearJob.TestField("No.");
//         NextYearJob.TestField("No.");

//         // [WHEN] Create Time Sheet For First resouce
//         // JobTask.Get(CurrentYearJob."No.", 'FEESTDAG');
//         JobResourcePZS.SetRange("Job No.", CurrentYearJob."No.");
//         JobResourcePZS.FindFirst();
//         Resource.Get(JobResourcePZS."Resource No.");

//         JobTask.Get(CurrentYearJob."No.", 'VERLOF');
//         CreateTimeSheetsProper(TimeSheetHeader, JobTask, Resource, Today(), 0);
//         // LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Resource, Resource."No.", 20220101D, 8);
//         // LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Resource, Resource."No.", 20220505D, 8);

//         // JobTask.Get(CurrentYearJob."No.", 'VERLOF');
//         // LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Resource, Resource."No.", 20220701D, 40);
//         // LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Resource, Resource."No.", 20221011D, 24);

//         // [WHEN] Create Planning Lines For Second resouce
//         // JobTask.Get(CurrentYearJob."No.", 'FEESTDAG');
//         // JobResourcePZS.SetRange("Job No.", CurrentYearJob."No.");
//         // JobResourcePZS.FindLast();
//         // Resource.Get(JobResourcePZS."Resource No.");
//         // LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Resource, Resource."No.", 20220101D, 8);
//         // LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Resource, Resource."No.", 20220505D, 8);

//         // JobTask.Get(CurrentYearJob."No.", 'VERLOF');
//         // LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Resource, Resource."No.", 20220701D, 40);
//         // LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Resource, Resource."No.", 20221011D, 24);

//         // [WHEN] Transfer Absence 2022->2023
//         // AbsenceJobPZS.FindLast();
//         // AbsenceJobPZS.TransferAbsenceJob();
//     end;

//     local procedure Initialize()
//     begin
//         //Nothing for now
//         LibraryUserLIB.AddUserSetup(UserId());
//         LibraryUserLIB.SetUserAsTimeSheetAdmin(UserId());
//     end;

//     procedure CreateTimeSheetsProper(var TimeSheetHeader: Record "Time Sheet Header"; JobTask: Record "Job Task"; Resource: Record Resource; StartingDate: Date; TimeSheetHours: Decimal)
//     var
//         StartDate: Date;
//         I: Integer;

//     begin
//         StartDate := CalcDate('<-CM-CW>', StartingDate);
//         LibraryTimeSheetLIB.CreateTimeSheetForResource(TimeSheetHeader, Resource, StartDate);
//         ClearTimeSheet(TimeSheetHeader);
//         CreateTimeSheetLinesProper(TimeSheetHeader, JobTask, TimeSheetHours);

//         for I := 1 to 4 do begin
//             StartDate := CalcDate('<+1W>', StartDate);
//             LibraryTimeSheetLIB.CreateTimeSheetForResource(TimeSheetHeader, Resource, StartDate);
//             ClearTimeSheet(TimeSheetHeader);
//             CreateTimeSheetLinesProper(TimeSheetHeader, JobTask, TimeSheetHours);
//         end;
//     end;

//     procedure CreateTimeSheetLinesProper(var TimeSheetHeader: Record "Time Sheet Header"; JobTask: Record "Job Task"; TimeSheetHours: Decimal)
//     var
//         TimeSheetLine: Record "Time Sheet Line";
//         Send: Boolean;
//         LineDate: Date;
//         MonthDate: Date;
//         Hours: Decimal;
//         TimeSheetLineType: Enum "Time Sheet Line Type";
//         I: Integer;
//     begin
//         MonthDate := CalcDate('<-CM>', TimeSheetHeader."Starting Date");

//         //for I := 1 to 1 do begin
//         Clear(TimeSheetLine);
//         LibraryTimeSheetLIB.CreateTimeSheetLine(TimeSheetHeader, TimeSheetLine, TimeSheetLineType::Job, JobTask."Job No.", JobTask."Job Task No.");
//         LineDate := TimeSheetHeader."Starting Date" - 1;
//         Send := true;

//         for I := 1 to 5 do begin
//             LineDate += 1;
//             Hours := TimeSheetHours;
//             if Hours = 0 then
//                 Hours := GenerateRandomTimeSheetHours();

//             if MonthDate <> CalcDate('<-CM>', LineDate) then begin
//                 TimeSheetLine.CalcFields("Total Quantity");
//                 // TotalQuantity += TimeSheetLine."Total Quantity";
//                 // TimeSheetLine.Validate(Status, TimeSheetLine.Status::Approved);
//                 LibraryTimeSheetLIB.SetTimeSheetLineToSubmitted(TimeSheetLine);
//                 TimeSheetLine.Modify(true);
//                 Send := false;

//                 //New Line
//                 LibraryTimeSheetLIB.CreateTimeSheetLine(TimeSheetHeader, TimeSheetLine, TimeSheetLineType::Job, JobTask."Job No.", JobTask."Job Task No.");
//                 MonthDate := CalcDate('<-CM>', LineDate);
//             end;
//             LibraryTimeSheet.CreateTimeSheetDetail(TimeSheetLine, LineDate, Hours);
//         end;

//         if Send then begin
//             LibraryTimeSheetLIB.SetTimeSheetLineToSubmitted(TimeSheetLine);
//             // TimeSheetLine.Validate(Status, TimeSheetLine.Status::Approved);
//             // TimeSheetLine.Modify(true);

//             TimeSheetLine.CalcFields("Total Quantity");
//             // TotalQuantity += TimeSheetLine."Total Quantity";
//         end;
//     end;

//     procedure GenerateRandomTimeSheetHours() Hours: Decimal
//     begin
//         Hours := LibraryRandom.RandDecInRange(5, 8, 2);
//         Hours := Round(Hours, 0.25, '>');
//     end;

//     procedure ClearTimeSheet(TimeSheetHeader: Record "Time Sheet Header")
//     var
//         TimeSheetLine: Record "Time Sheet Line";
//     begin
//         TimeSheetLine.SetRange("Time Sheet No.", TimeSheetHeader."No.");
//         TimeSheetLine.ModifyAll(Status, TimeSheetLine.Status::Open, true);
//         TimeSheetLine.DeleteAll(true);
//     end;


//     [MessageHandler]
//     procedure MessageHandler(MessageText: Text[1024])
//     begin

//     end;

//     [ConfirmHandler]
//     procedure ConfirmHandler(Question: Text[1024]; var Reply: Boolean)
//     begin
//         Reply := true;
//     end;
// }
