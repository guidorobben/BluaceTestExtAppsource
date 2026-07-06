codeunit 83933 "UT Object Maintenance TPTE"
{
    Permissions =
        tabledata Contact = R,
        tabledata "Contr. Archive Line CBLC" = R,
        tabledata "Contr. Template Header CBLC" = RD,
        tabledata "Contract Header CBLC" = RMD,
        tabledata "Contract Norm CBLC" = RD,
        tabledata "Contract Setup CBLC" = R,
        tabledata Item = RD,
        tabledata "Maint. Sched. Templ. Hdr. CBLC" = RD,
        tabledata "Maint. Sched. Templ. Line CBLC" = R,
        tabledata "Object Maint. Schedule CBLC" = R,
        tabledata "Object Template CBLC" = RD,
        tabledata "Object CBLC" = RMD,
        tabledata "Resource Group" = R,
        tabledata "Sales Line" = R,
        tabledata "Sales Plan. Line CBLC" = RM,
        tabledata "Sales Realization CBLC" = RIM;
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        LibraryContractLIB: Codeunit "Library - Contract LIB";
        LibraryMaintenanceLIB: Codeunit "Library - Maintenance LIB";
        LibraryObjectLIB: Codeunit "Library - Object LIB";
        LibraryRandomLIB: Codeunit "Library - Random LIB";
        LibrarySalesLIB: Codeunit "Library - Sales LIB";
        MaintScheduleTemplateNo: Code[20];
        ObjectNo: Code[20];
        ObjectNormTypeCBLC: Enum "Object Norm Type CBLC";
        RelatedNormTypeCBLC: Enum "Related Norm Type CBLC";
        ScheduleCalcTypeCBLC: Enum "Schedule Calc. Type CBLC";


    #region Maintenance Template    
    [Test]
    procedure CreateMaintenanceTemplateWithNorm()
    var
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [WHEN] Create All/All norm for M-Template
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::All, '', MaintSchedTemplHdrCBLC."No.");
    end;

    [Test]
    procedure CreateMaintenanceTemplateWithNormAndDelete()
    var
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithNorm();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [WHEN/THEN] Delete M-Template
        asserterror MaintSchedTemplHdrCBLC.Delete(true);
    end;
    #endregion Maintenance Template 

    #region Object
    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectWithObjectMaintenanceScheduleLastRealisationDate()
    var
        Contact: Record Contact;
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        ObjectCBLC: Record "Object CBLC";
    // LibrarySalesLIB: Codeunit "Library - Sales LIB";
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Object
        LibraryObjectLIB.CreateObject(ObjectCBLC, true, Today() - 23);
        ObjectCBLC.Validate(Description, 'With Maint. schedule (Real. Date)');
        ObjectCBLC.Modify(true);
        ObjectNo := ObjectCBLC."No.";

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [GIVEN] Contact
        LibrarySalesLIB.CreatePersonContactWithCustomer(Contact);
        LibraryObjectLIB.CreateObjectContact(ObjectCBLC, 'KLANT', Today() - 600, 0D, Contact."No.");

        // [WHEN] Create All/All norm for M-Template
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::All, '', MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Create Object Maint. for Object
        LibraryMaintenanceLIB.CreateObjectMaintenanceSchedule(ObjectCBLC);

        // [THEN] Match Object Schedule to M-Schedule
        MatchObjectScheduleWithTemplate(ObjectCBLC, MaintSchedTemplHdrCBLC);
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectWithObjectMaintenanceScheduleStartingDate()
    var
        Contact: Record Contact;
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        ObjectCBLC: Record "Object CBLC";
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Object
        LibraryObjectLIB.CreateObject(ObjectCBLC, true, Today() - 23);
        ObjectCBLC.Validate(Description, 'With Maint. schedule (Start. Date)');
        ObjectCBLC.Modify(true);
        ObjectNo := ObjectCBLC."No.";

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastStartingDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [GIVEN] Contact
        LibrarySalesLIB.CreatePersonContactWithCustomer(Contact);
        LibraryObjectLIB.CreateObjectContact(ObjectCBLC, 'KLANT', Today() - 600, 0D, Contact."No.");

        // [WHEN] Create All/All norm for M-Template
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::All, '', MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Create Object Maint. for Object
        LibraryMaintenanceLIB.CreateObjectMaintenanceSchedule(ObjectCBLC);

        // [THEN]
        MatchObjectScheduleWithTemplate(ObjectCBLC, MaintSchedTemplHdrCBLC);
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectWithMaintenanceScheduleAndDelete()
    var
        ObjectCBLC, xObjectCBLC : Record "Object CBLC";
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Object with Schedule
        CreateObjectWithObjectMaintenanceScheduleLastRealisationDate();
        ObjectCBLC.Get(ObjectNo);
        ObjectCBLC.TestField("No.");
        ObjectCBLC.TestField("Maint. Schedule Updated");

        // [WHEN] Delete Object
        xObjectCBLC := ObjectCBLC;
        ObjectCBLC.Delete(true);

        // [THEN] No more M-Schedule
        Assert.IsFalse(LibraryMaintenanceLIB.HasObjectMaintenance(xObjectCBLC), 'There should be no more object maintenance for Object.');
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectWithMaintenanceScheduleAndUpdateMaintSchedule()
    var
        ObjectCBLC: Record "Object CBLC";
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Object with Schedule
        CreateObjectWithObjectMaintenanceScheduleLastRealisationDate();
        ObjectCBLC.Get(ObjectNo);
        ObjectCBLC.TestField("No.");
        ObjectCBLC.TestField("Maint. Schedule Updated");

        // [WHEN] "Maint. Schedule Updated" = false
        ObjectCBLC.Validate("Maint. Schedule Updated", false);
        ObjectCBLC.Modify(true);

        // [THEN]
        Assert.IsFalse(LibraryMaintenanceLIB.HasObjectMaintenance(ObjectCBLC), 'There should be no more object maintenance for Object.');
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectWithMaintenanceScheduleChangeSkill()
    var
        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
        ObjectCBLC: Record "Object CBLC";
        LibrarySkillLIB: Codeunit "Library - Skill LIB";
        SkillCode: Code[10];
        SkillTypeCBLC: Enum "Skill Type CBLC";
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Object with Schedule
        CreateObjectWithObjectMaintenanceScheduleLastRealisationDate();
        ObjectCBLC.Get(ObjectNo);
        ObjectCBLC.TestField("No.");
        ObjectCBLC.TestField("Maint. Schedule Updated");

        // [WHEN] Add Geo Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillTypeCBLC::Geography);
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        ObjectCBLC.Find('=');

        // [THEN] Object has Geo skill on record
        Assert.AreEqual(SkillCode, ObjectCBLC."Geography Skill Code", 'Object Geography Skill not the same');
        // [THEN] Has OM-Lines
        ObjectMaintScheduleCBLC.Reset();
        ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectCBLC."No.");
        Assert.IsFalse(ObjectMaintScheduleCBLC.IsEmpty(), 'OM-Schedule has no lines.');
        // [THEN] All OM-Lines have Geo. skill from object
        ObjectMaintScheduleCBLC.SetFilter("Geography Skill Code", '<>%1', ObjectCBLC."Geography Skill Code");
        Assert.IsTrue(ObjectMaintScheduleCBLC.IsEmpty(), 'Not all OM-Schedule have the correct Geo. Skill.');

        // [WHEN] Add Org Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillTypeCBLC::Organization);
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        ObjectCBLC.Get(ObjectCBLC."No.");

        // [THEN] Object has Org skill on record
        Assert.AreEqual(SkillCode, ObjectCBLC."Organization Skill Code", 'Object Organization Skill not the same');
        // [THEN] Has OM-Lines
        ObjectMaintScheduleCBLC.Reset();
        ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectCBLC."No.");
        Assert.IsFalse(ObjectMaintScheduleCBLC.IsEmpty(), 'OM-Schedule has no lines.');
        // [THEN] All OM-Lines have Geo. skill from object
        ObjectMaintScheduleCBLC.SetFilter("Organization Skill Code", '<>%1', ObjectCBLC."Organization Skill Code");
        Assert.IsTrue(ObjectMaintScheduleCBLC.IsEmpty(), 'Not all OM-Schedule have the correct Org. Skill.');

    end;
    #endregion Object

    #region Object Template
    [Test]
    procedure CreateObjectTemplateWithMaintenanceScheduleAndNormAndDelete()
    var
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        ObjectTemplateCBLC, xObjectTemplateCBLC : Record "Object Template CBLC";
    begin
        // [GIVEN] Object Template
        LibraryObjectLIB.CreateObjectTemplate(ObjectTemplateCBLC);
        ObjectTemplateCBLC.TestField("No.");

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [GIVEN] Maintenance Template
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Template", ObjectTemplateCBLC."No.", RelatedNormTypeCBLC::All, '', MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Delete Object Template
        xObjectTemplateCBLC := ObjectTemplateCBLC;
        ObjectTemplateCBLC.Delete(true);

        // [THEN] No more MT Norms
        Assert.IsFalse(LibraryMaintenanceLIB.HasMaintTemplateNorms(xObjectTemplateCBLC), 'There should be no more norms for Object Template.');
    end;

    [Test]
    procedure CreateObjectTemplateWithMaintenanceScheduleAndNormAndCopy()
    var
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        NewObjectTemplateCBLC, ObjectTemplateCBLC : Record "Object Template CBLC";
    begin
        // [SCENARIO] CReate Object Template with norm and copy template.

        // [GIVEN] Object Template
        LibraryObjectLIB.CreateObjectTemplate(ObjectTemplateCBLC);
        ObjectTemplateCBLC.TestField("No.");

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [GIVEN] Maintenance Template
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Template", ObjectTemplateCBLC."No.", RelatedNormTypeCBLC::All, '', MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Copy Object Template
        LibraryObjectLIB.CopyObjectTemplate(ObjectTemplateCBLC, NewObjectTemplateCBLC);
        NewObjectTemplateCBLC.TestField("No.");

        // [THEN] Test New Object Template
        Assert.IsTrue(LibraryMaintenanceLIB.HasMaintTemplateNorms(NewObjectTemplateCBLC), 'Object Template should have Maintenance Norm.');
    end;
    #endregion Object Template

    #region Contract Template
    [Test]
    procedure CreateContractTemplateWithMaintenanceScheduleAndNormAndDelete()
    var
        ContrTemplateHeaderCBLC, xContrTemplateHeaderCBLC : Record "Contr. Template Header CBLC";
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
    begin
        // [SCENARIO] Create Contract Template With M-Schedule and delete Contract Template

        // [GIVEN] Contract Template
        LibraryContractLIB.CreateContractTemplate(ContrTemplateHeaderCBLC, 'MAAND');
        ContrTemplateHeaderCBLC.TestField("No.");

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [GIVEN] Maintenance Template
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::"Contract Template", ContrTemplateHeaderCBLC."No.", MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Delete Object Template
        xContrTemplateHeaderCBLC := ContrTemplateHeaderCBLC;
        ContrTemplateHeaderCBLC.Delete(true);

        // [THEN] No more MT Norms
        Assert.IsFalse(LibraryMaintenanceLIB.HasMaintTemplateNorms(xContrTemplateHeaderCBLC), 'There should be no more norms for contract template.');
    end;
    #endregion Contract Template

    #region Contract
    [Test]
    procedure CreateContractWithMaintenanceScheduleWithNormAndDelete()
    var
        // ContrTemplateHeaderCBLC, xContrTemplateHeaderCBLC : Record "Contr. Template Header CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
    begin
        // [SCENARIO] Create Contract Template With M-Schedule and delete Contract.

        // [GIVEN] Object Template
        LibraryContractLIB.CreateContract(ContractHeaderCBLC, '20000', 'MAAND');
        ContractHeaderCBLC.TestField("No.");

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [GIVEN] Maintenance Template
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::Contract, ContractHeaderCBLC."No.", MaintSchedTemplHdrCBLC."No.");

        // [WHEN/THEN] Delete Object Template without error
        ContractHeaderCBLC.Delete(true);
    end;

    [Test]
    procedure CreateContractNormWithMaintenanceScheduleWithNormAndDelete()
    var
        ContractNormCBLC, xContractNormCBLC : Record "Contract Norm CBLC";
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
    begin
        // [SCENARIO] Create Contract Norm With M-Schedule and delete Contract Template

        // [GIVEN] Contract Norm
        LibraryContractLIB.CreateContractNorm('CNORM1', 'Norm 1');
        ContractNormCBLC.Get('CNORM1');

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [GIVEN] Maintenance Template
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::"Contract Norm", ContractNormCBLC.Code, MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Delete Object Template
        xContractNormCBLC := ContractNormCBLC;
        ContractNormCBLC.Delete(true);

        // [THEN] No more MT Norms
        Assert.IsFalse(LibraryMaintenanceLIB.HasMaintTemplateNorms(xContractNormCBLC), 'There should be no more norms for contract norm.');
    end;
    #endregion Contract

    #region Contract Norm

    #endregion Contract Norm

    #region Item
    [Test]
    procedure CreateItemWithMaintenanceScheduleAndDelete()
    var
        ContractSetupCBLC: Record "Contract Setup CBLC";
        Item: Record Item;
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        MaintSchedTemplLineCBLC: Record "Maint. Sched. Templ. Line CBLC";
        LibraryItemLIB: Codeunit "Library - Item LIB";
        LibraryRandom: Codeunit "Library - Random";
        EmptyDF: DateFormula;
        Periodicity: DateFormula;
        ItemNo: Code[20];
        YearLbl: Label '<+1Y>';
    begin
        // [SCENARIO] Create MT with items and delete the item.

        // [GIVEN] Item
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Item Category Service");
        ContractSetupCBLC.TestField("Unit of Measure Code Month");

        ItemNo := 'TSERVICE666';
        Clear(Item);
        if not Item.Get(ItemNo) then
            LibraryItemLIB.CreatePriceItem(Item, ItemNo, LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), ContractSetupCBLC."Unit of Measure Code Month", ContractSetupCBLC."Item Category Service");

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [GIVEN] MT-Line with Item
        Evaluate(Periodicity, YearLbl);
        LibraryMaintenanceLIB.CreateMaintenanceTemplateLine(MaintSchedTemplHdrCBLC, MaintSchedTemplLineCBLC, ItemNo, Periodicity, EmptyDF, EmptyDF);

        // [WHEN/THEN] Delete Item with error 
        asserterror Item.Delete(true);
    end;
    #endregion Item

    #region Object Maintenance Schedule
    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectMaintenanceScheduleAllForContract()
    var
        ContrArchiveLineCBLC: Record "Contr. Archive Line CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
        ObjectCBLC: Record "Object CBLC";
    begin
        // [GIVEN] Refresh Norms
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        CreateTestMaintenanceNorms();

        // [GIVEN] Object & Contract
        CreateObjectFromTemplateWithContract(ObjectCBLC, ContractHeaderCBLC);
        ContractHeaderCBLC.Release();

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [WHEN] Create MT Norm
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::Contract, ContractHeaderCBLC."No.", MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Create Object M-schedule
        LibraryObjectLIB.CreateObjectMaintenanceSchedule(ObjectCBLC);

        // [THEN] Check OM-schedule
        ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectCBLC."No.");
        ObjectMaintScheduleCBLC.FindFirst();

        Assert.AreEqual(MaintSchedTemplHdrCBLC."No.", ObjectMaintScheduleCBLC."Maint. Schedule Template No.", 'MT-Schedule does not match.');

        LibraryObjectLIB.GetActiveContractArchiveLine(ObjectCBLC, ContrArchiveLineCBLC, Today());
        // GetActiveContractLine(ObjectCBLC, ContractLineCBLC);
        Assert.AreEqual(ObjectMaintScheduleCBLC."Starting Date", ContrArchiveLineCBLC."Starting Date", 'Starting date does not match contract line.');
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectMaintenanceScheduleAllForAllContracts()
    var
        ContrArchiveLineCBLC: Record "Contr. Archive Line CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        // ContractLineCBLC: Record "Contract Line CBLC";
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
        ObjectCBLC: Record "Object CBLC";
    begin
        // [GIVEN] Refresh Norms
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        CreateTestMaintenanceNorms();

        // [GIVEN] Object & Contract
        CreateObjectFromTemplateWithContract(ObjectCBLC, ContractHeaderCBLC);
        ContractHeaderCBLC.Release();

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [WHEN] Create MT Norm
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::"All Contracts", '', MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Create Object M-schedule
        LibraryObjectLIB.CreateObjectMaintenanceSchedule(ObjectCBLC);

        // [THEN] Check OM-schedule
        ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectCBLC."No.");
        ObjectMaintScheduleCBLC.FindFirst();

        Assert.AreEqual(MaintSchedTemplHdrCBLC."No.", ObjectMaintScheduleCBLC."Maint. Schedule Template No.", 'MT-Schedule does not match.');

        LibraryObjectLIB.GetActiveContractArchiveLine(ObjectCBLC, ContrArchiveLineCBLC, Today());
        Assert.AreEqual(ObjectMaintScheduleCBLC."Starting Date", ContrArchiveLineCBLC."Starting Date", 'Starting date does not match contract line.');
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectMaintenanceScheduleAllForContractTemplate()
    var
        ContrArchiveLineCBLC: Record "Contr. Archive Line CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        // ContractLineCBLC: Record "Contract Line CBLC";
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
        ObjectCBLC: Record "Object CBLC";
    begin
        // [GIVEN] Refresh Norms
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        CreateTestMaintenanceNorms();

        // [GIVEN] Object & Contract
        CreateObjectFromTemplateWithContract(ObjectCBLC, ContractHeaderCBLC);
        ContractHeaderCBLC.Release();

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [WHEN] Create MT Norm
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::"Contract Template", ContractHeaderCBLC."Contract Template No.", MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Create Object M-schedule
        LibraryObjectLIB.CreateObjectMaintenanceSchedule(ObjectCBLC);

        // [THEN] Check OM-schedule
        ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectCBLC."No.");
        ObjectMaintScheduleCBLC.FindFirst();

        Assert.AreEqual(MaintSchedTemplHdrCBLC."No.", ObjectMaintScheduleCBLC."Maint. Schedule Template No.", 'MT-Schedule does not match.');

        LibraryObjectLIB.GetActiveContractArchiveLine(ObjectCBLC, ContrArchiveLineCBLC, Today());
        Assert.AreEqual(ObjectMaintScheduleCBLC."Starting Date", ContrArchiveLineCBLC."Starting Date", 'Starting date does not match contract line.');
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectMaintenanceScheduleAllForContractNorm()
    var
        ContrArchiveLineCBLC: Record "Contr. Archive Line CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        // ContractLineCBLC: Record "Contract Line CBLC";
        // ContractNormCBLC: Record "Contract Norm CBLC";
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
        ObjectCBLC: Record "Object CBLC";
        ContractNormCode: Code[20];
    begin
        // [GIVEN] Refresh Norms
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        CreateTestMaintenanceNorms();

        // [GIVEN] Object & Contract
        CreateObjectFromTemplateWithContract(ObjectCBLC, ContractHeaderCBLC);
        ContractNormCode := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contract Norm CBLC");
        ContractHeaderCBLC.Validate("Contract Norm Code", ContractNormCode);
        ContractHeaderCBLC.Modify(true);
        ContractHeaderCBLC.Release();

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [WHEN] Create MT Norm
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::"Contract Norm", ContractNormCode, MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Create Object M-schedule
        LibraryObjectLIB.CreateObjectMaintenanceSchedule(ObjectCBLC);

        // [THEN] Check OM-schedule
        ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectCBLC."No.");
        ObjectMaintScheduleCBLC.FindFirst();

        Assert.AreEqual(MaintSchedTemplHdrCBLC."No.", ObjectMaintScheduleCBLC."Maint. Schedule Template No.", 'MT-Schedule does not match.');

        LibraryObjectLIB.GetActiveContractArchiveLine(ObjectCBLC, ContrArchiveLineCBLC, Today());
        Assert.AreEqual(ObjectMaintScheduleCBLC."Starting Date", ContrArchiveLineCBLC."Starting Date", 'Starting date does not match contract line.');
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectMaintenanceScheduleObjectTemplateForContract()
    var
        ContrArchiveLineCBLC: Record "Contr. Archive Line CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        // ContractLineCBLC: Record "Contract Line CBLC";
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
        ObjectCBLC: Record "Object CBLC";
    begin
        // [GIVEN] Refresh Norms
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        CreateTestMaintenanceNorms();

        // [GIVEN] Object & Contract
        CreateObjectFromTemplateWithContract(ObjectCBLC, ContractHeaderCBLC);
        ContractHeaderCBLC.Release();

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [WHEN] Create MT Norm
        ObjectCBLC.TestField("Object Template No.");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Template", ObjectCBLC."Object Template No.", RelatedNormTypeCBLC::Contract, ContractHeaderCBLC."No.", MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Create Object M-schedule
        LibraryObjectLIB.CreateObjectMaintenanceSchedule(ObjectCBLC);

        // [THEN] Check OM-schedule
        ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectCBLC."No.");
        ObjectMaintScheduleCBLC.FindFirst();

        Assert.AreEqual(MaintSchedTemplHdrCBLC."No.", ObjectMaintScheduleCBLC."Maint. Schedule Template No.", 'MT-Schedule does not match.');

        LibraryObjectLIB.GetActiveContractArchiveLine(ObjectCBLC, ContrArchiveLineCBLC, Today());
        Assert.AreEqual(ObjectMaintScheduleCBLC."Starting Date", ContrArchiveLineCBLC."Starting Date", 'Starting date does not match contract line.');
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectMaintenanceScheduleObjectTemplateForAllContracts()
    var
        ContrArchiveLineCBLC: Record "Contr. Archive Line CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        // ContractLineCBLC: Record "Contract Line CBLC";
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
        ObjectCBLC: Record "Object CBLC";
    begin
        // [GIVEN] Refresh Norms
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        CreateTestMaintenanceNorms();

        // [GIVEN] Object & Contract
        CreateObjectFromTemplateWithContract(ObjectCBLC, ContractHeaderCBLC);
        ContractHeaderCBLC.Release();

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [WHEN] Create MT Norm
        ObjectCBLC.TestField("Object Template No.");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Template", ObjectCBLC."Object Template No.", RelatedNormTypeCBLC::"All Contracts", '', MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Create Object M-schedule
        LibraryObjectLIB.CreateObjectMaintenanceSchedule(ObjectCBLC);

        // [THEN] Check OM-schedule
        ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectCBLC."No.");
        ObjectMaintScheduleCBLC.FindFirst();

        Assert.AreEqual(MaintSchedTemplHdrCBLC."No.", ObjectMaintScheduleCBLC."Maint. Schedule Template No.", 'MT-Schedule does not match.');

        LibraryObjectLIB.GetActiveContractArchiveLine(ObjectCBLC, ContrArchiveLineCBLC, Today());
        Assert.AreEqual(ObjectMaintScheduleCBLC."Starting Date", ContrArchiveLineCBLC."Starting Date", 'Starting date does not match contract line.');
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectMaintenanceScheduleObjectTemplateForContractTemplate()
    var
        ContrArchiveLineCBLC: Record "Contr. Archive Line CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        // ContractLineCBLC: Record "Contract Line CBLC";
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
        ObjectCBLC: Record "Object CBLC";
    begin
        // [GIVEN] Refresh Norms
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        CreateTestMaintenanceNorms();

        // [GIVEN] Object & Contract
        CreateObjectFromTemplateWithContract(ObjectCBLC, ContractHeaderCBLC);
        ContractHeaderCBLC.Release();

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [WHEN] Create MT Norm
        ObjectCBLC.TestField("Object Template No.");
        ContractHeaderCBLC.TestField("Contract Template No.");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Template", ObjectCBLC."Object Template No.", RelatedNormTypeCBLC::"Contract Template", ContractHeaderCBLC."Contract Template No.", MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Create Object M-schedule
        LibraryObjectLIB.CreateObjectMaintenanceSchedule(ObjectCBLC);

        // [THEN] Check OM-schedule
        ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectCBLC."No.");
        ObjectMaintScheduleCBLC.FindFirst();

        Assert.AreEqual(MaintSchedTemplHdrCBLC."No.", ObjectMaintScheduleCBLC."Maint. Schedule Template No.", 'MT-Schedule does not match.');

        LibraryObjectLIB.GetActiveContractArchiveLine(ObjectCBLC, ContrArchiveLineCBLC, Today());
        Assert.AreEqual(ObjectMaintScheduleCBLC."Starting Date", ContrArchiveLineCBLC."Starting Date", 'Starting date does not match contract line.');
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectMaintenanceScheduleObjectTemplateForContractNorm()
    var
        ContrArchiveLineCBLC: Record "Contr. Archive Line CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        // ContractLineCBLC: Record "Contract Line CBLC";
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
        ObjectCBLC: Record "Object CBLC";
        ContractNormCode: Code[20];
    begin
        // [GIVEN] Refresh Norms
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        CreateTestMaintenanceNorms();

        // [GIVEN] Object & Contract
        CreateObjectFromTemplateWithContract(ObjectCBLC, ContractHeaderCBLC);
        ContractNormCode := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contract Norm CBLC");
        ContractHeaderCBLC.Validate("Contract Norm Code", ContractNormCode);
        ContractHeaderCBLC.Modify(true);
        ContractHeaderCBLC.Release();

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithLinesLastRealisationDate();
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [WHEN] Create MT Norm
        ObjectCBLC.TestField("Object Template No.");
        ContractHeaderCBLC.TestField("Contract Template No.");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Template", ObjectCBLC."Object Template No.", RelatedNormTypeCBLC::"Contract Norm", ContractNormCode, MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Create Object M-schedule
        LibraryObjectLIB.CreateObjectMaintenanceSchedule(ObjectCBLC);

        // [THEN] Check OM-schedule
        ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectCBLC."No.");
        ObjectMaintScheduleCBLC.FindFirst();

        Assert.AreEqual(MaintSchedTemplHdrCBLC."No.", ObjectMaintScheduleCBLC."Maint. Schedule Template No.", 'MT-Schedule does not match.');

        LibraryObjectLIB.GetActiveContractArchiveLine(ObjectCBLC, ContrArchiveLineCBLC, Today());
        Assert.AreEqual(ObjectMaintScheduleCBLC."Starting Date", ContrArchiveLineCBLC."Starting Date", 'Starting date does not match contract line.');
    end;
    #endregion Object Maintenance Schedule

    #region Sales Orders

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectWithObjectMaintenanceScheduleAndItemLinesLastRealisationDate()
    var
        Contact: Record Contact;
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        ObjectCBLC: Record "Object CBLC";
    // LibrarySalesLIB: Codeunit "Library - Sales LIB";
    begin
        // [GIVEN] Object
        LibraryObjectLIB.CreateObject(ObjectCBLC, true, Today() - 23);
        ObjectCBLC.Validate(Description, 'With Maint. schedule');
        ObjectCBLC.Modify(true);
        ObjectNo := ObjectCBLC."No.";

        // [GIVEN] Maintenance Template
        // TODO CreateMaintenanceTemplateWithItemLines(ScheduleCalcTypeCBLC::"Last Realisation Date");
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [GIVEN] Contact
        LibrarySalesLIB.CreatePersonContactWithCustomer(Contact);
        LibraryObjectLIB.CreateObjectContact(ObjectCBLC, 'KLANT', Today() - 600, 0D, Contact."No.");

        // [WHEN] Create All/All norm for M-Template
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::All, '', MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Create Object Maint. for Object
        LibraryMaintenanceLIB.CreateObjectMaintenanceSchedule(ObjectCBLC);

        // [THEN] Match Object Schedule to M-Schedule
        MatchObjectScheduleWithTemplate(ObjectCBLC, MaintSchedTemplHdrCBLC);
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectWithObjectMaintenanceScheduleAndItemLinesStartingDate()
    var
        Contact: Record Contact;
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        ObjectCBLC: Record "Object CBLC";
    // LibrarySalesLIB: Codeunit "Library - Sales LIB";
    begin
        // [GIVEN] Object
        LibraryObjectLIB.CreateObject(ObjectCBLC, true, Today() - 23);
        ObjectCBLC.Validate(Description, 'With Maint. schedule');
        ObjectCBLC.Modify(true);
        ObjectNo := ObjectCBLC."No.";

        // [GIVEN] Maintenance Template
        CreateMaintenanceTemplateWithItemLines(ScheduleCalcTypeCBLC::"Starting Date");
        MaintSchedTemplHdrCBLC.Get(MaintScheduleTemplateNo);
        MaintSchedTemplHdrCBLC.TestField("No.");

        // [GIVEN] Contact
        LibrarySalesLIB.CreatePersonContactWithCustomer(Contact);
        LibraryObjectLIB.CreateObjectContact(ObjectCBLC, 'KLANT', Today() - 600, 0D, Contact."No.");

        // [WHEN] Create All/All norm for M-Template
        LibraryMaintenanceLIB.DeleteAllMaintenanceNorms();
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::All, '', MaintSchedTemplHdrCBLC."No.");

        // [WHEN] Create Object Maint. for Object
        LibraryMaintenanceLIB.CreateObjectMaintenanceSchedule(ObjectCBLC);

        // [THEN] Match Object Schedule to M-Schedule
        MatchObjectScheduleWithTemplate(ObjectCBLC, MaintSchedTemplHdrCBLC);
    end;

    [Test]
    [HandlerFunctions('MessageHandler,CreateScheduleOrdersRequestPageHandler')]
    procedure CreateObjectWithObjectMaintenanceScheduleAndSalesOrders()
    var
        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
        // ObjectNo: Code[20];
        // ObjectCBLC: Record "Object CBLC";
        CreateMaintenanceOrdersCBLC: Report "Create Maintenance Orders CBLC";
        ObjectNoArray: array[3] of Code[20];
    begin
        // [GIVEN] Create 3 Object & OM-Schedule
        CreateObjectWithObjectMaintenanceScheduleAndItemLinesLastRealisationDate();
        ObjectNoArray[1] := ObjectNo;
        CreateObjectWithObjectMaintenanceScheduleAndItemLinesLastRealisationDate();
        ObjectNoArray[2] := ObjectNo;
        CreateObjectWithObjectMaintenanceScheduleAndItemLinesLastRealisationDate();
        ObjectNoArray[3] := ObjectNo;

        // [WHEN] Run Report
        Commit();
        ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectNoArray[1]);
        // CreateScheduleOrdersCBLC.SetNextPlanningDate(Today() + 400); //FIXME
        CreateMaintenanceOrdersCBLC.SetTableView(ObjectMaintScheduleCBLC);
        CreateMaintenanceOrdersCBLC.RunModal();

        // [THEN] Test OM-Schedule
        ObjectMaintScheduleCBLC.FindFirst();
        ObjectMaintScheduleCBLC.TestField("Sales Order No.");
    end;

    [Test]
    [HandlerFunctions('MessageHandler,CreateScheduleOrdersRequestPageHandler')]
    procedure CreateObjectWithObjectMaintenanceScheduleAndSalesOrdersItemLastRealisationDate()
    var
        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
        ResourceGroup: Record "Resource Group";
        SalesLine: Record "Sales Line";
        SalesPlanLineCBLC: Record "Sales Plan. Line CBLC";
        SalesRealizationCBLC: Record "Sales Realization CBLC";
        CreateMaintenanceOrdersCBLC: Report "Create Maintenance Orders CBLC";
        ItemNo: Code[20];
        ObjectNoArray: array[3] of Code[20];
        ResourceGroupNo: Code[20];
        I: Integer;
    begin
        // [GIVEN] Create 3 Object & OM-Schedule
        CreateObjectWithObjectMaintenanceScheduleAndItemLinesLastRealisationDate();
        ObjectNoArray[1] := ObjectNo;
        CreateObjectWithObjectMaintenanceScheduleAndItemLinesLastRealisationDate();
        ObjectNoArray[2] := ObjectNo;
        CreateObjectWithObjectMaintenanceScheduleAndItemLinesLastRealisationDate();
        ObjectNoArray[3] := ObjectNo;

        // [WHEN] Run Report to create orders
        Commit();
        ItemNo := 'TSERVICE1';
        // LibraryObjectLIB.GetLastObject(ObjectCBLC);
        ObjectMaintScheduleCBLC.SetFilter("Object No.", '%1..%2', ObjectNoArray[1], ObjectNoArray[3]);
        ObjectMaintScheduleCBLC.SetRange("Item No. (Service)", ItemNo);
        // CreateScheduleOrdersCBLC.SetNextPlanningDate(Today() + 400); //FIXME
        CreateMaintenanceOrdersCBLC.SetTableView(ObjectMaintScheduleCBLC);
        CreateMaintenanceOrdersCBLC.RunModal();

        // [THEN] Test OM-Schedules
        for I := 1 to 3 do
            if ObjectNoArray[I] <> '' then begin
                ObjectMaintScheduleCBLC.Reset();
                ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectNoArray[I]);
                ObjectMaintScheduleCBLC.SetRange("Item No. (Service)", ItemNo);

                ObjectMaintScheduleCBLC.FindFirst();
                // [THEN] Must have Sales Order
                ObjectMaintScheduleCBLC.TestField("Sales Order No.");
                ObjectMaintScheduleCBLC.TestField("Sales Order Line No.");
                ObjectMaintScheduleCBLC.CalcFields("Sales Order Planning Date Time");
                ObjectMaintScheduleCBLC.TestField("Sales Order Planning Date Time");
            end;

        // Commit;

        // [When] Update Sales Plan Line & Sales Realization
        for I := 1 to 3 do
            if ObjectNoArray[I] <> '' then begin
                ObjectMaintScheduleCBLC.Reset();
                ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectNoArray[I]);
                ObjectMaintScheduleCBLC.SetRange("Item No. (Service)", ItemNo);
                ObjectMaintScheduleCBLC.FindFirst();

                ObjectMaintScheduleCBLC.TestField("Sales Order No.");
                ObjectMaintScheduleCBLC.TestField("Sales Order Line No.");

                ResourceGroupNo := 'INSTALLATIE';
                ResourceGroup.Get(ResourceGroupNo);

                SalesLine.Get(SalesLine."Document Type"::Order, ObjectMaintScheduleCBLC."Sales Order No.", ObjectMaintScheduleCBLC."Sales Order Line No.");
                SalesPlanLineCBLC.Get(SalesPlanLineCBLC."Document Type"::Order, SalesLine."Document No.", ObjectMaintScheduleCBLC."Sales Order Line No.", ResourceGroupNo);
                SalesPlanLineCBLC.Validate("Resource No.", 'HESSEL');
                SalesPlanLineCBLC.Modify(true);

                LibrarySalesLIB.InitSalesRealization(SalesLine, SalesRealizationCBLC, ResourceGroup);
                SalesRealizationCBLC.Insert(true);

                //Reis
                LibrarySalesLIB.SalesRealizationUpdateTravelStartingDateTime(SalesRealizationCBLC, Today(), 090000T);
                LibrarySalesLIB.SalesRealizationUpdateTravelEndingDateTime(SalesRealizationCBLC, Today(), 100000T);

                //KM
                //        SalesRealizationCBLC.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0));

                //Work
                LibrarySalesLIB.SalesRealizationUpdateWorkStartingDateTime(SalesRealizationCBLC, Today(), 110000T);
                LibrarySalesLIB.SalesRealizationUpdateWorkEndingDateTime(SalesRealizationCBLC, Today(), 130000T);

                SalesRealizationCBLC.Modify(true);
                LibrarySalesLIB.SetSalesRealizationToProcessed(SalesRealizationCBLC);
            end;

        // [THEN] Test for New dates and sales order is removed
        for I := 1 to 3 do
            if ObjectNoArray[I] <> '' then begin
                ObjectMaintScheduleCBLC.Reset();
                ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectNoArray[I]);
                ObjectMaintScheduleCBLC.SetRange("Item No. (Service)", ItemNo);
                ObjectMaintScheduleCBLC.FindFirst();

                ObjectMaintScheduleCBLC.TestField("Sales Order No.", '');
                ObjectMaintScheduleCBLC.TestField("Sales Order Line No.", 0);
            end;
    end;

    [Test]
    [HandlerFunctions('MessageHandler,CreateScheduleOrdersRequestPageHandler')]
    procedure CreateObjectWithObjectMaintenanceScheduleAndSalesOrdersItemStartingDate()
    var
        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
        ResourceGroup: Record "Resource Group";
        SalesLine: Record "Sales Line";
        SalesPlanLineCBLC: Record "Sales Plan. Line CBLC";
        SalesRealizationCBLC: Record "Sales Realization CBLC";
        CreateMaintenanceOrdersCBLC: Report "Create Maintenance Orders CBLC";
        ItemNo: Code[20];
        ObjectNoArray: array[3] of Code[20];
        ResourceGroupNo: Code[20];
        I: Integer;
    begin
        // [GIVEN] Create 3 Object & OM-Schedule
        CreateObjectWithObjectMaintenanceScheduleAndItemLinesStartingDate();
        ObjectNoArray[1] := ObjectNo;
        CreateObjectWithObjectMaintenanceScheduleAndItemLinesStartingDate();
        ObjectNoArray[2] := ObjectNo;
        CreateObjectWithObjectMaintenanceScheduleAndItemLinesStartingDate();
        ObjectNoArray[3] := ObjectNo;

        // [WHEN] Run Report to create orders
        Commit();
        ItemNo := 'TSERVICE1';
        // LibraryObjectLIB.GetLastObject(ObjectCBLC);
        ObjectMaintScheduleCBLC.SetFilter("Object No.", '%1..%2', ObjectNoArray[1], ObjectNoArray[3]);
        ObjectMaintScheduleCBLC.SetRange("Item No. (Service)", ItemNo);
        // CreateScheduleOrdersCBLC.SetNextPlanningDate(Today() + 400); //FIXME
        CreateMaintenanceOrdersCBLC.SetTableView(ObjectMaintScheduleCBLC);
        CreateMaintenanceOrdersCBLC.RunModal();

        // [THEN] Test OM-Schedules
        for I := 1 to 3 do
            if ObjectNoArray[I] <> '' then begin
                ObjectMaintScheduleCBLC.Reset();
                ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectNoArray[I]);
                ObjectMaintScheduleCBLC.SetRange("Item No. (Service)", ItemNo);

                ObjectMaintScheduleCBLC.FindFirst();
                // [THEN] Must have Sales Order
                ObjectMaintScheduleCBLC.TestField("Sales Order No.");
                ObjectMaintScheduleCBLC.TestField("Sales Order Line No.");
                ObjectMaintScheduleCBLC.CalcFields("Sales Order Planning Date Time");
                ObjectMaintScheduleCBLC.TestField("Sales Order Planning Date Time");
            end;

        // Commit;

        // [When] Update Sales Plan Line & Sales Realization
        for I := 1 to 3 do
            if ObjectNoArray[I] <> '' then begin
                ObjectMaintScheduleCBLC.Reset();
                ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectNoArray[I]);
                ObjectMaintScheduleCBLC.SetRange("Item No. (Service)", ItemNo);
                ObjectMaintScheduleCBLC.FindFirst();

                ObjectMaintScheduleCBLC.TestField("Sales Order No.");
                ObjectMaintScheduleCBLC.TestField("Sales Order Line No.");

                ResourceGroupNo := 'INSTALLATIE';
                ResourceGroup.Get(ResourceGroupNo);

                SalesLine.Get(SalesLine."Document Type"::Order, ObjectMaintScheduleCBLC."Sales Order No.", ObjectMaintScheduleCBLC."Sales Order Line No.");
                SalesPlanLineCBLC.Get(SalesPlanLineCBLC."Document Type"::Order, SalesLine."Document No.", ObjectMaintScheduleCBLC."Sales Order Line No.", ResourceGroupNo);
                SalesPlanLineCBLC.Validate("Resource No.", 'HESSEL');
                SalesPlanLineCBLC.Modify(true);

                LibrarySalesLIB.InitSalesRealization(SalesLine, SalesRealizationCBLC, ResourceGroup);
                SalesRealizationCBLC.Insert(true);

                //Reis
                LibrarySalesLIB.SalesRealizationUpdateTravelStartingDateTime(SalesRealizationCBLC, Today(), 090000T);
                LibrarySalesLIB.SalesRealizationUpdateTravelEndingDateTime(SalesRealizationCBLC, Today(), 100000T);

                //KM
                //        SalesRealizationCBLC.Validate("Travel Distance (km)", LibraryRandom.RandDecInDecimalRange(5, 30, 0));

                //Work
                LibrarySalesLIB.SalesRealizationUpdateWorkStartingDateTime(SalesRealizationCBLC, Today(), 110000T);
                LibrarySalesLIB.SalesRealizationUpdateWorkEndingDateTime(SalesRealizationCBLC, Today(), 130000T);

                SalesRealizationCBLC.Modify(true);
                LibrarySalesLIB.SetSalesRealizationToProcessed(SalesRealizationCBLC);
            end;

        // [THEN] Test for New dates and sales order is removed
        for I := 1 to 3 do
            if ObjectNoArray[I] <> '' then begin
                ObjectMaintScheduleCBLC.Reset();
                ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectNoArray[I]);
                ObjectMaintScheduleCBLC.SetRange("Item No. (Service)", ItemNo);
                ObjectMaintScheduleCBLC.FindFirst();

                ObjectMaintScheduleCBLC.TestField("Sales Order No.", '');
                ObjectMaintScheduleCBLC.TestField("Sales Order Line No.", 0);
            end;
    end;
    #endregion Sales Orders

    #region Support functions
    local procedure MatchObjectScheduleWithTemplate(var ObjectCBLC: Record "Object CBLC"; var MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC")
    var
        MaintSchedTemplLineCBLC: Record "Maint. Sched. Templ. Line CBLC";
        ObjectMaintScheduleCBLC: Record "Object Maint. Schedule CBLC";
        ContractNo: Code[20];
        StartEntryNo: Integer;
    begin
        ObjectCBLC.TestField("No.");
        // ContractNo := ObjectCBLC.GetActiveContractArchiveNo(Today()); //FIXME
        ObjectMaintScheduleCBLC.SetRange("Object No.", ObjectCBLC."No.");

        MaintSchedTemplHdrCBLC.TestField("No.");
        MaintSchedTemplLineCBLC.SetRange("Maint. Template No.", MaintSchedTemplHdrCBLC."No.");

        Assert.AreEqual(MaintSchedTemplLineCBLC.Count(), ObjectMaintScheduleCBLC.Count(), 'Templates lines do not match.');

        ObjectMaintScheduleCBLC.FindFirst();
        StartEntryNo := ObjectMaintScheduleCBLC."Entry No.";
        StartEntryNo -= 1;

        if MaintSchedTemplLineCBLC.FindSet() then
            repeat
                StartEntryNo += 1;
                ObjectMaintScheduleCBLC.Get(StartEntryNo);
                Assert.AreEqual(MaintSchedTemplLineCBLC."Item No. (Service)", ObjectMaintScheduleCBLC."Item No. (Service)", 'Item No. does not match.');
                Assert.AreEqual(ContractNo, ObjectMaintScheduleCBLC."Contract No.", 'Contract No. does not match.');
            until MaintSchedTemplLineCBLC.Next() = 0;
    end;

    local procedure CreateTestMaintenanceNorms()
    var
        MaintenanceTemplateNo: Code[20];
        ObjectNormNo: Code[20];
        RelatedNormNo: Code[20];
    begin
        //Template
        ObjectNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Template CBLC");
        RelatedNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contract Header CBLC");
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Template", ObjectNormNo, RelatedNormTypeCBLC::Contract, RelatedNormNo, MaintenanceTemplateNo);

        ObjectNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Template CBLC");
        RelatedNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contr. Template Header CBLC");
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Template", ObjectNormNo, RelatedNormTypeCBLC::"Contract Template", RelatedNormNo, MaintenanceTemplateNo);

        ObjectNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Template CBLC");
        // RelatedNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contract Header CBLC");
        RelatedNormNo := '';
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Template", ObjectNormNo, RelatedNormTypeCBLC::"All Contracts", RelatedNormNo, MaintenanceTemplateNo);

        ObjectNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Template CBLC");
        RelatedNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contract Norm CBLC");
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Template", ObjectNormNo, RelatedNormTypeCBLC::"Contract Norm", RelatedNormNo, MaintenanceTemplateNo);

        ObjectNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Template CBLC");
        // RelatedNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contract Header CBLC");
        RelatedNormNo := '';
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Template", ObjectNormNo, RelatedNormTypeCBLC::All, RelatedNormNo, MaintenanceTemplateNo);

        //Object Norm
        ObjectNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Norm CBLC");
        RelatedNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contract Header CBLC");
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Norm", ObjectNormNo, RelatedNormTypeCBLC::Contract, RelatedNormNo, MaintenanceTemplateNo);

        ObjectNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Norm CBLC");
        RelatedNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contr. Template Header CBLC");
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Norm", ObjectNormNo, RelatedNormTypeCBLC::"Contract Template", RelatedNormNo, MaintenanceTemplateNo);

        ObjectNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Norm CBLC");
        RelatedNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contract Norm CBLC");
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Norm", ObjectNormNo, RelatedNormTypeCBLC::"Contract Norm", RelatedNormNo, MaintenanceTemplateNo);

        ObjectNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Norm CBLC");
        // RelatedNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contract Norm CBLC");
        RelatedNormNo := '';
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Norm", ObjectNormNo, RelatedNormTypeCBLC::"All Contracts", RelatedNormNo, MaintenanceTemplateNo);

        ObjectNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Norm CBLC");
        // RelatedNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contract Norm CBLC");
        RelatedNormNo := '';
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::"Object Norm", ObjectNormNo, RelatedNormTypeCBLC::All, RelatedNormNo, MaintenanceTemplateNo);

        //All
        ObjectNormNo := '';
        RelatedNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contract Header CBLC");
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, ObjectNormNo, RelatedNormTypeCBLC::Contract, RelatedNormNo, MaintenanceTemplateNo);

        ObjectNormNo := '';
        RelatedNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contr. Template Header CBLC");
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, ObjectNormNo, RelatedNormTypeCBLC::"Contract Template", RelatedNormNo, MaintenanceTemplateNo);

        ObjectNormNo := '';
        RelatedNormNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Contract Norm CBLC");
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, ObjectNormNo, RelatedNormTypeCBLC::"Contract Norm", RelatedNormNo, MaintenanceTemplateNo);

        ObjectNormNo := '';
        RelatedNormNo := '';
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, ObjectNormNo, RelatedNormTypeCBLC::"All Contracts", RelatedNormNo, MaintenanceTemplateNo);

        ObjectNormNo := '';
        RelatedNormNo := '';
        MaintenanceTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Maint. Sched. Templ. Hdr. CBLC");
        LibraryMaintenanceLIB.CreateMaintenanceNorm(ObjectNormTypeCBLC::All, ObjectNormNo, RelatedNormTypeCBLC::All, RelatedNormNo, MaintenanceTemplateNo);
    end;

    local procedure CreateObjectFromTemplateWithContract(var ObjectCBLC: Record "Object CBLC"; var ContractHeaderCBLC: Record "Contract Header CBLC")
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        // CreateContractObjMethCBLC: Codeunit "Create Contract Obj. Meth CBLC";
        LibrarySkillLIB: Codeunit "Library - Skill LIB";
        SkillCode: Code[10];
        SkillTypeCBLC: Enum "Skill Type CBLC";
    begin
        // [SCENARIO]

        // [GIVEN] Object
        LibraryObjectLIB.CreateObjectWithRandomTemplate(ObjectCBLC);
        ObjectNo := ObjectCBLC."No.";

        ObjectCBLC.Validate("Installation Date", Today() - 4);
        ObjectCBLC.Modify(true);
        LibraryObjectLIB.CreatePriceItemNoForObject(ObjectCBLC);

        // [WHEN] Add Geo Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillTypeCBLC::Geography);
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        ObjectCBLC.Find('=');

        // [THEN] Object has Geo skill on record
        Assert.AreEqual(SkillCode, ObjectCBLC."Geography Skill Code", 'Object Geography Skill not the same');

        // [WHEN] Add Org Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillTypeCBLC::Organization);
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        ObjectCBLC.Find('=');
        // [THEN] Object has Org skill on record
        Assert.AreEqual(SkillCode, ObjectCBLC."Organization Skill Code", 'Object Organization Skill not the same');
        //TODO TERUG

        // [GIVEN] Object Contact
        LibraryObjectLIB.AddObjectCustomerContact(ObjectCBLC, Today() - 10);

        // [WHEN] Create Contract
        ContrTemplateHeaderCBLC.FindFirst();
        // CreateContractObjMethCBLC.CreateContractFromObject(ObjectCBLC, ContrTemplateHeaderCBLC."No.", Today(), true); //FIXME
        ContractHeaderCBLC.FindLast();
    end;

    local procedure CreateMaintenanceTemplateWithItemLines(ScheduleCalcType: Enum "Schedule Calc. Type CBLC")
    var
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
        MaintSchedTemplLineCBLC: Record "Maint. Sched. Templ. Line CBLC";
        DevMax: DateFormula;
        DevMin: DateFormula;
        Periodicity: DateFormula;
        ItemNo: Code[20];
        I: Integer;
        DevMaxTok: Label '<+1M>', Locked = true;
        DevMinTok: Label '<-1M>', Locked = true;
        YearTok: Label '<+%1Y>', Comment = '%1=Year', Locked = true;
    begin
        // [GIVEN] Maintenance Template
        Initialize();
        LibraryMaintenanceLIB.CreateMaintenanceTemplate(MaintSchedTemplHdrCBLC, ScheduleCalcType);
        // [THEN]
        MaintSchedTemplHdrCBLC.TestField("No.");
        MaintScheduleTemplateNo := MaintSchedTemplHdrCBLC."No.";

        I := 1;
        ItemNo := 'TSERVICE1';
        Evaluate(Periodicity, StrSubstNo(YearTok, I));
        Evaluate(DevMin, DevMinTok);
        Evaluate(DevMax, DevMaxTok);
        Clear(MaintSchedTemplLineCBLC);
        LibraryMaintenanceLIB.CreateMaintenanceTemplateLine(MaintSchedTemplHdrCBLC, MaintSchedTemplLineCBLC, ItemNo, Periodicity, DevMin, DevMax);

        I := 2;
        ItemNo := 'TSERVICE2';
        Evaluate(Periodicity, StrSubstNo(YearTok, I));
        Evaluate(DevMin, DevMinTok);
        Evaluate(DevMax, DevMaxTok);
        Clear(MaintSchedTemplLineCBLC);
        LibraryMaintenanceLIB.CreateMaintenanceTemplateLine(MaintSchedTemplHdrCBLC, MaintSchedTemplLineCBLC, ItemNo, Periodicity, DevMin, DevMax);

        I := 3;
        ItemNo := 'TSERVICE3';
        Evaluate(Periodicity, StrSubstNo(YearTok, I));
        Evaluate(DevMin, DevMinTok);
        Evaluate(DevMax, DevMaxTok);
        Clear(MaintSchedTemplLineCBLC);
        LibraryMaintenanceLIB.CreateMaintenanceTemplateLine(MaintSchedTemplHdrCBLC, MaintSchedTemplLineCBLC, ItemNo, Periodicity, DevMin, DevMax);
    end;

    // procedure GetActiveContractLine(ObjectCBLC: Record "Object CBLC"; var ContractLineCBLC: Record "Contract Line CBLC")
    // begin
    //     //Get Active Contract Line
    //     ContractLineCBLC.SetRange("Object No.", ObjectCBLC."No.");
    //     ContractLineCBLC.SetFilter("Starting Date", '<=%1', Today());
    //     ContractLineCBLC.SetFilter("Ending Date", '>=%1|%2', Today(), 0D);
    //     ContractLineCBLC.FindFirst();
    // end;


    local procedure Initialize()
    var
        LibraryItemLIB: Codeunit "Library - Item LIB";
    begin
        // [GIVEN] Create Service Items
        LibraryItemLIB.CreateTestServiceItems();
    end;

    local procedure CreateMaintenanceTemplateWithLinesLastRealisationDate()
    var
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Maintenance Template
        LibraryMaintenanceLIB.CreateMaintenanceTemplateWithLines(MaintSchedTemplHdrCBLC, ScheduleCalcTypeCBLC::"Last Realization Date");
        MaintScheduleTemplateNo := MaintSchedTemplHdrCBLC."No.";

        // [THEN]
        MaintSchedTemplHdrCBLC.TestField("No.");
    end;

    [Test]
    procedure CreateMaintenanceTemplateWithLinesLastStartingDate()
    var
        MaintSchedTemplHdrCBLC: Record "Maint. Sched. Templ. Hdr. CBLC";
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Maintenance Template
        LibraryMaintenanceLIB.CreateMaintenanceTemplateWithLines(MaintSchedTemplHdrCBLC, ScheduleCalcTypeCBLC::"Starting Date");
        MaintScheduleTemplateNo := MaintSchedTemplHdrCBLC."No.";

        // [THEN]
        MaintSchedTemplHdrCBLC.TestField("No.");
    end;

    #endregion Support functions

    #region Handlers
    [MessageHandler]
    procedure MessageHandler(MessageText: Text[1024])
    begin
        // if MessageText = MessageText then;
    end;

    [RequestPageHandler]
    procedure CreateScheduleOrdersRequestPageHandler(var CreateMaintenanceOrdersCBLC: TestRequestPage "Create Maintenance Orders CBLC")
    begin
        // CreateScheduleOrdersCBLC.NextPlanningDateControl.SetValue(Today() + 400);
        CreateMaintenanceOrdersCBLC.OK().Invoke();
    end;
    #endregion Handlers
}
