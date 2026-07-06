codeunit 83922 "UT Skills TMNL TPTE"
{
    Permissions =
        tabledata "Object Setup CBLC" = RM,
        tabledata "Object CBLC" = RM,
        tabledata Resource = RM,
        tabledata "Skill Item Line CBLC" = R;
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        LibraryObjectLIB: Codeunit "Library - Object LIB";
        LibraryResourceLIB: Codeunit "Library - Resource LIB";
        LibrarySkillLIB: Codeunit "Library - Skill LIB";
        LibrarySkillNLLIB: Codeunit "Library - Skill NL LIB";
        ObjectNo: Code[20];
        ResourceNo: Code[20];

    #region Object TMNL

    [Test]
    procedure Initialize()
    var
        InitItemLIB: Codeunit "Init. Item LIB";
        InitObjectLIB: Codeunit "Init. Object LIB";
        InitResoureLIB: Codeunit "Init. Resoure LIB";
    // InitSkillsLIB: Codeunit "Init. Skills LIB";
    begin
        InitResoureLIB.Initialize();
        InitItemLIB.Initialize();
        InitObjectLIB.Initialize();
        // InitSkillsLIB.Initialize(); //Maakt alle zooi leeg
    end;

    #region ZL
    [Test]
    procedure ClearGeographicSkills()
    begin
        LibrarySkillNLLIB.DeleteAllPostCodeRangesGeographicSkill(false);
    end;

    [Test]
    procedure AddPostCodeToGeographicSkill_ZL()
    var
        SkillCode: Code[10];
    begin
        SkillCode := 'ZL';
        LibrarySkillNLLIB.AddPostCodeRangeToGeographicSkill(SkillCode, '2406AA', '2406ZZ');
    end;

    [Test]
    procedure AddSecondPostCodeToGeographicSkill_ZL()
    var
        SkillCode: Code[10];
    begin
        SkillCode := 'ZL';
        LibrarySkillNLLIB.AddPostCodeRangeToGeographicSkill(SkillCode, '3406AA', '3406ZZ');
    end;

    #endregion ZL

    #region DR
    [Test]
    procedure AddPostCodeToGeographicSkill_DR()
    var
        SkillCode: Code[10];
    begin
        //[GIVEN] Skill DR
        SkillCode := 'DR';

        //[WHEN] Delete all skills 
        LibrarySkillNLLIB.DeletePostCodeRangesGeographicSkill(SkillCode, false);

        //[THEN] Error door dubbele postcode
        asserterror LibrarySkillNLLIB.AddPostCodeRangeToGeographicSkill(SkillCode, '3406AA', '3406ZZ');
    end;

    #endregion DR

    #region Object
    [Test]
    procedure ObjectAddPostCodeWithoutCountryCode()
    var
        ObjectCBLC: Record "Object CBLC";
        SkillCode: Code[20];
    begin
        //[GIVEN] New object
        LibraryObjectLIB.CreateObject(ObjectCBLC, true, Today());

        //Disable NL Country Code
        EnableCountryCodeNL(false);

        //[WHEN] Set Country & Postcode
        ObjectCBLC.Validate("Country/Region Code", 'NL');
        ObjectCBLC.Validate("Post Code", '2406GG');
        ObjectCBLC.Modify(true);
        ObjectCBLC.Get(ObjectCBLC."No.");

        //[THEN] Skill should be empty
        SkillCode := '';
        Assert.AreEqual(SkillCode, ObjectCBLC."Geography Skill Code", 'Object Geographic skill not the same');
    end;

    [Test]
    procedure ObjectAddPostCodeWithCountryCode()
    var
        ObjectCBLC: Record "Object CBLC";
        SkillCode: Code[20];
    begin
        //[GIVEN] New object
        LibraryObjectLIB.CreateObject(ObjectCBLC, true, Today());
        ObjectCBLC.TestField("No.");
        ObjectNo := ObjectCBLC."No.";

        //Enable NL Country Code
        EnableCountryCodeNL(true);

        //[WHEN] Set Country & Postcode
        ObjectCBLC.Validate("Country/Region Code", 'NL');
        ObjectCBLC.Validate("Post Code", '2406GG');
        ObjectCBLC.Modify(true);
        ObjectCBLC.Get(ObjectCBLC."No.");

        //[THEN] Skill should be empty
        SkillCode := 'ZL';
        Assert.AreEqual(SkillCode, ObjectCBLC."Geography Skill Code", 'Object Geographic skill not the same');
    end;

    [Test]
    procedure ObjectAddPostCodeWithCountryCodeAndDeleteSkill()
    var
        ObjectCBLC: Record "Object CBLC";
        SkillItemLineCBLC: Record "Skill Item Line CBLC";
        SkillCode: Code[20];
    begin
        //[GIVEN] New object
        ObjectAddPostCodeWithCountryCode();
        ObjectCBLC.Get(ObjectNo);

        //Enable NL Country Code
        EnableCountryCodeNL(true);

        // [WHEN] Delete Skill
        SkillItemLineCBLC.DeleteSkillItems(Database::"Object CBLC", ObjectCBLC.SystemId, Enum::"Skill Type CBLC"::Geography, false);
        ObjectCBLC.Get(ObjectNo);

        // [THEN] Skill should be empty
        SkillCode := '';
        Assert.AreEqual(SkillCode, ObjectCBLC."Geography Skill Code", 'Resouce Geographic skill is not empty');

    end;
    #endregion

    #region FL
    [Test]
    procedure AddOrganizationSkillToGeographicSkill_Fl()
    var
        SkillCode: Code[10];
    begin
        //[GIVEN] Skill FL
        SkillCode := 'FL';

        //[WHEN] Delete all skills 
        LibrarySkillNLLIB.DeletePostCodeRangesGeographicSkill(SkillCode, false);
        LibrarySkillNLLIB.DeleteOrganizationSkillsFromGeographicSkill(SkillCode, false);

        //[WHEN] Add postcode & 
        LibrarySkillNLLIB.AddPostCodeRangeToGeographicSkill(SkillCode, '4406AA', '4406ZZ');
        LibrarySkillNLLIB.AddOrganizationSkillToGeographicSkill(SkillCode, 'BC');
        LibrarySkillNLLIB.AddPostCodeRangeToGeographicSkill(SkillCode, '2406AA', '2406ZZ');

        //[THEN] Error door dubbele postcode
        asserterror LibrarySkillNLLIB.DeleteOrganizationSkillFromGeographicSkill(SkillCode, 'BC', true);
    end;

    [Test]

    procedure AddPostCodeToGeographicSkill_FL()
    var
        SkillCode: Code[10];
    begin
        //[GIVEN] Skill DR
        SkillCode := 'DR';

        //[WHEN] Delete all skills 
        LibrarySkillNLLIB.DeletePostCodeRangesGeographicSkill(SkillCode, false);

        //[THEN] Error door dubbele postcode
        asserterror LibrarySkillNLLIB.AddPostCodeRangeToGeographicSkill(SkillCode, '3406AA', '3406ZZ');
    end;
    #endregion FL


    #region Resource
    [Test]
    procedure ResouceAddPostCodeWithCountryCode()
    var
        // ObjectCBLC: Record "Object CBLC";
        Resource: Record Resource;
        SkillCode: Code[20];
    begin
        //[GIVEN] New Resouce
        LibraryResourceLIB.CreateResource(Resource);
        Resource.Validate("Name 2", 'Geographic = ZL');
        Resource.Modify(true);
        ResourceNo := Resource."No.";

        // [GIVEN] Enable NL Country Code
        EnableCountryCodeNL(true);

        //[WHEN] Set Country & Postcode
        Resource.Validate("Country/Region Code", 'NL');
        Resource.Validate("Post Code", '2406GG');
        Resource.Modify(true);
        Resource.Get(Resource."No.");

        //[THEN] Skill should be ZL
        SkillCode := 'ZL';
        Assert.AreEqual(SkillCode, Resource."Geography Skill Code CBLC", 'Resouce Geographic skill not the same');
    end;

    [Test]
    procedure ResouceAddPostCodeWithCountryCodeAndDeleteSkill()
    var
        // ObjectCBLC: Record "Object CBLC";
        Resource: Record Resource;
        SkillCode: Code[20];
        ResourceSkillType: Enum "Resource Skill Type";
        SkillTypeCBLC: Enum "Skill Type CBLC";
    begin
        //[GIVEN] New Resouce
        ResouceAddPostCodeWithCountryCode();
        Resource.Get(ResourceNo);

        // [WHEN] Delete Skill
        LibrarySkillLIB.DeleteResourceSkills(ResourceSkillType::Resource, Resource."No.", SkillTypeCBLC::Geography, false);
        Resource.Get(ResourceNo);

        // [THEN] Skill should be empty
        SkillCode := '';
        Assert.AreEqual(SkillCode, Resource."Geography Skill Code CBLC", 'Resouce Geographic skill is not empty');
    end;
    #endregion Resouce


    #region support functions
    local procedure EnableCountryCodeNL(Enable: Boolean)
    var
        ObjectSetupCBLC: Record "Object Setup CBLC";
    begin
        ObjectSetupCBLC.Get();
        if Enable then
            ObjectSetupCBLC.Validate("Country Code NL YBLC", 'NL')
        else
            ObjectSetupCBLC.Validate("Country Code NL YBLC", '');

        ObjectSetupCBLC.Modify(true);
    end;
    #endregion

    #endregion Object TMNL
}
