#pragma warning disable PC0030
codeunit 83900 "UT Contract TPTE"
{
    Permissions =
        tabledata Contact = R,
        tabledata "Contr. Template Header CBLC" = RM,
        tabledata "Contr. Template Service CBLC" = R,
        tabledata "Contr. Template UOM CBLC" = R,
        tabledata "Contract Header CBLC" = RIM,
        tabledata "Contract Line CBLC" = RD,
        tabledata "Contract Service CBLC" = R,
        tabledata "Contract Setup CBLC" = R,
        tabledata "Contract Templ. Coverage CBLC" = R,
        tabledata "Contract UOM CBLC" = R,
        tabledata Customer = R,
        tabledata "Object Template CBLC" = RM,
        tabledata "Object CBLC" = R,
        tabledata "Sales Header" = R;
    Subtype = Test;
    TestPermissions = Disabled;

    var

        ContractSetupCBLC: Record "Contract Setup CBLC";
        Assert: Codeunit Assert;
        LibraryContractLIB: Codeunit "Library - Contract LIB";
        LibraryItemLIB: Codeunit "Library - Item LIB";
        // LibraryMarketing: Codeunit "Library - Marketing";
        LibraryObjectLIB: Codeunit "Library - Object LIB";
        LibraryRandomLIB: Codeunit "Library - Random LIB";
        LibrarySalesLIB: Codeunit "Library - Sales LIB";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        ContractTemplateNo: Code[20];


    #region Contract Template
    [Test]
    procedure CreateContractTemplateMonthWithCoverage()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC";
        ContractTemplCoverageCBLC: Record "Contract Templ. Coverage CBLC";
    begin
        // [SCENARIO] 18307 - Create Contract Template with everything
        // [GIVEN] Create Contract Template
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");
        LibraryContractLIB.CreateContractTemplateWithUOM(ContrTemplateHeaderCBLC, ContractSetupCBLC."Unit of Measure Code Month", 1);
        ContrTemplateHeaderCBLC.Validate(Description, 'With coverage random [18307]');
        ContrTemplateHeaderCBLC.Modify(true);
        ContractTemplateNo := ContrTemplateHeaderCBLC."No.";

        // [WHEN] Contr. Template Service CBLC 
        ContractSetupCBLC.TestField("Item Category Service");
        LibraryContractLIB.AddContractTemplateServiceWithCoverageRandom(ContrTemplateHeaderCBLC, ContractSetupCBLC."Item Category Service");

        //[THEN] Contract Template Service
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        if ContrTemplateServiceCBLC.IsEmpty() then
            Assert.Fail('Contract Template Has no Service records.');

        // [THEN] Contract Template Coverage
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");

        ContrTemplateServiceCBLC.FindFirst();

        ContractTemplCoverageCBLC.SetRange("Contract Template No.", ContrTemplateServiceCBLC."Contract Template No.");
        ContractTemplCoverageCBLC.SetRange("Item Category Code", ContrTemplateServiceCBLC."Item Category Code");
        if ContractTemplCoverageCBLC.IsEmpty() then
            Assert.Fail('Contract Template Coverage has no records.')
    end;

    [Test]
    procedure CreateContractTemplateYearWithCoverage()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC";
        ContractTemplCoverageCBLC: Record "Contract Templ. Coverage CBLC";
    begin
        // [SCENARIO] 18434 - Create Contract Template with everything
        // [GIVEN] Create Contract Template
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Year");
        LibraryContractLIB.CreateContractTemplateWithUOM(ContrTemplateHeaderCBLC, ContractSetupCBLC."Unit of Measure Code Year", 12);
        ContrTemplateHeaderCBLC.Validate(Description, 'With coverage random');
        ContrTemplateHeaderCBLC.Modify(true);
        ContractTemplateNo := ContrTemplateHeaderCBLC."No.";

        // [WHEN] Contr. Template Service CBLC 
        ContractSetupCBLC.TestField("Item Category Service");
        LibraryContractLIB.AddContractTemplateServiceWithCoverageRandom(ContrTemplateHeaderCBLC, ContractSetupCBLC."Item Category Service");

        //[THEN] Contract Template Service
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        if ContrTemplateServiceCBLC.IsEmpty() then
            Assert.Fail('Contract Template Has no Service records.');

        // [THEN] Contract Template Coverage
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        ContrTemplateServiceCBLC.FindFirst();

        ContractTemplCoverageCBLC.SetRange("Contract Template No.", ContrTemplateServiceCBLC."Contract Template No.");
        ContractTemplCoverageCBLC.SetRange("Item Category Code", ContrTemplateServiceCBLC."Item Category Code");
        if ContractTemplCoverageCBLC.IsEmpty() then
            Assert.Fail('Contract Template Coverage has no records.')
    end;

    [Test]
    procedure CreateContractTemplateQuaterWithCoverage()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC";
        ContractTemplCoverageCBLC: Record "Contract Templ. Coverage CBLC";
    begin
        // [SCENARIO] 18434 - Create Contract Template with everything
        // [GIVEN] Create Contract Template
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Quarter");
        LibraryContractLIB.CreateContractTemplateWithUOM(ContrTemplateHeaderCBLC, ContractSetupCBLC."Unit of Measure Code Quarter", 3);
        ContrTemplateHeaderCBLC.Validate(Description, 'With coverage random');
        ContrTemplateHeaderCBLC.Modify(true);
        ContractTemplateNo := ContrTemplateHeaderCBLC."No.";

        // [WHEN] Contr. Template Service CBLC 
        ContractSetupCBLC.TestField("Item Category Service");
        LibraryContractLIB.AddContractTemplateServiceWithCoverageRandom(ContrTemplateHeaderCBLC, ContractSetupCBLC."Item Category Service");

        //[THEN] Contract Template Service
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        if ContrTemplateServiceCBLC.IsEmpty() then
            Assert.Fail('Contract Template Has no Service records.');

        // [THEN] Contract Template Coverage
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        ContrTemplateServiceCBLC.FindFirst();

        ContractTemplCoverageCBLC.SetRange("Contract Template No.", ContrTemplateServiceCBLC."Contract Template No.");
        ContractTemplCoverageCBLC.SetRange("Item Category Code", ContrTemplateServiceCBLC."Item Category Code");
        if ContractTemplCoverageCBLC.IsEmpty() then
            Assert.Fail('Contract Template Coverage has no records.')
    end;

    [Test]
    procedure CreateContractTemplateWithCoverageAndFollowUp()
    var
        ContrTemplateHeaderCBLC, FollowContrTemplateHeaderCBLC : Record "Contr. Template Header CBLC";
    begin
        // [SCENARIO] Create Contract Template with everything

        // [GIVEN] Create Contract Template
        CreateContractTemplateMonthWithRandomCoverage(ContrTemplateHeaderCBLC);
        // ContrTemplateHeaderCBLC.Get(ContractTemplateNo);
        ContrTemplateHeaderCBLC.TestField("No.");

        // [GIVEN] Create 2nd Contract Template
        CreateContractTemplateMonthWithRandomCoverage(FollowContrTemplateHeaderCBLC);

        // [WHEN] Validate follow-up template
        ContrTemplateHeaderCBLC.Validate("Follow-up Template No.", FollowContrTemplateHeaderCBLC."No.");
        ContrTemplateHeaderCBLC.Modify(true);
        ContractTemplateNo := ContrTemplateHeaderCBLC."No.";

        // [THEN]
        Assert.AreEqual(FollowContrTemplateHeaderCBLC."No.", ContrTemplateHeaderCBLC."Follow-up Template No.", 'Contract Follow Up Template is not the same.');
    end;

    [Test]
    procedure CreateContractTemplateYearWithMonthFollowUp()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        YearContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
    begin
        // [SCENARIO] Create Month Template and validate a Year Template as follow-up

        // [GIVEN] Create Month Contract Template
        CreateContractTemplateMonthWithCoverage();
        ContrTemplateHeaderCBLC.Get(ContractTemplateNo);
        ContrTemplateHeaderCBLC.TestField("No.");

        // [GIVEN] Create 2nd Contract Template (Year)
        CreateContractTemplateYearWithCoverage();
        YearContrTemplateHeaderCBLC.Get(ContractTemplateNo);
        YearContrTemplateHeaderCBLC.TestField("No.");

        // [WHEN] Validate follow-up template / <ust Generate Error
        asserterror ContrTemplateHeaderCBLC.Validate("Follow-up Template No.", ContractTemplateNo);
    end;

    [Test]
    procedure CreateContractTemplateWithCoverageAndContract_18307()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractTemplCoverageCBLC: Record "Contract Templ. Coverage CBLC";
    begin
        // [SCENARIO] 18307 - Create Contract Template with everything
        // [SCENARIO] Create Template, Create contract from Template.
        // [SCENARIO] Create contract from Template.
        // [SCENARIO] Check Contract matches Template

        // [GIVEN] Create Contract Template
        ContractSetupCBLC.Get();
        LibraryContractLIB.CreateContractTemplateWithUOM(ContrTemplateHeaderCBLC, ContractSetupCBLC."Unit of Measure Code Month", 1);
        LibraryContractLIB.CreateContractTemplateUnitofMeasure(ContrTemplateHeaderCBLC, ContractSetupCBLC."Unit of Measure Code Year", 12);
        ContrTemplateHeaderCBLC.Validate(Description, 'With coverage random [18307]');
        ContrTemplateHeaderCBLC.Modify(true);


        // [WHEN] Contr. Template Service CBLC 
        ContractSetupCBLC.TestField("Item Category Service");
        LibraryContractLIB.AddContractTemplateServiceWithCoverageRandom(ContrTemplateHeaderCBLC, ContractSetupCBLC."Item Category Service");

        // [THEN] Contract Template Service
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        if ContrTemplateServiceCBLC.IsEmpty() then
            Assert.Fail('Contract Template Has no Service records.');

        // [THEN] Contract Template Coverage
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        ContrTemplateServiceCBLC.FindFirst();

        ContractTemplCoverageCBLC.SetRange("Contract Template No.", ContrTemplateServiceCBLC."Contract Template No.");
        ContractTemplCoverageCBLC.SetRange("Item Category Code", ContrTemplateServiceCBLC."Item Category Code");
        if ContractTemplCoverageCBLC.IsEmpty() then
            Assert.Fail('Contract Template Coverage has no records.');

        // [WHEN] Create Contract from Template
        ContractHeaderCBLC.CreateContractFromTemplate(ContrTemplateHeaderCBLC."No.");

        // [THEN] Check Contract 
        ContractHeaderCBLC.TestField("No.");
        ContractMatchesTemplate(ContractHeaderCBLC, ContrTemplateHeaderCBLC);
    end;

    [Test]
    // [HandlerFunctions('ApplyContractTemplateRequestPageHandler')]
    // [HandlerFunctions('ApplyContractTemplateReportHandler')]
    procedure CreateContractTemplateWithCoverageAndContractUpdate_18307()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";
        ContractTemplCoverageCBLC: Record "Contract Templ. Coverage CBLC";

        ItemCategoryCode: Code[20];
        ObjectNo: Code[20];
        SellToCustomerNo: Code[20];
        CurrentArchiveVersion: Integer;
    begin
        // [SCENARIO] 18307 - Create Contract Template with everything
        // [SCENARIO] Create Template, Create contract from Template.
        // [SCENARIO] Create contract from Template.
        // [SCENARIO] Check Contract matches Template
        // [SCENARIO] Update Service Template
        // [SCENARIO] Update Contract With template
        // [SCENARIO] Check Contract matches Template

        // [GIVEN] Create Contract Template
        ContractSetupCBLC.Get();
        LibraryContractLIB.CreateContractTemplateWithUOM(ContrTemplateHeaderCBLC, ContractSetupCBLC."Unit of Measure Code Month", 1);
        ContrTemplateHeaderCBLC.Validate(Description, 'With coverage random & Update [18307]');
        ContrTemplateHeaderCBLC.Modify(true);

        // [WHEN] Contr. Template Service CBLC 
        ContractSetupCBLC.TestField("Item Category Service");
        ItemCategoryCode := ContractSetupCBLC."Item Category Service";
        LibraryContractLIB.AddContractTemplateServiceWithCoverageRandom(ContrTemplateHeaderCBLC, ItemCategoryCode);

        // [THEN] Contract Template Service
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        if ContrTemplateServiceCBLC.IsEmpty() then
            Assert.Fail('Contract Template Has no Service records.');

        // [THEN] Contract Template Coverage
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        ContrTemplateServiceCBLC.FindFirst();

        ContractTemplCoverageCBLC.SetRange("Contract Template No.", ContrTemplateServiceCBLC."Contract Template No.");
        ContractTemplCoverageCBLC.SetRange("Item Category Code", ContrTemplateServiceCBLC."Item Category Code");
        if ContractTemplCoverageCBLC.IsEmpty() then
            Assert.Fail('Contract Template Coverage has no records.');

        // [WHEN] Create Contract from Template
        ContractHeaderCBLC.CreateContractFromTemplate(ContrTemplateHeaderCBLC."No.");
        SellToCustomerNo := '40000';
        ContractHeaderCBLC.Validate("Sell-to Customer No.", SellToCustomerNo);
        ContractHeaderCBLC.Modify(true);

        // [GIVEN] Lines &  Release
        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, false, 50, 20180101D, 0D);
        ContractHeaderCBLC.Release();

        // [THEN] Check Contract 
        ContractHeaderCBLC.TestField("No.");
        ContractMatchesTemplate(ContractHeaderCBLC, ContrTemplateHeaderCBLC);

        // [WHEN] Update Template & Update Contract
        ItemCategoryCode := 'ONDERHOUD';
        LibraryContractLIB.AddContractTemplateServiceWithCoverageRandom(ContrTemplateHeaderCBLC, ItemCategoryCode);
        ContractHeaderCBLC.Get(ContractHeaderCBLC."No.");
        LibraryVariableStorage.Enqueue(ContrTemplateHeaderCBLC."No.");
        //ContractHeaderCBLC.ApplyContractTemplateOnExistingContract();
        CurrentArchiveVersion := ContractHeaderCBLC.GetLastVersionNo();
        LibraryContractLIB.ApplyContractTemplateOnExistingContract(ContractHeaderCBLC, ContrTemplateHeaderCBLC);

        // [THEN] Check Contract 
        ContractHeaderCBLC.TestField("No.");
        Assert.AreEqual(CurrentArchiveVersion + 1, ContractHeaderCBLC.GetLastVersionNo(), 'Archive version do not match.');
        ContractMatchesTemplate(ContractHeaderCBLC, ContrTemplateHeaderCBLC);
    end;

    [Test]
    // [HandlerFunctions('ApplyContractTemplateRequestPageHandler')]
    // [HandlerFunctions('ApplyContractTemplateReportHandler')]
    procedure CreateContractTemplateFromMonthToYear_18307()
    var
        MonthContrTemplateHeaderCBLC, YearContrTemplateHeaderCBLC : Record "Contr. Template Header CBLC";
        ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractTemplCoverageCBLC: Record "Contract Templ. Coverage CBLC";

        ItemCategoryCode: Code[20];
        SellToCustomerNo: Code[20];
    begin
        // [SCENARIO] 18307 - Create Contract Template with everything
        // [SCENARIO] Create Template Month
        // [SCENARIO] Create Template Year
        // [SCENARIO] Create contract from Template.
        // [SCENARIO] Check Contract matches Template
        // [SCENARIO] Update to Year Contract Template
        // [SCENARIO] Check Contract matches Template

        // [GIVEN] Create Contract Template Month
        ContractSetupCBLC.Get();
        LibraryContractLIB.CreateContractTemplateWithUOM(MonthContrTemplateHeaderCBLC, ContractSetupCBLC."Unit of Measure Code Month", 1);
        MonthContrTemplateHeaderCBLC.Validate(Description, 'MONTH With coverage random [18307]');
        MonthContrTemplateHeaderCBLC.Modify(true);

        // [WHEN] Contr. Template Service CBLC 
        ContractSetupCBLC.TestField("Item Category Service");
        ItemCategoryCode := ContractSetupCBLC."Item Category Service";
        LibraryContractLIB.AddContractTemplateServiceWithCoverageRandom(MonthContrTemplateHeaderCBLC, ItemCategoryCode);

        // [THEN] Contract Template Service
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", MonthContrTemplateHeaderCBLC."No.");
        if ContrTemplateServiceCBLC.IsEmpty() then
            Assert.Fail('Contract Template Has no Service records.');

        // [THEN] Contract Template Coverage
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", MonthContrTemplateHeaderCBLC."No.");
        ContrTemplateServiceCBLC.FindFirst();

        ContractTemplCoverageCBLC.SetRange("Contract Template No.", ContrTemplateServiceCBLC."Contract Template No.");
        ContractTemplCoverageCBLC.SetRange("Item Category Code", ContrTemplateServiceCBLC."Item Category Code");
        if ContractTemplCoverageCBLC.IsEmpty() then
            Assert.Fail('Contract Template Coverage has no records.');

        // [GIVEN] Contract Template Year
        ContractSetupCBLC.TestField("Unit of Measure Code Year");
        // LibraryContractLIB.CreateContractTemplateWithUOM(ContrTemplateHeaderYearCBLC, ContractSetupCBLC."Unit of Measure Code Month", 1);
        LibraryContractLIB.CreateContractTemplateWithUOM(YearContrTemplateHeaderCBLC, ContractSetupCBLC."Unit of Measure Code Year", 12);
        YearContrTemplateHeaderCBLC.Validate(Description, 'YEAR With coverage random & Update [18307]');
        YearContrTemplateHeaderCBLC.Modify(true);

        // [WHEN] Contr. Template Service CBLC 
        ContractSetupCBLC.TestField("Item Category Service");
        ItemCategoryCode := ContractSetupCBLC."Item Category Service";
        LibraryContractLIB.AddContractTemplateServiceWithCoverageRandom(YearContrTemplateHeaderCBLC, ItemCategoryCode);

        // [THEN] Contract Template Service
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", YearContrTemplateHeaderCBLC."No.");
        if ContrTemplateServiceCBLC.IsEmpty() then
            Assert.Fail('Contract Template Has no Service records.');

        // [THEN] Contract Template Coverage
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", YearContrTemplateHeaderCBLC."No.");
        ContrTemplateServiceCBLC.FindFirst();

        ContractTemplCoverageCBLC.SetRange("Contract Template No.", ContrTemplateServiceCBLC."Contract Template No.");
        ContractTemplCoverageCBLC.SetRange("Item Category Code", ContrTemplateServiceCBLC."Item Category Code");
        if ContractTemplCoverageCBLC.IsEmpty() then
            Assert.Fail('Contract Template Coverage has no records.');

        // [WHEN] Create Contract from Template
        ContractHeaderCBLC.CreateContractFromTemplate(MonthContrTemplateHeaderCBLC."No.");
        SellToCustomerNo := '40000';
        ContractHeaderCBLC.Validate("Sell-to Customer No.", SellToCustomerNo);
        ContractHeaderCBLC.Validate(Description, 'Month to Year [18307]');
        ContractHeaderCBLC.Modify(true);

        // [THEN] Check Contract 
        ContractHeaderCBLC.TestField("No.");
        ContractMatchesTemplate(ContractHeaderCBLC, MonthContrTemplateHeaderCBLC);

        // [WHEN] Update to Year Template
        LibraryContractLIB.ApplyContractTemplateOnExistingContract(ContractHeaderCBLC, YearContrTemplateHeaderCBLC);

        // [THEN] Check Contract 
        ContractMatchesTemplate(ContractHeaderCBLC, YearContrTemplateHeaderCBLC);
    end;

    #endregion Contract Template

    #region Contract
    [Test]
    procedure CreateContractWithObjectLines()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";

        UoMCode: Code[10];
        IndexCode: Code[20];
        ObjectNo: Code[20];
        PostingDate: Date;
        FixedValue: Decimal;
    begin
        // [SCENARIO] 18191
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        // [GIVEN] Index
        IndexCode := '18191';
        FixedValue := 10;
        LibraryContractLIB.CreateIndexCode(IndexCode, Enum::"Contract Index Type CBLC"::"Fixed Value", FixedValue, true);

        // [GIVEN] Header
        UoMCode := ContractSetupCBLC."Unit of Measure Code Month";
        LibraryContractLIB.CreateContract(ContractHeaderCBLC, '40000', UoMCode);
        ContractHeaderCBLC.Validate(Description, 'Contract with Object lines [18191]');

        ContractHeaderCBLC.Validate("Index Code", IndexCode);
        ContractHeaderCBLC.Modify(true);

        // [GIVEN] Lines
        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, false, 50, 20180101D, 0D);

        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, false, 50, 20180101D, 0D);

        // [GIVEN] Release
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Release();

        // [WHEN] Ship
        PostingDate := 20190131D;
        SendContract(ContractHeaderCBLC, PostingDate);

        // [WHEN] Reindex
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20200101D);

        // [THEN] No changes in Line
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        Assert.AreEqual(2, ContractLineCBLC.Count(), 'Expected 2 contract lines.');

        // [WHEN] Update Price and Reindex
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        if ContractLineCBLC.FindSet() then
            repeat
                LibraryItemLIB.UpdateItemUnitPriceWithFixedValue(ContractLineCBLC."Price Item No.", 10);
            until ContractLineCBLC.Next() = 0;

        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20200101D);

        // [THEN]
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        Assert.AreEqual(4, ContractLineCBLC.Count(), 'Expected 4 contract lines.');

        if ContractLineCBLC.FindSet() then
            repeat
                if ContractLineCBLC."Original Manual Unit Price" <> 0 then
                    Assert.AreEqual(ContractLineCBLC."Original Manual Unit Price" + FixedValue, ContractLineCBLC."Unit Price", 'Unit price does not match unit price + fixed value');
            until ContractLineCBLC.Next() = 0;
    end;

    [Test]
    procedure CreateContractWithItemLinesFixed_18191()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";
        UoMCode: Code[10];
        IndexCode: Code[20];
        ObjectNo: Code[20];
        PostingDate: Date;
        CurrentArchiveCount: Integer;
    begin
        // [SCENARIO] 18191
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        // [GIVEN] Index
        IndexCode := '2022';
        LibraryContractLIB.CreateIndexCode(IndexCode, Enum::"Contract Index Type CBLC"::"Fixed Value", 10, true);

        // [GIVEN] Header
        UoMCode := ContractSetupCBLC."Unit of Measure Code Month";
        LibraryContractLIB.CreateContract(ContractHeaderCBLC, '40000', UoMCode);
        ContractHeaderCBLC.Validate(Description, 'Contract with Item lines [18191]');
        ContractHeaderCBLC.Validate("Index Code", '2022');
        ContractHeaderCBLC.Modify(true);

        // [GIVEN] Lines
        ObjectNo := '';
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, false, 50, 20180101D, 0D);

        ObjectNo := '';
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, false, 50, 20180101D, 0D);

        // [GIVEN] Release
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Release();

        // [WHEN] Ship
        PostingDate := 20190131D;
        SendContract(ContractHeaderCBLC, PostingDate);

        // [WHEN] Reindex
        CurrentArchiveCount := ContractHeaderCBLC.GetLastVersionNo();
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20200101D);

        // [THEN]
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        Assert.AreEqual(2, ContractLineCBLC.Count(), 'Expected 2 contract lines.');
        Assert.AreEqual(ContractHeaderCBLC.Status::Released, ContractHeaderCBLC.Status, 'Contract status should be released.');
        Assert.AreEqual(CurrentArchiveCount, ContractHeaderCBLC.GetLastVersionNo(), 'No new archive should have been created.');

        // [WHEN] Update Price and Reindex
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        if ContractLineCBLC.FindSet() then
            repeat
                LibraryItemLIB.UpdateItemUnitPriceWithFixedValue(ContractLineCBLC."Price Item No.", 10);
            until ContractLineCBLC.Next() = 0;

        CurrentArchiveCount := ContractHeaderCBLC.GetLastVersionNo();
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20200101D);

        // [THEN]
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        Assert.AreEqual(4, ContractLineCBLC.Count(), 'Expected 4 contract lines.');
        Assert.AreEqual(ContractHeaderCBLC.Status::Released, ContractHeaderCBLC.Status, 'Contract status should be released.');
        Assert.AreEqual(CurrentArchiveCount + 1, ContractHeaderCBLC.GetLastVersionNo(), 'A new archive should have been created.');
    end;

    [Test]
    procedure CreateContractWithItemLinesPercentage_18191()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";
        UoMCode: Code[10];
        IndexCode: Code[20];
        ObjectNo: Code[20];
        PostingDate: Date;
        CurrentArchiveCount: Integer;
    begin
        // [SCENARIO] 18191
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        // [GIVEN] Index
        IndexCode := '2022';
        LibraryContractLIB.CreateIndexCode(IndexCode, Enum::"Contract Index Type CBLC"::"Fixed Value", 10, true);

        // [GIVEN] Header
        UoMCode := ContractSetupCBLC."Unit of Measure Code Month";
        LibraryContractLIB.CreateContract(ContractHeaderCBLC, '40000', UoMCode);
        ContractHeaderCBLC.Validate(Description, 'Contract with Item lines [18191]');
        ContractHeaderCBLC.Validate("Index Code", '2022');
        ContractHeaderCBLC.Modify(true);

        // [GIVEN] Lines
        ObjectNo := '';
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, false, 50, 20180101D, 0D);

        ObjectNo := '';
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, false, 50, 20180101D, 0D);

        // [GIVEN] Release
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Release();

        // [WHEN] Ship
        PostingDate := 20190131D;
        SendContract(ContractHeaderCBLC, PostingDate);

        // [WHEN] Reindex
        CurrentArchiveCount := ContractHeaderCBLC.GetLastVersionNo();
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20200101D);

        // [THEN]
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        Assert.AreEqual(2, ContractLineCBLC.Count(), 'Expected 2 contract lines.');
        Assert.AreEqual(ContractHeaderCBLC.Status::Released, ContractHeaderCBLC.Status, 'Contract status should be released.');
        Assert.AreEqual(CurrentArchiveCount, ContractHeaderCBLC.GetLastVersionNo(), 'No new archive should have been created.');

        // [WHEN] Update Price and Reindex
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        if ContractLineCBLC.FindSet() then
            repeat
                LibraryItemLIB.UpdateItemUnitPriceWithPercentage(ContractLineCBLC."Price Item No.", 10);
            until ContractLineCBLC.Next() = 0;

        CurrentArchiveCount := ContractHeaderCBLC.GetLastVersionNo();
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20200101D);

        // [THEN]
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        Assert.AreEqual(4, ContractLineCBLC.Count(), 'Expected 4 contract lines.');
        Assert.AreEqual(ContractHeaderCBLC.Status::Released, ContractHeaderCBLC.Status, 'Contract status should be released.');
        Assert.AreEqual(CurrentArchiveCount + 1, ContractHeaderCBLC.GetLastVersionNo(), 'A new archive should have been created.');
    end;

    [Test]
    procedure CreateContractWithManualLineObjectReindex_18192()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";
        UoMCode: Code[10];
        IndexCode: Code[20];
        ObjectNo: Code[20];
        UnitPrice: Decimal;
    begin
        // [SCENARIO] 18192
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        // [GIVEN] Index
        IndexCode := '18192';
        LibraryContractLIB.CreateIndexCode(IndexCode, Enum::"Contract Index Type CBLC"::"Fixed Value", 10, true);

        // [GIVEN] Header
        UoMCode := ContractSetupCBLC."Unit of Measure Code Month";
        LibraryContractLIB.CreateContract(ContractHeaderCBLC, '40000', UoMCode);
        ContractHeaderCBLC.Validate(Description, 'Contract With Object Lines [18192]');
        ContractHeaderCBLC.Validate("Index Code", IndexCode);
        ContractHeaderCBLC.Modify(true);

        // [GIVEN] Lines
        UnitPrice := 50;
        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, true, UnitPrice, 20180101D, 0D);

        // [GIVEN] Release
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Release();

        // [WHEN] Reindex
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20190101D);

        // [THEN]
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.FindLast();
        Assert.AreEqual(UnitPrice + 10, ContractLineCBLC."Unit Price", '1: Unit Price should be the same');

        // [WHEN] Reindex
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20200101D);

        // [THEN]
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.FindLast();
        Assert.AreEqual(UnitPrice + 20, ContractLineCBLC."Unit Price", '2: Unit Price should be the same');

        // [WHEN] Reindex
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20220101D);

        // [THEN]
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.FindLast();
        Assert.AreEqual(UnitPrice + 30, ContractLineCBLC."Unit Price", '3: Unit Price should be the same');
    end;

    [Test]
    procedure CreateContractWithManualLineObjectReindexSameLine_18192()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";
        UoMCode: Code[10];
        IndexCode: Code[20];
        ObjectNo: Code[20];
        UnitPrice: Decimal;
        CurrentArchiveCount: Integer;
    begin
        // [SCENARIO] 18192
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        // [GIVEN] Index
        IndexCode := '18192';
        LibraryContractLIB.DeleteIndexCode(IndexCode, false);
        LibraryContractLIB.CreateIndexCode(IndexCode, Enum::"Contract Index Type CBLC"::"Fixed Value", 10, true);

        // [GIVEN] Header
        UoMCode := ContractSetupCBLC."Unit of Measure Code Month";
        LibraryContractLIB.CreateContract(ContractHeaderCBLC, '40000', UoMCode);
        ContractHeaderCBLC.Validate(Description, 'Contract With Object Lines Update Line [18192]');
        ContractHeaderCBLC.Validate("Index Code", IndexCode);
        ContractHeaderCBLC.Modify(true);

        // [GIVEN] Lines
        UnitPrice := 50;
        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, true, UnitPrice, 20180101D, 0D);

        // [GIVEN] Release
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Release();


        // [WHEN] First Reindex
        CurrentArchiveCount := ContractHeaderCBLC.GetLastVersionNo();
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20190101D);

        // [THEN]
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.FindLast();
        Assert.AreEqual(UnitPrice + 10, ContractLineCBLC."Unit Price", '1: Unit Price should be the same');
        Assert.AreEqual(CurrentArchiveCount + 1, ContractHeaderCBLC.GetLastVersionNo(), 'Archive count should be two');
        Assert.AreEqual(2, ContractLineCBLC.Count(), 'There should be 2 contract lines.');

        // [WHEN] Reindex
        CurrentArchiveCount := ContractHeaderCBLC.GetLastVersionNo();
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20190101D);

        // [THEN] Nothing should have happend
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.FindLast();
        Assert.AreEqual(UnitPrice + 10, ContractLineCBLC."Unit Price", '1: Unit Price should be the same');
        Assert.AreEqual(CurrentArchiveCount, ContractHeaderCBLC.GetLastVersionNo(), 'Archive count should be two');
        Assert.AreEqual(2, ContractLineCBLC.Count(), 'There should be 2 contract lines.');
    end;

    [Test]
    procedure CreateContractWithManualLineObjectReindexSameLineDiffIndex_18192()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";
        UoMCode: Code[10];
        IndexCode: Code[20];
        ObjectNo: Code[20];
        UnitPrice: Decimal;
        CurrentArchiveCount: Integer;
    begin
        // [SCENARIO] 18192
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        // [GIVEN] Index
        IndexCode := '18192';
        LibraryContractLIB.DeleteIndexCode(IndexCode, false);
        LibraryContractLIB.CreateIndexCode(IndexCode, Enum::"Contract Index Type CBLC"::"Fixed Value", 10, true);

        // [GIVEN] Header
        UoMCode := ContractSetupCBLC."Unit of Measure Code Month";
        LibraryContractLIB.CreateContract(ContractHeaderCBLC, '40000', UoMCode);
        ContractHeaderCBLC.Validate(Description, 'Contract, Object, Update Line, Diff Index [18192]');
        ContractHeaderCBLC.Validate("Index Code", IndexCode);
        ContractHeaderCBLC.Modify(true);

        // [GIVEN] Lines
        UnitPrice := 50;
        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, true, UnitPrice, 20180101D, 0D);

        // [GIVEN] Release
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Release();


        // [WHEN] First Reindex
        CurrentArchiveCount := ContractHeaderCBLC.GetLastVersionNo();
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20190101D);

        // [THEN]
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.FindLast();
        Assert.AreEqual(UnitPrice + 10, ContractLineCBLC."Unit Price", '1: Unit Price should be the same');
        Assert.AreEqual(CurrentArchiveCount + 1, ContractHeaderCBLC.GetLastVersionNo(), 'Archive count should be two');
        Assert.AreEqual(2, ContractLineCBLC.Count(), 'There should be 2 contract lines.');

        // [WHEN] Reindex
        CurrentArchiveCount := ContractHeaderCBLC.GetLastVersionNo();
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20190101D);

        // [THEN] Nothing should have happend
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.FindLast();
        Assert.AreEqual(UnitPrice + 10, ContractLineCBLC."Unit Price", '1: Unit Price should be the same');
        Assert.AreEqual(CurrentArchiveCount, ContractHeaderCBLC.GetLastVersionNo(), 'Archive count should be two');
        Assert.AreEqual(2, ContractLineCBLC.Count(), 'There should be 2 contract lines.');

        // [GIVEN] Update Index
        LibraryContractLIB.UpdateIndexCode(IndexCode, Enum::"Contract Index Type CBLC"::"Fixed Value", 20);

        // [WHEN] Reindex
        CurrentArchiveCount := ContractHeaderCBLC.GetLastVersionNo();
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20190101D);

        // [THEN] New Unit price & Archive
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.FindLast();
        Assert.AreEqual(2, ContractLineCBLC.Count(), 'There should be 2 contract lines.');
        Assert.AreEqual(UnitPrice + 20, ContractLineCBLC."Unit Price", '1: Unit Price should be the same');
        Assert.AreEqual(CurrentArchiveCount + 1, ContractHeaderCBLC.GetLastVersionNo(), 'Archive count should be 3');
    end;

    [Test]
    procedure CreateContractWithManualLineNoObjectReindex_18192()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";

        UoMCode: Code[10];
        IndexCode: Code[20];
        ObjectNo: Code[20];
        PriceItemNo: Code[20];
        UnitPrice: Decimal;
    begin
        // [SCENARIO] 18192
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        // [GIVEN] Index
        IndexCode := '18192';
        LibraryContractLIB.DeleteIndexCode(IndexCode, false);
        LibraryContractLIB.CreateIndexCode(IndexCode, Enum::"Contract Index Type CBLC"::"Fixed Value", 10, true);

        // [GIVEN] Header
        UoMCode := ContractSetupCBLC."Unit of Measure Code Month";
        LibraryContractLIB.CreateContract(ContractHeaderCBLC, '40000', UoMCode);
        ContractHeaderCBLC.Validate(Description, 'Contract With No Object Lines [18192]');
        ContractHeaderCBLC.Validate("Index Code", IndexCode);
        ContractHeaderCBLC.Modify(true);

        // [GIVEN] Price Item No
        PriceItemNo := LibraryItemLIB.CreatePriceItemNo();

        // [GIVEN] Lines
        UnitPrice := 50;
        ObjectNo := '';
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, PriceItemNo, 1, true, UnitPrice, 20180101D, 0D);

        // [GIVEN] Release
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Release();

        // [WHEN] Reindex
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20190101D);

        // [THEN]
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.FindLast();
        Assert.AreEqual(UnitPrice + 10, ContractLineCBLC."Unit Price", '1: Unit Price should be the same');

        // [WHEN] Reindex
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20200101D);

        // [THEN]
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.FindLast();
        Assert.AreEqual(UnitPrice + 20, ContractLineCBLC."Unit Price", '2: Unit Price should be the same');

        // [WHEN] Reindex
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20220101D);

        // [THEN]
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.FindLast();
        Assert.AreEqual(UnitPrice + 30, ContractLineCBLC."Unit Price", '3: Unit Price should be the same');
    end;

    [Test]
    procedure CreateContractWithLinesAndSend()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";

        UoMCode: Code[10];
        ObjectNo: Code[20];
        PostingDate: Date;
    begin
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        //Header
        UoMCode := ContractSetupCBLC."Unit of Measure Code Month";
        LibraryContractLIB.CreateContract(ContractHeaderCBLC, '40000', UoMCode);
        ContractHeaderCBLC.Validate(Description, 'Contract With Lines and Send');
        ContractHeaderCBLC.Validate("Index Code", '2022');
        ContractHeaderCBLC.Modify(true);

        //Lines
        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, false, 50, 20220101D, 20221231D);

        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 10, false, 40, 20220201D, 0D);

        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1008', 1, false, 60, 20220601D, 20221231D);

        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1008', 10, false, 70, 20220601D, 0D);

        // ObjectNo := CreateObjectNo();
        // ObjectNo := '';
        // LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, '1008', -1, false, 70, 20220601D, 0D);

        //Release
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Release();

        //Send
        PostingDate := 20220401D;
        SendContract(ContractHeaderCBLC, PostingDate);
    end;

    [Test]
    procedure CreateContractWithLineNoObject()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";
        Customer: Record Customer;
        UoMCode: Code[10];
        StartingDate: Date;
    begin
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        // [GIVEN] Header
        LibrarySalesLIB.CreateCustomer(Customer);
        UoMCode := ContractSetupCBLC."Unit of Measure Code Month";
        LibraryContractLIB.CreateContract(ContractHeaderCBLC, Customer."No.", UoMCode);
        ContractHeaderCBLC.Validate(Description, 'Contract with Lines and Send');
        ContractHeaderCBLC.Modify(true);

        // [GIVEN] Line
        StartingDate := Today();
        StartingDate := CalcDate('<-CM>', StartingDate);
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, '', '1000', 10, false, 50, StartingDate, 0D);

        // [WHEN] Release
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Release();
    end;

    [Test]
    procedure CreateContractWithFixedPeriodDatesQuarter()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";
        UoMCode: Code[10];
        ObjectNo: Code[20];
    begin
        // [SCENARIO] 18066
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Quarter");

        ContractHeaderCBLC.Init();
        ContractHeaderCBLC.Insert(true);
        ContractHeaderCBLC.TestField("No.");

        UoMCode := ContractSetupCBLC."Unit of Measure Code Quarter";
        LibraryContractLIB.CreateContractUnitOfMeasure(ContractHeaderCBLC, UoMCode);

        ContractHeaderCBLC.Validate(Description, 'Test fixed period quater');
        ContractHeaderCBLC.Validate("Sell-to Customer No.", '40000');
        ContractHeaderCBLC.Validate("Contract Unit of Measure", UoMCode);
        ContractHeaderCBLC.Validate("Index Code", '2022');
        ContractHeaderCBLC.Validate("Fixed Period Dates", true);
        ContractHeaderCBLC.Modify(true);

        begin
            ObjectNo := CreateObjectNo();
            LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, false, 50, 20220101D, 20221231D);

            ObjectNo := CreateObjectNo();
            LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 10, false, 40, 20220201D, 0D);

            ObjectNo := CreateObjectNo();
            LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1008', 1, false, 60, 20220601D, 20221231D);

            ObjectNo := CreateObjectNo();
            LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1008', 10, false, 70, 20220601D, 0D);

            ObjectNo := '';
            LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1008', 10, false, 70, 20221203D, 0D);

            // ObjectNo := '';
            // LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, '1008', -1, false, 70, 20220601D, 0D);
        end;
    end;

    [Test]
    procedure CreateContractWithFixedPeriodDatesYear_18066()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";
        UoMCode: Code[10];
        ObjectNo: Code[20];
    begin
        // [SCENARIO] 18066
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Year");

        ContractHeaderCBLC.Init();
        ContractHeaderCBLC.Insert(true);
        ContractHeaderCBLC.TestField("No.");

        UoMCode := ContractSetupCBLC."Unit of Measure Code Year";
        LibraryContractLIB.CreateContractUnitOfMeasure(ContractHeaderCBLC, UoMCode);

        ContractHeaderCBLC.Validate(Description, 'Test fixed period year');
        ContractHeaderCBLC.Validate("Sell-to Customer No.", '40000');
        ContractHeaderCBLC.Validate("Contract Unit of Measure", UoMCode);
        ContractHeaderCBLC.Validate("Index Code", '2022');
        ContractHeaderCBLC.Validate("Fixed Period Dates", true);
        ContractHeaderCBLC.Modify(true);

        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, false, 50, 20220101D, 20221231D);

        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 10, false, 40, 20220201D, 0D);

        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1008', 1, false, 60, 20220601D, 20221231D);

        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1008', 10, false, 70, 20220601D, 0D);

        ObjectNo := '';
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1008', -1, false, 70, 20221212D, 0D);
    end;

    [Test]
    procedure CreateContractForBatchDelete_18201()
    var
        // ContrArchiveHeaderCBLC: Record "Contr. Archive Header CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";

        SalesHeader: Record "Sales Header";
        UoMCode: Code[10];
        ObjectNo: Code[20];
        PostingDate: Date;
    begin
        // [SCENARIO] 18201
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        #region Contract 1

        // [GIVEN] Contract 1
        UoMCode := ContractSetupCBLC."Unit of Measure Code Month";
        LibraryContractLIB.CreateContract(ContractHeaderCBLC, '40000', UoMCode);
        ContractHeaderCBLC.Validate(Description, 'Test Batch delete [18201]');
        ContractHeaderCBLC.Validate("Index Code", '2022');
        ContractHeaderCBLC.Modify(true);

        // [GIVEN] Lines
        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1008', 10, false, 70, 20200101D, 20200731D);

        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1008', 10, false, 70, 20180101D, 20180731D);

        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1008', 10, false, 70, 20180101D, 20190731D);

        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, false, 50, 20180101D, 0D);

        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, false, 50, 20180101D, 0D);

        //[WHEN] Relase
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Release();

        //[WHEN] Ship
        PostingDate := 20190131D;
        SendContract(ContractHeaderCBLC, PostingDate);

        // [WHEN] Reindex
        // LibraryContractLIB.ReindexContract(ContractHeaderCBLC, 20190201D);

        // [WHEN] Post Sales Order
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.FindLast();
        LibrarySalesLIB.PostSalesDocument(SalesHeader, true, true);

        // Commit();

        // [WHEN] Remove Contract Lines
        LibraryContractLIB.RemoveContractLines(ContractHeaderCBLC."No.");

        // [THEN] Record Count
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        Assert.AreEqual(4, ContractLineCBLC.Count(), 'Contract Line should have 4 records');

        // [THEN] Archive count
        Assert.AreEqual(2, ContractHeaderCBLC.GetLastVersionNo(), 'Archive count does not match the expected quantity');

        #endregion Contract 1
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateContractFromObject()
    var
        Contact: Record Contact;
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";

        ObjectTemplateCBLC: Record "Object Template CBLC";
        ObjectCBLC: Record "Object CBLC";
    // ContractTemplateNo: Code[20];
    begin
        // [SCENARIO] 18124
        // [GIVEN] Object
        LibraryObjectLIB.CreateObjectTemplate(ObjectTemplateCBLC);
        ObjectTemplateCBLC.Validate("Price Item No.", LibraryObjectLIB.CreatePriceItemNo());
        ObjectTemplateCBLC.Modify(true);

        LibraryObjectLIB.CreateObjectWithTemplate(ObjectCBLC, ObjectTemplateCBLC);

        // LibraryObject.CreateObjectWithRandomTemplate(ObjectCBLC);
        // LibraryObject.CreateObject(ObjectCBLC, true, 0D);

        // [GIVEN] Object Contact
        LibrarySalesLIB.CreatePersonContactWithCustomer(Contact);
        LibraryObjectLIB.CreateObjectContact(ObjectCBLC, 'KLANT', CalcDate('<-2Y>', Today()), 0D, Contact."No.");
        ObjectCBLC.TestField("No.");

        // [WHEN] Create Contract
        // ObjectCBLC.CreateContract(ObjectCBLC, WorkDate(), true);
        LibraryObjectLIB.CreateContractFromObject(ObjectCBLC, LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contr. Template Header CBLC"), WorkDate(), true);
        ContractSetupCBLC.Get();
        ContractHeaderCBLC.Reset();
        ContractHeaderCBLC.FindLast();
        LibraryContractLIB.AddContractService(ContractHeaderCBLC, ContractSetupCBLC."Item Category Service");

        // [THEN] Contract Header/Lines
        ContractHeaderCBLC.Reset();
        ContractHeaderCBLC.FindLast();
        Assert.AreEqual(ContractHeaderCBLC.Status::Open, ContractHeaderCBLC.Status, 'Contract status should be released.');

        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.FindFirst();
        Assert.AreEqual(ObjectCBLC."No.", ContractLineCBLC."Object No.", 'Object No. on contract line is not correct.');
        // Assert.AreEqual(ObjectCBLC."Price Item No.", ContractLineCBLC."Price Item No.", 'Price Item No. on contract line is not correct.');
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateContractFromObjectWithFollowUpTemplate()
    var
        Contact: Record Contact;
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";

        ObjectTemplateCBLC: Record "Object Template CBLC";
        ObjectCBLC: Record "Object CBLC";
    begin
        // [SCENARIO] 18124

        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Object
        CreateContractTemplateWithCoverageAndFollowUp();
        ContrTemplateHeaderCBLC.Get(ContractTemplateNo);
        ContrTemplateHeaderCBLC.TestField("No.");

        LibraryObjectLIB.CreateObjectTemplate(ObjectTemplateCBLC);
        ObjectTemplateCBLC.Validate("Price Item No.", LibraryObjectLIB.CreatePriceItemNo());
        ObjectTemplateCBLC.Modify(true);

        LibraryObjectLIB.CreateObjectWithTemplate(ObjectCBLC, ObjectTemplateCBLC);

        // LibraryObject.CreateObjectWithRandomTemplate(ObjectCBLC);
        // LibraryObject.CreateObject(ObjectCBLC, true, 0D);

        // [GIVEN] Object Contact
        LibrarySalesLIB.CreatePersonContactWithCustomer(Contact);
        LibraryObjectLIB.CreateObjectContact(ObjectCBLC, 'KLANT', CalcDate('<-2Y>', Today()), 0D, Contact."No.");
        ObjectCBLC.TestField("No.");

        // [WHEN] Create Contract
        // ObjectCBLC.CreateContract(ObjectCBLC, WorkDate(), true);
        LibraryObjectLIB.CreateContractFromObject(ObjectCBLC, ContrTemplateHeaderCBLC."No.", WorkDate(), true);
        ContractSetupCBLC.Get();

        // ContractHeaderCBLC.Reset();
        // ContractHeaderCBLC.FindLast();
        // LibraryContract.AddContractService(ContractHeaderCBLC, ContractSetupCBLC."Item Category Service");

        // [THEN] Contract Header/Lines
        ContractHeaderCBLC.Reset();
        ContractHeaderCBLC.FindLast();
        Assert.AreEqual(ContractHeaderCBLC.Status::Open, ContractHeaderCBLC.Status, 'Contract status should be released.');

        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.FindFirst();
        Assert.AreEqual(ObjectCBLC."No.", ContractLineCBLC."Object No.", 'Object No. on contract line is not correct.');
        // Assert.AreEqual(ObjectCBLC."Price Item No.", ContractLineCBLC."Price Item No.", 'Price Item No. on contract line is not correct.');
    end;

    [Test]
    // [HandlerFunctions('ConfirmHandler')]
    procedure CreateContractForDelete_18659()
    var
        // ContrArchiveHeaderCBLC: Record "Contr. Archive Header CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";

        UoMCode: Code[10];
        ObjectNo: Code[20];
    begin
        // [SCENARIO] 18659
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        // [GIVEN] Contract 1
        UoMCode := ContractSetupCBLC."Unit of Measure Code Month";
        LibraryContractLIB.CreateContract(ContractHeaderCBLC, '40000', UoMCode);
        ContractHeaderCBLC.Validate(Description, 'Test Batch delete [18201]');
        ContractHeaderCBLC.Validate("Index Code", '2022');
        ContractHeaderCBLC.Modify(true);

        // [GIVEN] Lines
        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1008', 10, false, 70, CalcDate('<-CY>', Today()), CalcDate('<+CY>', Today()));

        //[WHEN] Release
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Release();

        //[WHEN] Delete Contract Line
        ContractLineCBLC.Delete(false);

        // [THEN] Record Count
        ContractLineCBLC.Reset();
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        Assert.AreEqual(0, ContractLineCBLC.Count(), 'Contract Line should have 0 records');
    end;


    // [Test]
    // procedure CreateContractForBatchDeleteOverlap()
    // var
    //     ContractHeaderCBLC: Record "Contract Header CBLC";
    //     ContractLineCBLC: Record "Contract Line CBLC";
    //     
    //     UoMCode: Code[10];
    //     ObjectNo: Code[20];
    //     ContrArchiveHeaderCBLC: Record "Contr. Archive Header CBLC";
    //     TempSalesHeader: Record "Sales Header" temporary;
    //     ShipContractsHelperCBLC: Codeunit "Ship Contracts Helper CBLC";
    //     PostingDate: Date;
    // begin
    //     ContractSetupCBLC.Get();
    //     ContractSetupCBLC.TestField("Unit of Measure Code Month");

    //     ContractHeaderCBLC.Init();
    //     ContractHeaderCBLC.Insert(true);
    //     ContractHeaderCBLC.TestField("No.");

    //     UoMCode := ContractSetupCBLC."Unit of Measure Code Month";
    //     LibraryContractLIB.CreateContractUnitOfMeasure(ContractHeaderCBLC, UoMCode);

    //     ContractHeaderCBLC.Validate(Description, 'Test Batch delete overlap');
    //     ContractHeaderCBLC.Validate("Sell-to Customer No.", '40000');
    //     ContractHeaderCBLC.Validate("Contract Unit of Measure", UoMCode);
    //     ContractHeaderCBLC.Validate("Index Code", '2022');
    //     // ContractHeaderCBLC.Validate("Fixed Period Dates", true);
    //     ContractHeaderCBLC.Modify(true);

    //     ObjectNo := ''; //CreateObjectNo();
    //     LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, '1000', 1, false, 50, 20190301D, 0D);
    // end;

    #endregion Contract

    #region Support
    local procedure CreateObjectNo(): Code[20]
    var
        ObjectCBLC: Record "Object CBLC";
    begin
        LibraryObjectLIB.CreateObject(ObjectCBLC, true, 0D);
        exit(ObjectCBLC."No.");
    end;

    local procedure Initialize()
    begin
        Codeunit.Run(Codeunit::"Init. Contract LIB");
        ContractSetupCBLC.Get();
    end;

    local procedure SendContract(var ContractHeaderCBLC: Record "Contract Header CBLC"; PostingDate: Date)
    begin
        SendContract(ContractHeaderCBLC, PostingDate, false);
    end;

    local procedure SendContract(var ContractHeaderCBLC: Record "Contract Header CBLC"; PostingDate: Date; SkipCheckShipmentOnPostingDate: Boolean)
    // var
    // ContrArchiveHeaderCBLC: Record "Contr. Archive Header CBLC";
    // TempSalesHeader: Record "Sales Header" temporary;
    // ShipContractsHelperCBLC: Codeunit "Ship Contracts Helper CBLC";
    begin
        LibraryContractLIB.SendContract(ContractHeaderCBLC, PostingDate, SkipCheckShipmentOnPostingDate);
        // ShipContractsHelperCBLC.InitProgressWindow();
        // ContrArchiveHeaderCBLC.Get(ContractHeaderCBLC."No.", ContractHeaderCBLC.GetLastVersionNo());
        // ShipContractsHelperCBLC.CreateContractSalesLines(ContrArchiveHeaderCBLC, PostingDate, TempSalesHeader);
        // ShipContractsHelperCBLC.ShipSalesOrders(TempSalesHeader);
        // ShipContractsHelperCBLC.CloseProgressWindow();
    end;

    // procedure RemoveContractLines(ContractNo: Code[20])
    // var
    //     ContractLineCBLC: Record "Contract Line CBLC";
    //     RemoveContrLinesMethCBLC: Codeunit "Remove Contr. Lines Meth CBLC";
    // begin
    //     ContractLineCBLC.Reset();
    //     ContractLineCBLC.SetRange("Contract No.", ContractNo);
    //     if ContractLineCBLC.FindSet() then
    //         repeat
    //             RemoveContrLinesMethCBLC.RemoveContractLines(ContractLineCBLC);
    //         until ContractLineCBLC.Next() = 0;
    //     RemoveContrLinesMethCBLC.ReleaseContracts();
    // end;

    local procedure ContractMatchesTemplate(var ContractHeaderCBLC: Record "Contract Header CBLC"; var ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC")
    var
        ContrCoverageCBLC: Record "Contr. Coverage CBLC";
        // ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC";
        ContrTemplateUOMCBLC: Record "Contr. Template UOM CBLC";
        ContractServiceCBLC: Record "Contract Service CBLC";
        ContractTemplCoverageCBLC: Record "Contract Templ. Coverage CBLC";
        ContractUOMCBLC: Record "Contract UOM CBLC";
    begin
        // [SCENARIO] Match Contract With template
        // [SCENARIO] Match Contract Service
        // [SCENARIO] Match Contract UoM

        // [GIVEN] Contract Service
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        ContractServiceCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");

        // [THEN] Count should match
        Assert.AreEqual(ContrTemplateServiceCBLC.Count(), ContractServiceCBLC.Count(), 'Contract Service count does not match Template.');

        // [GIVEN] Contract Coverage
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        if ContrTemplateServiceCBLC.FindSet() then
            repeat
                ContractTemplCoverageCBLC.SetRange("Contract Template No.", ContractTemplCoverageCBLC."Contract Template No.");
                ContractTemplCoverageCBLC.SetRange("Item Category Code", ContrTemplateServiceCBLC."Item Category Code");

                ContractServiceCBLC.Get(ContractHeaderCBLC."No.", ContrTemplateServiceCBLC."Item Category Code");
                ContrCoverageCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
                ContrCoverageCBLC.SetRange("Item Category Code", ContractServiceCBLC."Item Category Code");

                // [THEN] Count should match
                Assert.AreEqual(ContrCoverageCBLC.Count(), ContrCoverageCBLC.Count(), 'Contract Coverage count does not match template.');
            until ContrTemplateServiceCBLC.Next() = 0;

        // [GIVEN] Contract UoM
        ContrTemplateUOMCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        ContractUOMCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");

        // [THEN] Count should match
        Assert.AreEqual(ContrTemplateUOMCBLC.Count(), ContractUOMCBLC.Count(), 'Contract UoM count does not match Template.');

        // [GIVEN] Contract Template UoM
        if ContrTemplateUOMCBLC.FindSet() then
            repeat
                // [THEN] Contract UoM
                ContractUOMCBLC.Get(ContractHeaderCBLC."No.", ContrTemplateUOMCBLC.Code);
            until ContrTemplateUOMCBLC.Next() = 0;

    end;

    local procedure CreateContractTemplateMonthWithRandomCoverage(var ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC")
    var
        ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC";
        ContractTemplCoverageCBLC: Record "Contract Templ. Coverage CBLC";
    begin
        // [SCENARIO] 18307 - Create Contract Template with everything
        // [GIVEN] Create Contract Template
        CreateContractTemplateMonthWithCoverage();
        ContrTemplateHeaderCBLC.Get(ContractTemplateNo);

        //[THEN] Contract Template Service
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        if ContrTemplateServiceCBLC.IsEmpty() then
            Assert.Fail('Contract Template Has no Service records.');

        // [THEN] Contract Template Coverage
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        ContrTemplateServiceCBLC.FindFirst();

        ContractTemplCoverageCBLC.SetRange("Contract Template No.", ContrTemplateServiceCBLC."Contract Template No.");
        ContractTemplCoverageCBLC.SetRange("Item Category Code", ContrTemplateServiceCBLC."Item Category Code");
        if ContractTemplCoverageCBLC.IsEmpty() then
            Assert.Fail('Contract Template Coverage has no records.')
    end;

    #endregion Support

    [MessageHandler]
    procedure MessageHandler(MessageText: Text[1024])
    begin
        // if MessageText = MessageText then;
    end;

    [ReportHandler]
    procedure ApplyContractTemplateReportHandler(var ApplyContractTemplateCBLC: Report "Apply Contract Template CBLC")
    begin
        //Close Handler
        // ApplyContractTemplateCBLC.OK().Invoke();
        // ApplyContractTemplateCBLC.
    end;

    [RequestPageHandler]
    procedure ApplyContractTemplateRequestPageHandler(var ApplyContractTemplateCBLC: TestRequestPage "Apply Contract Template CBLC")
    begin
        //Close Handler
        ApplyContractTemplateCBLC.ContractTemplateNoControl.SetValue(LibraryVariableStorage.DequeueText());
        ApplyContractTemplateCBLC.OK().Invoke();
    end;

    [ConfirmHandler]
    procedure ConfirmHandler(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;
}
#pragma warning restore PC0030