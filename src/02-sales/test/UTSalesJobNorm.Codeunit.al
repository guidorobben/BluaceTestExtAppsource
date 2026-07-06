#pragma warning disable PC0030
codeunit 83906 "UT Sales/Job Norm TPTE"
{
    Permissions =
        tabledata "Contract Header CBLC" = R,
        tabledata "Contract Setup CBLC" = R,
        tabledata Item = RM,
        tabledata "Item Usage Norm CBLC" = RD,
        tabledata Job = R,
        tabledata "Job Task" = R,
        tabledata "Object Template CBLC" = R,
        tabledata "Object CBLC" = RM,
        tabledata "Resource Group" = R;
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryItemLIB: Codeunit "Library - Item LIB";
        // LibraryItemLIB: Codeunit "Library - Item Norm LIB";
        LibraryObjectLib: Codeunit "Library - Object LIB";
        LibraryRandom: Codeunit "Library - Random";
        LibraryRandomLIB: Codeunit "Library - Random LIB";

    [Test]
    procedure Initialize()
    var
        InitContractLIB: Codeunit "Init. Contract LIB";
        InitItemLIB: Codeunit "Init. Item LIB";
        InitObjectLIB: Codeunit "Init. Object LIB";
    begin
        //[GIVEN] given
        //[WHEN] when
        //[THEN] then
        InitItemLIB.Initialize();
        InitContractLIB.Initialize();
        InitObjectLIB.Initialize();
    end;

    #region Sales
    [Test]
    procedure CreateServiceItemWithObjectNorms()
    var
        ContractSetupCBLC: Record "Contract Setup CBLC";
        Item: Record Item;
        ItemUsageNormCBLC: Record "Item Usage Norm CBLC";
        ObjectTemplateCBLC: Record "Object Template CBLC";
        ObjectCBLC, ObjectCBLC2 : Record "Object CBLC";
        ItemNo: Code[20];
        ObjectNormTypeCBLC: Enum "Object Norm Type CBLC";
        RelatedNormTypeCBLC: Enum "Related Norm Type CBLC";
    begin
        ContractSetupCBLC.Get();

        //[GIVEN] gItem
        ItemNo := 'TSERVICE1';
        Clear(Item);
        if not Item.Get(ItemNo) then
            LibraryItemLIB.CreatePriceItem(Item, ItemNo, LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), 'MAAND');
        Item.TestField("No.");
        Item.Validate("Item Category Code", ContractSetupCBLC."Item Category Service");
        Item.Modify(true);

        //Create Object
        LibraryObjectLib.CreateObject(ObjectCBLC, false, (Today() + 3));
        ObjectCBLC.Validate(Description, 'Object 1 with Norms');
        ObjectCBLC.Modify(true);

        //Create Object with Template
        ObjectTemplateCBLC.Get(LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Template CBLC"));
        LibraryObjectLib.CreateObjectWithTemplate(ObjectCBLC2, ObjectTemplateCBLC);
        ObjectCBLC2.Validate(Description, 'Object 1 with Norms');
        ObjectCBLC2.Modify(true);

        Clear(ItemUsageNormCBLC);
        ItemUsageNormCBLC.SetRange("Item No.", Item."No.");
        ItemUsageNormCBLC.DeleteAll(false);

        //Add Usage Norms
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::All, '');
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::Object, ObjectCBLC."No.", RelatedNormTypeCBLC::All, '');
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::"Object Template", ObjectTemplateCBLC."No.", RelatedNormTypeCBLC::All, '');
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::"Object Norm", LibraryRandomLIB.GetRandomValueByTable(Database::"Object Norm CBLC"), RelatedNormTypeCBLC::All, '');
    end;

    [Test]
    procedure CreateServiceItemWithObjectNormsAndRelatedAll()
    var
        ContractSetupCBLC: Record "Contract Setup CBLC";
        Item: Record Item;
        ItemUsageNormCBLC: Record "Item Usage Norm CBLC";
        ObjectTemplateCBLC: Record "Object Template CBLC";
        ObjectCBLC, ObjectCBLC2 : Record "Object CBLC";
        ItemNo: Code[20];
        ObjectNormTypeCBLC: Enum "Object Norm Type CBLC";
        RelatedNormTypeCBLC: Enum "Related Norm Type CBLC";
    begin
        ContractSetupCBLC.Get();

        //[GIVEN] given
        ItemNo := 'TSERVICE2';
        Clear(Item);
        if not Item.Get(ItemNo) then
            LibraryItemLIB.CreatePriceItem(Item, ItemNo, LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), 'MAAND');
        Item.TestField("No.");
        Item.Validate("Item Category Code", ContractSetupCBLC."Item Category Service");
        Item.Modify(true);

        //Create Object
        LibraryObjectLib.CreateObject(ObjectCBLC, false, (Today() + 3));
        ObjectCBLC.Validate(Description, 'Object 2 with Norms');
        ObjectCBLC.Modify(true);

        //Create Object with Template
        ObjectTemplateCBLC.Get(LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Template CBLC"));
        LibraryObjectLib.CreateObjectWithTemplate(ObjectCBLC2, ObjectTemplateCBLC);
        ObjectCBLC2.Validate(Description, 'Object 2 with Norms');
        ObjectCBLC2.Modify(true);

        //Delete Norms
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.DeleteAllItemUsageNorms(Item."No.", false);

        //Add Norms to Item
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::All, '', 'SP-BOM1101', 1);

        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::Object, ObjectCBLC."No.", RelatedNormTypeCBLC::All, '', 'SP-BOM1102', 2);

        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::"Object Template", ObjectTemplateCBLC."No.", RelatedNormTypeCBLC::All, '', 'SP-BOM1103', 3);

        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::"Object Norm", LibraryRandomLIB.GetRandomValueByTable(Database::"Object Norm CBLC"), RelatedNormTypeCBLC::All, '', 'SP-BOM1104', 4);
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateServiceItemWithObjectNormsAndRelatedMixed()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractSetupCBLC: Record "Contract Setup CBLC";
        Item: Record Item;
        ItemUsageNormCBLC: Record "Item Usage Norm CBLC";
        ObjectTemplateCBLC: Record "Object Template CBLC";
        ObjectCBLC, ObjectCBLC2 : Record "Object CBLC";
        ItemNo: Code[20];
        ObjectNormTypeCBLC: Enum "Object Norm Type CBLC";
        RelatedNormTypeCBLC: Enum "Related Norm Type CBLC";
    begin
        ContractSetupCBLC.Get();

        //[GIVEN] given
        ItemNo := 'TSERVICE3';
        Clear(Item);
        if not Item.Get(ItemNo) then
            LibraryItemLIB.CreatePriceItem(Item, ItemNo, LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), 'MAAND', ContractSetupCBLC."Item Category Service");

        //Create Object with Template and contract
        ObjectTemplateCBLC.Get(LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Template CBLC"));
        LibraryObjectLib.CreateObjectWithContract(ObjectCBLC2, ObjectTemplateCBLC, ContractHeaderCBLC);
        // LibraryObjectLib.CreateObjectWithTemplate(ObjectCBLC2, ObjectTemplateCBLC);
        ObjectCBLC2.Validate(Description, 'Object 3 with Norms');
        ObjectCBLC2.Validate("Object Norm Code", LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Norm CBLC"));
        ObjectCBLC2.Modify(true);

        //Contract
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Release();

        //Delete Norms
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.DeleteAllItemUsageNorms(Item."No.", false);

        //Add Norms to Item
        //All/All
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::All, '', 'SP-BOM1101', 1);

        //Object/All
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::Object, ObjectCBLC."No.", RelatedNormTypeCBLC::All, '', 'SP-BOM1102', 2);

        //Object/Contract All
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::Object, ObjectCBLC."No.", RelatedNormTypeCBLC::"All Contracts", '', 'SP-BOM1105', 5);

        //Object Template
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::"Object Template", ObjectTemplateCBLC."No.", RelatedNormTypeCBLC::All, '', 'SP-BOM1103', 3);

        //Object Norm
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::"Object Norm", LibraryRandomLIB.GetRandomValueByTable(Database::"Object Norm CBLC"), RelatedNormTypeCBLC::All, '', 'SP-BOM1104', 4);
    end;

    #endregion

    #region Job

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateServiceItemJobWithObjectNormsAndRelatedMixed()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractSetupCBLC: Record "Contract Setup CBLC";
        Item: Record Item;
        ItemPlanningNormCBLC: Record "Item Planning Norm CBLC";
        ItemUsageNormCBLC: Record "Item Usage Norm CBLC";
        Job: Record Job;
        JobTask: Record "Job Task";
        // ItemUsageNormCBLC: Record "Item Usage Norm CBLC";
        ObjectTemplateCBLC: Record "Object Template CBLC";
        ObjectCBLC: Record "Object CBLC";
        ResourceGroup: Record "Resource Group";
        ItemNo: Code[20];
        ObjectNormTypeCBLC: Enum "Object Norm Type CBLC";
        RelatedNormTypeCBLC: Enum "Related Norm Type CBLC";
    begin
        ContractSetupCBLC.Get();

        //[GIVEN] given
        ItemNo := 'TSERVICE4';
        Clear(Item);
        if not Item.Get(ItemNo) then
            LibraryItemLIB.CreatePriceItem(Item, ItemNo, LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), 'MAAND', ContractSetupCBLC."Item Category Service");

        //Create Object with Template and contract
        ObjectTemplateCBLC.Get(LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Template CBLC"));
        LibraryObjectLib.CreateObjectWithContract(ObjectCBLC, ObjectTemplateCBLC, ContractHeaderCBLC);
        ObjectCBLC.Validate(Description, 'Object 3 with Norms');
        ObjectCBLC.Validate("Object Norm Code", LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Object Norm CBLC"));
        ObjectCBLC.Modify(true);

        //Contract
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Release();

        ResourceGroup.Get(LibraryRandomLIB.GetRandomValueByTableCode20(Database::"Resource Group"));

        //Delete Norms
        Clear(ItemPlanningNormCBLC);
        LibraryItemLIB.DeleteAllItemPlanningNorms(Item."No.", false);

        //Add Planning Norms to Item
        //All/All
        Clear(ItemPlanningNormCBLC);
        LibraryItemLIB.CreateItemPlanningNorm(Item, ItemPlanningNormCBLC, ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::All, '', ResourceGroup."No.", 'UUR', 1);

        //Object/All
        Clear(ItemPlanningNormCBLC);
        LibraryItemLIB.CreateItemPlanningNorm(Item, ItemPlanningNormCBLC, ObjectNormTypeCBLC::Object, ObjectCBLC."No.", RelatedNormTypeCBLC::All, '', ResourceGroup."No.", 'UUR', 2);

        //All/Job
        Job.Get('JOB00020');
        JobTask.SetRange("Job No.", Job."No.");
        if JobTask.FindFirst() then; //IGNORE
        LibraryObjectLib.AddJobTaskObject(JobTask."Job No.", JobTask."Job Task No.", ObjectCBLC);

        Clear(ItemPlanningNormCBLC);
        LibraryItemLIB.CreateItemPlanningNorm(Item, ItemPlanningNormCBLC, ObjectNormTypeCBLC::All, ObjectCBLC."No.", RelatedNormTypeCBLC::Job, Job."No.", ResourceGroup."No.", 'UUR', 20);

        //Object/Job
        Job.Get('JOB00030');
        JobTask.SetRange("Job No.", Job."No.");
        if JobTask.FindFirst() then; //IGNORE
        LibraryObjectLib.AddJobTaskObject(JobTask."Job No.", JobTask."Job Task No.", ObjectCBLC);

        Clear(ItemPlanningNormCBLC);
        LibraryItemLIB.CreateItemPlanningNorm(Item, ItemPlanningNormCBLC, ObjectNormTypeCBLC::Object, ObjectCBLC."No.", RelatedNormTypeCBLC::Job, Job."No.", ResourceGroup."No.", 'UUR', 30);

        //Object Template
        Clear(ItemPlanningNormCBLC);
        LibraryItemLIB.CreateItemPlanningNorm(Item, ItemPlanningNormCBLC, ObjectNormTypeCBLC::"Object Template", ObjectTemplateCBLC."No.", RelatedNormTypeCBLC::All, '', ResourceGroup."No.", 'UUR', 3);

        //Object Norm
        Clear(ItemPlanningNormCBLC);
        LibraryItemLIB.CreateItemPlanningNorm(Item, ItemPlanningNormCBLC, ObjectNormTypeCBLC::"Object Norm", LibraryRandomLIB.GetRandomValueByTable(Database::"Object Norm CBLC"), RelatedNormTypeCBLC::"All Jobs", '', ResourceGroup."No.", 'UUR', 4);


        //Delete Usage Norms
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.DeleteAllItemUsageNorms(Item."No.", false);

        //Add Usage Norms to Item
        //All/All
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::All, '', 'SP-BOM1101', 1);

        //Object/All
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::Object, ObjectCBLC."No.", RelatedNormTypeCBLC::All, '', 'SP-BOM1102', 2);

        //Object/Contract All
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::Object, ObjectCBLC."No.", RelatedNormTypeCBLC::"All Contracts", '', 'SP-BOM1105', 5);

        //Object Template
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::"Object Template", ObjectTemplateCBLC."No.", RelatedNormTypeCBLC::All, '', 'SP-BOM1103', 3);


        //Object Norm
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::"Object Norm", LibraryRandomLIB.GetRandomValueByTable(Database::"Object Norm CBLC"), RelatedNormTypeCBLC::All, '', 'SP-BOM1104', 4);

        //All/ Job
        Job.Get('JOB00020');
        JobTask.SetRange("Job No.", Job."No.");
        if JobTask.FindFirst() then;//IGNORE
        LibraryObjectLib.AddJobTaskObject(JobTask."Job No.", JobTask."Job Task No.", ObjectCBLC);
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::Job, Job."No.", 'SP-BOM1106', 6);

        //All/All Jobs
        // Job.Get('JOB00020');
        Clear(ItemUsageNormCBLC);
        LibraryItemLIB.CreateItemUsageNorm(Item, ItemUsageNormCBLC, ObjectNormTypeCBLC::All, '', RelatedNormTypeCBLC::"All Jobs", '', 'SP-BOM1102', 2);
    end;
    #endregion

    [MessageHandler]
    procedure MessageHandler(MessageText: Text[1024])
    begin
        // if MessageText = MessageText then;
    end;
}
#pragma warning restore PC0030
