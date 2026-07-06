codeunit 83916 "UT Object Import TPTE"
{
    Permissions =
        tabledata "Contr. Template Header CBLC" = R,
        tabledata "Contract Header CBLC" = R,
        tabledata "Customer Templ." = R,
        tabledata Item = R,
        tabledata "Object Import Batch CBLC" = RID,
        tabledata "Object Import Line CBLC" = RIM,
        tabledata "Object Setup CBLC" = R,
        tabledata "Object Status CBLC" = R,
        tabledata "Object Template CBLC" = R;
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryContractLIB: Codeunit "Library - Contract LIB";
        // Assert: Codeunit Assert;
        // LibraryRandom: Codeunit "Library - Random";
        LibraryRandomLIB: Codeunit "Library - Random LIB";
        LibrarySalesLIB: Codeunit "Library - Sales LIB";
        ClearRandomValue: Boolean;
        BatchNameTok: Label 'TEST', Locked = true;

    // [Test]
    // procedure DeleteContracts()
    // var
    //     ContractHeaderCBLC: Record "Contract Header CBLC";
    // begin
    //     Initialize();

    //     ContractHeaderCBLC.SetRange("Sell-to Customer No.", 'GL00000505');
    //     ContractHeaderCBLC.DeleteAll(true);
    // end;

    [Test]
    procedure CreateContractImportLines()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ObjectImportLineCBLC: Record "Object Import Line CBLC";
        I: Integer;
    begin
        // [GIVEN] Initalize
        Initialize();

        // [GIVEN] Create Contract Template
        LibraryContractLIB.CreateContractTemplate(ContrTemplateHeaderCBLC, 'MAAND');

        for I := 1 to 10 do begin
            CreateContractImportLine(ObjectImportLineCBLC, I);
            if I in [6 .. 9] then begin
                // ObjectImportLineCBLC."Contact No." := 'CT000030';

                if I in [7 .. 9] then
                    ObjectImportLineCBLC."Contract Template No." := ContrTemplateHeaderCBLC."No.";
                ObjectImportLineCBLC.Modify(true);
            end;
        end;
    end;

    [Test]
    procedure ValidateAllLines()
    var
        // ContrImportLineHelperCBLC: Codeunit "Object Import Line Helper CBLC";
        // ErrorLogCBLC: Record "Error Log CBLC";
        ObjectImportLineCBLC: Record "Object Import Line CBLC";
    // CheckContrImportMethCBLC: Codeunit "Check Object Import Meth. CBLC";
    begin
        ObjectImportLineCBLC.FilterGroup(0);
        ObjectImportLineCBLC.SetRange("Batch Name", BatchNameTok);
        ObjectImportLineCBLC.FilterGroup(2);

        // CheckContrImportMethCBLC.CheckObjectImportLines(ObjectImportLineCBLC, ErrorLogCBLC, true); //Geen dialogs //FIXME
        // end;
        //        ContrImportLineHelperCBLC.ValidateContractLines(ObjectImportLineCBLC);
    end;

    local procedure CreateContractImportLine(var ObjectImportLineCBLC: Record "Object Import Line CBLC"; Index: Integer)
    var
        ContactType: Enum "Contact Type";
    begin
        // Initialize();

        //Functie
        ObjectImportLineCBLC.Init();
        ObjectImportLineCBLC."Batch Name" := BatchNameTok;
        ObjectImportLineCBLC."Line No." := Index * 10000;

        //if Index Mod 6 = 0 then
        if Index in [1 .. 5] then
            CreateContractImportLineContact(ObjectImportLineCBLC, ContactType::Company)
        else
            CreateContractImportLineContact(ObjectImportLineCBLC, ContactType::Person);

        CreateContractImportLineObject(ObjectImportLineCBLC);
        CreateContractImportLineContract(ObjectImportLineCBLC);
        ObjectImportLineCBLC.Insert(true);
    end;

    local procedure CreateContractImportLineContact(var ObjectImportLineCBLC: Record "Object Import Line CBLC"; ContactType: Enum "Contact Type")
    var
        // HouseNoAdd: Text[10];
        // HouseNo: Text[20];
        Contact: Record Contact;
        CustomerTempl: Record "Customer Templ.";
        RoleCode: array[2] of Code[10];
        // ContactNo: Code[20];
        CustomerTemplateNo: Code[20];
    begin
        //Contact Part        
        case ContactType of
            ContactType::Company:
                begin
                    LibrarySalesLIB.CreatePersonContactWithCustomer(Contact);
                    ObjectImportLineCBLC."Contact Type" := ObjectImportLineCBLC."Contact Type"::Company;
                    if ObjectImportLineCBLC."Contact Role Code" = '' then
                        ObjectImportLineCBLC.Validate("New Contact Role Code", 'KLANT')
                    else
                        ObjectImportLineCBLC.Validate("New Contact Role Code", LibraryRandomLIB.GetRandomValueByTableCode10(Database::"Role CBLC"));
                end;
            ContactType::Person:
                begin
                    LibrarySalesLIB.CreatePersonContactWithCustomer(Contact);
                    ObjectImportLineCBLC."Contact Type" := ObjectImportLineCBLC."Contact Type"::Person;
                    // ContactNo := LibraryRandomLIB.GetRandomContact(ContactType::Company);
                    ObjectImportLineCBLC.Validate("Contact No.", Contact."No.");
                    RoleCode[1] := LibraryRandomLIB.GetRandomValueByTableCode10(Database::"Role CBLC");
                    ObjectImportLineCBLC.Validate("Contact Role Code", RoleCode[1]);

                    RoleCode[2] := LibraryRandomLIB.GetRandomValueByTableCode10(Database::"Role CBLC");
                    while RoleCode[2] = RoleCode[1] do
                        RoleCode[2] := LibraryRandomLIB.GetRandomValueByTableCode10(Database::"Role CBLC");
                    ObjectImportLineCBLC.Validate("New Contact Role Code", RoleCode[2]);
                end;
        end;

        ObjectImportLineCBLC."Contact Name" := LibraryRandomLIB.FindFirstNameRandom() + ' ' + LibraryRandomLIB.FindLastNameRandom();
        //Tijdelijk uit

        //TODO TERUG TM-NL
        LibraryRandomLIB.FindAddressCompleteRandom(ObjectImportLineCBLC.Address,
                                                   ObjectImportLineCBLC."House No. YBLC",
                                                   ObjectImportLineCBLC."House No. Addition YBLC",
                                                   ObjectImportLineCBLC."Post Code",
                                                   ObjectImportLineCBLC.City);

        // LibraryRandomLIB.FindAddressCompleteRandom(ObjectImportLineCBLC.Address,
        //                                                 HouseNo, //    ObjectImportLineCBLC."House No. YBLC",
        //                                                 HouseNoAdd, //    ObjectImportLineCBLC."House No. Addition YBLC",
        //                                                    ObjectImportLineCBLC."Post Code",
        //                                                    ObjectImportLineCBLC.City);

        //Random Straat leeg maken ter test TM-Nl
        // ObjectImportLineCBLC.Address := ''; //TBV TMNL

        // if ClearRandomValue then begin
        //     // if LibraryRandomBLC.IsRandomMod(6) then
        //     //     ObjectImportLineCBLC.Address := '';

        //     //TODO TERUG TM-NL
        //     // if LibraryRandomBLC.IsRandomMod(3) then
        //     //     ObjectImportLineCBLC."House No. Addition YBLC" := '';
        //     // if LibraryRandomBLC.IsRandomMod(4) then
        //     //     ObjectImportLineCBLC."House No. YBLC" := '';
        // end;
        CustomerTemplateNo := LibraryRandomLIB.GetRandomValueByTableAndField(CustomerTempl.RecordId().TableNo(), CustomerTempl.FieldNo(Code));
        ObjectImportLineCBLC.Validate("Customer Template No.", CustomerTemplateNo);
    end;

    local procedure CreateContractImportLineObject(var ObjectImportLineCBLC: Record "Object Import Line CBLC")
    var
        Item: Record Item;
        ObjectStatusCBLC: Record "Object Status CBLC";
        ObjcetTemplateCBLC: Record "Object Template CBLC";
        ObjectTemplateNo: Code[20];
        StatusCode: Code[20];
        InstallationDate: Date;
    begin
        ObjectTemplateNo := LibraryRandomLIB.GetRandomValueByTableAndField(ObjcetTemplateCBLC.RecordId().TableNo(), ObjcetTemplateCBLC.FieldNo("No."));

        ObjectImportLineCBLC.Validate("Object Template No.", ObjectTemplateNo);
        if ObjectImportLineCBLC."Object Description" = '' then
            ObjectImportLineCBLC.Validate("Object Description", LowerCase(ObjectImportLineCBLC."Object Template No."));

        StatusCode := LibraryRandomLIB.GetRandomValueByTableAndField(ObjectStatusCBLC.RecordId().TableNo(), ObjectStatusCBLC.FieldNo(Code));
        ObjectImportLineCBLC.Validate("Object Status Code", StatusCode);
        ObjectImportLineCBLC.Validate("Location Description", LibraryRandomLIB.FindLocationRandom());

        if ClearRandomValue then
            if LibraryRandomLIB.IsRandomMod(3) then
                ObjectImportLineCBLC."Location Description" := '';

        Item.SetFilter(Type, '<>%1', Item.Type::Service);
        Item.FindFirst();

        ObjectImportLineCBLC.Validate("Physical Item No.", Item."No.");
        InstallationDate := CalcDate('<-CM>', WorkDate());
        InstallationDate += LibraryRandomLIB.RandIntInRange(0, 7);

        ObjectImportLineCBLC.Validate("Installation Date", InstallationDate);
        ObjectImportLineCBLC.Validate("Serial No.", CopyStr(UpperCase(LibraryRandomLIB.RandText(32)), 1, 32));

        //FIXME WERK NIET ObjectImportLineCBLC.Validate("Maintenance Item No.", LibraryRandomLIB.FindItemNoRandom(Enum::"Item Type"::Service));

        CreateContractImportLineObjectProperties(ObjectImportLineCBLC);
        // CreateContractImportLineObjectPropertiesExtension(ObjectImportLineCBLC);

    end;

    local procedure CreateContractImportLineObjectProperties(var ObjectImportLineCBLC: Record "Object Import Line CBLC")
    var
        ObjectSetupCBLC: Record "Object Setup CBLC";
    begin
        ObjectSetupCBLC.Get();
        ObjectImportLineCBLC."Line No." := ObjectImportLineCBLC."Line No.";
        exit; //TODO Geen properties voor nu

        // ObjectImportLineCBLC."Property 1" := Format(LibraryRandom.RandIntInRange(2010, 2021)); //BOUWJAAR
        // ObjectImportLineCBLC."Property 2" := LibraryRandomBLC.FindObjectPropertyValueRandom(ObjectSetupCBLC."Property 2 Code");
        // ObjectImportLineCBLC."Property 3" := Format(LibraryRandom.RandDateFromInRange(20200101D, 1, 100)); //PLAATSINGSDATUM
        // ObjectImportLineCBLC."Property 4" := LibraryRandomBLC.FindObjectPropertyValueRandom(ObjectSetupCBLC."Property 4 Code");
        // ObjectImportLineCBLC."Property 5" := LibraryRandomBLC.FindObjectPropertyValueRandom(ObjectSetupCBLC."Property 5 Code"); //VERMOGEN
        // ObjectImportLineCBLC."Property 6" := '';
        // ObjectImportLineCBLC."Property 7" := '';
        // ObjectImportLineCBLC."Property 8" := '';
        // ObjectImportLineCBLC."Property 9" := '';
        // ObjectImportLineCBLC."Property 10" := '';
    end;

    // local procedure CreateContractImportLineObjectPropertiesExtension(var ObjectImportLineCBLC: Record "Object Import Line CBLC")
    // var
    // // ObjectSetupCBLC: Record "Object Setup CBLC";
    // begin
    //     // ObjectSetupCBLC.Get();
    //     // ObjectImportLineCBLC."Property 83900" := LibraryRandomLIB.FindObjectPropertyValueRandom(ObjectSetupCBLC."Property 83900 Code"); //VERMOGEN
    // end;

    local procedure CreateContractImportLineContract(var ObjectImportLineCBLC: Record "Object Import Line CBLC")
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
        ContractHeader: Record "Contract Header CBLC";
        DateFormulaValue: DateFormula;
        ContractNo: Code[20];
        ContractTemplateNo: Code[20];
        EndDate: Date;
        StartDate: Date;
        Index: Integer;
    begin
        ContractTemplateNo := LibraryRandomLIB.GetRandomValueByTableAndField(ContrTemplateHeaderCBLC.RecordId().TableNo(), ContrTemplateHeaderCBLC.FieldNo("No."));

        ContractNo := LibraryRandomLIB.GetRandomValueByTableAndField(ContractHeader.RecordId().TableNo(), ContractHeader.FieldNo("No."));
        if LibraryRandomLIB.IsRandomMod(3) then
            ContractNo := '';


        ObjectImportLineCBLC.Validate("Contract No.", ContractNo);
        if ObjectImportLineCBLC."Contract No." = '' then
            ObjectImportLineCBLC.Validate("Contract Template No.", ContractTemplateNo);

        if LibraryRandomLIB.IsRandomMod(6) then
            ObjectImportLineCBLC.Validate("Contract Template No.", ContractTemplateNo);

        StartDate := CalcDate('<-CY>', Today());
        EndDate := CalcDate('<+CY>', Today());
        ObjectImportLineCBLC.Validate("Starting Date", StartDate);
        ObjectImportLineCBLC.Validate("Ending Date", EndDate);
        ObjectImportLineCBLC.Validate("Follow-up Template No.", LibraryRandomLIB.GetRandomValueByTableAndFieldCode20(ContrTemplateHeaderCBLC.RecordId().TableNo(), ContrTemplateHeaderCBLC.FieldNo("No.")));

        Index := LibraryRandomLIB.RandIntInRange(1, 3);
        case Index of
            1:
                begin
                    Evaluate(DateFormulaValue, '<5Y>');
                    ObjectImportLineCBLC.Validate("Follow-up Date Formula", DateFormulaValue);
                end;
            2:
                begin
                    Evaluate(DateFormulaValue, '<+10Y>');
                    ObjectImportLineCBLC.Validate("Follow-up Date Formula", DateFormulaValue);
                end;
            3:
                begin
                    Evaluate(DateFormulaValue, '<15Y>');
                    ObjectImportLineCBLC.Validate("Follow-up Date Formula", DateFormulaValue);
                end;
        end;
    end;

    local procedure Initialize()
    var
        // InitContract: Codeunit "Init. Contract TEST";
        InitObjectLIB: Codeunit "Init. Object LIB";
    // InitProperty: Codeunit "Init. Property BLC";
    begin
        ClearRandomValue := false;

        InitObjectLIB.Initialize();
        DeleteBatch();
        CreateImportBatch(BatchNameTok, 'Test batch');
        //uit voor nu  InitContract.Initialize();
        // InitProperty.Initialize();
        //UIT VOOR NU LibraryContractBLC.CreateContractTemplate(ContrTemplateHeaderCBLC, 'MAAND');
    end;

    local procedure DeleteBatch()
    var
        ContractImportBatchCBLC: Record "Object Import Batch CBLC";
        ObjectImportLineCBLC: Record "Object Import Line CBLC";
        ExistErr: Label 'Still lines for Batch %1', Comment = '%1=Batch Name';
    begin
        // BatchName := 'TEST';
        if ContractImportBatchCBLC.Get(BatchNameTok) then
            ContractImportBatchCBLC.Delete(true);

        //Test
        ObjectImportLineCBLC.SetRange("Batch Name", BatchNameTok);
        if not ObjectImportLineCBLC.IsEmpty() then
            Error(ErrorInfo.Create(StrSubstNo(ExistErr, BatchNameTok)));
    end;

    local procedure CreateImportBatch(Name: Code[20]; Description: Text[100])
    var
        ObjectImportBatchCBLC: Record "Object Import Batch CBLC";
    begin
        ObjectImportBatchCBLC.Init();
        ObjectImportBatchCBLC.Validate(Name, Name);
        ObjectImportBatchCBLC.Validate(Description, Description);
        ObjectImportBatchCBLC.Insert(true);
    end;
}