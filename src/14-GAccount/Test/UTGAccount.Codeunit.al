// codeunit 83869 "UT G-Account TPTE"
// {
//     Permissions =
//         tabledata Customer = R,
//         tabledata "Customer Posting Group" = RM,
//         tabledata "G/L Account" = RIM,
//         tabledata Item = RM,
//         tabledata "Purchase Header" = RM,
//         tabledata "Purchase Line" = R,
//         tabledata "Sales Header" = R,
//         tabledata "Sales Line" = R,
//         tabledata Vendor = R,
//         tabledata "Vendor Bank Account" = RM,
//         tabledata "G-Account GPZS" = RIMD,
//         tabledata "Vendor Posting Group" = RM;
//     Subtype = Test;
//     TestPermissions = Disabled;

//     var
//         Customer: Record Customer;
//         // PurchaseHeader: Record "Purchase Header";
//         // SalesHeader: Record "Sales Header";
//         Vendor: Record Vendor;

//         LibraryInventory: Codeunit "Library - Inventory";
//         LibraryPurchase: Codeunit "Library - Purchase";
//         LibraryRandom: Codeunit "Library - Random";
//         LibrarySales: Codeunit "Library - Sales";

//     [Test]
//     procedure Initialize()
//     begin
//         CreateGLAccount('2101', 'Inkoop G-rekening verwerking tussenrekening');
//         CreateGLAccount('2102', 'Verkoop G-rekening verwerking tussenrekening');
//         SetupPostingGroups();
//     end;

//     [Test]
//     procedure CreatingVendorWithBankAccount()
//     var
//         VendorBankAccount: Record "Vendor Bank Account";
//     begin
//         LibraryPurchase.CreateVendor(Vendor);
//         Vendor.TestField("No.");

//         //1
//         LibraryPurchase.CreateVendorBankAccount(VendorBankAccount, Vendor."No.");
//         VendorBankAccount.Name := 'Bank 1';
//         VendorBankAccount.Modify(true);
//         Vendor."Preferred Bank Account Code" := VendorBankAccount.Code;

//         //2
//         LibraryPurchase.CreateVendorBankAccount(VendorBankAccount, Vendor."No.");
//         VendorBankAccount.Name := 'Bank 2';
//         VendorBankAccount.Modify(true);
//     end;

//     [Test]
//     procedure CreateVendorGAccount()
//     var
//         GAccountGPZS: Record "G-Account GPZS";
//     begin
//         GAccountGPZS.Init();
//         GAccountGPZS."Source Table ID" := Database::Vendor;
//         GAccountGPZS."Source No." := Vendor."No.";
//         GAccountGPZS."Source Account No." := GAccountGPZS."Source No.";
//         GAccountGPZS."G-Account %" := LibraryRandom.RandIntInRange(10, 40);
//         GAccountGPZS."Bank Account Code" := Vendor."Preferred Bank Account Code";
//         GAccountGPZS.Insert(true);
//     end;

//     [Test]
//     procedure CreatingCustomerWithBankAccount()
//     var
//     begin
//         LibrarySales.CreateCustomer(Customer);
//         Customer.TestField("No.");

//         // //1
//         // LibrarySales.CreateCustomerBankAccount(CustomerBankAccount, Customer."No.");
//         // CustomerBankAccount.Name := 'Bank 1';
//         // CustomerBankAccount.Modify(true);
//         // Customer."Preferred Bank Account Code" := CustomerBankAccount.Code;

//         // //2
//         // LibrarySales.CreateCustomerBankAccount(CustomerBankAccount, Customer."No.");
//         // CustomerBankAccount.Name := 'Bank 2';
//         // CustomerBankAccount.Modify(true);
//     end;

//     [Test]
//     procedure CreateCustomerGAccount()
//     var
//         GAccountGPZS: Record "G-Account GPZS";
//     begin
//         GAccountGPZS.Init();
//         GAccountGPZS."Source Table ID" := Database::Customer;
//         GAccountGPZS."Source No." := Customer."No.";
//         GAccountGPZS."Source Account No." := GAccountGPZS."Source No.";
//         GAccountGPZS."G-Account %" := LibraryRandom.RandIntInRange(10, 40);
//         GAccountGPZS."Bank Account Code" := 'ABN';
//         GAccountGPZS.Insert(true);
//     end;


//     [Test]
//     procedure TestPurchaseInvoice()
//     var
//         PurchaseHeader: Record "Purchase Header";
//         PurchaseLine: Record "Purchase Line";
//         VendorBankAccount: Record "Vendor Bank Account";
//     begin
//         // Exercise: Create Purchase Invoice.
//         CreatePurchaseInvoice(PurchaseHeader, PurchaseLine, Vendor."No.");

//         PurchaseHeader.CalcFields("Amount Including VAT");
//         PurchaseHeader.Validate("Doc. Amount Incl. VAT", PurchaseHeader."Amount Including VAT");

//         //Add Bank Account
//         VendorBankAccount.SetRange("Vendor No.", Vendor."No.");
//         VendorBankAccount.FindFirst();

//         PurchaseHeader.Validate("Bank Account Code", VendorBankAccount.Code);
//         PurchaseHeader.Modify(true);

//         // Verify: Verify Purchase Invoice created.
//         // PurchaseHeader.GET(PurchaseHeader."Document Type", PurchaseHeader."No.");
//         // PurchaseLine.GET(PurchaseLine."Document Type", PurchaseLine."Document No.", PurchaseLine."Line No.");
//     end;

