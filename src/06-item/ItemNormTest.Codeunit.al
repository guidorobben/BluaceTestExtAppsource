// codeunit 83905 "Item Norm Test TPTE"
// {
//     Subtype = Test;

//     var
//         LibraryItemLIB: Codeunit "Library - Item LIB";
//         LibraryRandomLIB: Codeunit "Library - Random LIB";

//     [Test]
//     procedure Initialize()
//     var
//         InitItemLIB: Codeunit "Init Item LIB";
//     begin
//         InitItemLIB.Initialize();
//     end;

//     [Test]
//     procedure CreateContractAndObjectNorms()
//     var
//         ContractNormCBLC: Record "Contract Norm CBLC";
//         ObjectNormCBLC: Record "Object Norm CBLC";
//     begin
//         //Contract
//         Clear(ContractNormCBLC);
//         ContractNormCBLC.Init();
//         ContractNormCBLC.Validate(Code, 'CCODE1');
//         ContractNormCBLC.Validate(Description, 'C-Code 1');
//         if ContractNormCBLC.Insert(true) then;

//         Clear(ContractNormCBLC);
//         ContractNormCBLC.Init();
//         ContractNormCBLC.Validate(Code, 'CCODE2');
//         ContractNormCBLC.Validate(Description, 'C-Code 2');
//         if ContractNormCBLC.Insert(true) then;

//         Clear(ContractNormCBLC);
//         ContractNormCBLC.Init();
//         ContractNormCBLC.Validate(Code, 'CCODE3');
//         ContractNormCBLC.Validate(Description, 'C-Code 3');
//         if ContractNormCBLC.Insert(true) then;

//         //Object
//         Clear(ObjectNormCBLC);
//         ObjectNormCBLC.Init();
//         ObjectNormCBLC.Validate(Code, 'OCODE1');
//         ObjectNormCBLC.Validate(Description, 'O-Code 1');
//         if ObjectNormCBLC.Insert(true) then;

//         Clear(ObjectNormCBLC);
//         ObjectNormCBLC.Init();
//         ObjectNormCBLC.Validate(Code, 'OCODE2');
//         ObjectNormCBLC.Validate(Description, 'O-Code 2');
//         if ObjectNormCBLC.Insert(true) then;

//         Clear(ObjectNormCBLC);
//         ObjectNormCBLC.Init();
//         ObjectNormCBLC.Validate(Code, 'OCODE3');
//         ObjectNormCBLC.Validate(Description, 'O-Code 3');
//         if ObjectNormCBLC.Insert(true) then;
//     end;

//     [Test]
//     procedure CreateItemsUsages()
//     var
//         Item: Record Item;
//         ItemUsageCBLC: Record "Item Usage CBLC";
//     begin
//         //[GIVEN] given
//         LibraryItemLIB.CreateItem(Item, '');
//         Item.TestField("No.");

//         //1
//         Clear(ItemUsageCBLC);
//         ItemUsageCBLC.Init();
//         ItemUsageCBLC.Validate("Item No.", Item."No.");
//         ItemUsageCBLC.Insert();

//         ItemUsageCBLC.Validate(Contract, ItemUsageCBLC.Contract::All);
//         //ItemUsageCBLC.Validate("Contract Source No.", LibraryRandomLIB.GetRandomValueByTable(Database::"Contract Norm CBLC"))
//         ItemUsageCBLC.Validate(Object, ItemUsageCBLC.Object::All);
//         ItemUsageCBLC.Modify(true);

//         //2
//         Clear(ItemUsageCBLC);
//         ItemUsageCBLC.Init();
//         ItemUsageCBLC.Validate("Item No.", Item."No.");
//         ItemUsageCBLC.Insert();

//         ItemUsageCBLC.Validate(Contract, ItemUsageCBLC.Contract::Contract);
//         ItemUsageCBLC.Validate("Contract Source No.", LibraryRandomLIB.GetRandomValueByTable(Database::"Contract Header CBLC"));

//         ItemUsageCBLC.Validate(Object, ItemUsageCBLC.Object::Object);
//         ItemUsageCBLC.Validate("Object Source No.", LibraryRandomLIB.GetRandomValueByTable(Database::"Object CBLC"));

//         ItemUsageCBLC.Modify(true);

//         //3
//         Clear(ItemUsageCBLC);
//         ItemUsageCBLC.Init();
//         ItemUsageCBLC.Validate("Item No.", Item."No.");
//         ItemUsageCBLC.Insert();

//         ItemUsageCBLC.Validate(Contract, ItemUsageCBLC.Contract::"Contract Norm");
//         ItemUsageCBLC.Validate("Contract Source No.", LibraryRandomLIB.GetRandomValueByTable(Database::"Contract Norm CBLC"));

//         ItemUsageCBLC.Validate(Object, ItemUsageCBLC.Object::"Object Norm");
//         ItemUsageCBLC.Validate("Object Source No.", LibraryRandomLIB.GetRandomValueByTable(Database::"Object Norm CBLC"));

//         ItemUsageCBLC.Modify(true);

//         //4
//         Clear(ItemUsageCBLC);
//         ItemUsageCBLC.Init();
//         ItemUsageCBLC.Validate("Item No.", Item."No.");
//         ItemUsageCBLC.Insert();

//         ItemUsageCBLC.Validate(Contract, ItemUsageCBLC.Contract::"Contract Template");
//         ItemUsageCBLC.Validate("Contract Source No.", LibraryRandomLIB.GetRandomValueByTable(Database::"Contr. Template Header CBLC"));

//         ItemUsageCBLC.Validate(Object, ItemUsageCBLC.Object::"Object Template");
//         ItemUsageCBLC.Validate("Object Source No.", LibraryRandomLIB.GetRandomValueByTable(Database::"Object Template CBLC"));

//         ItemUsageCBLC.Modify(true);

//         //[WHEN] when
//         //[THEN] then
//     end;

// }
