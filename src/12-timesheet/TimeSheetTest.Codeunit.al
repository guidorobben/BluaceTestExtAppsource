// QBack office
// codeunit 83927 "Time Sheet Test PTE"
// {
//     Subtype = Test;
//     TestPermissions = Disabled;
//     EventSubscriberInstance = Manual;

//     var
//         Job: Record Job;
//         JobTask: Record "Job Task";
//         // "Approver Time Sheet PZS": Page "Approver Time Sheet PZS";
//         // T: page "Time Sheet Card" 
//         Resource: Record Resource;
//         TimeSheetHeader: Record "Time Sheet Header";
//         Assert: Codeunit Assert;
//         LibraryRandom: Codeunit "Library - Random";
//         LibraryRandomBLC: Codeunit "Library - Random BLC";
//         LibraryResource: codeunit "Library - Resource";
//         LibraryTimeSheet: codeunit "Library - Time Sheet";
//         LibraryTimeSheetLIB: codeunit "Library - Time Sheet LIB";
//         // ProcessJournal: Boolean;
//         ProcessPost: Boolean;
//         JournalBatchName: Code[10];
//         JournalTemplateName: Code[20];
//         EndDate: Date;
//         StartDate: Date;
//         TotalQuantity: Decimal;


//     [Test]
//     procedure Initialize()
//     var
//         InitResourceTPTE: Codeunit "Init. Resource TPTE";
//     begin
//         InitResourceTPTE.Initialize();

//         JournalTemplateName := 'UREN';
//         JournalBatchName := 'MAAN002';
//         StartDate := 20220501D;
//         EndDate := 20220531D;

//         //Aan/uit Boeken
//         ProcessPost := true;
//     end;

//     [Test]
//     procedure FindJobAndJobTask()
//     begin
//         Job.FindFirst();

//         JobTask.SetRange("Job No.", Job."No.");
//         JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::Posting);
//         JobTask.FindFirst();

//         DeleteJobLedgerEntries();
//         DeleteJobPlanningLines();
//         DeleteJobPlanningImportLine();
//         DeleteJobJournalLines();
//     end;

//     [Test]
//     procedure GetResource1()
//     begin
//         Resource.Get('R0010');
//         LibraryTimeSheetLIB.UpdateResourceForTimeSheet(Resource);
//         UpdateResource(Resource);
//     end;

//     [Test]
//     [HandlerFunctions('ApproveTimeSheetLineToSubmit')]
//     procedure CreateTimeSheet1()
//     begin
//         SetCurrentUserToTimeSheetAdmin(true);
//         CreateTimeSheetsProper(Today(), 0);
//         SetCurrentUserToTimeSheetAdmin(false);
//     end;

//     [Test]
//     [HandlerFunctions('ConfirmProcessJobPlanningImportLine')]
//     procedure CreateJobPlanningLine1()
//     var
//         // JobPlanningLine: Record "Job Planning Line";
//         JobPlanningImportLineQPTE: Record "Job Planning Import Line QPTE";
//     begin
//         // ClearPlanningLines();
//         CreateJobPlanningImportLine(JobPlanningImportLineQPTE);
//         CreateJobPlanningImportLineNotBillable('');
//         ProcessJobPlanningImportLine();
//         // CreateJobPlanningLine(JobPlanningLine);
//     end;

//     [Test]
//     procedure GetResource2()
//     begin
//         Resource.Get('R0030');
//         LibraryTimeSheetLIB.UpdateResourceForTimeSheet(Resource);
//         UpdateResource(Resource);
//         TotalQuantity := 0;
//     end;

//     [Test]
//     [HandlerFunctions('ApproveTimeSheetLineToSubmit')]
//     procedure CreateTimeSheets2()
//     begin
//         SetCurrentUserToTimeSheetAdmin(true);
//         CreateTimeSheetsProper(Today(), 0);
//         SetCurrentUserToTimeSheetAdmin(false);
//     end;

//     [Test]
//     [HandlerFunctions('ConfirmProcessJobPlanningImportLine')]
//     procedure CreateJobPlanningLineMismatchQuantityToMuch()
//     var
//         JobPlanningImportLineQPTE: Record "Job Planning Import Line QPTE";
//     begin
//         // ClearPlanningLines();
//         CreateJobPlanningImportLine(JobPlanningImportLineQPTE);

