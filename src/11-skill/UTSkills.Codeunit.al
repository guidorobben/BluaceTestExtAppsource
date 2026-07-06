#pragma warning disable PC0030
codeunit 83923 "UT Skills TPTE"
{
    Permissions =
        tabledata "Contr. Template Header CBLC" = RMD,
        tabledata "Contr. Template Service CBLC" = R,
        tabledata "Contract Header CBLC" = RMD,
        tabledata "Contract Setup CBLC" = R,
        tabledata "Contract Templ. Coverage CBLC" = R,
        tabledata Customer = R,
        tabledata Item = RM,
        tabledata "Job Planning Line" = RMD,
        tabledata "Job Task" = R,
        tabledata "Object Template CBLC" = RM,
        tabledata "Object CBLC" = RIMD,
        tabledata Resource = R,
        tabledata "Sales Header" = R,
        tabledata "Sales Line" = RMD,
        tabledata "Skill Code" = RM,
        tabledata "Skill Line CBLC" = R;
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        LibraryContractLIB: Codeunit "Library - Contract LIB";
        LibraryItemLIB: Codeunit "Library - Item LIB";
        LibraryJobLIB: Codeunit "Library - Job LIB";
        LibraryObjectLIB: Codeunit "Library - Object LIB";
        LibraryRandomLIB: Codeunit "Library - Random LIB";
        LibraryResource: Codeunit "Library - Resource LIB";
        LibrarySalesLIB: Codeunit "Library - Sales LIB";
        LibrarySkillLIB: Codeunit "Library - Skill LIB";
        JobPlanningLineType: Enum "Job Planning Line Line Type";
        JobPlanningType: Enum "Job Planning Line Type";
        ResourceSkillType: Enum "Resource Skill Type";
        SkillType: Enum "Skill Type CBLC";
        JobPlanningLineSystemId: Guid;
        SkillDoesNotExistErr: Label 'Skill %1 does not exist for %2 %3.', Comment = '%1=Skill, %2=2, %3=3';


    #region Resource

    [Test]
    procedure CreateResourceWithSkills()
    var
        Resource: Record Resource;
    begin
        // [SCENARIO]        

        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] resource
        if not Resource.Get('RESOURCE1') then
            LibraryResource.CreateResource(Resource, 'RESOURCE1', 'Resource 1');
        Resource.TestField("No.");

        // [WHEN]
        LibrarySkillLIB.DeleteResourceSkills(Resource);
        Resource.Get(Resource."No.");

        // [THEN]
        Assert.AreEqual('', Resource."Geography Skill Code CBLC", 'Resource Geography Skill is not empty.');
        Assert.AreEqual('', Resource."Organization Skill Code CBLC", 'Resource Organization Skill is not empty.');
    end;

    [Test]
    procedure AddResourceSkills()
    var
        Resource: Record Resource;
        SkillCode: Code[10];
        ResourceNo: Code[20];
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Resource
        ResourceNo := 'ADDSKILLS';
        if not Resource.Get(ResourceNo) then
            LibraryResource.CreateResource(Resource, ResourceNo, 'Resource first skills');

        LibrarySkillLIB.DeleteResourceSkills(Resource);
        Resource.Find('=');

        // [WHEN]
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToResource(Resource, SkillCode);
        Resource.Find('=');
        // [THEN]
        Assert.AreEqual(SkillCode, Resource."Geography Skill Code CBLC", 'Resource Geography Skill not the same');

        // [WHEN]
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToResource(Resource, SkillCode);
        Resource.Get(Resource."No.");

        // [THEN]
        Assert.AreEqual(SkillCode, Resource."Organization Skill Code CBLC", 'Resource Organization Skill not the same');
    end;

    [Test]
    procedure AddSecondResourceSkills()
    var
        Resource: Record Resource;
        SkillCode: Code[10];
        ResourceNo: Code[20];
    // ResourceSkillHelperCBLC: Codeunit "Resource Skill Helper CBLC";
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Resource
        ResourceNo := 'SECONDSKILLS';
        if not Resource.Get(ResourceNo) then
            LibraryResource.CreateResource(Resource, ResourceNo, 'Resource Second skills');

        LibrarySkillLIB.DeleteResourceSkills(Resource);
        Resource.Find('=');

        // [WHEN] Geo SKill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        if SkillCode = '' then
            Assert.Fail('Skill Code cannot be empty');
        LibrarySkillLIB.AddSkillToResource(Resource, SkillCode);
        Resource.Find('=');
        // [THEN]
        Assert.AreEqual(1, LibrarySkillLIB.ResourceSkillCount(ResourceSkillType::Resource, ResourceNo), 'Resouce Skill count does not match.');
        Assert.AreEqual(SkillCode, Resource."Geography Skill Code CBLC", 'Resource Geography Skill not the same');

        // [WHEN] Org Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        if SkillCode = '' then
            Assert.Fail('Skill Code cannot be empty');
        LibrarySkillLIB.AddSkillToResource(Resource, SkillCode);
        Resource.Find('=');
        // [THEN]
        Assert.AreEqual(SkillCode, Resource."Organization Skill Code CBLC", 'Resource Organization Skill not the same');
        Assert.AreEqual(2, LibrarySkillLIB.ResourceSkillCount(ResourceSkillType::Resource, ResourceNo), 'Resouce Skill count does not match.');

        // [THEN] Error when adding second Geo Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        asserterror LibrarySkillLIB.AddSkillToResource(Resource, SkillCode);
        // [THEN] Error when adding second Org Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        asserterror LibrarySkillLIB.AddSkillToResource(Resource, SkillCode);
    end;

    [Test]
    procedure AddResourceSkillsEmpty()
    var
        Resource: Record Resource;
        SkillCode: Code[10];
    begin
        // [GIVEN] Initialize
        Initialize();

        Resource.Get('RESOURCE1');

        SkillCode := 'BOREN';
        LibrarySkillLIB.AddSkillToResource(Resource, SkillCode);
        if not LibrarySkillLIB.ResourceSkillExist(ResourceSkillType::Resource, Resource."No.", SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, Resource.TableCaption(), Resource."No.");

        SkillCode := 'HAKKEN';
        LibrarySkillLIB.AddSkillToResource(Resource, SkillCode);
        if not LibrarySkillLIB.ResourceSkillExist(ResourceSkillType::Resource, Resource."No.", SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, Resource.TableCaption(), Resource."No.");

        SkillCode := 'ZAGEN';
        LibrarySkillLIB.AddSkillToResource(Resource, SkillCode);
        if not LibrarySkillLIB.ResourceSkillExist(ResourceSkillType::Resource, Resource."No.", SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, Resource.TableCaption(), Resource."No.");
    end;
    #endregion Resource

    #region Item    
    // procedure GetItem(var Item: Record Item)
    // begin
    //     if not Item.Get('1000') then
    //         Item.Get('1010');
    // end;

    [Test]
    procedure AddItemSkills()
    var
        Item: Record Item;
        SkillCode: Code[10];
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN]
        LibraryItemLIB.CreateItem(Item, '');
        // Item.Get('1000');
        LibrarySkillLIB.DeleteItemSkills(Item);

        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToItem(Item, SkillCode);
        Item.Find('=');
        Assert.AreEqual(SkillCode, Item."Geography Skill Code CBLC", 'Item Geography Skill not the same');

        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToItem(Item, SkillCode);
        Item.Get(Item."No.");
        Assert.AreEqual(SkillCode, Item."Organization Skill Code CBLC", 'Item Organization Skill not the same');
    end;

    [Test]
    procedure AddItemSecondItemSkills()
    var
        Item: Record Item;
        SkillCode: Code[10];
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN]
        LibraryItemLIB.CreateItem(Item, '');
        LibrarySkillLIB.DeleteItemSkills(Item);

        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToItem(Item, SkillCode);
        Item.Find('=');
        Assert.AreEqual(SkillCode, Item."Geography Skill Code CBLC", 'Item Geography Skill not the same');

        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToItem(Item, SkillCode);
        Item.Find('=');
        Assert.AreEqual(SkillCode, Item."Organization Skill Code CBLC", 'Item Organization Skill not the same');

        // [THEN] 
        asserterror LibrarySkillLIB.AddSkillToItem(Item, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography));
        asserterror LibrarySkillLIB.AddSkillToItem(Item, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization));
    end;

    [Test]
    procedure AddItemSkillsEmpty()
    var
        Item: Record Item;
        SkillCode: Code[10];
    begin
        // [GIVEN] Initialize
        Initialize();

        LibraryItemLIB.CreateItem(Item, '');

        SkillCode := 'BOREN';
        LibrarySkillLIB.AddSkillToItem(Item, SkillCode);
        if not LibrarySkillLIB.ResourceSkillExist(ResourceSkillType::Item, Item."No.", SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, Item.TableCaption(), Item."No.");

        SkillCode := 'HAKKEN';
        LibrarySkillLIB.AddSkillToItem(Item, SkillCode);
        if not LibrarySkillLIB.ResourceSkillExist(ResourceSkillType::Item, Item."No.", SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, Item.TableCaption(), Item."No.");

        SkillCode := 'ZAGEN';
        LibrarySkillLIB.AddSkillToItem(Item, SkillCode);
        if not LibrarySkillLIB.ResourceSkillExist(ResourceSkillType::Item, Item."No.", SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, Item.TableCaption(), Item."No.");
    end;
    #endregion

    #region Object Template
    local procedure CreateObjectTemplate(var ObjectTemplateCBLC: Record "Object Template CBLC")
    begin
        LibraryObjectLIB.CreateObjectTemplate(ObjectTemplateCBLC);
        ObjectTemplateCBLC.Description := 'Sjabloon: ' + ObjectTemplateCBLC."No.";
        ObjectTemplateCBLC.Modify(true);
    end;

    [Test]
    procedure DeleteSkillFromObjectTemplate()
    var
        ObjectTemplateCBLC: Record "Object Template CBLC";
        SkillsExistErr: Label 'Record still exist for Object Template %1', Comment = '%1=Object Template No.';
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Object Template
        CreateObjectTemplate(ObjectTemplateCBLC);
        // ObjectTemplateCBLC.Get(ObjectTemplateNo);
        ObjectTemplateCBLC.TestField("No.");

        // [WHEN] Delete Skills
        LibrarySkillLIB.DeleteObjectTemplateSkillItems(ObjectTemplateCBLC);

        // [THEN] Test for no skills
        Assert.AreEqual('', ObjectTemplateCBLC."Geography Skill Code", 'Resource Geography Skill is not empty.');
        Assert.AreEqual('', ObjectTemplateCBLC."Organization Skill Code", 'Resource Organization Skill is not empty.');
        if LibrarySkillLIB.HasSkillItemLines(Database::"Object Template CBLC", ObjectTemplateCBLC.SystemId) then
            Error(SkillsExistErr, ObjectTemplateCBLC."No.");
    end;

    [Test]
    procedure CreateObjectTemplateWithSkills()
    var
        ObjectTemplateCBLC: Record "Object Template CBLC";
        SkillCode: Code[10];
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Object Template
        CreateObjectTemplate(ObjectTemplateCBLC);
        // ObjectTemplateCBLC.Get(ObjectTemplateNo);

        // [WHEN] Add Geo Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, SkillCode);
        ObjectTemplateCBLC.Find('=');
        // [THEN] Test Geo Skill
        Assert.AreEqual(SkillCode, ObjectTemplateCBLC."Geography Skill Code", 'Object Template Geography Skill not the same');

        // [WHEN] Add Org Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, SkillCode);
        ObjectTemplateCBLC.Get(ObjectTemplateCBLC."No.");
        // [THEN] Test Org Skill
        Assert.AreEqual(SkillCode, ObjectTemplateCBLC."Organization Skill Code", 'Object Template Organization Skill not the same');
    end;

    [Test]
    procedure AddSecondObjectTemplateGeographySkill()
    var
        ObjectTemplateCBLC: Record "Object Template CBLC";
        SkillCode: Code[10];
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Template
        CreateObjectTemplateWithSkills();
        ObjectTemplateCBLC.FindLast();

        // [THEN] Has Geo skill
        Assert.IsTrue(LibrarySkillLIB.AlreadyHasSkillType(ObjectTemplateCBLC, SkillType::Geography), 'Object Template is missing GEO skill.');

        // [WHEN/THEN] Add Geo Skill with error
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        asserterror LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, SkillCode);
    end;

    [Test]
    procedure AddSecondObjectTemplateOrganizationSkill()
    var
        ObjectTemplateCBLC: Record "Object Template CBLC";
        SkillCode: Code[10];
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Template
        CreateObjectTemplateWithSkills();
        ObjectTemplateCBLC.FindLast();

        // [THEN] Has Org skill
        Assert.IsTrue(LibrarySkillLIB.AlreadyHasSkillType(ObjectTemplateCBLC, SkillType::Organization), 'Object Template is missing ORG skill.');

        // [WHEN/THEN] Add Org Skill with Error
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        asserterror LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, SkillCode);
    end;

    [Test]
    procedure CreateObjectTemplateWithEmptySkills()
    var
        ObjectTemplateCBLC: Record "Object Template CBLC";
        SkillCode: Code[10];
    begin
        // [GIVEN] Initialize
        Initialize();

        CreateObjectTemplateWithSkills();
        ObjectTemplateCBLC.FindLast();

        SkillCode := 'BOREN';
        LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, SkillCode);
        if not LibrarySkillLIB.ObjectTemplateSkillCodeExist(ObjectTemplateCBLC, SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, ObjectTemplateCBLC.TableCaption(), ObjectTemplateCBLC."No.");

        SkillCode := 'HAKKEN';
        LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, SkillCode);
        if not LibrarySkillLIB.ObjectTemplateSkillCodeExist(ObjectTemplateCBLC, SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, ObjectTemplateCBLC.TableCaption(), ObjectTemplateCBLC."No.");

        SkillCode := 'ZAGEN';
        LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, SkillCode);
        if not LibrarySkillLIB.ObjectTemplateSkillCodeExist(ObjectTemplateCBLC, SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, ObjectTemplateCBLC.TableCaption(), ObjectTemplateCBLC."No.");
    end;

    [Test]
    procedure CreateObjectTemplateWithEmptyItemSkills()
    var
        ObjectTemplateCBLC: Record "Object Template CBLC";
        SkillCode: Code[10];
        ItemNo: Code[20];
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Object Template 
        CreateObjectTemplateWithSkills();
        ObjectTemplateCBLC.FindLast();

        // [WHEN] Create Boren
        SkillCode := 'BOREN';
        ItemNo := 'TSERVICE1';
        LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, ItemNo, SkillCode);
        // [THEN] Test for Boren
        if not LibrarySkillLIB.ObjectTemplateSkillCodeExist(ObjectTemplateCBLC, ItemNo, SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, ObjectTemplateCBLC.TableCaption(), ObjectTemplateCBLC."No.");

        // [WHEN] Create Hakken
        SkillCode := 'HAKKEN';
        LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, ItemNo, SkillCode);
        // [THEN] Test for Hakken
        if not LibrarySkillLIB.ObjectTemplateSkillCodeExist(ObjectTemplateCBLC, ItemNo, SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, ObjectTemplateCBLC.TableCaption(), ObjectTemplateCBLC."No.");

        // [WHEN] Create Zagen
        SkillCode := 'ZAGEN';
        LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, ItemNo, SkillCode);
        // [THEN] Test for Zagen
        if not LibrarySkillLIB.ObjectTemplateSkillCodeExist(ObjectTemplateCBLC, ItemNo, SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, ObjectTemplateCBLC.TableCaption(), ObjectTemplateCBLC."No.");
    end;

    [Test]
    procedure CreateObjectFromObjectTemplate()
    var
        ObjectTemplateCBLC: Record "Object Template CBLC";
        ObjectCBLC: Record "Object CBLC";
        TempSkillItemLineCBLC: Record "Skill Item Line CBLC" temporary;
        NoSkillCodeErr: Label 'Skill Code %1 does not exist for Object %2', Comment = '%1=Skill Code, %2=Object No.';
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Template with skills
        CreateObjectTemplateWithEmptyItemSkills();
        ObjectTemplateCBLC.FindLast();

        // [GIVEN] Object
        ObjectCBLC.Init();
        ObjectCBLC.Insert(true);

        // [WHEN] Create Object from Template
        LibraryObjectLIB.CreateObjectWithTemplate(ObjectCBLC, ObjectTemplateCBLC);

        ObjectCBLC.Description := 'Object: ' + ObjectCBLC."No.";
        ObjectCBLC.Modify(true);

        // [THEN] Check Skills
        LibrarySkillLIB.GetObjectTemplateSkillItems(ObjectTemplateCBLC, TempSkillItemLineCBLC);
        TempSkillItemLineCBLC.FindSet();
        repeat
            //Template = Object
            if not LibrarySkillLIB.ObjectSkillCodeExist(ObjectCBLC, TempSkillItemLineCBLC."Item No. (Service)", TempSkillItemLineCBLC."Skill Code") then
                Error(NoSkillCodeErr, TempSkillItemLineCBLC."Skill Code", ObjectCBLC."No.");
        until TempSkillItemLineCBLC.Next() = 0;
    end;

    [Test]
    // [HandlerFunctions('UpdateTemplateSkillsRequestPageHandler')]
    procedure UpdateObjectWithTemplateSkills()
    var
        ObjectTemplateCBLC: Record "Object Template CBLC";
        ObjectCBLC: Record "Object CBLC";
        SkillCode: Record "Skill Code";
        TempSkillItemLineCBLC: Record "Skill Item Line CBLC" temporary;
        NoSkillCodeErr: Label 'Skill Code %1 does not exist for Object %2', Comment = '%1=Skill Code, %2=Object No.';
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Object Template
        LibraryObjectLIB.CreateObjectTemplate(ObjectTemplateCBLC);
        // ObjectTemplateCBLC.Get(ObjectTemplateNo);

        // [GIVEN] Add Skills
        LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography));
        LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization));

        Assert.AreEqual(2, LibrarySkillLIB.SkillItemLineCount(Database::"Object Template CBLC", ObjectTemplateCBLC.SystemId), 'Skill count does not match.');

        // [GIVEN] New Skill and add to template
        if not SkillCode.Get('No') then
            LibrarySkillLIB.CreateSkill('NO', 'NO NO NO NO NO, there is no limit', SkillType::" ");
        LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, 'NO');

        // Commit();

        // [GIVEN] Create new object
        LibraryObjectLIB.CreateObject(ObjectCBLC);
        // [WHEN] Apply To Object
        LibraryObjectLIB.ApplyObjectTemplate(ObjectCBLC, ObjectTemplateCBLC);
        // ObjectCBLC.ApplyObjectTemplateOnExistingObject();

        // [THEN ]Check Skills
        // ObjectTemplateCBLC.GetSkillItems(TempSkillItemLine);
        LibrarySkillLIB.GetObjectTemplateSkillItems(ObjectTemplateCBLC, TempSkillItemLineCBLC);

        // LibrarySkillLIB.GetSkillsFromObjectTemplate(TempResourceSkill, ObjectTemplateCBLC."No.");
        TempSkillItemLineCBLC.FindSet();
        repeat
            //Template = Object
            if not LibrarySkillLIB.ObjectSkillCodeExist(ObjectCBLC, TempSkillItemLineCBLC."Skill Code") then
                Error(NoSkillCodeErr, TempSkillItemLineCBLC."Skill Code", ObjectCBLC."No.");
        until TempSkillItemLineCBLC.Next() = 0;
    end;

    [Test]
    procedure DeleteObjectCreatedFromObjectTemplate()
    var
        ObjectTemplateCBLC: Record "Object Template CBLC";
        ObjectCBLC: Record "Object CBLC";
        xRecObjectCBLC: Record "Object CBLC";
        SkillsExistErr: Label 'Record still exist for Object %1', Comment = '%1=Object No.';
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Object Template
        LibraryObjectLIB.CreateObjectTemplate(ObjectTemplateCBLC);

        // [GIVEN] Delete Skills
        // LibrarySkillLIB.DeleteResourceSkills(ResourceSkillType::"Object Template", ObjectTemplateCBLC."No.", SkillType::Geography);
        // LibrarySkillLIB.DeleteResourceSkills(ResourceSkillType::"Object Template", ObjectTemplateCBLC."No.", SkillType::Organization);

        // [GIVEN] Add Skills
        LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography));
        LibrarySkillLIB.AddSkillToObjectTemplate(ObjectTemplateCBLC, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization));

        Assert.AreEqual(2, LibrarySkillLIB.SkillItemLineCount(Database::"Object Template CBLC", ObjectTemplateCBLC.SystemId), 'Skill count does not match.');

        // [GIVEN] Create new object
        LibraryObjectLIB.CreateObject(ObjectCBLC);
        // [WHEN] Apply To Object
        LibraryObjectLIB.ApplyObjectTemplate(ObjectCBLC, ObjectTemplateCBLC);

        // [WHEN] Delete Object
        ObjectCBLC.Find('=');
        xRecObjectCBLC := ObjectCBLC;
        ObjectCBLC.Delete(true);

        // [THEN] No More Skills
        if LibrarySkillLIB.HasSkillItemLines(Database::Object, xRecObjectCBLC.SystemId) then
            Error(SkillsExistErr, ObjectCBLC."No.");
    end;

    [Test]
    procedure CopyObjectTemplateWithSkills()
    var
        NewObjectTemplateCBLC, ObjectTemplateCBLC : Record "Object Template CBLC";
        TempSkillItemLineCBLC: Record "Skill Item Line CBLC" temporary;
        NoSkillCodeErr: Label 'Skill Code %1 does not exist for Object  Template %2', Comment = '%1=Skill Code, %2=Object Template No.';
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Template with skills
        CreateObjectTemplateWithEmptyItemSkills();
        ObjectTemplateCBLC.FindLast();
        ObjectTemplateCBLC.TestField("No.");

        // [WHEN] Copy Object Template
        LibraryObjectLIB.CopyObjectTemplate(ObjectTemplateCBLC, NewObjectTemplateCBLC);
        NewObjectTemplateCBLC.TestField("No.");

        // [THEN] Check Skills
        // ObjectTemplateCBLC.GetSkillItems(TempSkillItemLine);
        LibrarySkillLIB.GetObjectTemplateSkillItems(ObjectTemplateCBLC, TempSkillItemLineCBLC);
        TempSkillItemLineCBLC.FindSet();
        repeat
            //Template = New template
            if not LibrarySkillLIB.ObjectTemplateSkillCodeExist(NewObjectTemplateCBLC, TempSkillItemLineCBLC."Item No. (Service)", TempSkillItemLineCBLC."Skill Code") then
                Error(NoSkillCodeErr, TempSkillItemLineCBLC."Skill Code", NewObjectTemplateCBLC."No.");
        until TempSkillItemLineCBLC.Next() = 0;
    end;

    #endregion Object Template

    #region Object    

    [Test]
    procedure CreateObjectWithSkills()
    var
        ObjectCBLC: Record "Object CBLC";
        SkillCode: Code[10];
    begin
        // [GIVEN] Create Object
        CreateObject(ObjectCBLC);

        // [WHEN] Delete Skills
        LibrarySkillLIB.DeleteObjectSkills(ObjectCBLC);

        // [WHEN] Add Geo Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        ObjectCBLC.Find('=');
        // [THEN] Object has Geo skill on record
        Assert.AreEqual(SkillCode, ObjectCBLC."Geography Skill Code", 'Object Geography Skill not the same');

        // [WHEN] Add Org Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        ObjectCBLC.Get(ObjectCBLC."No.");
        // [THEN] Object has Org skill on record
        Assert.AreEqual(SkillCode, ObjectCBLC."Organization Skill Code", 'Object Organization Skill not the same');
    end;

    [Test]
    procedure CreateObjectWithItemSkillsGeography()
    var
        ObjectCBLC: Record "Object CBLC";
        SkillCode: Code[10];
        ItemNo: Code[20];
    begin
        // [GIVEN] Create Object
        CreateObject(ObjectCBLC);
        ObjectCBLC.Validate(Description, 'With item skills');
        ObjectCBLC.Modify(true);

        // [WHEN] Delete Skills
        LibrarySkillLIB.DeleteObjectSkills(ObjectCBLC);

        // [WHEN] Add Geo Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        ItemNo := '1000';
        asserterror LibrarySkillLIB.AddSkillToObject(ObjectCBLC, ItemNo, SkillCode);
    end;

    [Test]
    procedure CreateObjectWithItemSkillsOrganization()
    var
        ObjectCBLC: Record "Object CBLC";
        SkillCode: Code[10];
        ItemNo: Code[20];
    begin
        // [GIVEN] Create Object
        CreateObject(ObjectCBLC);
        ObjectCBLC.Validate(Description, 'With item skills');
        ObjectCBLC.Modify(true);

        // [WHEN] Delete Skills
        LibrarySkillLIB.DeleteObjectSkills(ObjectCBLC);

        // [WHEN] Add Org Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        ItemNo := '1000';
        asserterror LibrarySkillLIB.AddSkillToObject(ObjectCBLC, ItemNo, SkillCode);
    end;

    [Test]
    procedure AddSecondObjectGeoSkill()
    var
        ObjectCBLC: Record "Object CBLC";
    begin
        CreateObjectWithSkills();
        ObjectCBLC.FindLast();
        asserterror LibrarySkillLIB.AddSkillToObject(ObjectCBLC, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography));
        // asserterror LibrarySkillLIB.AddSkillToObject(ObjectCBLC, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization));
    end;

    [Test]
    procedure AddSecondObjectOrgSkill()
    var
        ObjectCBLC: Record "Object CBLC";
    begin
        CreateObjectWithSkills();
        ObjectCBLC.FindLast();
        asserterror LibrarySkillLIB.AddSkillToObject(ObjectCBLC, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography));
        // asserterror LibrarySkillLIB.AddSkillToObject(ObjectCBLC, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization));
    end;

    [Test]
    procedure AddObjectEmptySkills()
    var
        ObjectCBLC: Record "Object CBLC";
        SkillCode: Code[10];
    begin
        CreateObjectWithSkills();
        ObjectCBLC.FindLast();

        SkillCode := 'BOREN';
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);

        if not LibrarySkillLIB.SkillItemLineExist(Database::"Object CBLC", ObjectCBLC.SystemId, SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, ObjectCBLC.TableCaption(), ObjectCBLC."No.");

        SkillCode := 'HAKKEN';
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        if not LibrarySkillLIB.SkillItemLineExist(Database::"Object CBLC", ObjectCBLC.SystemId, SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, ObjectCBLC.TableCaption(), ObjectCBLC."No.");

        SkillCode := 'ZAGEN';
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        if not LibrarySkillLIB.SkillItemLineExist(Database::"Object CBLC", ObjectCBLC.SystemId, SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, ObjectCBLC.TableCaption(), ObjectCBLC."No.");
    end;

    #endregion

    #region Object TM-NL

    [Test]
    procedure AddObjectPostCode()
    var
        ObjectCBLC: Record "Object CBLC";
        PostCode: Code[20];
    begin
        CreateObjectWithSkills();
        ObjectCBLC.FindLast();

        PostCode := '2406AA';
        ObjectCBLC.Validate("Country/Region Code", 'NL');
        ObjectCBLC.Validate("Post Code", PostCode);
        ObjectCBLC.Modify(true);
    end;

    #endregion

    #region Sales Line
    // [Test]
    // procedure GetSalesOrderLines()
    // var
    //     SalesHeader: Record "Sales Header";
    //     DeleteSalesLine: Record "Sales Line";
    // begin
    //     LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesHeader, '20000');
    //     SalesHeader.TestField("No.");
    //     SalesHeaderDocumentNo := SalesHeader."No.";
    //     // SalesHeader.Get(SalesHeader."Document Type"::Order, SalesHeaderDocumentNo);

    //     DeleteSalesLine.SetRange("Document Type", SalesHeader."Document Type");
    //     DeleteSalesLine.SetRange("Document No.", SalesHeader."No.");
    //     DeleteSalesLine.DeleteAll(true);
    // end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure CreateSalesOrderWithLine()
    var
        ContractSetupCBLC: Record "Contract Setup CBLC";
        Item: Record Item;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ItemNo: Code[20];
    begin
        ContractSetupCBLC.Get();
        LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesHeader, '20000');
        SalesHeader.TestField("No.");
        // SalesHeaderDocumentNo := SalesHeader."No.";

        //[GIVEN] Item
        ItemNo := 'TSERVICE4';
        Clear(Item);
        if not Item.Get(ItemNo) then
            LibraryItemLIB.CreatePriceItem(Item, ItemNo, LibraryRandomLIB.RandDecInRange(10, 100, 0), LibraryRandomLIB.RandDecInRange(50, 100, 0), 'MAAND', ContractSetupCBLC."Item Category Service");

        // [GIVEN] Sales line
        Clear(SalesLine);
        LibrarySalesLIB.CreateSalesLine(SalesLine, SalesHeader, Enum::"Sales Line Type"::Item, 'TSERVICE4', 1);
        // // [WHEN] Delete Skills
        // LibrarySkillLIB.DeleteSalesLineSkills(SalesLine);

        // // [THEN] Check Skills
        // Assert.AreEqual('', SalesLine."Geography Skill Code CBLC", 'Sales Line Geography Skill is not empty.');
        // Assert.AreEqual('', SalesLine."Organization Skill Code CBLC", 'Sales Line Organization Skill is not empty.');
    end;

    [Test]
    // [HandlerFunctions('UsageMessageHandler')]
    [HandlerFunctions('ConfirmHandler')]
    procedure CreateSalesOrderWithLineAndDeleteLine()
    var
        // ContractSetupCBLC: Record "Contract Setup CBLC";
        // Item: Record Item;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    // ItemNo: Code[20];
    begin
        CreateSalesOrderWithLine();
        LibrarySalesLIB.GetLastSalesOrder(SalesHeader);
        // SalesHeader.Get(SalesHeader."Document Type"::Order, SalesHeaderDocumentNo);
        LibrarySalesLIB.FindFirstSalesLine(SalesLine, SalesHeader);

        // ContractSetupCBLC.Get();
        // LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesHeader, '20000');
        // SalesHeader.TestField("No.");
        // SalesHeaderDocumentNo := SalesHeader."No.";

        // //[GIVEN] Item
        // ItemNo := 'TSERVICE4';
        // Clear(Item);
        // if not Item.Get(ItemNo) then
        //     LibraryItemLIB.CreatePriceItem(Item, ItemNo, LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), 'MAAND', ContractSetupCBLC."Item Category Service");

        // // [GIVEN] Sales line
        // Clear(SalesLine);
        // LibrarySales.CreateSalesLine(SalesLine, SalesHeader, Enum::"Sales Line Type"::Item, 'TSERVICE4', 1);
        // [WHEN] Delete Skills
        LibrarySkillLIB.DeleteSalesLineSkills(SalesLine);

        // [THEN] Check Skills
        Assert.AreEqual('', SalesLine."Geography Skill Code CBLC", 'Sales Line Geography Skill is not empty.');
        Assert.AreEqual('', SalesLine."Organization Skill Code CBLC", 'Sales Line Organization Skill is not empty.');
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure CreateSalesOrderLineSkills()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SkillCode: Code[10];
    begin
        // DOENST IT WORK. CHECK ITEM NORM 

        // [GIVEN] Sales Order With Line
        CreateSalesOrderWithLine();
        // SalesHeader.Get(SalesHeader."Document Type"::Order, SalesHeaderDocumentNo);
        LibrarySalesLIB.GetLastSalesOrder(SalesHeader);
        LibrarySalesLIB.FindFirstSalesLine(SalesLine, SalesHeader);
        SalesLine.Validate(Description, 'Add Sales Line Skills');
        SalesLine.Modify(true);

        // [WHEN] Delete Skills
        LibrarySkillLIB.DeleteSalesLineSkills(SalesLine);
        // [THEN] No Skill Lines
        Assert.IsFalse(LibrarySkillLIB.HasSkillLines(SalesLine.RecordId().TableNo(), SalesLine.SystemId), 'Sales Skill Line should not exist!');

        // [WHEN] Find Geo Skill and Link
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToSalesLine(SalesLine, SkillCode, 0);
        SalesLine.Find('=');
        // [THEN] check sales line
        Assert.AreEqual(SkillCode, SalesLine."Geography Skill Code CBLC", 'Sales Line Geography Skill not the same');
        // [THEN] check Skill Line
        Assert.IsTrue(LibrarySkillLIB.SkillLineExist(SalesLine.RecordId().TableNo(), SalesLine.SystemId, SkillCode), 'Sales Skill Line Geo does not exist!');

        // [WHEN] Find Org Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToSalesLine(SalesLine, SkillCode, 0);
        SalesLine.Find('=');
        // [THEN] Check Sales Line
        Assert.AreEqual(SkillCode, SalesLine."Organization Skill Code CBLC", 'Object Template Organization Skill not the same');
        // [THEN] Check Skill Line
        Assert.IsTrue(LibrarySkillLIB.SkillLineExist(SalesLine.RecordId().TableNo(), SalesLine.SystemId, SkillCode), 'Skill Line Org does not exist!');
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure AddSecondSalesLineSkills()
    var
        ContractSetupCBLC: Record "Contract Setup CBLC";
        Item: Record Item;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SkillCode: Code[10];
        ItemNo: Code[20];
    begin
        ContractSetupCBLC.Get();
        LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesHeader, '20000');
        SalesHeader.TestField("No.");

        //[GIVEN] Item
        ItemNo := 'TSERVICE4';
        Clear(Item);
        if not Item.Get(ItemNo) then
            LibraryItemLIB.CreatePriceItem(Item, ItemNo, LibraryRandomLIB.RandDecInRange(10, 100, 0), LibraryRandomLIB.RandDecInRange(50, 100, 0), 'MAAND', ContractSetupCBLC."Item Category Service");

        LibrarySalesLIB.CreateSalesLine(SalesLine, SalesHeader, Enum::"Sales Line Type"::Item, 'TSERVICE4', 1);
        SalesLine.Validate(Description, 'Add Second Sales Line Skills');
        SalesLine.Modify(true);

        // [WHEN] Delete Skills
        LibrarySkillLIB.DeleteSalesLineSkills(SalesLine);
        //  [THEN] No Skill Lines
        Assert.IsFalse(LibrarySkillLIB.HasSkillLines(SalesLine.RecordId().TableNo(), SalesLine.SystemId), 'Sales Skill Line should not exist!');

        // [WHEN] Find Geo Skill and Link
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToSalesLine(SalesLine, SkillCode, 0);
        SalesLine.Find('=');
        // [THEN] check sales line
        Assert.AreEqual(SkillCode, SalesLine."Geography Skill Code CBLC", 'Sales Line Geography Skill not the same');
        // [THEN] check Skill Line
        Assert.IsTrue(LibrarySkillLIB.SkillLineExist(SalesLine.RecordId().TableNo(), SalesLine.SystemId, SkillCode), 'Sales Skill Line Geo does not exist!');

        // [WHEN] Find Org Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToSalesLine(SalesLine, SkillCode, 0);
        SalesLine.Find('=');
        // [THEN] Check Sales Line
        Assert.AreEqual(SkillCode, SalesLine."Organization Skill Code CBLC", 'Object Template Organization Skill not the same');
        // [THEN] Check Skill Line
        Assert.IsTrue(LibrarySkillLIB.SkillLineExist(SalesLine.RecordId().TableNo(), SalesLine.SystemId, SkillCode), 'Skill Line Org does not exist!');
        Assert.AreEqual(2, LibrarySkillLIB.SkillLineCount(SalesLine.RecordId().TableNo(), SalesLine.SystemId), 'Sales Line Skill count does not match.');
        // [WHEN] adding double skills

        //TODO FIX
        // asserterror LibrarySkillLIB.AddSkillToSalesLine(SalesLine, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography));
        // // [THEN] Skills count
        // Assert.AreEqual(2, LibrarySkillLIB.SkillLineCount(SalesLine.RecordId().TableNo(), SalesLine.SystemId), 'Sales Line Skill count does not match.');
        // exit;
        // asserterror 
        // LibrarySkillLIB.AddSkillToSalesLine(SalesLine, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization));
    end;


    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure CreateSalesLineAndAddItemToEmptySalesLine()
    var
        Item: Record Item;
        TempResourceSkill: Record "Resource Skill" temporary;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SkillCode: Code[10];
    begin
        LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesHeader, '20000');
        SalesHeader.TestField("No.");
        LibrarySalesLIB.CreateSalesLine(SalesLine, SalesHeader, Enum::"Sales Line Type"::Item, '', 1);

        // [GIVEN] Item
        LibraryItemLIB.CreateItem(Item, '');
        LibrarySkillLIB.DeleteItemSkills(Item);

        // [WHEN] Add Skills
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToItem(Item, SkillCode);
        Item.Find('=');
        Assert.AreEqual(SkillCode, Item."Geography Skill Code CBLC", 'Item Geography Skill not the same');

        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToItem(Item, SkillCode);
        Item.Get(Item."No.");
        Assert.AreEqual(SkillCode, Item."Organization Skill Code CBLC", 'Item Organization Skill not the same');

        // [WHEN] Validate Item No
        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", Item."No.");
        SalesLine.Modify(true);

        // [THEN] Skills Should match
        LibrarySkillLIB.GetSkillsFromItem(TempResourceSkill, Item."No.");
        TempResourceSkill.FindSet();
        repeat
            LibrarySkillLIB.SkillLineExist(SalesLine.RecordId().TableNo(), SalesLine.SystemId, TempResourceSkill."Skill Code");
        until TempResourceSkill.Next() = 0;
    end;

    [Test]
    // [HandlerFunctions('UsageMessageHandler')]
    [HandlerFunctions('ConfirmHandler')]
    procedure CreateSalesLineAndAddObjectToEmptySalesLine()
    var
        ObjectCBLC: Record "Object CBLC";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TempSkillItemLine: Record "Skill Item Line CBLC" temporary;
        SkillCode: Code[10];
    begin
        LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesHeader, '20000');
        SalesHeader.TestField("No.");

        // [GIVEN] Object with skills
        LibraryObjectLIB.CreateObject(ObjectCBLC);
        LibrarySkillLIB.DeleteObjectSkills(ObjectCBLC);

        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        ObjectCBLC.Find('=');
        Assert.AreEqual(SkillCode, ObjectCBLC."Geography Skill Code", 'Object Geography Skill not the same');

        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        ObjectCBLC.Find('=');
        Assert.AreEqual(SkillCode, ObjectCBLC."Organization Skill Code", 'Object Organization Skill not the same');

        // [WHEN] Create Sales Line and validate Object
        LibrarySalesLIB.CreateSalesLine(SalesLine, SalesHeader, Enum::"Sales Line Type"::Item, 'TSERVICE4', 1); //Moet Service zijn
        //SalesLine.Validate("No.", Item."No.");
        SalesLine.Modify(true);
        SalesLine.Find('=');

        SalesLine.TestField("Service CBLC");

        SalesLine.Validate("Object No. CBLC", ObjectCBLC."No.");
        SalesLine.Modify(true);

        // [THEN]
        ObjectCBLC.GetSkills(TempSkillItemLine, SalesLine."Object No. CBLC");
        // LibrarySkillLIB.GetSkillsFromObject(TempResourceSkill, ObjectCBLC."No.");
        TempSkillItemLine.FindSet();
        repeat
            LibrarySkillLIB.SkillLineExist(SalesLine.RecordId().TableNo(), SalesLine.SystemId, TempSkillItemLine."Skill Code");
        until TempSkillItemLine.Next() = 0;
    end;


    [Test]
    // [HandlerFunctions('UsageMessageHandler')]
    procedure AddObjectToSalesLineWithSkills()
    var
        ObjectCBLC: Record "Object CBLC";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        // TempResourceSkill: Record "Resource Skill" temporary;
        TempSkillItemLine: Record "Skill Item Line CBLC" temporary;
        SkillCode: Code[10];
    begin
        // [GIVEN] Sales Header
        // SalesHeader.Get(SalesHeader."Document Type"::Order, SalesHeaderDocumentNo);
        LibrarySalesLIB.GetLastSalesOrder(SalesHeader);
        //Create Line
        LibrarySalesLIB.CreateSalesLine(SalesLine, SalesHeader, Enum::"Sales Line Type"::Item, 'TSERVICE4', 1); //20000

        // [GIVEN] Object with skills
        LibraryObjectLIB.CreateObject(ObjectCBLC);
        LibrarySkillLIB.DeleteObjectSkills(ObjectCBLC);

        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        ObjectCBLC.Find('=');
        Assert.AreEqual(SkillCode, ObjectCBLC."Geography Skill Code", 'Object Geography Skill not the same');

        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        ObjectCBLC.Find('=');
        Assert.AreEqual(SkillCode, ObjectCBLC."Organization Skill Code", 'Object Organization Skill not the same');

        // [WHEN] Validate Object No
        SalesLine.Validate("Object No. CBLC", ObjectCBLC."No.");
        SalesLine.Modify(true);

        // [THEN] Skills must match 
        ObjectCBLC.GetSkills(TempSkillItemLine, SalesLine."No.");
        // LibrarySkillLIB.GetSkillsFromObject(TempResourceSkill, ObjectCBLC."No.");
        TempSkillItemLine.FindSet();
        repeat
            LibrarySkillLIB.SkillLineExist(SalesLine.RecordId().TableNo(), SalesLine.SystemId, TempSkillItemLine."Skill Code");
        until TempSkillItemLine.Next() = 0;
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure CreateAndDeleteSalesLineAndSkills()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SkillCode: Code[10];
        SkillsExistErr: Label 'Record still exist for Sales Line %1 %2', Comment = '%1=Document No., %2=Line No.';
    begin
        LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesHeader, '20000');
        LibrarySalesLIB.CreateSalesLine(SalesLine, SalesHeader, Enum::"Sales Line Type"::Item, 'TSERVICE4', 1);

        SalesLine.Find('=');
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::" ");
        LibrarySkillLIB.AddSkillToSalesLine(SalesLine, SkillCode);
        Assert.IsTrue(LibrarySkillLIB.SkillLineExist(SalesLine.RecordId().TableNo(), SalesLine.SystemId, SkillCode), 'Skill Line does not exist!');

        SalesLine.Delete(true);

        if LibrarySkillLIB.HasSkillLines(SalesLine.RecordId().TableNo(), SalesLine.SystemId) then
            Error(SkillsExistErr, SalesLine."Document No.", SalesLine."Line No.");
    end;

    [Test]
    procedure CreateSalesorderWithContractWithCoverage()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";
        ContractSetupCBLC: Record "Contract Setup CBLC";
        ContrTemplateCoverageCBLC: Record "Contract Templ. Coverage CBLC";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SkillCode: Code[10];
        ItemNo: Code[20];
        ObjectNo: Code[20];
    begin
        // [SCENARIO] 18307 - Create Contract Template with everything
        // [SCENARIO] Create Template, Create contract from Template.
        // [SCENARIO] Create contract from Template.

        // [GIVEN] Create Contract Template
        ContractSetupCBLC.Get();
        LibraryContractLIB.CreateContractTemplateWithUOM(ContrTemplateHeaderCBLC, ContractSetupCBLC."Unit of Measure Code Month", 1);
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

        ContrTemplateCoverageCBLC.SetRange("Contract Template No.", ContrTemplateServiceCBLC."Contract Template No.");
        ContrTemplateCoverageCBLC.SetRange("Item Category Code", ContrTemplateServiceCBLC."Item Category Code");
        if ContrTemplateCoverageCBLC.IsEmpty() then
            Assert.Fail('Contract Template Coverage has no records.');

        // [WHEN] Create Contract from Template
        ContractHeaderCBLC.CreateContractFromTemplate(ContrTemplateHeaderCBLC."No.");

        // [THEN] Check Contract 
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Validate("Sell-to Customer No.", '20000');
        ContractHeaderCBLC.Validate(Description, 'Contract With Lines and Send Skills');
        ContractHeaderCBLC.Validate("Index Code", '2022');
        ContractHeaderCBLC.Modify(true);
        // ContractMatchesTemplate(ContractHeaderCBLC, ContrTemplateHeaderCBLC);

        // [WHEN] Add Geo Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToContract(ContractHeaderCBLC, '', SkillCode);
        ContractHeaderCBLC.Find('=');
        // Assert.AreEqual(SkillCode, ContractHeaderCBLC."Geography Skill Code", 'Object Geography Skill not the same');

        // [WHEN] Add Org Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToContract(ContractHeaderCBLC, '', SkillCode);
        ContractHeaderCBLC.Find('=');
        // Assert.AreEqual(SkillCode, ContractHeaderCBLC."Organization Skill Code", 'Object Organization Skill not the same');

        // [WHEN] Add Skill with Item
        SkillCode := 'ZAGEN';
        ItemNo := 'TSERVICE1';
        LibrarySkillLIB.AddSkillToContract(ContractHeaderCBLC, ItemNo, SkillCode);

        // [WHEN] Add Skill with Item
        SkillCode := 'BOREN';
        ItemNo := 'TSERVICE4';
        LibrarySkillLIB.AddSkillToContract(ContractHeaderCBLC, ItemNo, SkillCode);

        // [WHEN] Add Empty Skill
        SkillCode := 'HAKKEN';
        ItemNo := '';
        LibrarySkillLIB.AddSkillToContract(ContractHeaderCBLC, ItemNo, SkillCode);

        //[GIVEN] Line
        ObjectNo := CreateObjectNo();
        LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, false, 50, 20220101D, 20221231D);

        // [WHEN] Release
        ContractHeaderCBLC.TestField("No.");
        ContractHeaderCBLC.Release();

        // [WHEN] Create Sales Order
        LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesHeader, '20000');
        SalesHeader.TestField("No.");

        // [WHEN] Create Sales line
        LibrarySalesLIB.CreateSalesLine(SalesLine, SalesHeader, Enum::"Sales Line Type"::Item, 'TSERVICE4', 1); //20000

        // [WHEN] Validate Object No
        SalesLine.Validate("Object No. CBLC", ObjectNo);
        SalesLine.Modify(true);

        // [THEN]
        SalesLine.TestField("Contract No. CBLC");
    end;

    // [Test]
    // procedure CreateContractWithLinesAndSend()
    // var
    //     ContractHeaderCBLC: Record "Contract Header CBLC";
    //     ContractLineCBLC: Record "Contract Line CBLC";
    //     ContractSetupCBLC: Record "Contract Setup CBLC";
    //     UoMCode: Code[10];
    //     PostingDate: Date;
    // begin
    //     ContractSetupCBLC.Get();
    //     ContractSetupCBLC.TestField("Unit of Measure Code Month");

    //     //[GIVEN] Contract Header
    //     UoMCode := ContractSetupCBLC."Unit of Measure Code Month";
    //     LibraryContractLIB.CreateContract(ContractHeaderCBLC, '40000', UoMCode);
    //     ContractHeaderCBLC.Validate(Description, 'Contract With Lines and Send Skills');
    //     ContractHeaderCBLC.Validate("Index Code", '2022');
    //     ContractHeaderCBLC.Modify(true);


    //     //[GIVEN] Line
    //     ObjectNo := CreateObjectNo();
    //     LibraryContractLIB.CreateContractLine(ContractHeaderCBLC, ContractLineCBLC, ObjectNo, '1000', 1, false, 50, 20220101D, 20221231D);

    //     //Release
    //     ContractHeaderCBLC.TestField("No.");
    //     ContractHeaderCBLC.Release();

    //     //Send
    //     PostingDate := 20220401D;
    //     LibraryContractLIB.SendContract(ContractHeaderCBLC, PostingDate);
    // end;

    #endregion Sales Line

    #region Job Planning Line
    [Test]
    // [HandlerFunctions('UsageMessageHandler')]
    procedure CreateJobPlanningLine()
    var
        JobPlanningLine: Record "Job Planning Line";
        JobTask: Record "Job Task";
    begin
        JobTask.Get('JOB00010', '1020');
        LibraryJobLIB.CreateJobPlanningLine(JobPlanningLineType::Billable, JobPlanningType::Item, JobTask, JobPlanningLine);

        JobPlanningLine.Validate("No.", 'TSERVICE4');
        JobPlanningLine.Validate(Description, 'Created for Test');
        JobPlanningLine.Validate(Quantity, 1);
        JobPlanningLine.Modify(true);
        JobPlanningLineSystemId := JobPlanningLine.SystemId;
    end;

    [Test]
    procedure CreateJobPlanningLineWithSkills()
    var
        JobPlanningLine: Record "Job Planning Line";
        // JobTask: Record "Job Task";
        SkillCode: Code[10];
    begin
        // [GIVEN] Create Job Planning Line
        CreateJobPlanningLine();
        JobPlanningLine.GetBySystemId(JobPlanningLineSystemId);

        // [WHEN] Delete Skills
        LibrarySkillLIB.DeleteJobPlanningLineSkills(JobPlanningLine);
        JobPlanningLine.Find('=');
        // [THEN] Check Skills
        Assert.AreEqual('', JobPlanningLine."Geography Skill Code CBLC", 'Job planning line Geography Skill must be empty');
        Assert.AreEqual('', JobPlanningLine."Organization Skill Code CBLC", 'Job planning line Organization Skill must be empty');

        // [WHEN] Add Geo Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToJobPlanningLine(JobPlanningLine, SkillCode);
        JobPlanningLine.Find('=');
        // [THEN] Test Geo Skill
        Assert.AreEqual(SkillCode, JobPlanningLine."Geography Skill Code CBLC", 'Job planning line Geography Skill not the same');
        Assert.IsTrue(LibrarySkillLIB.SkillLineExist(JobPlanningLine.RecordId().TableNo(), JobPlanningLine.SystemId, SkillCode), 'Skill Line does not exist!');

        // [WHEN] Add Org Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToJobPlanningLine(JobPlanningLine, SkillCode);
        JobPlanningLine.Find('=');
        // [THEN] Test Geo Skill
        Assert.AreEqual(SkillCode, JobPlanningLine."Organization Skill Code CBLC", 'Job planning line Organization Skill not the same');
        Assert.IsTrue(LibrarySkillLIB.SkillLineExist(JobPlanningLine.RecordId().TableNo(), JobPlanningLine.SystemId, SkillCode), 'Skill Line does not exist!');
    end;

    [Test]
    procedure AddSecondJobPlanningLineGeographySkill()
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        // [GIVEN] Job Planning Line with skills
        CreateJobPlanningLineWithSkills();
        JobPlanningLine.GetBySystemId(JobPlanningLineSystemId);
        // [THEN] Add second skill with error
        asserterror LibrarySkillLIB.AddSkillToJobPlanningLine(JobPlanningLine, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography));
    end;

    [Test]
    procedure AddSecondJobPlanningLineOrganizationSkill()
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        // [GIVEN] Job Planning Line with skills
        CreateJobPlanningLineWithSkills();
        JobPlanningLine.GetBySystemId(JobPlanningLineSystemId);
        // [THEN] Add second skill with error
        asserterror LibrarySkillLIB.AddSkillToJobPlanningLine(JobPlanningLine, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization));
    end;

    [Test]
    procedure AddObjectToEmptyJobPlanningLine()
    var
        JobPlanningLine: Record "Job Planning Line";
        ObjectCBLC: Record "Object CBLC";
        TempSkillItemLine: Record "Skill Item Line CBLC" temporary;
        SkillItemCount: Integer;
    begin
        // [GIVEN] Job Planning Line
        CreateJobPlanningLine();
        JobPlanningLine.GetBySystemId(JobPlanningLineSystemId);
        JobPlanningLine.TestField(SystemId);

        // [GIVEN] Create Object with skills
        CreateObjectWitkSkills(ObjectCBLC);
        LibraryObjectLIB.AddJobTaskObject(JobPlanningLine, ObjectCBLC);

        // [WHEN] Validating Object
        JobPlanningLine.Validate("Object No. CBLC", ObjectCBLC."No.");
        JobPlanningLine.Modify(true);

        // [THEN] Match Count Skills
        ObjectCBLC.GetSkills(TempSkillItemLine, JobPlanningLine."No.");
        SkillItemCount := TempSkillItemLine.Count();
        Assert.AreEqual(4, SkillItemCount, 'Skill count does not match Temp.');

        // [THEN] Skills match
        TempSkillItemLine.FindSet();
        repeat
            LibrarySkillLIB.SkillLineExist(JobPlanningLine.RecordId().TableNo(), JobPlanningLine.SystemId, TempSkillItemLine."Skill Code");
        until TempSkillItemLine.Next() = 0;
    end;

    [Test]
    // [HandlerFunctions('UsageMessageHandler')]
    procedure AddObjectToJobPlanningLineWithSkills()
    var
        NewJobPlanningLine: Record "Job Planning Line";
        ObjectCBLC: Record "Object CBLC";
        TempSkillItemLine: Record "Skill Item Line CBLC" temporary;
        SkillCode: Code[10];
    begin
        // [GIVEN] Job Planning Line
        CreateJobPlanningLine();
        NewJobPlanningLine.GetBySystemId(JobPlanningLineSystemId);
        NewJobPlanningLine.TestField(SystemId);

        // [GIVEN] Object with skills
        CreateObjectWitkSkills(ObjectCBLC);
        LibraryObjectLIB.AddJobTaskObject(NewJobPlanningLine, ObjectCBLC);

        // [WHEN] Validate Object 
        NewJobPlanningLine.Validate("Object No. CBLC", ObjectCBLC."No.");
        NewJobPlanningLine.Modify(true);

        //Skills
        SkillCode := LibrarySkillLIB.SkillLineSkillTypeExist(NewJobPlanningLine.RecordId().TableNo(), NewJobPlanningLine.SystemId, SkillType::Organization);
        if SkillCode = '' then begin
            SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
            LibrarySkillLIB.AddSkillToJobPlanningLine(NewJobPlanningLine, SkillCode);
        end;

        SkillCode := LibrarySkillLIB.SkillLineSkillTypeExist(NewJobPlanningLine.RecordId().TableNo(), NewJobPlanningLine.SystemId, SkillType::Geography);
        if SkillCode = '' then begin
            SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
            LibrarySkillLIB.AddSkillToJobPlanningLine(NewJobPlanningLine, SkillCode);
        end;
        NewJobPlanningLine.Modify(true);

        //Test
        ObjectCBLC.GetSkills(TempSkillItemLine, NewJobPlanningLine."No.");
        TempSkillItemLine.FindSet();
        repeat
            LibrarySkillLIB.SkillLineExist(NewJobPlanningLine.RecordId().TableNo(), NewJobPlanningLine.SystemId, TempSkillItemLine."Skill Code");
        until TempSkillItemLine.Next() = 0;
    end;

    [Test]
    // [HandlerFunctions('UsageMessageHandler')]
    procedure CreateJobPlanningLineToDeleteAndDelete()
    var
        NewJobPlanningLine: Record "Job Planning Line";
        SkillCode: Code[10];
        SkillsExistErr: Label 'Record still exist for Job Planning Line %1 %2', Comment = '%1=Document No., %2=Line No.';
    begin
        // [GIVEN] Job Planning Line
        CreateJobPlanningLine();
        NewJobPlanningLine.GetBySystemId(JobPlanningLineSystemId);
        NewJobPlanningLine.TestField(SystemId);

        //Skills
        SkillCode := LibrarySkillLIB.SkillLineSkillTypeExist(NewJobPlanningLine.RecordId().TableNo(), NewJobPlanningLine.SystemId, SkillType::Organization);
        if SkillCode = '' then begin
            SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
            LibrarySkillLIB.AddSkillToJobPlanningLine(NewJobPlanningLine, SkillCode);
        end;
        Assert.IsTrue(LibrarySkillLIB.SkillLineExist(NewJobPlanningLine.RecordId().TableNo(), NewJobPlanningLine.SystemId, SkillCode), 'Skill Line Organization does not exist for job planning line!');

        SkillCode := LibrarySkillLIB.SkillLineSkillTypeExist(NewJobPlanningLine.RecordId().TableNo(), NewJobPlanningLine.SystemId, SkillType::Geography);
        if SkillCode = '' then begin
            SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
            LibrarySkillLIB.AddSkillToJobPlanningLine(NewJobPlanningLine, SkillCode);
        end;
        Assert.IsTrue(LibrarySkillLIB.SkillLineExist(NewJobPlanningLine.RecordId().TableNo(), NewJobPlanningLine.SystemId, SkillCode), 'Skill Line Geography does not exist for job planning line!');

        NewJobPlanningLine.Modify(true);

        NewJobPlanningLine.Find('=');
        NewJobPlanningLine.Delete(true);

        if LibrarySkillLIB.HasSkillLines(NewJobPlanningLine.RecordId().TableNo(), NewJobPlanningLine.SystemId) then
            Error(SkillsExistErr, NewJobPlanningLine."Job No.", NewJobPlanningLine."Line No.");
    end;
    #endregion

    #region Sales Quote
    [Test]
    // [HandlerFunctions('UsageMessageHandler')]
    [HandlerFunctions('ConfirmHandler')]
    procedure CreateSalesQuote()
    var
        ContractSetupCBLC: Record "Contract Setup CBLC";
        Customer: Record Customer;
        Item: Record Item;
        SalesOrder: Record "Sales Header";
        SalesQuote: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesOrderLine: Record "Sales Line";
        TempSkillLineCBLC: Record "Skill Line CBLC" temporary;
        SalesQuoteToOrder: Codeunit "Sales-Quote to Order";
        SkillCode: Code[10];
        ItemNo: Code[20];
    begin
        ContractSetupCBLC.Get();

        // [GIVEN] Item
        ItemNo := 'TSERVICE1';
        Clear(Item);
        if not Item.Get(ItemNo) then begin
            LibraryItemLIB.CreatePriceItem(Item, ItemNo, LibraryRandomLIB.RandDecInRange(10, 100, 0), LibraryRandomLIB.RandDecInRange(50, 100, 0), 'MAAND');
            Item.TestField("No.");
            Item.Validate("Item Category Code", ContractSetupCBLC."Item Category Service");
            Item.Modify(true);
        end;

        LibrarySkillLIB.DeleteItemSkills(Item);

        // [WHEN] Add Geo & Org Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToItem(Item, SkillCode);
        Item.Find('=');
        Assert.AreEqual(SkillCode, Item."Geography Skill Code CBLC", 'Object Geography Skill not the same');

        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToItem(Item, SkillCode);
        Item.Get(Item."No.");
        Assert.AreEqual(SkillCode, Item."Organization Skill Code CBLC", 'Object Organization Skill not the same');

        // [GIVEN] Create Quote
        Customer.FindFirst();
        LibrarySalesLIB.CreateSalesQuoteForCustomerNo(SalesQuote, Customer."No.");
        LibrarySalesLIB.CreateSalesLine(SalesLine, SalesQuote, Enum::"Sales Line Type"::Item, 'TSERVICE1', 1);

        Assert.IsTrue(LibrarySkillLIB.SkillLineSkillTypeExist(SalesLine.RecordId().TableNo(), SalesLine.SystemId, SkillType::Geography) <> '', 'Skill Line does not exist!');
        Assert.IsTrue(LibrarySkillLIB.SkillLineSkillTypeExist(SalesLine.RecordId().TableNo(), SalesLine.SystemId, SkillType::Organization) <> '', 'Skill Line does not exist!');

        LibrarySkillLIB.GetSkillsFromSalesLine(TempSkillLineCBLC, SalesLine);

        // [WHEN] Quote To Order
        SalesQuoteToOrder.Run(SalesQuote);
        SalesQuoteToOrder.GetSalesOrderHeader(SalesOrder);

        SalesOrder.TestField("No.");

        SalesLine.Reset();
        SalesOrderLine.SetRange("Document Type", SalesOrder."Document Type");
        SalesOrderLine.SetRange("Document No.", SalesOrder."No.");
        SalesOrderLine.SetRange(Type, SalesLine.Type::Item);
        SalesOrderLine.SetRange("No.", 'TSERVICE1');
        SalesOrderLine.FindFirst();

        // [THEN] Test
        TempSkillLineCBLC.FindSet();
        repeat
            LibrarySkillLIB.SkillLineExist(SalesOrderLine.RecordId().TableNo(), SalesOrderLine.SystemId, TempSkillLineCBLC."Skill Code");
        until TempSkillLineCBLC.Next() = 0;

        // LibrarySales.PostSalesDocument()
        // Assert.AreEqual(SkillCode, SalesLine."Organization Skill Code CBLC", 'Object Template Organization Skill not the same');
        // Assert.IsTrue(LibrarySkill.SkillLineExist(SalesLine.RecordId().TableNo(), SalesLine.SystemId, SkillCode), 'Skill Line does not exist!');

        // Assert.AreEqual(SkillCode, SalesLine."Organization Skill Code CBLC", 'Object Template Organization Skill not the same');
        // Assert.IsTrue(LibrarySkill.SkillLineExist(SalesLine.RecordId().TableNo(), SalesLine.SystemId, SkillCode), 'Skill Line does not exist!');


    end;
    #endregion

    #region Score

    [Test]
    procedure CreateSkillsWithDifferentScore()
    var
        SkillCode: Code[10];
    begin
        // [GIVEN] Create Skill
        SkillCode := 'SCORE1';
        LibrarySkillLIB.DeleteSkill(SkillCode, false);
        LibrarySkillLIB.CreateSkill(SkillCode, 'Score 1', SkillType::" ", 666666);
        // [THEN] Must produce errror
        SkillCode := 'SCORE2';
        LibrarySkillLIB.DeleteSkill(SkillCode, false);
        LibrarySkillLIB.CreateSkill(SkillCode, 'Score 2', SkillType::" ", 777777);
    end;

    [Test]
    procedure CreateSkillsWithScoreAndRemoveScore()
    var
        CurrentSkillCode: Record "Skill Code";
        SkillCode: Code[10];
    begin
        // [GIVEN] Initalize
        Initialize();

        // [GIVEN] Create Skill
        SkillCode := 'SCORE0';
        LibrarySkillLIB.DeleteSkill(SkillCode, false);
        LibrarySkillLIB.CreateSkill(SkillCode, 'Score 0', SkillType::" ", 1111);

        // [WHEN] score to 0
        CurrentSkillCode.Get(SkillCode);
        CurrentSkillCode.Validate("Score CBLC", 0);
        CurrentSkillCode.Modify(true);

        // [THEN] Test for 0
        CurrentSkillCode.TestField("Score CBLC", 0);
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure CreateSalesLineWithObject()
    var
        ObjectCBLC: Record "Object CBLC";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CurrentSkillCode: Record "Skill Code";
        // TempResourceSkill: Record "Resource Skill" temporary;
        TempSkillItemLine: Record "Skill Item Line CBLC" temporary;
        SkillLineCBLC: Record "Skill Line CBLC";
        SkillCode: Code[10];
    begin
        // [GIVEN] Initalize
        Initialize();

        // [GIVEN] Object with skills
        LibraryObjectLIB.CreateObject(ObjectCBLC);
        LibrarySkillLIB.DeleteObjectSkills(ObjectCBLC);

        // [GIVEN] Skill
        SkillCode := 'SCORE1';
        if not CurrentSkillCode.Get(SkillCode) then
            LibrarySkillLIB.CreateSkill(SkillCode, 'Score 1', SkillType::" ", 666666);
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        ObjectCBLC.Find('=');

        // [GIVEN] Sales Header and Line
        LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesHeader, '20000');
        LibrarySalesLIB.CreateSalesLine(SalesLine, SalesHeader, Enum::"Sales Line Type"::Item, 'TSERVICE4', 1);

        // [WHEN] Validate Object No
        SalesLine.Validate("Object No. CBLC", ObjectCBLC."No.");
        SalesLine.Modify(true);

        // [THEN] Skills must match 
        ObjectCBLC.GetSkills(TempSkillItemLine, ''); //TODO Check
        TempSkillItemLine.FindSet();
        repeat
            // TempSkillItemLine.CalcFields(Score);
            Assert.IsTrue(LibrarySkillLIB.SkillLineExist(SalesLine.RecordId().TableNo(), SalesLine.SystemId, TempSkillItemLine."Skill Code"), 'Skill Line does not exist.');
            if LibrarySkillLIB.GetSkillLine(SkillLineCBLC, SalesLine.RecordId().TableNo(), SalesLine.SystemId, TempSkillItemLine."Skill Code") then
                Assert.AreEqual(TempSkillItemLine.Score, SkillLineCBLC.Score, 'Score sales line does not match object.')
            else
                Assert.Fail('Could not get Skill Line record.');
        until TempSkillItemLine.Next() = 0;
    end;

    [Test]
    procedure CreateJobPlanningLineWithObject()
    var
        NewJobPlanningLine: Record "Job Planning Line";
        JobTask: Record "Job Task";
        ObjectCBLC: Record "Object CBLC";
        CurrentSkillCode: Record "Skill Code";
        TempSkillItemLine: Record "Skill Item Line CBLC" temporary;
        SkillLineCBLC: Record "Skill Line CBLC";
        SkillCode: Code[10];
    begin
        // [GIVEN] Skill
        SkillCode := 'SCORE10';

        // [WHEN] Create Skill
        if not CurrentSkillCode.Get(SkillCode) then
            LibrarySkillLIB.CreateSkill(SkillCode, 'Score 10', SkillType::" ", 10101010);

        // [GIVEN] Create Job Plannign Line
        JobTask.Get('JOB00010', '1010');

        //Create Line
        LibraryJobLIB.CreateJobPlanningLine(JobPlanningLineType::Billable, JobPlanningType::Item, JobTask, NewJobPlanningLine);
        NewJobPlanningLine.Validate("No.", 'TSERVICE4');
        NewJobPlanningLine.Validate(Quantity, 1);
        NewJobPlanningLine.Modify(true);

        // [GIVEN] Object with skills
        LibraryObjectLIB.CreateObject(ObjectCBLC);
        LibraryObjectLIB.AddJobTaskObject(NewJobPlanningLine, ObjectCBLC);
        LibrarySkillLIB.DeleteObjectSkills(ObjectCBLC);

        // [WHEN] Add skill to Object
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        ObjectCBLC.Get(ObjectCBLC."No.");

        // [THEN]
        if not LibrarySkillLIB.SkillItemLineExist(Database::"Object CBLC", ObjectCBLC.SystemId, SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, ObjectCBLC.TableCaption(), ObjectCBLC."No.");

        // [THEN] test for skill
        Assert.AreEqual(1, LibrarySkillLIB.SkillItemLineCount(Database::"Object CBLC", ObjectCBLC.SystemId), 'Object Skill Item Line does not match.');

        // [WHEN] Validate Object No
        NewJobPlanningLine.Validate("Object No. CBLC", ObjectCBLC."No.");
        NewJobPlanningLine.Modify(true);

        // message(NewJobPlanningLine.job)
        // exit;

        // [THEN] Skills must match 
        ObjectCBLC.GetSkills(TempSkillItemLine, ''); //TODO Check
        TempSkillItemLine.FindSet();
        repeat
            Assert.IsTrue(LibrarySkillLIB.SkillLineExist(NewJobPlanningLine.RecordId().TableNo(), NewJobPlanningLine.SystemId, TempSkillItemLine."Skill Code"), 'Skill Line does not exist.');
            if LibrarySkillLIB.GetSkillLine(SkillLineCBLC, NewJobPlanningLine.RecordId().TableNo(), NewJobPlanningLine.SystemId, TempSkillItemLine."Skill Code") then
                Assert.AreEqual(TempSkillItemLine.Score, SkillLineCBLC.Score, 'Score sales line does not match object.')
            else
                Assert.Fail('Could not get Skill Line record.');
        until TempSkillItemLine.Next() = 0;

    end;
    #endregion Score

    #region Contract Template
    local procedure CreateContractTemplate(var ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC")
    var
        ContractSetupCBLC: Record "Contract Setup CBLC";
    begin
        // [SCENARIO] 18307 - Create Contract Template with everything
        // [WHEN] Create Contract Template
        ContractSetupCBLC.Get();
        LibraryContractLIB.CreateContractTemplateWithUOM(ContrTemplateHeaderCBLC, ContractSetupCBLC."Unit of Measure Code Month", 1);
        // ContrTemplateHeaderCBLC.Validate(Description, 'With coverage random [18307]');
        // [THEN] Test
        ContrTemplateHeaderCBLC.Modify(true);
        // ContractTemplateNo := ContrTemplateHeaderCBLC."No.";
    end;

    [Test]
    procedure CreateContractTemplateWithCoverage()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContrTemplateServiceCBLC: Record "Contr. Template Service CBLC";
        ContractSetupCBLC: Record "Contract Setup CBLC";
        ContractTemplCoverageCBLC: Record "Contract Templ. Coverage CBLC";
    begin
        // [SCENARIO] 18307 - Create Contract Template with everything

        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Create Contract Template
        CreateContractTemplate(ContrTemplateHeaderCBLC);
        // ContrTemplateHeaderCBLC.Get(ContractTemplateNo);
        ContrTemplateHeaderCBLC.TestField("No.");

        // LibraryContractLIB.CreateContractTemplateWithUOM(ContrTemplateHeaderCBLC, ContractSetupCBLC."Unit of Measure Code Month", 1);
        ContrTemplateHeaderCBLC.Validate(Description, 'With coverage random [18307]');
        ContrTemplateHeaderCBLC.Modify(true);
        // ContractTemplateNo := ContrTemplateHeaderCBLC."No.";

        // [WHEN] Contr. Template Service CBLC 
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Item Category Service");
        LibraryContractLIB.AddContractTemplateServiceWithCoverageRandom(ContrTemplateHeaderCBLC, ContractSetupCBLC."Item Category Service");

        //[THEN] Contract Template Service
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        if ContrTemplateServiceCBLC.IsEmpty() then
            Assert.Fail('Contract Template has no Service records.');

        // [THEN] Contract Template Coverage
        ContrTemplateServiceCBLC.SetRange("Contract Template No.", ContrTemplateHeaderCBLC."No.");
        ContrTemplateServiceCBLC.FindFirst();

        ContractTemplCoverageCBLC.SetRange("Contract Template No.", ContrTemplateServiceCBLC."Contract Template No.");
        ContractTemplCoverageCBLC.SetRange("Item Category Code", ContrTemplateServiceCBLC."Item Category Code");
        if ContractTemplCoverageCBLC.IsEmpty() then
            Assert.Fail('Contract Template Coverage has no records.')
    end;

    [Test]
    procedure DeleteSkillFromContractTemplate()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
    // SkillsExistErr: Label 'Record still exist for Object Template %1', Comment = '%1=Object Template No.';
    begin
        // [GIVEN] Contract Template
        CreateContractTemplateWithCoverage();
        ContrTemplateHeaderCBLC.FindLast();
        ContrTemplateHeaderCBLC.TestField("No.");

        // [WHEN] Delete Skills
        LibrarySkillLIB.DeleteContractTemplateSkillItems(ContrTemplateHeaderCBLC);

        // [THEN] Test for no skills
        // Assert.AreEqual('', ContrTemplateHeaderCBLC."Geography Skill Code", 'Resource Geography Skill is not empty.');
        // Assert.AreEqual('', ContrTemplateHeaderCBLC."Organization Skill Code", 'Resource Organization Skill is not empty.');
        // if LibrarySkillLIB.HasSkillItemLines(Database::"Object Template CBLC", ContrTemplateHeaderCBLC.SystemId) then
        //     Error(SkillsExistErr, ContrTemplateHeaderCBLC."No.");
    end;

    [Test]
    procedure CreateContractTemplateWithSkills()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        SkillCode: Code[10];
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Contract Template
        CreateContractTemplateWithCoverage();
        ContrTemplateHeaderCBLC.FindLast();
        ContrTemplateHeaderCBLC.TestField("No.");

        // [WHEN] Add Geo Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToContractTemplate(ContrTemplateHeaderCBLC, '', SkillCode);
        ContrTemplateHeaderCBLC.Find('=');
        // [THEN] Test Geo Skill
        // Assert.AreEqual(SkillCode, ContrTemplateHeaderCBLC."Geography Skill Code", 'Object Template Geography Skill not the same');

        // [WHEN] Add Org Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToContractTemplate(ContrTemplateHeaderCBLC, '', SkillCode);
        // ContrTemplateHeaderCBLC.Find('=');
        // [THEN] Test Org Skill
        // Assert.AreEqual(SkillCode, ContrTemplateHeaderCBLC."Organization Skill Code", 'Object Template Organization Skill not the same');
    end;

    [Test]
    procedure DeleteContractTemplateWithSkills()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        xContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        SkillsExistErr: Label 'Record still exist for contract template %1', Comment = '%1=Contract template No.';
    begin
        // [GIVEN] Contract Template
        CreateContractTemplateWithCoverage();
        ContrTemplateHeaderCBLC.FindLast();
        ContrTemplateHeaderCBLC.TestField("No.");

        // [WHEN] Delete Contract Template
        xContrTemplateHeaderCBLC := ContrTemplateHeaderCBLC;
        ContrTemplateHeaderCBLC.Delete(true);

        // [THEN] No More Skills
        if LibrarySkillLIB.HasSkillItemLines(ContrTemplateHeaderCBLC.RecordId().TableNo(), xContrTemplateHeaderCBLC.SystemId) then
            Error(SkillsExistErr, ContrTemplateHeaderCBLC."No.");
    end;

    [Test]
    procedure AddSecondContractTemplateGeographySkill()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        SkillCode: Code[10];
    begin
        // [GIVEN] Template
        CreateContractTemplateWithSkills();
        ContrTemplateHeaderCBLC.FindLast();
        ContrTemplateHeaderCBLC.TestField("No.");

        // [THEN] Has Geo skill
        Assert.IsTrue(LibrarySkillLIB.AlreadyHasSkillType(ContrTemplateHeaderCBLC, SkillType::Geography), 'Object Template is missing GEO skill.');

        // [WHEN/THEN] Add Geo Skill with error
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        asserterror LibrarySkillLIB.AddSkillToContractTemplate(ContrTemplateHeaderCBLC, SkillCode);
    end;

    [Test]
    procedure AddSecondContractTemplateOrganizationSkill()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        SkillCode: Code[10];
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Template
        CreateContractTemplateWithSkills();
        ContrTemplateHeaderCBLC.FindLast();
        ContrTemplateHeaderCBLC.TestField("No.");

        // [THEN] Has Org skill
        Assert.IsTrue(LibrarySkillLIB.AlreadyHasSkillType(ContrTemplateHeaderCBLC, SkillType::Organization), 'Object Template is missing ORG skill.');

        // [WHEN/THEN] Add Org Skill with Error
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        asserterror LibrarySkillLIB.AddSkillToContractTemplate(ContrTemplateHeaderCBLC, SkillCode);
    end;

    [Test]
    procedure CreateContractTemplateWithEmptySkills()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        SkillCode: Code[10];
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Template
        CreateContractTemplateWithSkills();
        ContrTemplateHeaderCBLC.FindLast();
        ContrTemplateHeaderCBLC.TestField("No.");
        // ContractTemplateNo := ContrTemplateHeaderCBLC."No.";

        // [WHEN] Add Empty Skill
        SkillCode := 'BOREN';
        LibrarySkillLIB.AddSkillToContractTemplate(ContrTemplateHeaderCBLC, SkillCode);
        // [THEN] Test for skill
        if not LibrarySkillLIB.ContractTemplateSkillCodeExist(ContrTemplateHeaderCBLC, SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, ContrTemplateHeaderCBLC.TableCaption(), ContrTemplateHeaderCBLC."No.");

        // [WHEN] Add Empty Skill
        SkillCode := 'HAKKEN';
        LibrarySkillLIB.AddSkillToContractTemplate(ContrTemplateHeaderCBLC, SkillCode);
        // [THEN] Test for skill
        if not LibrarySkillLIB.ContractTemplateSkillCodeExist(ContrTemplateHeaderCBLC, SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, ContrTemplateHeaderCBLC.TableCaption(), ContrTemplateHeaderCBLC."No.");

        // [WHEN] Add Empty Skill
        SkillCode := 'ZAGEN';
        LibrarySkillLIB.AddSkillToContractTemplate(ContrTemplateHeaderCBLC, SkillCode);
        // [THEN] Test for skill
        if not LibrarySkillLIB.ContractTemplateSkillCodeExist(ContrTemplateHeaderCBLC, SkillCode) then
            Error(SkillDoesNotExistErr, SkillCode, ContrTemplateHeaderCBLC.TableCaption(), ContrTemplateHeaderCBLC."No.");
    end;

    [Test]
    procedure CreateContractFromContractTemplate()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        // ObjectCBLC: Record "Object CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        TempSkillItemLineCBLC: Record "Skill Item Line CBLC" temporary;
        // ContractNo: Code[20];
        NoSkillCodeErr: Label 'Skill Code %1 does not exist for contract %2', Comment = '%1=Skill Code, %2=Contract No.';
    begin
        // [GIVEN] Initialize
        Initialize();

        // [GIVEN] Template with skills
        CreateContractTemplateWithEmptySkills();
        ContrTemplateHeaderCBLC.FindLast();
        ContrTemplateHeaderCBLC.TestField("No.");

        // [GIVEN] Object
        ContractHeaderCBLC.Init();

        // [WHEN] Create contract from Template
        LibraryContractLIB.CreateContractFromTemplate(ContractHeaderCBLC, ContrTemplateHeaderCBLC);

        ContractHeaderCBLC.Description := 'Created from Template ' + ContrTemplateHeaderCBLC."No.";
        ContractHeaderCBLC.Modify(true);
        // ContractNo := ContractHeaderCBLC."No.";

        // [THEN] Check Skills
        // ContrTemplateHeaderCBLC.GetSkillItems(TempSkillItemLine);
        LibrarySkillLIB.GetContractTemplateSkillItems(ContrTemplateHeaderCBLC, TempSkillItemLineCBLC);
        TempSkillItemLineCBLC.FindSet();
        repeat
            //Template = Contract
            if not LibrarySkillLIB.ContractSkillCodeExist(ContractHeaderCBLC, TempSkillItemLineCBLC."Item No. (Service)", TempSkillItemLineCBLC."Skill Code") then
                Error(NoSkillCodeErr, TempSkillItemLineCBLC."Skill Code", ContractHeaderCBLC."No.");
        until TempSkillItemLineCBLC.Next() = 0;
    end;

    [Test]
    // [HandlerFunctions('UpdateTemplateSkillsRequestPageHandler')]
    procedure UpdateContractWithTemplateSkills()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractSetupCBLC: Record "Contract Setup CBLC";
        SkillCode: Record "Skill Code";
        TempSkillItemLineCBLC: Record "Skill Item Line CBLC" temporary;
        // ContractNo: Code[20];
        UoMCode: Code[10];
        NoSkillCodeErr: Label 'Skill Code %1 does not exist for Object %2', Comment = '%1=Skill Code, %2=Object No.';
    begin
        // [GIVEN] Contract Template
        CreateContractTemplate(ContrTemplateHeaderCBLC);
        // ContrTemplateHeaderCBLC.Get(ContractTemplateNo);
        ContrTemplateHeaderCBLC.TestField("No.");

        // [GIVEN] Add Skills
        LibrarySkillLIB.AddSkillToContractTemplate(ContrTemplateHeaderCBLC, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography));
        LibrarySkillLIB.AddSkillToContractTemplate(ContrTemplateHeaderCBLC, LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization));

        // [THEN] Test skill count
        Assert.AreEqual(2, LibrarySkillLIB.SkillItemLineCount(ContrTemplateHeaderCBLC.RecordId().TableNo(), ContrTemplateHeaderCBLC.SystemId), 'Skill count does not match.');

        // [GIVEN] New Skill and add to template
        if not SkillCode.Get('No') then
            LibrarySkillLIB.CreateSkill('NO', 'NO NO NO NO NO, there is no limit', SkillType::" ");
        LibrarySkillLIB.AddSkillToContractTemplate(ContrTemplateHeaderCBLC, 'NO');

        // [THEN] Test skill count
        Assert.AreEqual(3, LibrarySkillLIB.SkillItemLineCount(ContrTemplateHeaderCBLC.RecordId().TableNo(), ContrTemplateHeaderCBLC.SystemId), 'Skill count does not match.');

        // [GIVEN] Create new Contract
        ContractSetupCBLC.Get();
        ContractSetupCBLC.TestField("Unit of Measure Code Month");
        UoMCode := ContractSetupCBLC."Unit of Measure Code Month";
        LibraryContractLIB.CreateContract(ContractHeaderCBLC, '40000', UoMCode);
        ContractHeaderCBLC.TestField("No.");
        // ContractNo := ContractHeaderCBLC."No.";
        // [WHEN] Apply template to contract
        LibraryContractLIB.ApplyContractTemplateOnExistingContract(ContractHeaderCBLC, ContrTemplateHeaderCBLC);

        // [THEN] Check Skills
        // ContrTemplateHeaderCBLC.GetSkillItems(TempSkillItemLine);
        LibrarySkillLIB.GetContractTemplateSkillItems(ContrTemplateHeaderCBLC, TempSkillItemLineCBLC);
        TempSkillItemLineCBLC.FindSet();
        repeat
            //Template = Contract
            if not LibrarySkillLIB.ContractSkillCodeExist(ContractHeaderCBLC, TempSkillItemLineCBLC."Skill Code") then
                Error(NoSkillCodeErr, TempSkillItemLineCBLC."Skill Code", ContractHeaderCBLC."No.");
        until TempSkillItemLineCBLC.Next() = 0;
    end;

    [Test]
    procedure DeleteContractCreatedFromContractTemplate()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
        xContractHeaderCBLC: Record "Contract Header CBLC";
        SkillsExistErr: Label 'Record still exist for contract %1', Comment = '%1=Object No.';
    begin
        // [GIVEN] Contract created from template
        UpdateContractWithTemplateSkills();
        ContractHeaderCBLC.FindLast();
        ContractHeaderCBLC.TestField("No.");

        // [WHEN] Delete Contract
        xContractHeaderCBLC := ContractHeaderCBLC;
        ContractHeaderCBLC.Delete(true);

        // [THEN] No More Skills
        if LibrarySkillLIB.HasSkillItemLines(ContractHeaderCBLC.RecordId().TableNo(), xContractHeaderCBLC.SystemId) then
            Error(SkillsExistErr, ContractHeaderCBLC."No.");
    end;
    #endregion Contract template

    local procedure CreateObjectWitkSkills(var ObjectCBLC: Record "Object CBLC")
    var
        SkillCode: Code[10];
        ItemNo: Code[20];
    begin
        // [GIVEN] Object with skills
        LibraryObjectLIB.CreateObject(ObjectCBLC);
        LibrarySkillLIB.DeleteObjectSkills(ObjectCBLC);

        // [WHEN] Add Geo Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Geography);
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        ObjectCBLC.Find('=');
        Assert.AreEqual(SkillCode, ObjectCBLC."Geography Skill Code", 'Object Geography Skill not the same');

        // [WHEN] Add Org Skill
        SkillCode := LibraryRandomLIB.FindSkillCodeRandom(SkillType::Organization);
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, SkillCode);
        ObjectCBLC.Find('=');
        Assert.AreEqual(SkillCode, ObjectCBLC."Organization Skill Code", 'Object Organization Skill not the same');

        // [WHEN] Add Skill with Item
        SkillCode := 'ZAGEN';
        ItemNo := 'TSERVICE1';
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, ItemNo, SkillCode);

        // [WHEN] Add Skill with Item
        SkillCode := 'BOREN';
        ItemNo := 'TSERVICE4';
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, ItemNo, SkillCode);

        // [WHEN] Add Empty Skill
        SkillCode := 'HAKKEN';
        ItemNo := '';
        LibrarySkillLIB.AddSkillToObject(ObjectCBLC, ItemNo, SkillCode);
    end;

    #region Support

    local procedure CreateObjectNo(): Code[20]
    var
        ObjectCBLC: Record "Object CBLC";
    begin
        LibraryObjectLIB.CreateObject(ObjectCBLC, true, 0D);
        exit(ObjectCBLC."No.");
    end;

    local procedure Initialize()
    var
        InitItemLIB: Codeunit "Init. Item LIB";
        InitObjectLIB: Codeunit "Init. Object LIB";
        InitResoureLIB: Codeunit "Init. Resoure LIB";
        InitSkillsLIB: Codeunit "Init. Skills LIB";
    begin
        InitResoureLIB.Initialize();
        InitItemLIB.Initialize();
        InitObjectLIB.Initialize();
        InitSkillsLIB.Initialize();
    end;

    local procedure CreateObject(var ObjectCBLC: Record "Object CBLC")
    begin
        Clear(ObjectCBLC);
        LibraryObjectLIB.CreateObject(ObjectCBLC, true, 20230101D);
    end;

    #endregion Support

    [RequestPageHandler]
    procedure UpdateTemplateSkillsRequestPageHandler(var ApplyObjectTemplateCBLC: TestRequestPage "Apply Object Template CBLC")
    begin
        ApplyObjectTemplateCBLC.OK().Invoke();
        // Empty handler used to close the request page, default settings are used
    end;

    [MessageHandler]
    procedure MessageHandler(MessageText: Text[1024])
    begin
    end;

    [ConfirmHandler]
    procedure ConfirmHandler(Question: Text[1024]; var Response: Boolean)
    begin
        Response := true;
    end;
}
#pragma warning restore PC0030