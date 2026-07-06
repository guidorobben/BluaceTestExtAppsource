codeunit 83914 "UT Sales Order TPTE"
{
    Permissions =
        tabledata Resource = R,
        tabledata "Resource Group" = R,
        tabledata "Sales Header" = R,
        tabledata "Sales Line" = RD,
        tabledata "Sales Plan. Line CBLC" = RM,
        tabledata "Sales Realization CBLC" = RIMD;
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Resource: Record Resource;
        ResourceGroup: Record "Resource Group";
        // SalesHeader: Record "Sales Header";
        // SalesLine: Record "Sales Line";
        LibraryRandom: Codeunit "Library - Random";
        LibraryResourceLIB: Codeunit "Library - Resource LIB";
        LibrarySales: Codeunit "Library - Sales";
        LibrarySalesLIB: Codeunit "Library - Sales LIB";
        LibraryTimeSheetLIB: Codeunit "Library - Time Sheet LIB";

    [Test]
    procedure Initialize()
    var
        // RealizationStatusCBLC: Record "Realization Status CBLC";
        InitGeneralLIB: Codeunit "Init. General LIB";
    begin
        InitGeneralLIB.InitializeRealizationStatus();
    end;

    [Test]
    procedure CreateSalesOrder()
    var
        SalesHeader: Record "Sales Header";
    begin
        //GET for now
        SalesHeader.Get(SalesHeader."Document Type"::Order, '101005');
    end;

    [Test]
    procedure DeleteSalesOrderLines()
    var
        SalesHeader: Record "Sales Header";
        DeleteSalesLine: Record "Sales Line";
    begin
        DeleteSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        DeleteSalesLine.SetRange("Document No.", SalesHeader."No.");
        DeleteSalesLine.DeleteAll(false);
    end;

    [Test]
    procedure DeleteSalesRealization()
    var
        SalesHeader: Record "Sales Header";
        SalesRealizationCBLC: Record "Sales Realization CBLC";
    begin
        SalesRealizationCBLC.SetRange("Document Type", SalesHeader."Document Type");
        SalesRealizationCBLC.SetRange("Document No.", SalesHeader."No.");
        SalesRealizationCBLC.DeleteAll(false);
    end;

    [Test]
    procedure CreateSalesOrderLine()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, Enum::"Sales Line Type"::Item, '1002', 1);
    end;

    [Test]
    procedure UpdateSalesPlanningLine()
    var
        SalesLine: Record "Sales Line";
    begin
        Resource.Get('ARNOUD'); //UUR    
        // Resource.Get('R0010'); //MINUUT    
        ResourceGroup.Get('MONTEURS');
        LibraryResourceLIB.CreateResourceUnitOfMeasureTravelKm(Resource);
        UpdateSalesPlanningLineWithResource(SalesLine);
    end;

    [Test]
    procedure CreateSalesRealizationWithoutTravel()
    var
        SalesLine: Record "Sales Line";
        SalesRealizationCBLC: Record "Sales Realization CBLC";
        DT: DateTime;
        T: Time;
    begin
        InitSalesRealizationCBLC(SalesRealizationCBLC, SalesLine);
        SalesRealizationCBLC.Insert(true);

        //Reis
        T := 090000T;
        DT := CreateDateTime(Today(), T);
        SalesRealizationCBLC.Validate("Travel Starting Date Time", DT);

        T := 100000T;
        DT := CreateDateTime(Today(), T);
        SalesRealizationCBLC.Validate("Travel Ending Date Time", DT);

        //KM
        //        SalesRealizationCBLC.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0));

        //Work
        T := 110000T;
        DT := CreateDateTime(Today(), T);
        SalesRealizationCBLC.Validate("Work Starting Date Time", DT);

        T := 130000T;
        DT := CreateDateTime(Today(), T);
        SalesRealizationCBLC.Validate("Work Ending Date Time", DT);

        SalesRealizationCBLC.Modify(true);
        LibrarySalesLIB.SetSalesRealizationToProcessed(SalesRealizationCBLC);
        //TEST                
    end;

    [Test]
    procedure CreateSalesOrderLine2()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        Clear(SalesLine);
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, Enum::"Sales Line Type"::Item, '1002', 1);
    end;

    [Test]
    procedure UpdateSalesPlanningLine2()
    var
        SalesLine: Record "Sales Line";
    begin
        Resource.Get('R0010');
        ResourceGroup.Get('MONTEURS');
        LibraryResourceLIB.CreateResourceUnitOfMeasureTravelKm(Resource);
        UpdateSalesPlanningLineWithResource(SalesLine);
    end;

    [Test]
    procedure CreateSalesRealization2()
    var
        SalesLine: Record "Sales Line";
        SalesRealizationCBLC: Record "Sales Realization CBLC";
        WorkDate: Date;
        DT: DateTime;
        T: Time;
    begin
        InitSalesRealizationCBLC(SalesRealizationCBLC, SalesLine);
        SalesRealizationCBLC.Insert(true);

        WorkDate := WorkDate();
        LibraryTimeSheetLIB.CreateTimeSheetForResource(Resource, WorkDate());

        //Reis
        T := 090000T;
        WorkDate += 1;
        DT := CreateDateTime(WorkDate, T);
        SalesRealizationCBLC.Validate("Travel Starting Date Time", DT);

        T := 104000T;
        DT := CreateDateTime(WorkDate, T);
        SalesRealizationCBLC.Validate("Travel Ending Date Time", DT);

        //KM
        SalesRealizationCBLC.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0));

        //Work
        T := 110000T;
        DT := CreateDateTime(WorkDate, T);
        SalesRealizationCBLC.Validate("Work Starting Date Time", DT);

        T := 134000T;
        DT := CreateDateTime(WorkDate, T);
        SalesRealizationCBLC.Validate("Work Ending Date Time", DT);

        SalesRealizationCBLC.Modify(true);

        // SetSalesRealizationToProcessed(SalesRealizationCBLC);
    end;

    [Test]
    procedure CreateSalesOrderLine3()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        Clear(SalesLine);
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, Enum::"Sales Line Type"::Item, '1002', 1);
    end;

    [Test]
    procedure UpdateSalesPlanningLine3()
    var
        // ResourceUnitOfMeasure: Record "Resource Unit of Measure";
        // SalesPlanLineCBLC: Record "Sales Plan. Line CBLC";
        SalesLine: Record "Sales Line";
    begin
        // Resource.Get('HESSEL'); //UUR
        Resource.Get('R0010'); //MINUUT
        ResourceGroup.Get('MONTEURS');
        LibraryResourceLIB.CreateResourceUnitOfMeasureTravelKm(Resource);
        UpdateSalesPlanningLineWithResource(SalesLine);
    end;

    [Test]
    procedure CreateSalesRealizationWithTravel()
    var
        SalesLine: Record "Sales Line";
        SalesRealizationCBLC: Record "Sales Realization CBLC";
        WorkDate: Date;
        DT: DateTime;
        T: Time;
    begin
        InitSalesRealizationCBLC(SalesRealizationCBLC, SalesLine);
        SalesRealizationCBLC.Insert(true);

        WorkDate := WorkDate();
        LibraryTimeSheetLIB.CreateTimeSheetForResource(Resource, WorkDate);

        //Reis
        T := 090000T;
        WorkDate += 2;
        DT := CreateDateTime(WorkDate, T);
        SalesRealizationCBLC.Validate("Travel Starting Date Time", DT);

        T := 104000T;
        DT := CreateDateTime(WorkDate, T);
        SalesRealizationCBLC.Validate("Travel Ending Date Time", DT);

        //KM
        SalesRealizationCBLC.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0));

        //Work
        T := 110000T;
        DT := CreateDateTime(WorkDate, T);
        SalesRealizationCBLC.Validate("Work Starting Date Time", DT);

        T := 134000T;
        DT := CreateDateTime(WorkDate, T);
        SalesRealizationCBLC.Validate("Work Ending Date Time", DT);

        SalesRealizationCBLC.Modify(true);

        LibrarySalesLIB.SetSalesRealizationToProcessed(SalesRealizationCBLC);
    end;

    [Test]
    procedure CreateSalesOrderWithLinePlanningRealization()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesPlanLineCBLC: Record "Sales Plan. Line CBLC";
        SalesRealizationCBLC: Record "Sales Realization CBLC";
        LibraryRandomLIB: Codeunit "Library - Random LIB";
        ResourceNo: Code[20];
        EndDateTime, StartDateTime : DateTime;
    begin
        // [GIVEN] Create Sales Order
        LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesHeader, '50000');
        LibrarySalesLIB.CreatesalesLineItem(SalesLine, SalesHeader, 'TSERVICE1', 1);
        if not LibrarySalesLIB.GetSalesPlanLine(SalesPlanLineCBLC, SalesLine) then
            ShowError('Cannot find sales plan line.');

        // [GIVEN] Update Sales Plan Line
        if SalesPlanLineCBLC."Resource Group No." = '' then
            exit;

        ResourceNo := LibraryRandomLIB.FindResourceRandom(SalesPlanLineCBLC."Resource Group No.");
        if ResourceNo <> '' then
            SalesPlanLineCBLC.Validate("Resource No.", ResourceNo);

        StartDateTime := CreateDateTime(Today(), 090000T);
        EndDateTime := CreateDateTime(Today(), 110000T);
        SalesPlanLineCBLC.Validate("Starting Date Time", StartDateTime);
        SalesPlanLineCBLC.Validate("Ending Date Time", EndDateTime);
        SalesPlanLineCBLC.Modify(true);

        // [GIVEN] Create Sales realization Line
        StartDateTime := CreateDateTime(Today(), 073000T);
        EndDateTime := CreateDateTime(Today(), 090000T);
        LibrarySalesLIB.CreateSalesRealization(SalesRealizationCBLC, SalesLine, SalesPlanLineCBLC."Starting Date Time", SalesPlanLineCBLC."Ending Date Time", StartDateTime, EndDateTime, 5);
    end;

    [Test]
    procedure CreateSalesOrderWithLinesPlanningRealization()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesPlanLineCBLC: Record "Sales Plan. Line CBLC";
        SalesRealizationCBLC: Record "Sales Realization CBLC";
        LibraryRandomLIB: Codeunit "Library - Random LIB";
        ResourceNo: Code[20];
        EndDateTime, StartDateTime : DateTime;
    begin
        // [GIVEN] Create Sales Order
        LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesHeader, '50000');

        // [GIVEN] Create First Sales Line
        LibrarySalesLIB.CreatesalesLineItem(SalesLine, SalesHeader, 'TSERVICE1', 1);
        if not LibrarySalesLIB.GetSalesPlanLine(SalesPlanLineCBLC, SalesLine) then
            ShowError('Cannot find sales plan line.');

        // [GIVEN] Update First Sales Plan Line
        if SalesPlanLineCBLC."Resource Group No." = '' then
            exit;

        ResourceNo := LibraryRandomLIB.FindResourceRandom(SalesPlanLineCBLC."Resource Group No.");
        if ResourceNo <> '' then
            SalesPlanLineCBLC.Validate("Resource No.", ResourceNo);

        StartDateTime := CreateDateTime(Today(), 090000T);
        EndDateTime := CreateDateTime(Today(), 110000T);
        SalesPlanLineCBLC.Validate("Starting Date Time", StartDateTime);
        SalesPlanLineCBLC.Validate("Ending Date Time", EndDateTime);
        SalesPlanLineCBLC.Modify(true);

        // [GIVEN] Create First Sales realization Line
        StartDateTime := CreateDateTime(Today(), 073000T);
        EndDateTime := CreateDateTime(Today(), 090000T);
        LibrarySalesLIB.CreateSalesRealization(SalesRealizationCBLC, SalesLine, SalesPlanLineCBLC."Starting Date Time", SalesPlanLineCBLC."Ending Date Time", StartDateTime, EndDateTime, 5);

        // [GIVEN] Create Second Sales Line
        Clear(SalesLine);
        Clear(SalesPlanLineCBLC);
        Clear(SalesRealizationCBLC);

        LibrarySalesLIB.CreatesalesLineItem(SalesLine, SalesHeader, 'TSERVICE1', 1);
        if not LibrarySalesLIB.GetSalesPlanLine(SalesPlanLineCBLC, SalesLine) then
            ShowError('Cannot find sales plan line.');

        // [GIVEN] Update Second Sales Plan Line
        if SalesPlanLineCBLC."Resource Group No." = '' then
            exit;

        SalesPlanLineCBLC.Validate("Resource No.", ResourceNo);

        StartDateTime := CreateDateTime(Today(), 114500T);
        EndDateTime := CreateDateTime(Today(), 130000T);
        SalesPlanLineCBLC.Validate("Starting Date Time", StartDateTime);
        SalesPlanLineCBLC.Validate("Ending Date Time", EndDateTime);
        SalesPlanLineCBLC.Modify(true);

        // [GIVEN] Create Second Sales realization Line
        StartDateTime := CreateDateTime(Today(), 110000T);
        EndDateTime := CreateDateTime(Today(), 114500T);
        LibrarySalesLIB.CreateSalesRealization(SalesRealizationCBLC, SalesLine, SalesPlanLineCBLC."Starting Date Time", SalesPlanLineCBLC."Ending Date Time", StartDateTime, EndDateTime, 5);
    end;

    [Test]
    procedure CreateSalesOrderWithLinePlanning()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesPlanLineCBLC: Record "Sales Plan. Line CBLC";
        LibraryRandomLIB: Codeunit "Library - Random LIB";
        ResourceNo: Code[20];
        EndDateTime, StartDateTime : DateTime;
    begin
        // [GIVEN] Create Sales Order
        LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesHeader, '50000');

        // [GIVEN] Create First Sales Line
        LibrarySalesLIB.CreatesalesLineItem(SalesLine, SalesHeader, 'TSERVICE1', 1);
        if not LibrarySalesLIB.GetSalesPlanLine(SalesPlanLineCBLC, SalesLine) then
            ShowError('Cannot find sales plan line.');

        // [GIVEN] Update First Sales Plan Line
        if SalesPlanLineCBLC."Resource Group No." = '' then
            exit;

        ResourceNo := LibraryRandomLIB.FindResourceRandom(SalesPlanLineCBLC."Resource Group No.");
        if ResourceNo <> '' then
            SalesPlanLineCBLC.Validate("Resource No.", ResourceNo);

        StartDateTime := CreateDateTime(Today(), 090000T);
        EndDateTime := CreateDateTime(Today(), 110000T);
        SalesPlanLineCBLC.Validate("Starting Date Time", StartDateTime);
        SalesPlanLineCBLC.Validate("Ending Date Time", EndDateTime);
        SalesPlanLineCBLC.Modify(true);
    end;

    #region support
    local procedure InitSalesRealizationCBLC(var SalesRealizationCBLC: Record "Sales Realization CBLC"; SalesLine: Record "Sales Line")
    begin
        SalesRealizationCBLC.Init();
        SalesRealizationCBLC.Validate("Document Type", SalesLine."Document Type");
        SalesRealizationCBLC.Validate("Document No.", SalesLine."Document No.");
        SalesRealizationCBLC.Validate("Document Line No.", SalesLine."Line No.");
        SalesRealizationCBLC.Validate("Resource Group No.", ResourceGroup."No.");
    end;

    local procedure UpdateSalesPlanningLineWithResource(SalesLine: Record "Sales Line")
    var
        SalesPlanLineCBLC: Record "Sales Plan. Line CBLC";
    begin
        SalesPlanLineCBLC.SetRange("Document Type", SalesLine."Document Type");
        SalesPlanLineCBLC.SetRange("Document No.", SalesLine."Document No.");
        SalesPlanLineCBLC.SetRange("Document Line No.", SalesLine."Line No.");
        SalesPlanLineCBLC.FindFirst();

        SalesPlanLineCBLC.Validate("Resource Group No.", ResourceGroup."No.");
        SalesPlanLineCBLC.Validate("Resource No.", Resource."No.");

        SalesPlanLineCBLC.Modify(true);
    end;
    #endregion Support
    // local procedure SetSalesRealizationToProcessed(var SalesRealizationCBLC: Record "Sales Realization CBLC")
    // begin
    //     SalesRealizationCBLC.Validate("Realization Status Code", 'UITGEVOERD');
    //     SalesRealizationCBLC.Modify(true);
    // end;

    // procedure CreateResourceUnitOfMeasureIfNotExist(var ResourceUnitOfMeasure: Record "Resource Unit of Measure"; ResourceNo: Code[20]; UnitOfMeasureCode: Code[10]; QtyPerUoM: Decimal)
    // begin
    //     ResourceUnitOfMeasure.Init();
    //     ResourceUnitOfMeasure.Validate("Resource No.", ResourceNo);
    //     ResourceUnitOfMeasure.Validate(Code, UnitOfMeasureCode);
    //     if QtyPerUoM = 0 then
    //         QtyPerUoM := 1;
    //     ResourceUnitOfMeasure.Validate("Qty. per Unit of Measure", QtyPerUoM);
    //     if ResourceUnitOfMeasure.Insert(true) then;
    // end;

    // local procedure CreateResourceUnitOfMeasureTravelKm(Resource: Record Resource)
    // var
    //     ResourceUnitOfMeasure: Record "Resource Unit of Measure";
    //     ResourceSetup: Record "Resources Setup";
    //     WorkType: Record "Work Type";
    // begin
    //     ResourceSetup.Get();
    //     ResourceSetup.TestField("Work Type Travel (km) CBLC");

    //     WorkType.Get(ResourceSetup."Work Type Travel (km) CBLC");
    //     WorkType.TestField("Unit of Measure Code");

    //     CreateResourceUnitOfMeasureIfNotExist(ResourceUnitOfMeasure, Resource."No.", WorkType."Unit of Measure Code", 1);
    //     ResourceUnitOfMeasure.validate("Related to Base Unit of Meas.", false);
    //     ResourceUnitOfMeasure.Modify(true);
    // end;

    // local procedure CreateTimeSheet(Resource: Record Resource; StartingDate: Date)
    // var
    //     CreateTimeSheets: report "Create Time Sheets";
    //     ResourcesSetup: Record "Resources Setup";
    //     TimeSheetHeader: Record "Time Sheet Header";
    // begin
    //     if not Resource."Use Time Sheet" then
    //         exit;

    //     ResourcesSetup.Get();
    //     ResourcesSetup.Testfield("Time Sheet Nos.");

    //     // create time sheet
    //     CreateTimeSheets.InitParameters(StartingDate, 1, Resource."No.", false, true);
    //     CreateTimeSheets.UseRequestPage(false);
    //     CreateTimeSheets.Run;

    //     // find created time sheet
    //     TimeSheetHeader.SetRange("Resource No.", Resource."No.");
    //     TimeSheetHeader.FindFirst;
    // end;

    #region Support
    local procedure ShowError(ErrorText: Text)
    var
        CurrentErrorInfo: ErrorInfo;
    begin
        CurrentErrorInfo := ErrorInfo.Create(ErrorText);
        CurrentErrorInfo.Collectible(true);
        Error(CurrentErrorInfo);
    end;
    #endregion Support
}