//         //Teveel
//         JobPlanningImportLineQPTE.Quantity += 0.25;
//         JobPlanningImportLineQPTE.Modify(false);

//         CreateJobPlanningImportLineNotBillable('');

//         ProcessJobPlanningImportLine();
//     end;

//     [Test]
//     procedure GetResource3()
//     begin
//         Resource.Get('R0040');
//         LibraryTimeSheetLIB.UpdateResourceForTimeSheet(Resource);
//         UpdateResource(Resource);
//         TotalQuantity := 0;
//     end;

//     [Test]
//     [HandlerFunctions('ApproveTimeSheetLineToSubmit')]
//     procedure CreateTimeSheets3()
//     begin
//         SetCurrentUserToTimeSheetAdmin(true);
//         CreateTimeSheetsWrong();
//         SetCurrentUserToTimeSheetAdmin(false);
//     end;

//     [Test]
//     [HandlerFunctions('ConfirmProcessJobPlanningImportLine')]
//     procedure CreateJobPlanningLine3()
//     var
//         // JobPlanningLine: Record "Job Planning Line";
//         JobPlanningImportLineQPTE: Record "Job Planning Import Line QPTE";
//     begin
//         // ClearPlanningLines();
//         CreateJobPlanningImportLine(JobPlanningImportLineQPTE);
//         CreateJobPlanningImportLineNotBillable('');
//         ProcessJobPlanningImportLine();
//         // CreateJobPlanningLine(JobPlanningLine);
//     end;

//     [Test]
//     procedure GetResource4()
//     begin
//         Resource.Get('R0050');
//         LibraryTimeSheetLIB.UpdateResourceForTimeSheet(Resource);
//         UpdateResource(Resource);
//         TotalQuantity := 0;
//     end;

//     [Test]
//     [HandlerFunctions('ApproveTimeSheetLineToSubmit')]
//     procedure CreateTimeSheets4()
//     begin
//         SetCurrentUserToTimeSheetAdmin(true);
//         CreateTimeSheetsProper(Today(), 0);
//         SetCurrentUserToTimeSheetAdmin(false);
//     end;

//     [Test]
//     [HandlerFunctions('ConfirmProcessJobPlanningImportLine')]
//     procedure CreateJobPlanningLineMismatchQuantityTooFew()
//     var
//         JobPlanningImportLineQPTE: Record "Job Planning Import Line QPTE";
//         JobPlanningLine: Record "Job Planning Line";
//     begin
//         CreateJobPlanningImportLine(JobPlanningImportLineQPTE);

//         //Teveel
//         JobPlanningImportLineQPTE.Quantity -= 0.25;
//         JobPlanningImportLineQPTE.Modify(false);

//         CreateJobPlanningImportLineNotBillable('');

//         ProcessJobPlanningImportLine();
//     end;

//     [Test]
//     procedure GetResource5()
//     begin
//         Resource.Get('R0060');
//         LibraryTimeSheetLIB.UpdateResourceForTimeSheet(Resource);
//         UpdateResource(Resource);
//         TotalQuantity := 0;
//     end;

//     [Test]
//     [HandlerFunctions('ApproveTimeSheetLineToSubmit')]
//     procedure CreateTimeSheets5()
//     begin
//         SetCurrentUserToTimeSheetAdmin(true);
//         CreateTimeSheetsProper(20220301D, 8);
//         SetCurrentUserToTimeSheetAdmin(false);
//     end;

//     [Test]
//     procedure ChangeJob()
//     begin
//         Job.Get('JOB00020');

//         // JobTask.SetRange("Job No.", Job."No.");
//         // JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::Posting);
//         // JobTask.FindFirst();
//         Jobtask.Get(Job."No.", '200');

//         DeleteJobLedgerEntries();
//         DeleteJobPlanningLines();
//         DeleteJobPlanningImportLine();
//         DeleteJobJournalLines();
//     end;

//     [Test]
//     procedure GetResource6()
//     begin
//         Resource.Get('R0070');
//         LibraryTimeSheetLIB.UpdateResourceForTimeSheet(Resource);
//         UpdateResource(Resource);
//         TotalQuantity := 0;

//     end;