//     [Test]
//     procedure CreateGAccountOnPurchaseHeader()
//     var
//         GAccountGPZS: Record "G-Account GPZS";
//         // GAccountPercentageGPZS: Decimal;
//         // GAccountAmountGPZS: Decimal;
//         PurchaseHeader: Record "Purchase Header";
//         PurchaseLine: Record "Purchase Line";
//     // VendorHelperGPZS: Codeunit "Vendor Helper GPZS";
//     begin
//         PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
//         PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
//         if PurchaseLine.IsEmpty() then
//             Error(ErrorInfo.Create('Purchase Line does not exist.'));



//         //Copy From Vendor
//         VendorHelperGPZS.GetGAccount(GAccountGPZS, Vendor);
//         // Vendor.GetGAccountGPZS(GAccountGPZS);
//         //Copy to Inv.
//         PurchaseHeader.CreateNewGAccountEntryGPZS(GAccountGPZS);
//     end;

//     [Test]
//     procedure TestSalesInvoice()
//     var
//         // VendorBankAccount: Record "Vendor Bank Account";
//         SalesHeader: Record "Sales Header";
//         SalesLine: Record "Sales Line";

//     begin
//         // Exercise: Create Purchase Invoice.
//         CreateSalesInvoice(SalesHeader, SalesLine, Customer."No.");

//         SalesHeader.CalcFields("Amount Including VAT");
//         // SalesHeader.Validate("Doc. Amount Incl. VAT", PurchaseHeader."Amount Including VAT");

//         //Add Bank Account
//         // VendorBankAccount.SetRange("Vendor No.", Vendor."No.");
//         // VendorBankAccount.FindFirst();

//         // PurchaseHeader.Validate("Bank Account Code", VendorBankAccount.Code);
//         // PurchaseHeader.modify(true);

//         // Verify: Verify Purchase Invoice created.
//         // PurchaseHeader.GET(PurchaseHeader."Document Type", PurchaseHeader."No.");
//         // PurchaseLine.GET(PurchaseLine."Document Type", PurchaseLine."Document No.", PurchaseLine."Line No.");
//     end;

//     [Test]
//     procedure CreateGAccountOnSalesHeader()
//     var
//         GAccountGPZS: Record "G-Account GPZS";
//         // GAccountHelper: Codeunit "G-Account Helper GPZS";
//         // GAccountAmountGPZS: Decimal;
//         // GAccountPercentageGPZS: Decimal;
//         PurchaseHeader: Record "Purchase Header";
//         PurchaseLine: Record "Purchase Line";
//         SalesHeader: Record "Sales Header";
//     // CustomerHelperGPZS: Codeunit "Customer Helper GPZS";

//     begin
//         PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
//         PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
//         if PurchaseLine.IsEmpty() then
//             Error(ErrorInfo.Create('Sales does not exist.'));

//         //Copy From Customer
//         // Customer.GetGAccountGPZS(GAccountGPZS);
//         CustomerHelperGPZS.GetGAccount(GAccountGPZS, Customer);
//         //Copy to Inv.
//         SalesHeader.CreateNewGAccountEntryGPZS(GAccountGPZS);
//     end;

//     procedure CreateGLAccount(AccountNo: Code[20]; AccountName: Text[100])
//     var
//         GLAccount: Record "G/L Account";
//     begin
//         GLAccount.Init();
//         GLAccount.Validate("No.", AccountNo);
//         GLAccount.Validate(Name, AccountName);
//         GLAccount."Account Type" := GLAccount."Account Type"::Posting;
//         GLAccount."Income/Balance" := GLAccount."Income/Balance"::"Balance Sheet";
//         GLAccount."Direct Posting" := false;
//         if not GLAccount.Insert(true) then
//             GLAccount.Modify(true);
//     end;

//     local procedure SetupPostingGroups()
//     var
//         CustomerPostingGroup: Record "Customer Posting Group";
//         VendorPostingGroup: Record "Vendor Posting Group";
//     begin
//         if CustomerPostingGroup.FindSet() then
//             repeat
//                 CustomerPostingGroup.Validate("G-Account (Interim) GPZS", '2102');
//                 CustomerPostingGroup.Modify(true);
//             until CustomerPostingGroup.Next() = 0;

//         if VendorPostingGroup.FindSet() then
//             repeat
//                 VendorPostingGroup.Validate("G-Account (Interim) GPZS", '2101');
//                 VendorPostingGroup.Modify(true);
//             until VendorPostingGroup.Next() = 0;
//     end;

//     local procedure CreatePurchaseInvoice(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; VendorNo: Code[20])
//     var
//         Counter: Integer;
//     begin
//         LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::Invoice, VendorNo);

//         // Create Multiple purchase line and using RANDOM for Quantity.
//         for Counter := 1 to 1 + LibraryRandom.RandInt(5) do
//             LibraryPurchase.CreatePurchaseLine(
//               PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, CreateItemNo(), LibraryRandom.RandInt(10));
//     end;

//     local procedure CreateSalesInvoice(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CustomerNo: Code[20])
//     var
//         Counter: Integer;
//     begin
//         LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Invoice, CustomerNo);

//         // Create Multiple purchase line and using RANDOM for Quantity.
//         for Counter := 1 to 1 + LibraryRandom.RandInt(5) do
//             LibrarySales.CreateSalesLine(
//               SalesLine, SalesHeader, SalesLine.Type::Item, CreateItemNo(), LibraryRandom.RandInt(10));
//     end;

//     local procedure CreateItemNo(): Code[20]
//     var
//         Item: Record Item;
//     begin
//         LibraryInventory.CreateItem(Item);
//         Item.Validate("Unit Price", LibraryRandom.RandInt(50));  // Using RANDOM value for Unit Price.
//         Item.Validate("Last Direct Cost", Item."Unit Price");
//         Item.Modify(true);
//         exit(Item."No.");
//     end;


// }