codeunit 83902 "UT Upd. Posting Dates TPTE"
{
    Permissions =
        tabledata "Purchase Header" = RM,
        tabledata "Purchase Line" = RM,
        tabledata "Sales Header" = RM,
        tabledata "Sales Line" = RM,
        tabledata "Transfer Header" = RM,
        tabledata "Transfer Line" = RM;
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryInventoryLIB: Codeunit "Library - Inventory LIB";
        // LibraryJobLIB: Codeunit "Library - Job LIB";
        LibraryPurchaseLIB: Codeunit "Library - Purchase LIB";
        LibraryRandom: Codeunit "Library - Random";
        LibrarySalesLIB: Codeunit "Library - Sales LIB";

    #region Sales
    [Test]
    procedure CreateSalesQuoteWithCurrentPostingDate()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySalesLIB.CreateSalesQuoteForCustomerNoWithSalesLine(SalesHeader, '10000');
        SalesHeader.Validate("Posting Date", Today());
        // SalesHeader.Validate("Shipment Date", SalesHeader."Posting Date");
        SalesHeader.Validate("Posting Description", 'Posting date: ' + Format(SalesHeader."Posting Date"));
        SalesHeader.Modify(true);

        LibrarySalesLIB.FindFirstSalesLine(SalesLine, SalesHeader);
        SalesLine.Validate("Outstanding Quantity", 69);
        SalesLine.Modify(true);
    end;

    [Test]
    procedure CreateSalesQuoteWithOldPostingDate()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySalesLIB.CreateSalesQuoteForCustomerNoWithSalesLine(SalesHeader, '10000');
        SalesHeader.Validate("Posting Date", Today() - LibraryRandom.RandIntInRange(3, 10));
        // SalesHeader.Validate("Shipment Date", SalesHeader."Posting Date");
        SalesHeader.Validate("Posting Description", 'Posting date: ' + Format(SalesHeader."Posting Date"));
        SalesHeader.Modify(true);

        LibrarySalesLIB.FindFirstSalesLine(SalesLine, SalesHeader);
        SalesLine.Validate("Outstanding Quantity", 69);
        SalesLine.Modify(true);
    end;

    [Test]
    procedure CreateSalesOrderWithCurrentPostingDate()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySalesLIB.CreateSalesOrderForCustomerNoWithSalesLine(SalesHeader, '10000');
        SalesHeader.Validate("Posting Date", Today());
        // SalesHeader.Validate("Shipment Date", SalesHeader."Posting Date");
        SalesHeader.Validate("Posting Description", 'Posting date: ' + Format(SalesHeader."Posting Date"));
        SalesHeader.Modify(true);

        LibrarySalesLIB.FindFirstSalesLine(SalesLine, SalesHeader);
        SalesLine.Validate("Outstanding Quantity", 69);
        SalesLine.Modify(true);
    end;

    [Test]
    procedure CreateSalesOrderWithOldPostingDate()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySalesLIB.CreateSalesOrderForCustomerNoWithSalesLine(SalesHeader, '10000');
        SalesHeader.Validate("Posting Date", Today() - LibraryRandom.RandIntInRange(3, 10));
        // SalesHeader.Validate("Shipment Date", SalesHeader."Posting Date");
        SalesHeader.Validate("Posting Description", 'Posting date: ' + Format(SalesHeader."Posting Date"));
        SalesHeader.Modify(true);

        LibrarySalesLIB.FindFirstSalesLine(SalesLine, SalesHeader);
        SalesLine.Validate("Outstanding Quantity", 69);
        SalesLine.Modify(true);
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateSalesInvoiceWithCurrentPostingDate()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySalesLIB.CreateSalesInvoiceForCustomerNoWithSalesLine(SalesHeader, '10000');
        SalesHeader.Validate("Posting Date", Today());
        // SalesHeader.Validate("Shipment Date", SalesHeader."Posting Date");
        SalesHeader.Validate("Posting Description", 'Posting date: ' + Format(SalesHeader."Posting Date"));
        SalesHeader.Modify(true);

        LibrarySalesLIB.FindFirstSalesLine(SalesLine, SalesHeader);
        SalesLine.Validate("Outstanding Quantity", 69);
        SalesLine.Modify(true);
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateSalesInvoiceWithOldPostingDate()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySalesLIB.CreateSalesInvoiceForCustomerNoWithSalesLine(SalesHeader, '10000');
        SalesHeader.Validate("Posting Date", Today() - LibraryRandom.RandIntInRange(3, 10));
        // SalesHeader.Validate("Shipment Date", SalesHeader."Posting Date");
        SalesHeader.Validate("Posting Description", 'Posting date: ' + Format(SalesHeader."Posting Date"));
        SalesHeader.Modify(true);

        LibrarySalesLIB.FindFirstSalesLine(SalesLine, SalesHeader);
        SalesLine.Validate("Outstanding Quantity", 69);
        SalesLine.Modify(true);
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateSalesCreditMemoWithCurrentPostingDate()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySalesLIB.CreateSalesCreditMemoForCustomerNoWithSalesLine(SalesHeader, '10000');
        SalesHeader.Validate("Posting Date", Today());
        // SalesHeader.Validate("Shipment Date", SalesHeader."Posting Date");
        SalesHeader.Validate("Posting Description", 'Posting date: ' + Format(SalesHeader."Posting Date"));
        SalesHeader.Modify(true);

        LibrarySalesLIB.FindFirstSalesLine(SalesLine, SalesHeader);
        SalesLine.Validate("Outstanding Quantity", 69);
        SalesLine.Modify(true);
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateSalesCreditMemoWithOldPostingDate()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySalesLIB.CreateSalesCreditMemoForCustomerNoWithSalesLine(SalesHeader, '10000');
        SalesHeader.Validate("Posting Date", Today() - LibraryRandom.RandIntInRange(3, 10));
        // SalesHeader.Validate("Shipment Date", SalesHeader."Posting Date");
        SalesHeader.Validate("Posting Description", 'Posting date: ' + Format(SalesHeader."Posting Date"));
        SalesHeader.Modify(true);

        LibrarySalesLIB.FindFirstSalesLine(SalesLine, SalesHeader);
        SalesLine.Validate("Outstanding Quantity", 69);
        SalesLine.Modify(true);
    end;

    [Test]
    // [HandlerFunctions('MessageHandler')]
    procedure CreateSalesReturnOrderWithCurrentPostingDate()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySalesLIB.CreateSalesReturnOrderForCustomerNoWithSalesLine(SalesHeader, '10000');
        SalesHeader.Validate("Posting Date", Today());
        // SalesHeader.Validate("Shipment Date", SalesHeader."Posting Date");
        SalesHeader.Validate("Posting Description", 'Posting date: ' + Format(SalesHeader."Posting Date"));
        SalesHeader.Modify(true);

        LibrarySalesLIB.FindFirstSalesLine(SalesLine, SalesHeader);
        SalesLine.Validate("Outstanding Quantity", 69);
        SalesLine.Modify(true);
    end;

    [Test]
    // [HandlerFunctions('MessageHandler')]
    procedure CreateSalesReturnOrderWithOldPostingDate()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySalesLIB.CreateSalesReturnOrderForCustomerNoWithSalesLine(SalesHeader, '10000');
        SalesHeader.Validate("Posting Date", Today() - LibraryRandom.RandIntInRange(3, 10));
        // SalesHeader.Validate("Shipment Date", SalesHeader."Posting Date");
        SalesHeader.Validate("Posting Description", 'Posting date: ' + Format(SalesHeader."Posting Date"));
        SalesHeader.Modify(true);

        LibrarySalesLIB.FindFirstSalesLine(SalesLine, SalesHeader);
        SalesLine.Validate("Outstanding Quantity", 69);
        SalesLine.Modify(true);
    end;
    // [Test]
    // procedure CreateSalesLinesWithServiceItemAndLinkOldPlanningDate()
    // var
    //     SalesHeader: Record "Sales Header";
    // // SalesLine: Record "Sales Line";
    // // SalesPlanLine: Record "Sales Plan. Line CBLC";
    // // ItemNo: Code[20];
    // // LineNo: Integer;
    // begin
    //     Clear(SalesHeader);

    //     LibrarySalesLIB.CreateSalesOrderForCustomerNoWithSalesLine(SalesHeader, '10000');
    //     SalesHeader.Validate("Posting Date", Today() - LibraryRandom.RandIntInRange(3, 10));
    //     // SalesHeader.Validate("Shipment Date", SalesHeader."Posting Date");
    //     SalesHeader.Validate("Posting Description", 'Posting date: ' + Format(SalesHeader."Posting Date"));
    //     // SalesHeader.Validate("Sales Type Group Code PTE", 'A');
    //     SalesHeader.Modify(true);

    //     // //1
    //     // ItemNo := 'TSERVICE4';
    //     // LibrarySalesLIB.CreatesalesLine(SalesLine, SalesHeader, ItemNo);
    //     // SalesLine.Validate("Outstanding Quantity", 69);
    //     // SalesLine.Modify(true);
    //     // LineNo := SalesLine."Line No.";

    //     // //2
    //     // Clear(SalesLine);
    //     // LibrarySalesLIB.CreatesalesLine(SalesLine, SalesHeader, ItemNo);
    //     // SalesLine.Validate("Outstanding Quantity", 69);
    //     // SalesLine.Validate(Description, 'Linked');
    //     // SalesLine.Modify(true);
    //     // // LineNo := SalesLine."Line No.";

    //     // //Link
    //     // if SalesLine."Line No." = LineNo then
    //     //     Error('Cannot link to itself.');

    //     // LibrarySalesLIB.LinkSalesLines(SalesLine, LineNo);

    //     // //Test
    //     // SalesLine.Find('=');
    //     // if not LibrarySalesLIB.GetSalesPlanLine(SalesPlanLine, SalesLine) then
    //     //     Error('Sales Plan. Line not found.');
    //     // SalesPlanLine.TestField("Plan. Document Line No.", LineNo)
    // end;
    #endregion Sales

    #region Purchase
    [Test]
    procedure CreatePurchaseQuoteWithCurrentPostingDate()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchaseLIB.CreatePurchaseQuoteWithLineForVendorNo(PurchaseHeader, PurchaseLine, '10000');
        PurchaseHeader.Validate("Posting Date", Today());
        PurchaseHeader.Validate("Posting Description", 'Posting date: ' + Format(PurchaseHeader."Posting Date"));
        PurchaseHeader.Modify(true);

        LibraryPurchaseLIB.FindFirstPurchaseLine(PurchaseLine, PurchaseHeader);
        // PurchaseLine.Validate("Outstanding Quantity", 69);
        PurchaseLine.Modify(true);
    end;

    [Test]
    procedure CreatePurchaseQuoteWithOldPostingDate()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchaseLIB.CreatePurchaseQuoteWithLineForVendorNo(PurchaseHeader, PurchaseLine, '10000');
        PurchaseHeader.Validate("Posting Date", Today() - LibraryRandom.RandIntInRange(3, 10));
        PurchaseHeader.Validate("Posting Description", 'Posting date: ' + Format(PurchaseHeader."Posting Date"));
        PurchaseHeader.Modify(true);

        LibraryPurchaseLIB.FindFirstPurchaseLine(PurchaseLine, PurchaseHeader);
        // PurchaseLine.Validate("Outstanding Quantity", 69);
        PurchaseLine.Modify(true);
    end;

    [Test]
    procedure CreatePurchaseOrderWithCurrentPostingDate()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchaseLIB.CreatePurchaseOrderWithLineForVendorNo(PurchaseHeader, PurchaseLine, '10000');
        PurchaseHeader.Validate("Posting Date", Today());
        PurchaseHeader.Validate("Posting Description", 'Posting date: ' + Format(PurchaseHeader."Posting Date"));
        PurchaseHeader.Modify(true);

        LibraryPurchaseLIB.FindFirstPurchaseLine(PurchaseLine, PurchaseHeader);
        // PurchaseLine.Validate("Outstanding Quantity", 69);
        PurchaseLine.Modify(true);
    end;

    [Test]
    procedure CreatePurchaseOrderWithOldPostingDate()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchaseLIB.CreatePurchaseOrderWithLineForVendorNo(PurchaseHeader, PurchaseLine, '10000');
        PurchaseHeader.Validate("Posting Date", Today() - LibraryRandom.RandIntInRange(3, 10));
        PurchaseHeader.Validate("Posting Description", 'Posting date: ' + Format(PurchaseHeader."Posting Date"));
        PurchaseHeader.Modify(true);

        LibraryPurchaseLIB.FindFirstPurchaseLine(PurchaseLine, PurchaseHeader);
        // PurchaseLine.Validate("Outstanding Quantity", 69);
        PurchaseLine.Modify(true);
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreatePurchaseInvoiceWithCurrentPostingDate()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchaseLIB.CreatePurchaseInvoiceWithLineForVendorNo(PurchaseHeader, PurchaseLine, '10000');
        PurchaseHeader.Validate("Posting Date", Today());
        PurchaseHeader.Validate("Posting Description", 'Posting date: ' + Format(PurchaseHeader."Posting Date"));
        PurchaseHeader.Modify(true);

        LibraryPurchaseLIB.FindFirstPurchaseLine(PurchaseLine, PurchaseHeader);
        // PurchaseLine.Validate("Outstanding Quantity", 69);
        PurchaseLine.Modify(true);
    end;

    [Test]
    // [HandlerFunctions('MessageHandler')]
    procedure CreatePurchaseInvoiceWithOldPostingDate()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchaseLIB.CreatePurchaseInvoiceWithLineForVendorNo(PurchaseHeader, PurchaseLine, '10000');
        PurchaseHeader.Validate("Posting Date", Today() - LibraryRandom.RandIntInRange(3, 10));
        PurchaseHeader.Validate("Posting Description", 'Posting date: ' + Format(PurchaseHeader."Posting Date"));
        PurchaseHeader.Modify(true);

        LibraryPurchaseLIB.FindFirstPurchaseLine(PurchaseLine, PurchaseHeader);
        // PurchaseLine.Validate("Outstanding Quantity", 69);
        PurchaseLine.Modify(true);
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreatePurchaseCreditMemoWithCurrentPostingDate()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchaseLIB.CreatePurchaseCreditMemoWithLineForVendorNo(PurchaseHeader, PurchaseLine, '10000');
        PurchaseHeader.Validate("Posting Date", Today());
        PurchaseHeader.Validate("Posting Description", 'Posting date: ' + Format(PurchaseHeader."Posting Date"));
        PurchaseHeader.Modify(true);

        LibraryPurchaseLIB.FindFirstPurchaseLine(PurchaseLine, PurchaseHeader);
        // PurchaseLine.Validate("Outstanding Quantity", 69);
        PurchaseLine.Modify(true);
    end;

    [Test]
    // [HandlerFunctions('MessageHandler')]
    procedure CreatePurchaseCreditMemoWithOldPostingDate()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchaseLIB.CreatePurchaseCreditMemoWithLineForVendorNo(PurchaseHeader, PurchaseLine, '10000');
        PurchaseHeader.Validate("Posting Date", Today() - LibraryRandom.RandIntInRange(3, 10));
        PurchaseHeader.Validate("Posting Description", 'Posting date: ' + Format(PurchaseHeader."Posting Date"));
        PurchaseHeader.Modify(true);

        LibraryPurchaseLIB.FindFirstPurchaseLine(PurchaseLine, PurchaseHeader);
        // PurchaseLine.Validate("Outstanding Quantity", 69);
        PurchaseLine.Modify(true);
    end;

    [Test]
    // [HandlerFunctions('MessageHandler')]
    procedure CreatePurchaseReturnOrderWithCurrentPostingDate()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchaseLIB.CreatePurchaseReturnOrderWithLineForVendorNo(PurchaseHeader, PurchaseLine, '10000');
        PurchaseHeader.Validate("Posting Date", Today());
        PurchaseHeader.Validate("Posting Description", 'Posting date: ' + Format(PurchaseHeader."Posting Date"));
        PurchaseHeader.Modify(true);

        LibraryPurchaseLIB.FindFirstPurchaseLine(PurchaseLine, PurchaseHeader);
        // PurchaseLine.Validate("Outstanding Quantity", 69);
        PurchaseLine.Modify(true);
    end;

    [Test]
    // [HandlerFunctions('MessageHandler')]
    procedure CreatePurchaseReturnOrderWithOldPostingDate()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchaseLIB.CreatePurchaseReturnOrderWithLineForVendorNo(PurchaseHeader, PurchaseLine, '10000');
        PurchaseHeader.Validate("Posting Date", Today() - LibraryRandom.RandIntInRange(3, 10));
        PurchaseHeader.Validate("Posting Description", 'Posting date: ' + Format(PurchaseHeader."Posting Date"));
        PurchaseHeader.Modify(true);

        LibraryPurchaseLIB.FindFirstPurchaseLine(PurchaseLine, PurchaseHeader);
        // PurchaseLine.Validate("Outstanding Quantity", 69);
        PurchaseLine.Modify(true);
    end;
    #endregion purchase

    #region Transfer
    [Test]
    procedure CreateTransferOrderWithCurrentPostingDate()
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
    begin
        // Verify Receipt Date on Transfer Line.

        // Setup: Create Transfer Header and Line with Base Calendar.
        // Initialize();
        LibraryInventoryLIB.CreateTransferOrderWithBaseCalendar(TransferLine);
        // TransferLine.Validate("Outstanding Quantity", 69);
        TransferLine.Modify(true);

        // Exercise.
        TransferHeader.Get(TransferLine."Document No.");
        TransferHeader.Validate("Posting Date", Today());
        TransferHeader.Modify(true);

        // Verify: Receipt Date on Transfer Line.
        TransferLine.TestField("Receipt Date", TransferHeader."Receipt Date");
    end;

    [Test]
    procedure CreateTransferOrderWithOldPostingDateAndOutstandingQuantity()
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
    begin
        // Verify Receipt Date on Transfer Line.

        // Setup: Create Transfer Header and Line with Base Calendar.
        // Initialize();
        LibraryInventoryLIB.CreateTransferOrderWithBaseCalendar(TransferLine);
        TransferLine.Validate("Outstanding Quantity", 69);
        TransferLine.Modify(true);

        // Exercise.
        TransferHeader.Get(TransferLine."Document No.");
        TransferHeader.Validate("Posting Date", Today() - LibraryRandom.RandIntInRange(3, 10));
        TransferHeader.Modify(true);

        // Verify: Receipt Date on Transfer Line.
        TransferLine.Find('=');
        TransferLine.Validate(Description, 'Posting Date: ' + Format(TransferHeader."Posting Date"));
        TransferLine.Modify(true);
        TransferLine.TestField("Receipt Date", TransferHeader."Receipt Date");
    end;

    #endregion Transfer

    //     #region Job
    //     [Test]
    //     procedure CreateJobPlanningLineWithServiceItemAndJobPlanLineAndCurrentPlanningDate()
    //     var
    //         JobPlanLineCBLC: Record "Job Plan. Line CBLC";
    //         JobPlanningLine: Record "Job Planning Line";
    //         JobTask: Record "Job Task";
    //         ItemNo: Code[20];
    //         JobPlanningLineLineType: Enum "Job Planning Line Line Type";
    //         JobPlanningLineType: Enum "Job Planning Line Type";
    //     begin
    //         JobTask.SetRange("Job No.", 'JOB00030');
    //         JobTask.FindFirst();

    //         //Create Job Planning Line
    //         ItemNo := 'TSERVICE4';
    //         LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Item, ItemNo, '', 1);
    //         JobPlanningLine.Validate("Planning Date", Today());
    //         JobPlanningLine.Validate(Description, 'Planning Date: ' + Format(JobPlanningLine."Planning Date"));
    //         JobPlanningLine.Modify(true);

    //         //Let op, Job Plan. Line wordt gemaakt via norm
    //         JobPlanLineCBLC.SetRange("Job No.", JobPlanningLine."Job No.");
    //         JobPlanLineCBLC.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
    //         JobPlanLineCBLC.SetRange("Job Planning Line No.", JobPlanningLine."Line No.");
    //         if not JobPlanLineCBLC.FindFirst() then
    //             Error('JPL Does not exist %1', JobPlanLineCBLC."Job Planning Line No.");
    //     end;

    //     [Test]
    //     procedure CreateJobPlanningLineWithServiceItemAndJobPlanLineAndOldPlanningDate()
    //     var
    //         JobPlanLineCBLC: Record "Job Plan. Line CBLC";
    //         JobPlanningLine: Record "Job Planning Line";
    //         JobTask: Record "Job Task";
    //         ItemNo: Code[20];
    //         JobPlanningLineLineType: Enum "Job Planning Line Line Type";
    //         JobPlanningLineType: Enum "Job Planning Line Type";
    //     begin
    //         JobTask.SetRange("Job No.", 'JOB00030');
    //         JobTask.FindFirst();

    //         //Create Job Planning Line
    //         ItemNo := 'TSERVICE4';
    //         LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Item, ItemNo, '', 1);
    //         JobPlanningLine.Validate("Planning Date", Today() - LibraryRandom.RandIntInRange(3, 10));
    //         JobPlanningLine.Validate(Description, 'Planning Date: ' + Format(JobPlanningLine."Planning Date"));
    //         JobPlanningLine.Modify(true);

    //         //Let op, Job Plan. Line wordt gemaakt via norm
    //         JobPlanLineCBLC.SetRange("Job No.", JobPlanningLine."Job No.");
    //         JobPlanLineCBLC.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
    //         JobPlanLineCBLC.SetRange("Job Planning Line No.", JobPlanningLine."Line No.");
    //         if JobPlanLineCBLC.IsEmpty() then
    //             Error('JPL does not exist.');

    //     end;

    //     [Test]
    //     procedure CreateJobPlanningLinesWithServiceItemAndLinkOldPlanningDate()
    //     var
    //         JobPlanLineCBLC: Record "Job Plan. Line CBLC";
    //         JobPlanningLine: Record "Job Planning Line";
    //         JobTask: Record "Job Task";
    //         ItemNo: Code[20];
    //         JobPlanningLineLineType: Enum "Job Planning Line Line Type";
    //         JobPlanningLineType: Enum "Job Planning Line Type";
    //         LineNo: Integer;
    //     begin
    //         JobTask.SetRange("Job No.", 'JOB00030');
    //         JobTask.FindFirst();

    //         //1 Create Job Planning Line
    //         ItemNo := 'TSERVICE4';
    //         LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Item, ItemNo, '', 1);
    //         JobPlanningLine.Validate("Planning Date", Today() - LibraryRandom.RandIntInRange(3, 10));
    //         JobPlanningLine.Validate(Description, 'Planning Date: ' + Format(JobPlanningLine."Planning Date"));
    //         JobPlanningLine.Modify(true);
    //         LineNo := JobPlanningLine."Line No.";

    //         //Let op, Job Plan. Line wordt gemaakt via norm
    //         JobPlanLineCBLC.SetRange("Job No.", JobPlanningLine."Job No.");
    //         JobPlanLineCBLC.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
    //         JobPlanLineCBLC.SetRange("Job Planning Line No.", JobPlanningLine."Line No.");
    //         JobPlanLineCBLC.FindFirst();

    //         //2
    //         Clear(JobPlanningLine);
    //         Clear(JobPlanningLine);

    //         ItemNo := 'TSERVICE4';
    //         LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Item, ItemNo, '', 1);
    //         JobPlanningLine.Validate("Planning Date", Today() - LibraryRandom.RandIntInRange(3, 10));
    //         JobPlanningLine.Validate(Description, 'Planning Date: ' + Format(JobPlanningLine."Planning Date") + ', Linked');
    //         JobPlanningLine.Modify(true);

    //         //Let op, Job Plan. Line wordt gemaakt via norm
    //         JobPlanLineCBLC.SetRange("Job No.", JobPlanningLine."Job No.");
    //         JobPlanLineCBLC.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
    //         JobPlanLineCBLC.SetRange("Job Planning Line No.", JobPlanningLine."Line No.");
    //         JobPlanLineCBLC.FindFirst();

    //         //Link the two
    //         if JobPlanningLine."Line No." = LineNo then
    //             Error('Can not link to itself');
    //         // LibraryJobLIB.LinkJobPlanningLines(JobPlanningLine, LineNo);

    //         //Test
    //         Clear(JobPlanLineCBLC);
    //         JobPlanningLine.Find('=');
    //         if not LibraryJobLIB.GetJobPlanLine(JobPlanLineCBLC, JobPlanningLine) then
    //             Error('Job Plan. Line not found.');
    //         JobPlanLineCBLC.TestField("Plan. Job Planning Line No.", LineNo);
    //     end;

    //     #endregion Job

    #region Handlers
    [MessageHandler]
    procedure MessageHandler(MessageText: Text[1024])
    begin
    end;
    #endregion Handlers


}