//     [Test]
//     [HandlerFunctions('ApproveTimeSheetLineToSubmit')]
//     procedure CreateTimeSheets6()
//     begin
//         SetCurrentUserToTimeSheetAdmin(true);
//         CreateTimeSheetsProper(20220201D, 8);
//         SetCurrentUserToTimeSheetAdmin(false);
//     end;

//     [Test]
//     [HandlerFunctions('ConfirmProcessJobPlanningImportLine')]
//     procedure CreateJobPlanningLine6()
//     var
//         JobPlanningImportLineQPTE: Record "Job Planning Import Line QPTE";
//     begin
//         CreateJobPlanningImportLine(JobPlanningImportLineQPTE);
//         CreateJobPlanningImportLineNotBillable('300');
//         ProcessJobPlanningImportLine();
//     end;

//     [Test]
//     procedure GetResource7()
//     begin
//         Resource.Get('R0080');
//         LibraryTimeSheetLIB.UpdateResourceForTimeSheet(Resource);
//         UpdateResource(Resource);
//         TotalQuantity := 0;
//     end;

//     [Test]
//     [HandlerFunctions('ApproveTimeSheetLineToSubmit')]
//     procedure CreateTimeSheets7()
//     begin
//         SetCurrentUserToTimeSheetAdmin(true);
//         CreateTimeSheetsCorrection(20220201D, 8);
//         SetCurrentUserToTimeSheetAdmin(false);
//     end;

//     [Test]
//     [HandlerFunctions('ConfirmProcessJobPlanningImportLine')]
//     procedure CreateJobPlanningLine7()
//     var
//         JobPlanningImportLineQPTE: Record "Job Planning Import Line QPTE";
//     begin
//         CreateJobPlanningImportLine(JobPlanningImportLineQPTE);
//         CreateJobPlanningImportLineNotBillable('300');
//         ProcessJobPlanningImportLine();
//     end;

//     //Process
//     // [Test]
//     // [HandlerFunctions('RunAutoTimeSheetReportRequestPageHandlerPreview')]
//     // procedure RunAutoTimeSheetReportPreview()
//     // var
//     //     AutoTimeSheetApprovalQPTE: Report "Auto. Time Sheet Approval QPTE";
//     // begin
//     //     AutoTimeSheetApprovalQPTE.RunModal();
//     // end;

//     // [Test]
//     // procedure TestAutoTimeSheetReportPreviewResult()
//     // var
//     //     JobJournalLine: Record "Job Journal Line";
//     //     JobLedgerEntry: Record "Job Ledger Entry";
//     // begin
//     //     JobJournalLine.SetRange("Journal Template Name", JournalTemplateName);
//     //     JobJournalLine.SetRange("Journal Batch Name", JournalBatchName);
//     //     Assert.IsTrue(JobJournalLine.IsEmpty, 'Job Journal must be empty');

//     //     JobLedgerEntry.SetRange("Source Code", JournalTemplateName);
//     //     JobLedgerEntry.SetRange("Journal Batch Name", JournalBatchName);
//     //     Assert.IsTrue(JobLedgerEntry.IsEmpty, 'Job Ledger Entries must be empty');
//     // end;

//     // [Test]
//     // [HandlerFunctions('RunAutoTimeSheetReportRequestPageHandlerPrint')]
//     // procedure RunAutoTimeSheetReportPrint()
//     // var
//     //     AutoTimeSheetApprovalQPTE: Report "Auto. Time Sheet Approval QPTE";
//     // begin
//     //     // if not ProcessPost then
//     //     //     exit;

//     //     AutoTimeSheetApprovalQPTE.RunModal();
//     // end;

//     // [Test]
//     // procedure TestAutoTimeSheetReportPreviewResultPrint()
//     // var
//     //     JobJournalLine: Record "Job Journal Line";
//     //     JobLedgerEntry: Record "Job Ledger Entry";
//     //     Resource: Record Resource;
//     //     TimeSheetDetail: Record "Time Sheet Detail";
//     //     TimeSheetHeader: Record "Time Sheet Header";
//     // begin
//     //     if not ProcessPost then
//     //         exit;

//     //     TimeSheetHeader.SetRange("Starting Date", StartDate, EndDate);
//     //     if TimeSheetHeader.FindSet() then
//     //         repeat
//     //             TimeSheetDetail.SetRange("Time Sheet No.", TimeSheetHeader."No.");
//     //             TimeSheetDetail.SetRange("Job Task No.", JobTask."Job Task No.");

