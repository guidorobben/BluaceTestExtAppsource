codeunit 83903 "UT Object TPTE"
{
    Permissions =
        tabledata Contact = R,
        tabledata "Contr. Template Header CBLC" = R,
        tabledata "Contract Header CBLC" = RM,
        tabledata "Contract Line CBLC" = R,
        tabledata Customer = RM,
        tabledata "FA Depreciation Book" = RM,
        tabledata "Fixed Asset" = RM,
        tabledata Item = R,
        tabledata "Object Status CBLC" = R,
        tabledata "Object Template CBLC" = R,
        tabledata "Object CBLC" = RM,
        tabledata "Property Line BBLC" = R,
        tabledata "Sales Line" = RM;
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        LibraryContractLIB: Codeunit "Library - Contract LIB";
        LibraryItem: Codeunit "Library - Item LIB";
        LibraryMarketing: Codeunit "Library - Marketing";
        LibraryObjectLIB: Codeunit "Library - Object LIB";
        LibraryProperty: Codeunit "Library - Property LIB";
        LibraryRandom: Codeunit "Library - Random";
        LibraryRandomLIB: Codeunit "Library - Random LIB";
        LibrarySales: Codeunit "Library - Sales LIB";
        LibrarySalesLIB: Codeunit "Library - Sales LIB";
        ObjectTemplateNo: Code[20];

    [Test]
    procedure CreateObjectWithPriceAndProperties()
    var
        ObjectCBLC: Record "Object CBLC";
    begin
        // [Given] Object
        LibraryObjectLIB.CreateObject(ObjectCBLC, true, (Today() + 3));
        ObjectCBLC.TestField("No.");
        ObjectCBLC.Validate(Description, 'Price and properties');
        ObjectCBLC.Modify(true);

        //Properties
        LibraryObjectLIB.AddObjectProperty(ObjectCBLC, 'PLAATSINGSDATUM', 20220101D, Format(CalcDate('<-CW>', Today())));
        LibraryObjectLIB.AddObjectProperty(ObjectCBLC, 'BOUWJAAR', 20220101D, Format(LibraryRandom.RandIntInRange(1990, 2021)));
        LibraryObjectLIB.AddObjectProperty(ObjectCBLC, 'BOUWJAAR', 20220101D, Format(LibraryRandom.RandIntInRange(1990, 2021)));
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectWithPriceAndContact()
    var
        Contact: Record Contact;
        ObjectCBLC: Record "Object CBLC";
    begin
        //[GIVEN] Object
        LibraryObjectLIB.CreateObject(ObjectCBLC, true, (Today() + 3));
        // [THEN] Test Object
        ObjectCBLC.TestField("No.");
        ObjectCBLC.Validate(Description, 'Price and contacts');
        ObjectCBLC.Modify(true);

        // [WHEN] Create and Link Contact
        LibrarySales.CreatePersonContactWithCustomer(Contact);
        LibraryObjectLIB.CreateObjectContact(ObjectCBLC, 'KLANT', Today() - 600, 0D, Contact."No.");

        ObjectCBLC.Validate(Address, 'Houtmanstraat 15');
        ObjectCBLC.Validate(City, 'Alkmaar');
        ObjectCBLC.Validate("Post Code", '1817EK');
        ObjectCBLC.Modify(true);

        // [THEN] TODO TEST FOR CONTACT
    end;


    [Test]
    procedure CreateObjectTemplate()
    var
        ObjectTemplateCBLC: Record "Object Template CBLC";
    begin
        LibraryObjectLIB.CreateObjectTemplate(ObjectTemplateCBLC);
        ObjectTemplateNo := ObjectTemplateCBLC."No.";
    end;

    [Test]
    procedure CreateObjectWithTemplate()
    var
        ObjectTemplateCBLC: Record "Object Template CBLC";
        ObjectCBLC: Record "Object CBLC";
        RandomObjectTemplateNo: Code[20];
    begin
        // [GIVEN] Get Random Template
        RandomObjectTemplateNo := LibraryRandomLIB.GetRandomValueByTableCode20(ObjectTemplateCBLC.RecordId().TableNo());
        ObjectTemplateCBLC.Get(RandomObjectTemplateNo);
        ObjectTemplateCBLC.TestField("No.");

        // [WHEN] Create Object from Template
        LibraryObjectLIB.CreateObjectWithTemplate(ObjectCBLC, ObjectTemplateCBLC);

        // [THEN] Test Object 
        ObjectCBLC.TestField("No.");
        ObjectCBLC.TestField("Object Template No.");
        //TODO TEST for matching info object and template
    end;

    [Test]
    procedure CreateObjectAndClose()
    var
        ObjectStatusCBLC: Record "Object Status CBLC";
        ObjectCBLC: Record "Object CBLC";
        ContactNo: Code[20];
    begin
        //Close via Validate

        // [GIVEN] Object with contact
        Clear(ObjectCBLC);
        LibraryObjectLIB.CreateObject(ObjectCBLC, false, (Today() + 4));
        ContactNo := LibraryMarketing.CreatePersonContactNo();
        LibraryObjectLIB.CreateObjectContact(ObjectCBLC, 'PARTNER', (Today()), 0D, ContactNo);

        // [WHEN] Close
        ObjectStatusCBLC.SetRange("End Object Contact/Contract", true);
        ObjectStatusCBLC.FindFirst();

        ObjectCBLC.Validate("Object Status Code", ObjectStatusCBLC.Code);
        ObjectCBLC.Modify(true);

        // [THEN] Test
        Assert.AreEqual(ObjectCBLC."Object Status Code", ObjectStatusCBLC.Code, 'Object Status Code is not correct');
    end;

    // [Test]
    // [HandlerFunctions('MessageHandler')]
    // procedure CreateObjectWithChildAndClose()
    // var
    //     Contact: Record Contact;
    //     ObjectStatusCBLC: Record "Object Status CBLC";
    //     ChildObjectCBLC: Record "Object CBLC";
    //     ObjectCBLC: Record "Object CBLC";
    //     CloseObjectMethCBLC: Codeunit "Close Object Meth CBLC";
    // begin
    //     //Close via Method codeunit

    //     //Create
    //     Clear(ObjectCBLC);
    //     LibraryObjectLIB.CreateObject(ObjectCBLC, false, (Today() + 4));

    //     //LibrarySales.CreateCustomer(Customer);
    //     //Customer.Validate(Contact, 'New Contact');
    //     //ContactNo := Customer."Primary Contact No.";
    //     //Contact.Get(ContactNo);
    //     // Commit;
    //     LibraryMarketing.CreatePersonContact(Contact);
    //     Contact.CreateCustomerFromTemplate('');

    //     // Contact.Validate("Company No.", LibraryMarketing.CreateCompanyContactNo());
    //     // Contact.Modify(true);

    //     // CustomerTempl.DeleteAll;
    //     // LibraryMarketing.CreateCustomerFromContact(Customer, Contact);
    //     LibraryObjectLIB.CreateObjectContact(ObjectCBLC, 'KLANT', (Today), 0D, Contact."No.");

    //     //Child
    //     LibraryObjectLIB.CreateObject(ChildObjectCBLC, false, (Today() + 4));
    //     LibraryObjectLIB.AddObjectToBOM(ObjectCBLC, ChildObjectCBLC);
    //     // ChildObjectCBLC.Validate("Main Object No.", ObjectCBLC."No.");
    //     ChildObjectCBLC.Validate(Description, 'Child of ' + ObjectCBLC."No.");
    //     ChildObjectCBLC.Modify(true);

    //     //Close
    //     ObjectStatusCBLC.SetRange("End Object Contact/Contract", true);
    //     ObjectStatusCBLC.FindFirst();

    //     CloseObjectMethCBLC.CloseObject(ObjectCBLC, CalcDate('<+CM>'), ObjectStatusCBLC.Code, not GuiAllowed);

    //     ObjectCBLC.Find('=');
    //     ChildObjectCBLC.Find('=');

    //     //Test
    //     Assert.AreEqual(ObjectCBLC."Object Status Code", ObjectStatusCBLC.Code, 'Object Status Code is not correct');
    //     Assert.AreEqual(ObjectCBLC."Object Status Code", ChildObjectCBLC."Object Status Code", 'Object - Status Code & Child Object - Status Code are not the same.');
    // end;


    // [Test]
    // [HandlerFunctions('MessageHandler')]
    // procedure CreateObjectWithContractAndClose()
    // var
    //     Contact: Record Contact;
    //     ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
    //     Customer: Record Customer;
    //     ObjectStatusCBLC: Record "Object Status CBLC";
    //     ObjectCBLC: Record "Object CBLC";
    //     CloseObjectMethCBLC: Codeunit "Close Object Meth CBLC";
    //     CreateContractObjMethCBLC: Codeunit "Create Contract Obj. Meth CBLC";
    // begin
    //     //Close via Method codeunit

    //     //Create
    //     Clear(ObjectCBLC);
    //     LibraryObjectLIB.CreateObject(ObjectCBLC, true, (Today() + 4));
    //     // ObjectCBLC.Validate("Price Item No.", 'GL00000161');
    //     ObjectCBLC.Modify(true);

    //     //LibrarySales.CreateCustomer(Customer);
    //     //Customer.Validate(Contact, 'New Contact');
    //     //ContactNo := Customer."Primary Contact No.";
    //     //Contact.Get(ContactNo);
    //     // Commit;
    //     LibraryMarketing.CreatePersonContact(Contact);
    //     Contact.CreateCustomerFromTemplate('');
    //     LibrarySales.GetCustomerFromContact(Customer, Contact);

    //     Customer.Validate("Gen. Bus. Posting Group", 'BINNENLAND');
    //     Customer.Validate("Customer Posting Group", 'BINNENLAND');
    //     Customer.Modify(true);

    //     // Contact.Validate("Company No.", LibraryMarketing.CreateCompanyContactNo());
    //     // Contact.Modify(true);

    //     // CustomerTempl.DeleteAll;
    //     // LibraryMarketing.CreateCustomerFromContact(Customer, Contact);
    //     LibraryObjectLIB.CreateObjectContact(ObjectCBLC, 'KLANT', Today(), 0D, Contact."No.");


    //     //Contract
    //     ContrTemplateHeaderCBLC.FindFirst();
    //     CreateContractObjMethCBLC.CreateContractFromObject(ObjectCBLC, ContrTemplateHeaderCBLC."No.", Today(), true);

    //     //Close
    //     ObjectStatusCBLC.SetRange("End Object Contact/Contract", true);
    //     ObjectStatusCBLC.FindFirst();

    //     CloseObjectMethCBLC.CloseObject(ObjectCBLC, CalcDate('<+CM>'), ObjectStatusCBLC.Code, not GuiAllowed);
    //     ObjectCBLC.Find('=');

    //     //Test
    //     Assert.AreEqual(ObjectCBLC."Object Status Code", ObjectStatusCBLC.Code, 'Object Status Code is not correct');
    //     //Contract
    //     // Assert.AreNotEqual('', );
    // end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CreateObjectWithContractAndReindex()
    var
        Contact: Record Contact;
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContractHeaderCBLC: Record "Contract Header CBLC";
        ContractLineCBLC: Record "Contract Line CBLC";
        Customer: Record Customer;
        ObjectCBLC: Record "Object CBLC";
        // CreateContractObjMethCBLC: Codeunit "Create Contract Obj. Meth CBLC";
        ReindexDate: Date;
    begin
        //Close via Method codeunit

        //Create
        Clear(ObjectCBLC);
        LibraryObjectLIB.CreateObject(ObjectCBLC, true, (Today() + 4));
        ObjectCBLC.Validate(Description, 'Create Object With Contract And Reindex');
        ObjectCBLC.Modify(true);

        //#Customer
        LibraryMarketing.CreatePersonContact(Contact);
        Contact.CreateCustomerFromTemplate('');
        LibrarySales.GetCustomerFromContact(Customer, Contact);

        Customer.Validate("Gen. Bus. Posting Group", 'BINNENLAND');
        Customer.Validate("Customer Posting Group", 'BINNENLAND');
        Customer.Modify(true);

        LibraryObjectLIB.CreateObjectContact(ObjectCBLC, 'KLANT', Today(), 0D, Contact."No.");

        //#Contract
        ContrTemplateHeaderCBLC.FindFirst();
        LibraryObjectLIB.CreateContractFromObject(ObjectCBLC, ContrTemplateHeaderCBLC."No.", Today(), true);
        // CreateContractObjMethCBLC.CreateContractFromObject(ObjectCBLC, ContrTemplateHeaderCBLC."No.", Today(), true);

        ContractHeaderCBLC.FindLast();
        ContractHeaderCBLC.Validate(Description, 'Create Object With Contract And Reindex');
        ContractHeaderCBLC.Modify(true);
        ContractHeaderCBLC.Release();

        //Reindex
        ReindexDate := Today() + 20;
        LibraryContractLIB.ReindexContract(ContractHeaderCBLC, ReindexDate);

        // //Close
        // ObjectStatusCBLC.SetRange("End Object Contact/Contract", true);
        // ObjectStatusCBLC.FindFirst();

        // CloseObjectMethCBLC.CloseObject(ObjectCBLC, CalcDate('<+CM>'), ObjectStatusCBLC.Code);
        // ObjectCBLC.Find('=');

        //Test
        ContractLineCBLC.SetRange("Contract No.", ContractHeaderCBLC."No.");
        ContractLineCBLC.FindFirst();
        Assert.AreEqual(10000, ContractLineCBLC."Line No.", 'First contract line must be 10000.');

        if ContractLineCBLC.FindSet() then
            repeat
                Assert.AreEqual(ObjectCBLC.Description, ContractLineCBLC.Description, 'Description of contract line must be the same as object description.');
            until ContractLineCBLC.Next() = 0;
    end;

    [Test]
    procedure CreateObjectAndTemplateAndAddProperties()
    var
        ObjectTemplate1CBLC, ObjectTemplate2CBLC, ObjectTemplate3CBLC : Record "Object Template CBLC";
        ObjectCBLC: Record "Object CBLC";
        PropertyCode: Code[20];
        PropertyDoesNotExistErr: Label 'Property %1 does not exist.', Comment = '%1=Property';
    begin
        //Create
        LibraryObjectLIB.CreateObject(ObjectCBLC, false, (Today() + 3));
        ObjectCBLC.Validate(Description, 'Test Property Add');
        ObjectCBLC.Modify(true);

        LibraryObjectLIB.AddObjectPropertyValue(ObjectCBLC, 'BOUWJAAR', 20220101D, 0D, '1977');

        CreatePropertyTemplates(ObjectTemplate1CBLC, ObjectTemplate2CBLC, ObjectTemplate3CBLC);

        //Test
        //1
        ObjectCBLC.ApplyObjectTemplate(ObjectTemplate1CBLC);
        PropertyCode := 'BOUWJAAR';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));

        //2
        ObjectCBLC.ApplyObjectTemplate(ObjectTemplate2CBLC);
        PropertyCode := 'BOUWJAAR';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));
        PropertyCode := 'PLAATSINGSDATUM';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));

        //3
        ObjectCBLC.ApplyObjectTemplate(ObjectTemplate3CBLC);
        PropertyCode := 'BOUWJAAR';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));
        PropertyCode := 'PLAATSINGSDATUM';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));
        PropertyCode := 'VERMOGEN';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));
    end;

    [Test]
    procedure CreateObjectAndTemplateAndRemoveProperties()
    var
        ObjectTemplate1CBLC, ObjectTemplate2CBLC, ObjectTemplate3CBLC : Record "Object Template CBLC";
        ObjectCBLC: Record "Object CBLC";
        PropertyLineBBLC: Record "Property Line BBLC";
        PropertyCode: Code[20];
        PropertyDoesNotExistButShouldntErr: Label 'Property %1 does exist but it shouldnt!', Comment = '%1=Property';
        PropertyDoesNotExistErr: Label 'Property %1 does not exist.', Comment = '%1=Property';
        PropertyWrongEndingDateErr: Label 'Property %1, Ending Date %2 is wrong.', Comment = '%1=Property, %2=Ending Date';
        PropertyWrongStartingDateErr: Label 'Property %1, Starting Date %2 is wrong.', Comment = '%1=Property, %2=Starting Date';
    begin
        //Create
        LibraryObjectLIB.CreateObject(ObjectCBLC, false, (Today() + 3));

        ObjectCBLC.Validate(Description, 'Test Property Remove');
        ObjectCBLC.Modify(true);

        CreatePropertyTemplates(ObjectTemplate1CBLC, ObjectTemplate2CBLC, ObjectTemplate3CBLC);

        //Properties
        LibraryObjectLIB.DeleteProperties(ObjectCBLC);
        PropertyCode := 'BOUWJAAR';
        LibraryObjectLIB.AddObjectPropertyValue(ObjectCBLC, PropertyCode, 20220101D, 0D, '1977');

        PropertyCode := 'VERMOGEN';
        LibraryObjectLIB.AddObjectPropertyValue(ObjectCBLC, PropertyCode, 20220101D, 0D, '<100');

        PropertyCode := 'PLAATSINGSDATUM';
        LibraryObjectLIB.AddObjectPropertyValue(ObjectCBLC, PropertyCode, Today(), 0D, Format(20220801D));

        //CHECK
        PropertyCode := 'VERMOGEN';
        Clear(PropertyLineBBLC);
        LibraryProperty.PropertyLineExist(PropertyLineBBLC, ObjectCBLC, PropertyCode);
        Assert.IsTrue(PropertyLineBBLC."Starting Date" = 20220101D, StrSubstNo(PropertyWrongStartingDateErr, PropertyCode, PropertyLineBBLC."Starting Date"));


        PropertyCode := 'PLAATSINGSDATUM';
        Clear(PropertyLineBBLC);
        LibraryProperty.PropertyLineExist(PropertyLineBBLC, ObjectCBLC, PropertyCode);
        Assert.IsTrue(PropertyLineBBLC."Starting Date" = Today(), StrSubstNo(PropertyWrongStartingDateErr, PropertyCode, PropertyLineBBLC."Starting Date"));

        //TEST
        //3
        ObjectCBLC.ApplyObjectTemplate(ObjectTemplate3CBLC);
        PropertyCode := 'BOUWJAAR';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));
        PropertyCode := 'PLAATSINGSDATUM';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));
        PropertyCode := 'VERMOGEN';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));

        //2
        ObjectCBLC.ApplyObjectTemplate(ObjectTemplate2CBLC);
        PropertyCode := 'BOUWJAAR';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));
        PropertyCode := 'PLAATSINGSDATUM';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));

        //Test No
        PropertyCode := 'VERMOGEN';
        Clear(PropertyLineBBLC);
        LibraryProperty.PropertyLineExist(PropertyLineBBLC, ObjectCBLC, PropertyCode, Today() - 1);
        Assert.IsTrue(PropertyLineBBLC."Starting Date" = 20220101D, StrSubstNo(PropertyWrongStartingDateErr, PropertyCode, PropertyLineBBLC."Starting Date"));
        Assert.IsTrue(PropertyLineBBLC."Ending Date" = Today() - 1, StrSubstNo(PropertyWrongEndingDateErr, PropertyCode, PropertyLineBBLC."Ending Date"));


        //1 
        //Property should have been deleted
        ObjectCBLC.ApplyObjectTemplate(ObjectTemplate1CBLC);
        PropertyCode := 'PLAATSINGSDATUM';
        Assert.IsFalse(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistButShouldntErr, PropertyCode));
    end;

    [Test]
    procedure CreateObjectAndTemplateAndReopenProperties()
    var
        ObjectTemplate1CBLC, ObjectTemplate2CBLC, ObjectTemplate3CBLC : Record "Object Template CBLC";
        ObjectCBLC: Record "Object CBLC";
        PropertyLineBBLC: Record "Property Line BBLC";
        PropertyCode: Code[20];
        PropertyDoesNotExistErr: Label 'Property %1 does not exist.', Comment = '%1=Property';
        PropertyWrongEndingDateErr: Label 'Property %1, Ending Date %2 is wrong.', Comment = '%1=Property, %2=Ending Date';
        PropertyWrongStartingDateErr: Label 'Property %1, Starting Date %2 is wrong.', Comment = '%1=Property, %2=Starting Date';
    begin
        //Create
        LibraryObjectLIB.CreateObject(ObjectCBLC, false, (Today() + 3));
        ObjectCBLC.Validate(Description, 'Test Property Reopen');
        ObjectCBLC.Modify(true);

        CreatePropertyTemplates(ObjectTemplate1CBLC, ObjectTemplate2CBLC, ObjectTemplate3CBLC);

        //Properties
        LibraryObjectLIB.DeleteProperties(ObjectCBLC);
        // ObjectCBLC.DeleteProperties();
        PropertyCode := 'BOUWJAAR';
        LibraryObjectLIB.AddObjectPropertyValue(ObjectCBLC, PropertyCode, 20220101D, 0D, '1977');

        PropertyCode := 'VERMOGEN';
        LibraryObjectLIB.AddObjectPropertyValue(ObjectCBLC, PropertyCode, 20220101D, 0D, '<100');

        PropertyCode := 'PLAATSINGSDATUM';
        LibraryObjectLIB.AddObjectPropertyValue(ObjectCBLC, PropertyCode, Today(), 0D, Format(20220801D));

        //CHECK
        PropertyCode := 'VERMOGEN';
        Clear(PropertyLineBBLC);
        LibraryProperty.PropertyLineExist(PropertyLineBBLC, ObjectCBLC, PropertyCode);
        Assert.IsTrue(PropertyLineBBLC."Starting Date" = 20220101D, StrSubstNo(PropertyWrongStartingDateErr, PropertyCode, PropertyLineBBLC."Starting Date"));


        PropertyCode := 'PLAATSINGSDATUM';
        Clear(PropertyLineBBLC);
        LibraryProperty.PropertyLineExist(PropertyLineBBLC, ObjectCBLC, PropertyCode);
        Assert.IsTrue(PropertyLineBBLC."Starting Date" = Today(), StrSubstNo(PropertyWrongStartingDateErr, PropertyCode, PropertyLineBBLC."Starting Date"));

        //TEST
        //3
        ObjectCBLC.ApplyObjectTemplate(ObjectTemplate3CBLC);
        PropertyCode := 'BOUWJAAR';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));
        PropertyCode := 'PLAATSINGSDATUM';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));
        PropertyCode := 'VERMOGEN';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));

        //2
        ObjectCBLC.ApplyObjectTemplate(ObjectTemplate2CBLC);
        PropertyCode := 'BOUWJAAR';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));
        PropertyCode := 'PLAATSINGSDATUM';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));

        //Test Property should be reopend
        PropertyCode := 'VERMOGEN';
        Clear(PropertyLineBBLC);
        LibraryProperty.PropertyLineExist(PropertyLineBBLC, ObjectCBLC, PropertyCode, Today() - 1);
        Assert.IsTrue(PropertyLineBBLC."Starting Date" = 20220101D, StrSubstNo(PropertyWrongStartingDateErr, PropertyCode, PropertyLineBBLC."Starting Date"));
        Assert.IsTrue(PropertyLineBBLC."Ending Date" = Today() - 1, StrSubstNo(PropertyWrongEndingDateErr, PropertyCode, PropertyLineBBLC."Ending Date"));

        //3
        ObjectCBLC.ApplyObjectTemplate(ObjectTemplate3CBLC);
        PropertyCode := 'BOUWJAAR';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));
        PropertyCode := 'PLAATSINGSDATUM';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));
        PropertyCode := 'VERMOGEN';
        Assert.IsTrue(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo(PropertyDoesNotExistErr, PropertyCode));

        //Test Property should be reopend
        PropertyCode := 'VERMOGEN';
        Clear(PropertyLineBBLC);
        LibraryProperty.PropertyLineExist(PropertyLineBBLC, ObjectCBLC, PropertyCode, Today() - 1);
        Assert.IsTrue(PropertyLineBBLC."Starting Date" = 20220101D, StrSubstNo(PropertyWrongStartingDateErr, PropertyCode, PropertyLineBBLC."Starting Date"));
        Assert.IsTrue(PropertyLineBBLC."Ending Date" = 0D, StrSubstNo(PropertyWrongEndingDateErr, PropertyCode, PropertyLineBBLC."Ending Date"));

        //3 
        // //Property should have been deleted
        // ObjectCBLC.ApplyObjectTemplate(ObjectTemplate3CBLC);
        // PropertyCode := 'PLAATSINGSDATUM';
        // Assert.IsFalse(LibraryProperty.PropertyLineExist(ObjectCBLC, PropertyCode), StrSubstNo('Property %1 does exist but it shouldnt!', PropertyCode));
    end;

    [Test]
    procedure CreateObjectAndMaintTemplate()
    var
        ObjectTemplate1CBLC, ObjectTemplate2CBLC, ObjectTemplate3CBLC : Record "Object Template CBLC";
        ObjectCBLC: Record "Object CBLC";
    begin
        //Create
        LibraryObjectLIB.CreateObject(ObjectCBLC, false, (Today() - 3));
        ObjectCBLC.Validate(Description, 'Test Maint. Schedule');
        ObjectCBLC.Modify(true);

        CreatePropertyTemplates(ObjectTemplate1CBLC, ObjectTemplate2CBLC, ObjectTemplate3CBLC);
        //TODO To NEW STYLE
        // CreateMainScheduleTemplates();
    end;

    //TODO To NEW STYLE
    // local procedure CreateMainScheduleTemplates()
    // var
    //     MaintSchedTempl1CBLC, MaintSchedTempl2CBLC, MaintSchedTempl3CBLC : Record "Maint. Sched. Templ. CBLC";
    //     ObjectTemplateCBLC: Record "Object Template CBLC";
    // begin
    //     ObjectTemplateCBLC.Get('1PROPERTY');
    //     MaintSchedTempl1CBLC.SetRange("Object Template No.", ObjectTemplateCBLC."No.");
    //     if not MaintSchedTempl1CBLC.FindFirst() then
    //         LibraryObjectLIB.CreateObjectTemplateMaintScheduleTemplateLine(MaintSchedTempl1CBLC, ObjectTemplateCBLC, 10000, 'SERVICE1');

    //     ObjectTemplateCBLC.Get('2PROPERTY');
    //     MaintSchedTempl2CBLC.SetRange("Object Template No.", ObjectTemplateCBLC."No.");
    //     if not MaintSchedTempl2CBLC.FindFirst() then begin
    //         LibraryObjectLIB.CreateObjectTemplateMaintScheduleTemplateLine(MaintSchedTempl2CBLC, ObjectTemplateCBLC, 10000, 'SERVICE1');
    //         LibraryObjectLIB.CreateObjectTemplateMaintScheduleTemplateLine(MaintSchedTempl2CBLC, ObjectTemplateCBLC, 20000, 'SERVICE2');
    //     end;

    //     ObjectTemplateCBLC.Get('3PROPERTY');
    //     MaintSchedTempl3CBLC.SetRange("Object Template No.", ObjectTemplateCBLC."No.");
    //     if not MaintSchedTempl3CBLC.FindFirst() then begin
    //         LibraryObjectLIB.CreateObjectTemplateMaintScheduleTemplateLine(MaintSchedTempl3CBLC, ObjectTemplateCBLC, 10000, 'SERVICE1');
    //         LibraryObjectLIB.CreateObjectTemplateMaintScheduleTemplateLine(MaintSchedTempl3CBLC, ObjectTemplateCBLC, 20000, 'SERVICE2');
    //         LibraryObjectLIB.CreateObjectTemplateMaintScheduleTemplateLine(MaintSchedTempl3CBLC, ObjectTemplateCBLC, 30000, 'SERVICE3');
    //     end;
    // end;


    [Test]
    procedure CreateObjectWithPriceAndPropertiesAndFixedAsset()
    var
        FixedAsset: Record "Fixed Asset";
        Item: Record Item;
        ObjectCBLC: Record "Object CBLC";
    begin
        //[GIVEN] Object
        LibraryObjectLIB.CreateObject(ObjectCBLC, false, (Today() + 3));
        ObjectCBLC.Validate(Description, 'Price and properties & Fixed Asset');

        //[GIVEN] Item
        LibraryItem.CreatePriceItem(Item, LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), 'MAAND');
        Item.TestField("No.");

        ObjectCBLC.Validate("Price Item No.", Item."No.");
        ObjectCBLC.Modify(true);

        //[GIVEN] Properties
        LibraryObjectLIB.AddObjectProperty(ObjectCBLC, 'PLAATSINGSDATUM', 20220101D, Format(CalcDate('<-CW>', Today())));
        LibraryObjectLIB.AddObjectProperty(ObjectCBLC, 'BOUWJAAR', 20220101D, Format(LibraryRandom.RandIntInRange(1990, 2021)));

        // [WHEN] Create Fixed Asset
        ObjectCBLC.SetRecFilter(); //Important
        LibraryObjectLIB.CreateFixedAsset(ObjectCBLC, true);
        // ObjectCBLC.CreateFixedAsset(true);

        // [THEN] Test for Fixed Asset
        ObjectCBLC.TestField("Fixed Asset No.");
        FixedAsset.Get(ObjectCBLC."Fixed Asset No.");

        // [THEN] Error creating fixed asset
        ObjectCBLC.SetRecFilter(); //Important
        // asserterror ObjectCBLC.CreateFixedAsset(true);
        asserterror LibraryObjectLIB.CreateFixedAsset(ObjectCBLC, true);

    end;

    #region Object Template
    [Test]
    procedure CreateObjectTemplateWithNormsAndCopy()
    var
        NewObjectTemplateCBLC: Record "Object Template CBLC";
        ObjectTemplateCBLC: Record "Object Template CBLC";
        "Object Norm Type CBLC": Enum "Object Norm Type CBLC";
    begin
        // [SCENARIO] 18758 Test copy of Object Templates with Norms
        // [GIVEN] Object Template
        CreateObjectTemplate();
        ObjectTemplateCBLC.Get(ObjectTemplateNo);
        ObjectTemplateCBLC.TestField("No.");

        // [GIVEN] Planning Norms
        LibraryObjectLIB.CreateItemPlanningNorm("Object Norm Type CBLC"::"Object Template", ObjectTemplateCBLC."No.", '1000');

        // [GIVEN] Usage Norms
        LibraryObjectLIB.CreateItemUsageNorm("Object Norm Type CBLC"::"Object Template", ObjectTemplateCBLC."No.", '1000');

        // [WHEN] Copy Object Template
        LibraryObjectLIB.CopyObjectTemplate(ObjectTemplateCBLC, NewObjectTemplateCBLC);
        NewObjectTemplateCBLC.TestField("No.");
    end;
    #endregion Object Template

    #region Sales Line
    [Test]
    procedure CreateSalesOrderLineWithObjectFixedAsset()
    var
        FADepreciationBook: Record "FA Depreciation Book";
        FixedAsset: Record "Fixed Asset";
        Item: Record Item;
        ObjectCBLC: Record "Object CBLC";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        UsageSalesLine: Record "Sales Line";
        FAPostingGroup: Code[20];
    // LibraryFixedAsset: Codeunit "Library - Fixed Asset";
    begin
        // [SCENARIO] ESNW

        // [GIVEN] Object
        LibraryObjectLIB.CreateObject(ObjectCBLC, false, (Today() + 3));
        ObjectCBLC.Validate(Description, 'Price and properties & Fixed Asset');

        // [GIVEN] Item
        LibraryItem.CreatePriceItem(Item, LibraryRandom.RandDecInRange(10, 100, 0), LibraryRandom.RandDecInRange(50, 100, 0), 'MAAND');
        Item.TestField("No.");

        ObjectCBLC.Validate("Price Item No.", Item."No.");
        ObjectCBLC.Modify(true);

        // //[GIVEN] Properties
        // LibraryObjectLIB.AddObjectProperty(ObjectCBLC, 'PLAATSINGSDATUM', 20220101D, Format(CalcDate('<-CW>', Today)));
        // LibraryObjectLIB.AddObjectProperty(ObjectCBLC, 'BOUWJAAR', 20220101D, Format(LibraryRandom.RandIntInRange(1990, 2021)));

        // [WHEN] Create Fixed Asset
        ObjectCBLC.SetRecFilter(); //Important
        LibraryObjectLIB.CreateFixedAsset(ObjectCBLC, true);
        // ObjectCBLC.CreateFixedAsset(true);

        FixedAsset.Get(ObjectCBLC."Fixed Asset No.");
        FAPostingGroup := LibraryRandomLIB.GetRandomValueByTable(Database::"FA Posting Group");

        FADepreciationBook.Get(FixedAsset."No.", 'BEDRIJF'); //TODO Fix
        FADepreciationBook.Validate("FA Posting Group", FAPostingGroup);
        FADepreciationBook.Modify(true);

        FixedAsset.Validate("FA Posting Group", FAPostingGroup);
        FixedAsset.Modify(true);

        // [THEN] Test for Fixed Asset
        ObjectCBLC.TestField("Fixed Asset No.");
        FixedAsset.Get(ObjectCBLC."Fixed Asset No.");

        // [GIVEN]
        LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesHeader, '40000');
        LibrarySalesLIB.CreatesalesLineItem(SalesLine, SalesHeader, 'SERVICE3');
        SalesLine.Validate("Object No. CBLC", ObjectCBLC."No.");
        SalesLine.Modify(true);

        LibrarySalesLIB.CreatesalesLineItem(UsageSalesLine, SalesHeader, Item."No.");
        UsageSalesLine.Validate("Usage For Line No. CBLC", SalesLine."Line No.");
        UsageSalesLine.Validate("Line Discount %", 100);
        UsageSalesLine.Modify(true);

        // [WHEN] 
        LibrarySalesLIB.PostSalesDocument(SalesHeader, true, true);

        // [THEN] Error creating fixed asset
        // ObjectCBLC.SetRecFilter(); //Important
        // asserterror ObjectCBLC.CreateFixedAsset(true);
    end;

    #endregion Sales Line

    local procedure CreatePropertyTemplates(var ObjectTemplate1CBLC: Record "Object Template CBLC"; var ObjectTemplate2CBLC: Record "Object Template CBLC"; var ObjectTemplate3CBLC: Record "Object Template CBLC")
    begin
        if not ObjectTemplate1CBLC.Get('1PROPERTY') then
            LibraryObjectLIB.CreateObjectTemplate(ObjectTemplate1CBLC, '1PROPERTY', '1 property');

        if not ObjectTemplate2CBLC.Get('2PROPERTY') then
            LibraryObjectLIB.CreateObjectTemplate(ObjectTemplate2CBLC, '2PROPERTY', '2 property');

        if not ObjectTemplate3CBLC.Get('3PROPERTY') then
            LibraryObjectLIB.CreateObjectTemplate(ObjectTemplate3CBLC, '3PROPERTY', '3 property');

        //1
        if not LibraryProperty.PropertyLineExist(ObjectTemplate1CBLC, 'BOUWJAAR') then
            LibraryObjectLIB.AddObjectTemplatePropertyValue(ObjectTemplate1CBLC, 'BOUWJAAR', 20220101D, 0D, '');

        //2
        if not LibraryProperty.PropertyLineExist(ObjectTemplate2CBLC, 'BOUWJAAR') then
            LibraryObjectLIB.AddObjectTemplatePropertyValue(ObjectTemplate2CBLC, 'BOUWJAAR', 20220101D, 0D, '');
        if not LibraryProperty.PropertyLineExist(ObjectTemplate2CBLC, 'PLAATSINGSDATUM') then
            LibraryObjectLIB.AddObjectTemplatePropertyValue(ObjectTemplate2CBLC, 'PLAATSINGSDATUM', 20220101D, 0D, '');

        //3
        if not LibraryProperty.PropertyLineExist(ObjectTemplate3CBLC, 'BOUWJAAR') then
            LibraryObjectLIB.AddObjectTemplatePropertyValue(ObjectTemplate3CBLC, 'BOUWJAAR', 20220101D, 0D, '');
        if not LibraryProperty.PropertyLineExist(ObjectTemplate3CBLC, 'PLAATSINGSDATUM') then
            LibraryObjectLIB.AddObjectTemplatePropertyValue(ObjectTemplate3CBLC, 'PLAATSINGSDATUM', 20220101D, 0D, '');
        if not LibraryProperty.PropertyLineExist(ObjectTemplate3CBLC, 'VERMOGEN') then
            LibraryObjectLIB.AddObjectTemplatePropertyValue(ObjectTemplate3CBLC, 'VERMOGEN', 20220101D, 0D, '');
    end;

    [MessageHandler]
    procedure MessageHandler(MessageText: Text[1024])
    begin
        // if MessageText = MessageText then;
    end;
}