//     //             if TimeSheetDetail.FindSet() then
//     //                 repeat
//     //                     //JJL
//     //                     JobJournalLine.SetRange("Journal Template Name", JournalTemplateName);
//     //                     JobJournalLine.SetRange("Journal Batch Name", JournalBatchName);
//     //                     JobJournalLine.SetRange("Job No.", JobTask."Job No.");
//     //                     JobJournalLine.SetRange("Job Task No.", JobTask."Job Task No.");
//     //                     JobJournalLine.SetRange(Type, JobJournalLine.Type::Resource);
//     //                     JobJournalLine.SetRange("No.", TimeSheetHeader."Resource No.");
//     //                     JobJournalLine.SetRange("Posting Date", TimeSheetDetail.Date);
//     //                     if JobJournalLine.FindFirst() then //TODO 
//     //                         Assert.AreEqual(TimeSheetDetail.Quantity, JobJournalLine.Quantity, 'Qty: Times Sheet Detail & Job Journal Line not the same\\');

//     //                     //JLE
//     //                     JobLedgerEntry.SetRange("Source Code", JournalTemplateName);
//     //                     JobLedgerEntry.SetRange("Journal Batch Name", JournalBatchName);
//     //                     JobLedgerEntry.SetRange("Job No.", JobTask."Job No.");
//     //                     JobLedgerEntry.SetRange("Job Task No.", JobTask."Job Task No.");
//     //                     JobLedgerEntry.SetRange(Type, JobJournalLine.Type::Resource);
//     //                     JobLedgerEntry.SetRange("No.", TimeSheetHeader."Resource No.");
//     //                     JobLedgerEntry.SetRange("Posting Date", TimeSheetDetail.Date);
//     //                     if JobLedgerEntry.FindFirst() then //TODO 
//     //                         Assert.AreEqual(TimeSheetDetail.Quantity, JobLedgerEntry.Quantity, StrSubstNo('Qty: Times Sheet Detail & Job Ledger Entry not the same\\%1 %2', TimeSheetDetail.Date, Resource."No."));

//     //                 until TimeSheetDetail.Next() = 0;
//     //         until Resource.Next() = 0;
//     // end;

//     procedure GenerateRandomTimeSheetHours() Hours: Decimal
//     begin
//         Hours := LibraryRandom.RanddecInRange(5, 8, 2);
//         Hours := Round(Hours, 0.25, '>');
//     end;

//     procedure ClearTimeSheet(TimeSheetHeader: Record "Time Sheet Header");
//     var
//         TimeSheetLine: Record "Time Sheet Line";
//     begin
//         TimeSheetLine.SetRange("Time Sheet No.", TimeSheetHeader."No.");
//         TimeSheetLine.ModifyAll(Status, TimeSheetLine.Status::Open);
//         TimeSheetLine.DeleteAll(true);
//     end;

//     procedure CreateTimeSheetLinesProper(TimeSheetHours: Decimal)
//     var
//         TimeSheetLine: Record "Time Sheet Line";
//         Send: Boolean;
//         LineDate: Date;
//         MonthDate: Date;
//         TimeSheetLineType: Enum "Time Sheet Line Type";
//         I: Integer;
//         Hours: Decimal;
//     begin
//         MonthDate := CalcDate('<-CM>', TimeSheetHeader."Starting Date");

//         //for I := 1 to 1 do begin
//         Clear(TimeSheetLine);
//         LibraryTimeSheetLIB.CreateTimeSheetLine(TimeSheetHeader, TimeSheetLine, TimeSheetLineType::Job, Job."No.", JobTask."Job Task No.");
//         LineDate := TimeSheetHeader."Starting Date" - 1;
//         Send := true;

//         for I := 1 to 5 do begin
//             LineDate += 1;
//             Hours := TimeSheetHours;
//             if Hours = 0 then
//                 Hours := GenerateRandomTimeSheetHours();

//             if MonthDate <> CalcDate('<-CM>', LineDate) then begin
//                 TimeSheetLine.CalcFields("Total Quantity");
//                 TotalQuantity += TimeSheetLine."Total Quantity";
//                 // TimeSheetLine.Validate(Status, TimeSheetLine.Status::Approved);
//                 LibraryTimeSheetLIB.SetTimeSheetLineToSubmitted(TimeSheetLine);
//                 TimeSheetLine.Modify(true);
//                 Send := false;

//                 //New Line
//                 LibraryTimeSheetLIB.CreateTimeSheetLine(TimeSheetHeader, TimeSheetLine, TimeSheetLineType::Job, Job."No.", JobTask."Job Task No.");
//                 MonthDate := CalcDate('<-CM>', LineDate);
//             end;
//             LibraryTimeSheet.CreateTimeSheetDetail(TimeSheetLine, LineDate, Hours);
//         end;

//         if Send then begin
//             LibraryTimeSheetLIB.SetTimeSheetLineToSubmitted(TimeSheetLine);
//             // TimeSheetLine.Validate(Status, TimeSheetLine.Status::Approved);
//             // TimeSheetLine.Modify(true);

//             TimeSheetLine.CalcFields("Total Quantity");
//             TotalQuantity += TimeSheetLine."Total Quantity";
//         end;
//     end;

//     procedure CreateTimeSheetLinesCorrection(TimeSheetHours: Decimal)
//     var
//         TimeSheetLine: Record "Time Sheet Line";
//         Send: Boolean;
//         LineDate: Date;
//         MonthDate: Date;
//         TimeSheetLineType: Enum "Time Sheet Line Type";
//         I: Integer;
//         Hours: Decimal;
//     begin
//         MonthDate := CalcDate('<-CM>', TimeSheetHeader."Starting Date");

//         //for I := 1 to 1 do begin
//         Clear(TimeSheetLine);
//         LibraryTimeSheetLIB.CreateTimeSheetLine(TimeSheetHeader, TimeSheetLine, TimeSheetLineType::Job, Job."No.", JobTask."Job Task No.");
//         LineDate := TimeSheetHeader."Starting Date" - 1;
//         Send := true;

//         for I := 1 to 5 do begin
//             LineDate += 1;
//             Hours := TimeSheetHours;
//             if Hours = 0 then
//                 Hours := GenerateRandomTimeSheetHours();

//             if MonthDate <> CalcDate('<-CM>', LineDate) then begin
//                 TimeSheetLine.CalcFields("Total Quantity");
//                 TotalQuantity -= TimeSheetLine."Total Quantity";
//                 // TimeSheetLine.Validate(Status, TimeSheetLine.Status::Approved);
//                 LibraryTimeSheetLIB.SetTimeSheetLineToSubmitted(TimeSheetLine);
//                 TimeSheetLine.Modify(true);
//                 Send := false;

//                 //New Line
//                 LibraryTimeSheetLIB.CreateTimeSheetLine(TimeSheetHeader, TimeSheetLine, TimeSheetLineType::Job, Job."No.", JobTask."Job Task No.");
//                 MonthDate := CalcDate('<-CM>', LineDate);
//             end;
//             LibraryTimeSheet.CreateTimeSheetDetail(TimeSheetLine, LineDate, -Hours);
//         end;

//         if Send then begin
//             LibraryTimeSheetLIB.SetTimeSheetLineToSubmitted(TimeSheetLine);
//             // TimeSheetLine.Validate(Status, TimeSheetLine.Status::Approved);
//             // TimeSheetLine.Modify(true);

//             TimeSheetLine.CalcFields("Total Quantity");
//             TotalQuantity += TimeSheetLine."Total Quantity";
//         end;
//     end;

//     procedure CreateTimeSheetLinesWrong(TimeSheetHours: Decimal)
//     var
//         TimeSheetLine: Record "Time Sheet Line";
//         Send: Boolean;
//         LineDate: Date;
//         MonthDate: Date;
//         TimeSheetLineType: Enum "Time Sheet Line Type";
//         I: Integer;
//         Hours: Decimal;
//     begin
//         MonthDate := CalcDate('<+3D-CM>', TimeSheetHeader."Starting Date");

//         //for I := 1 to 1 do begin
//         Clear(TimeSheetLine);
//         LibraryTimeSheetLIB.CreateTimeSheetLine(TimeSheetHeader, TimeSheetLine, TimeSheetLineType::Job, Job."No.", JobTask."Job Task No.");
//         LineDate := TimeSheetHeader."Starting Date" - 1;
//         Send := true;

//         for I := 1 to 5 do begin
//             LineDate += 1;
//             Hours := TimeSheetHours;
//             if hours = 0 then
//                 Hours := GenerateRandomTimeSheetHours();
//             //New Line
//             // LibraryTimeSheetBLC.CreateTimeSheetLine(TimeSheetHeader, TimeSheetLine, TimeSheetLineType::Job, Job."No.", JobTask."Job Task No.");
//             // MonthDate := CalcDate('<-CM>', LineDate);
//             LibraryTimeSheet.CreateTimeSheetDetail(TimeSheetLine, LineDate, Hours);
//         end;

//         TimeSheetLine.CalcFields("Total Quantity");
//         TotalQuantity += TimeSheetLine."Total Quantity";
//         LibraryTimeSheetLIB.SetTimeSheetLineToSubmitted(TimeSheetLine);
//         // TimeSheetLine.Validate(Status, TimeSheetLine.Status::Approved);
//         TimeSheetLine.Modify(true);

//         if Send then begin
//             //  TimeSheetLine.Validate(Status, TimeSheetLine.Status::Approved);
//             LibraryTimeSheetLIB.SetTimeSheetLineToSubmitted(TimeSheetLine);
//             TimeSheetLine.Modify(true);
//         end;
//     end;


//     procedure DeleteJobLedgerEntries()
//     var
//         JobLedgerEntry: Record "Job Ledger Entry";
//     begin
//         JobLedgerEntry.SetRange("Job No.", JobTask."Job No.");
//         JobLedgerEntry.SetRange("Job Task No.", JobTask."Job Task No.");
//         JobLedgerEntry.DeleteAll(false);
//     end;

//     procedure DeleteJobPlanningLines()
//     var
//         JobPlanningLine: Record "Job Planning Line";
//         JobUsageLink: Record "Job Usage Link";
//     begin
//         JobPlanningLine.SetRange("Job No.", Job."No.");
//         JobPlanningLine.SetRange("Job Task No.", JobTask."Job Task No.");
//         JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);
//         // JobPlanningLine.SetRange("No.", Resource."No.");
//         JobPlanningLine.DeleteAll(false);

//         //1020
//         JobPlanningLine.SetRange("Job No.", Job."No.");
//         JobPlanningLine.SetRange("Job Task No.", '1020');
//         JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);
//         // JobPlanningLine.SetRange("No.", Resource."No.");
//         JobPlanningLine.DeleteAll(false);

//         JobPlanningLine.SetRange("Job No.", Job."No.");
//         JobPlanningLine.SetRange("Job Task No.", '300');
//         JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);
//         JobPlanningLine.DeleteAll(false);

//         JobUsageLink.SetRange("Job No.", JobTask."Job No.");
//         JobUsageLink.SetRange("Job Task No.", JobTask."Job Task No.");
//         JobUsageLink.DeleteAll(true);
//     end;

//     procedure DeleteJobPlanningImportLine()
//     var
//         JobPlanningImportLineQPTE: Record "Job Planning Import Line QPTE";
//     begin
//         JobPlanningImportLineQPTE.DeleteAll(true);
//     end;


//     procedure DeleteJobJournalLines()
//     var
//         JobJournalLine: Record "Job Journal Line";
//     begin
//         JobJournalLine.SetRange("Journal Template Name", JournalTemplateName);
//         JobJournalLine.SetRange("Journal Batch Name", JournalBatchName);
//         JobJournalLine.DeleteAll(true);
//     end;

//     procedure CreateTimeSheetsProper(StartingDate: Date; TimeSheetHours: Decimal)
//     var
//         StartDate: Date;
//         I: Integer;
//     begin
//         StartDate := CalcDate('<-CM-CW>', StartingDate);
//         LibraryTimeSheetLIB.CreateTimeSheetForResource(TimeSheetHeader, Resource, StartDate);
//         ClearTimeSheet(TimeSheetHeader);
//         CreateTimeSheetLinesProper(TimeSheetHours);

//         for I := 1 to 4 do begin
//             StartDate := CalcDate('<+1W>', StartDate);
//             LibraryTimeSheetLIB.CreateTimeSheetForResource(TimeSheetHeader, Resource, StartDate);
//             ClearTimeSheet(TimeSheetHeader);
//             CreateTimeSheetLinesProper(TimeSheetHours);
//         end;
//     end;

//     procedure CreateTimeSheetsCorrection(StartingDate: Date; TimeSheetHours: Decimal)
//     var
//         StartDate: Date;
//         I: Integer;
//     begin
//         StartDate := CalcDate('<-CM-CW>', StartingDate);
//         LibraryTimeSheetLIB.CreateTimeSheetForResource(TimeSheetHeader, Resource, StartDate);
//         ClearTimeSheet(TimeSheetHeader);
//         CreateTimeSheetLinesProper(TimeSheetHours);
//         CreateTimeSheetLinesCorrection(TimeSheetHours);

//         for I := 1 to 4 do begin
//             StartDate := CalcDate('<+1W>', StartDate);
//             LibraryTimeSheetLIB.CreateTimeSheetForResource(TimeSheetHeader, Resource, StartDate);
//             ClearTimeSheet(TimeSheetHeader);
//             CreateTimeSheetLinesProper(TimeSheetHours);
//         end;
//     end;

//     procedure CreateTimeSheetsWrong()
//     var
//         StartDate: Date;
//         I: Integer;
//     begin
//         StartDate := CalcDate('<-CM-CW>', Today);
//         LibraryTimeSheetLIB.CreateTimeSheetForResource(TimeSheetHeader, Resource, StartDate);
//         ClearTimeSheet(TimeSheetHeader);
//         CreateTimeSheetLinesWrong(0);

//         for I := 1 to 4 do begin
//             StartDate := CalcDate('<+1W>', StartDate);
//             LibraryTimeSheetLIB.CreateTimeSheetForResource(TimeSheetHeader, Resource, StartDate);
//             ClearTimeSheet(TimeSheetHeader);
//             CreateTimeSheetLinesWrong(0);
//         end;
//     end;

//     procedure CreateJobPlanningImportLine(var JobPlanningImportLineQPTE: Record "Job Planning Import Line QPTE")
//     var
//         StartDate: Date;
//     begin
//         StartDate := TimeSheetHeader."Starting Date";

//         JobPlanningImportLineQPTE.Init();
//         JobPlanningImportLineQPTE.Validate("Resource No.", Resource."No.");
//         JobPlanningImportLineQPTE.Validate("Job No.", JobTask."Job No.");
//         JobPlanningImportLineQPTE.Validate("Job Task No.", JobTask."Job Task No.");
//         JobPlanningImportLineQPTE.Validate(Date, (StartDate + 5));
//         JobPlanningImportLineQPTE.Validate(Quantity, TotalQuantity);
//         JobPlanningImportLineQPTE.Validate("Realization Date", CalcDate('<+CM>', StartDate)); //Einde van de maand
//         JobPlanningImportLineQPTE.Description := 'Hours for period: ' + Format(JobPlanningImportLineQPTE."Realization Date");

//         JobPlanningImportLineQPTE.Insert(True);
//         JobPlanningImportLineQPTE.Status := JobPlanningImportLineQPTE.Status::Checked;
//         JobPlanningImportLineQPTE.Modify(false);
//     end;

//     procedure CreateJobPlanningImportLineNotBillable(JobTaskNo: Code[20])
//     var
//         JobPlanningImportLineQPTE: Record "Job Planning Import Line QPTE";
//         StartDate: Date;
//     begin
//         StartDate := TimeSheetHeader."Starting Date";
//         if JobTaskNo = '' then
//             JobTaskNo := '1020';


//         JobPlanningImportLineQPTE.Init();
//         JobPlanningImportLineQPTE.Validate("Resource No.", Resource."No.");
//         JobPlanningImportLineQPTE.Validate("Job No.", JobTask."Job No.");

//         JobPlanningImportLineQPTE.Validate("Job Task No.", JobTaskNo);
//         JobPlanningImportLineQPTE.Validate(Date, (StartDate + 5));
//         JobPlanningImportLineQPTE.Validate(Quantity, TotalQuantity - 10);
//         JobPlanningImportLineQPTE.Validate("Realization Date", CalcDate('<+CM>', StartDate)); //Einde van de maand
//         JobPlanningImportLineQPTE.Description := 'Not Billable: ' + Format(JobPlanningImportLineQPTE."Realization Date");

//         JobPlanningImportLineQPTE.Insert(True);
//         JobPlanningImportLineQPTE.Status := JobPlanningImportLineQPTE.Status::Checked;
//         JobPlanningImportLineQPTE.Modify(false);
//     end;

//     procedure SetCurrentUserToTimeSheetAdmin(SetToAdmin: Boolean);
//     var
//         UserSetup: Record "User Setup";
//     begin
//         UserSetup.Get(UserId);
//         UserSetup.Validate("Time Sheet Admin.", SetToAdmin);
//         UserSetup.Modify(true);
//     end;

//     procedure UpdateResource(var Resource: Record Resource)
//     begin
//         if Resource."Gen. Prod. Posting Group" = '' then
//             Resource."Gen. Prod. Posting Group" := 'DIENSTEN';

//         if Resource.Name in ['', ' '] then
//             Resource.Name := LibraryRandomBLC.FindFirstNameRandom() + ' ' + LibraryRandomBLC.FindLastNameRandom();

//         Resource.Modify();
//     end;

//     [HandlerFunctions('ConfirmProcessJobPlanningImportLine')]
//     procedure ProcessJobPlanningImportLine()
//     var
//         ProcJobPlLinesMethQPTE: Codeunit "Proc. Job Pl. Lines Meth QPTE";
//     begin
//         ProcJobPlLinesMethQPTE.ProcessJobPlanningImportLines();
//     end;

//     [ConfirmHandler]
//     procedure ConfirmProcessJobPlanningImportLine(Question: Text[1024]; var Reply: Boolean)
//     begin
//         Reply := true;
//     end;


//     [ConfirmHandler]
//     procedure ApproveTimeSheetLineToSubmit(Question: Text[1024]; var Reply: Boolean)
//     begin
//         Reply := true;
//     end;

//     [RequestPageHandler]
//     procedure RunAutoTimeSheetReportRequestPageHandlerPreview(var AutoTimeSheetApprovalQPTE: TestRequestPage "Auto. Time Sheet Approval QPTE")
//     begin
//         AutoTimeSheetApprovalQPTE."Start Date".SetValue(20220501D);
//         AutoTimeSheetApprovalQPTE."End Date".SetValue(20220531D);
//         // AutoTimeSheetApprovalQPTE."Job Journal Template Name".SetValue(JournalTemplateName);
//         AutoTimeSheetApprovalQPTE."Job Journal Batch Name".SetValue(JournalBatchName);
//         AutoTimeSheetApprovalQPTE.Preview.Invoke();
//         // Empty handler used to close the request page, default settings are used
//     end;

//     [RequestPageHandler]
//     procedure RunAutoTimeSheetReportRequestPageHandlerPrint(var AutoTimeSheetApprovalQPTE: TestRequestPage "Auto. Time Sheet Approval QPTE")
//     begin
//         AutoTimeSheetApprovalQPTE."Start Date".SetValue(20220501D);
//         AutoTimeSheetApprovalQPTE."End Date".SetValue(20220531D);
//         // AutoTimeSheetApprovalQPTE."Job Journal Template Name".SetValue(JournalTemplateName);
//         AutoTimeSheetApprovalQPTE."Job Journal Batch Name".SetValue(JournalBatchName);
//         AutoTimeSheetApprovalQPTE.Print.Invoke();
//         // Empty handler used to close the request page, default settings are used
//     end;

//     // [EventSubscriber(ObjectType::Report, Report::"Suggest Job Jnl. Lines", 'OnAfterTransferTimeSheetDetailToJobJnlLine', '', false, false)]
//     // local procedure OnAfterTransferTimeSheetDetailToJobJnlLine(var JobJournalLine: Record "Job Journal Line"; JobJournalTemplate: Record "Job Journal Template"; var TempTimeSheetLine: Record "Time Sheet Line" temporary; TimeSheetDetail: Record "Time Sheet Detail"; JobJournalBatch: Record "Job Journal Batch"; var LineNo: Integer)
//     // begin
//     //     //TODO ZO?
//     //     JobJournalLine."Line Type" := JobJournalLine."Line Type"::Billable;
//     // end;
// }
