// codeunit 83925 "Item Ext. Doc Text Test TPTE"
// {

//     Subtype = Test;
//     TestPermissions = Disabled;

//     var
//         Assert: Codeunit Assert;
//         LibraryExtDocumentsLIB: Codeunit "Library - Ext. Documents LIB";
//         LibraryItemLIB: Codeunit "Library - Item LIB";
//         LibraryJobLIB: Codeunit "Library - Job LIB";
//         LibraryPurchaseLIB: Codeunit "Library - Purchase LIB";
//         LibrarySalesLIB: Codeunit "Library - Sales LIB";

//     [Test]
//     procedure CreateItemWithDetailedDescription()
//     var
//         DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         Item: Record Item;
//         DetailedDescriptionCount: Integer;
//     begin
//         // [SCENARIO] 17138

//         // [GIVEN] Item
//         LibraryItemLIB.CreateItem(Item, '');
//         Item.Validate(Description, 'Item with detailed description [17138]');
//         Item.Modify(true);

//         // [WHEN] Detailed description
//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'NLD', 'Description 1');
//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 2');
//         DetailedDescriptionCount := LibraryExtDocumentsLIB.DetailedDescriptionCount(Database::Item, Item.SystemId);

//         // [THEN]
//         Assert.AreEqual(2, DetailedDescriptionCount, 'The should be 2 detailed descriptions for this item.');
//     end;

//     [Test]
//     procedure CreateItemWithDetailedDescriptionWithContentText()
//     var
//         DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         Item: Record Item;
//         DetailedDescriptionCount: Integer;
//         ContentText: Text;
//     begin
//         // [SCENARIO] 17138

//         // [GIVEN] Item
//         LibraryItemLIB.CreateItem(Item, '');
//         Item.Validate(Description, 'Item with content Text [17138]');
//         Item.Modify(true);

//         // [WHEN] Detailed description
//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'NLD', 'Description 1');
//         // LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 2');
//         DetailedDescriptionCount := LibraryExtDocumentsLIB.DetailedDescriptionCount(Database::Item, Item.SystemId);
//         ContentText := '<p>re<strong>Pieter</strong></p>';
//         LibraryExtDocumentsLIB.SetContent(DetailedDescriptionDBLC, ContentText);

//         // [THEN]
//         Assert.AreEqual(1, DetailedDescriptionCount, 'There should be 1 detailed descriptions for this item.');
//         DetailedDescriptionDBLC.CalcFields("Detailed Description");
//         Assert.IsTrue(DetailedDescriptionDBLC."Detailed Description".HasValue, 'Detail description should have a value');
//         Assert.AreEqual(ContentText, LibraryExtDocumentsLIB.GetContent(DetailedDescriptionDBLC), 'Full content does not match!');
//     end;

//     #Region Sales
//     [Test]
//     procedure CreateSalesOrderLineWithItemWithDetailedDescriptionWithContentText()
//     var
//         DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         SalesDetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         Item: Record Item;
//         SalesHeader: Record "Sales Header";
//         SalesLine: Record "Sales Line";
//         DetailedDescriptionCount: array[5] of Integer;
//         Index: Integer;
//         ContentText: array[5] of Text;
//     begin
//         // [SCENARIO] 17138

//         // [GIVEN] Item
//         LibraryItemLIB.CreateItem(Item, '');
//         Item.Validate(Description, 'Item for sales line with content Text [17138]');
//         Item.Modify(true);

//         // [WHEN] 2x Detailed description
//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 1');
//         // LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 2');
//         ContentText[1] := '<p>re<strong>Pieter</strong></p>';
//         LibraryExtDocumentsLIB.SetContent(DetailedDescriptionDBLC, ContentText[1]);

//         Clear(DetailedDescriptionDBLC);
//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'NLD', 'Description 2');
//         // LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 2');
//         DetailedDescriptionCount[1] := LibraryExtDocumentsLIB.DetailedDescriptionCount(Database::Item, Item.SystemId); //2
//         ContentText[2] := '<p>re<strong>Guido</strong></p>';
//         LibraryExtDocumentsLIB.SetContent(DetailedDescriptionDBLC, ContentText[2]);

//         // [THEN]
//         Assert.AreEqual(2, DetailedDescriptionCount[1], 'There should be 2 detailed descriptions for this item.');
//         DetailedDescriptionDBLC.Reset();
//         DetailedDescriptionDBLC.SetRange("Link-to Table ID", Database::Item);
//         DetailedDescriptionDBLC.SetRange("Link-to Sytem ID", Item.SystemId);
//         if DetailedDescriptionDBLC.FindSet() then
//             repeat
//                 Index += 1;
//                 DetailedDescriptionDBLC.CalcFields("Detailed Description");
//                 Assert.IsTrue(DetailedDescriptionDBLC."Detailed Description".HasValue, 'Detail description should have a value');
//                 Assert.AreEqual(ContentText[Index], LibraryExtDocumentsLIB.GetContent(DetailedDescriptionDBLC), 'Full content does not match!');
//             // SalesDetailedDescriptionDBLC.Get(Database::"Sales Line", SalesLine.SystemId, DetailedDescriptionDBLC."Language Code");
//             // Assert.IsTrue(LibraryExtDocumentsLIB.HasTheSameContent(DetailedDescriptionDBLC, SalesDetailedDescriptionDBLC), 'Content of sale line does not match');
//             until DetailedDescriptionDBLC.Next() = 0;

//         // [WHEN] Create Sales Header & Line
//         LibrarySalesLIB.CreateSalesOrderForCustomerNo(SalesHeader, '40000');
//         LibrarySalesLIB.CreatesalesLine(SalesLine, SalesHeader, Item."No.");

//         // [THEN]
//         DetailedDescriptionCount[2] := LibraryExtDocumentsLIB.DetailedDescriptionCount(Database::"Sales Line", SalesLine.SystemId);
//         Assert.AreEqual(DetailedDescriptionCount[1], DetailedDescriptionCount[2], 'There should be 2 detailed descriptions for this item.');

//         DetailedDescriptionDBLC.Reset();
//         DetailedDescriptionDBLC.SetRange("Link-to Table ID", Database::Item);
//         DetailedDescriptionDBLC.SetRange("Link-to Sytem ID", Item.SystemId);
//         if DetailedDescriptionDBLC.FindSet() then
//             repeat
//                 Assert.IsTrue(LibraryExtDocumentsLIB.HasLanguageCode(Database::"Sales Line", SalesLine.SystemId, DetailedDescriptionDBLC."Language Code"), 'Sales Line does not have language code');
//                 SalesDetailedDescriptionDBLC.Get(Database::"Sales Line", SalesLine.SystemId, DetailedDescriptionDBLC."Language Code");
//                 Assert.IsTrue(LibraryExtDocumentsLIB.HasTheSameContent(DetailedDescriptionDBLC, SalesDetailedDescriptionDBLC), 'Content of sale line does not match');
//             until DetailedDescriptionDBLC.Next() = 0;
//     end;

//     [Test]
//     procedure CreateSalesQuoteLineWithItemWithDetailedDescriptionWithContentText()
//     var
//         DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         SalesDetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         Item: Record Item;
//         SalesHeader: Record "Sales Header";
//         SalesLine: Record "Sales Line";
//         DetailedDescriptionCount: array[5] of Integer;
//         Index: Integer;
//         ContentText: array[5] of Text;
//     begin
//         // [SCENARIO] 17138

//         // [GIVEN] Item
//         LibraryItemLIB.CreateItem(Item, '');
//         Item.Validate(Description, 'Item for sales line with content Text [17138]');
//         Item.Modify(true);

//         // [WHEN] 2x Detailed description
//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 1');
//         // LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 2');
//         ContentText[1] := '<p>re<strong>Pieter</strong></p>';
//         LibraryExtDocumentsLIB.SetContent(DetailedDescriptionDBLC, ContentText[1]);

//         Clear(DetailedDescriptionDBLC);
//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'NLD', 'Description 2');
//         // LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 2');
//         DetailedDescriptionCount[1] := LibraryExtDocumentsLIB.DetailedDescriptionCount(Database::Item, Item.SystemId); //2
//         ContentText[2] := '<p>re<strong>Guido</strong></p>';
//         LibraryExtDocumentsLIB.SetContent(DetailedDescriptionDBLC, ContentText[2]);

//         // [THEN]
//         Assert.AreEqual(2, DetailedDescriptionCount[1], 'There should be 2 detailed descriptions for this item.');
//         DetailedDescriptionDBLC.Reset();
//         DetailedDescriptionDBLC.SetRange("Link-to Table ID", Database::Item);
//         DetailedDescriptionDBLC.SetRange("Link-to Sytem ID", Item.SystemId);
//         if DetailedDescriptionDBLC.FindSet() then
//             repeat
//                 Index += 1;
//                 DetailedDescriptionDBLC.CalcFields("Detailed Description");
//                 Assert.IsTrue(DetailedDescriptionDBLC."Detailed Description".HasValue, 'Detail description should have a value');
//                 Assert.AreEqual(ContentText[Index], LibraryExtDocumentsLIB.GetContent(DetailedDescriptionDBLC), 'Full content does not match!');
//             // SalesDetailedDescriptionDBLC.Get(Database::"Sales Line", SalesLine.SystemId, DetailedDescriptionDBLC."Language Code");
//             // Assert.IsTrue(LibraryExtDocumentsLIB.HasTheSameContent(DetailedDescriptionDBLC, SalesDetailedDescriptionDBLC), 'Content of sale line does not match');
//             until DetailedDescriptionDBLC.Next() = 0;

//         // [WHEN] Create Sales Header & Line
//         LibrarySalesLIB.CreateSalesQuoteForCustomerNo(SalesHeader, '40000');
//         LibrarySalesLIB.CreatesalesLine(SalesLine, SalesHeader, Item."No.");

//         // [THEN]
//         DetailedDescriptionCount[2] := LibraryExtDocumentsLIB.DetailedDescriptionCount(Database::"Sales Line", SalesLine.SystemId);
//         Assert.AreEqual(DetailedDescriptionCount[1], DetailedDescriptionCount[2], 'There should be 2 detailed descriptions for this item.');

//         DetailedDescriptionDBLC.Reset();
//         DetailedDescriptionDBLC.SetRange("Link-to Table ID", Database::Item);
//         DetailedDescriptionDBLC.SetRange("Link-to Sytem ID", Item.SystemId);
//         if DetailedDescriptionDBLC.FindSet() then
//             repeat
//                 Assert.IsTrue(LibraryExtDocumentsLIB.HasLanguageCode(Database::"Sales Line", SalesLine.SystemId, DetailedDescriptionDBLC."Language Code"), 'Sales Line does not have language code');
//                 SalesDetailedDescriptionDBLC.Get(Database::"Sales Line", SalesLine.SystemId, DetailedDescriptionDBLC."Language Code");
//                 Assert.IsTrue(LibraryExtDocumentsLIB.HasTheSameContent(DetailedDescriptionDBLC, SalesDetailedDescriptionDBLC), 'Content of sale line does not match');
//             until DetailedDescriptionDBLC.Next() = 0;
//     end;

//     #endregion Sales

//     #region Purchase
//     [Test]
//     procedure CreatePurchaseOrderLineWithItemWithDetailedDescriptionWithContentText()
//     var
//         DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         SalesDetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         Item: Record Item;
//         PurchaseHeader: Record "Purchase Header";
//         PurchaseLine: Record "Purchase Line";
//         DetailedDescriptionCount: array[5] of Integer;
//         Index: Integer;
//         ContentText: array[5] of Text;
//     begin
//         // [SCENARIO] 17138

//         // [GIVEN] Item
//         LibraryItemLIB.CreateItem(Item, '');
//         Item.Validate(Description, 'Item for purchase line with content Text [17138]');
//         Item.Modify(true);

//         // [WHEN] 2x Detailed description
//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 1');
//         // LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 2');
//         ContentText[1] := '<p>re<strong>Pieter</strong></p>';
//         LibraryExtDocumentsLIB.SetContent(DetailedDescriptionDBLC, ContentText[1]);

//         Clear(DetailedDescriptionDBLC);
//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'NLD', 'Description 2');
//         // LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 2');
//         DetailedDescriptionCount[1] := LibraryExtDocumentsLIB.DetailedDescriptionCount(Database::Item, Item.SystemId); //2
//         ContentText[2] := '<p>re<strong>Guido</strong></p>';
//         LibraryExtDocumentsLIB.SetContent(DetailedDescriptionDBLC, ContentText[2]);

//         // [THEN]
//         Assert.AreEqual(2, DetailedDescriptionCount[1], 'There should be 2 detailed descriptions for this item.');
//         DetailedDescriptionDBLC.Reset();
//         DetailedDescriptionDBLC.SetRange("Link-to Table ID", Database::Item);
//         DetailedDescriptionDBLC.SetRange("Link-to Sytem ID", Item.SystemId);
//         if DetailedDescriptionDBLC.FindSet() then
//             repeat
//                 Index += 1;
//                 DetailedDescriptionDBLC.CalcFields("Detailed Description");
//                 Assert.IsTrue(DetailedDescriptionDBLC."Detailed Description".HasValue, 'Detail description should have a value');
//                 Assert.AreEqual(ContentText[Index], LibraryExtDocumentsLIB.GetContent(DetailedDescriptionDBLC), 'Full content does not match!');
//             until DetailedDescriptionDBLC.Next() = 0;

//         // [WHEN] Create Purchase Header & Line
//         LibraryPurchaseLIB.CreatePurchaseOrderForVendorNo(PurchaseHeader, '20000');
//         LibraryPurchaseLIB.CreatePurchaseLine(PurchaseLine, PurchaseHeader, Item."No.");

//         // [THEN]
//         DetailedDescriptionCount[2] := LibraryExtDocumentsLIB.DetailedDescriptionCount(PurchaseLine.RecordId.TableNo, PurchaseLine.SystemId);
//         Assert.AreEqual(DetailedDescriptionCount[1], DetailedDescriptionCount[2], 'There should be 2 detailed descriptions for this item.');

//         DetailedDescriptionDBLC.Reset();
//         DetailedDescriptionDBLC.SetRange("Link-to Table ID", Database::Item);
//         DetailedDescriptionDBLC.SetRange("Link-to Sytem ID", Item.SystemId);
//         if DetailedDescriptionDBLC.FindSet() then
//             repeat
//                 Assert.IsTrue(LibraryExtDocumentsLIB.HasLanguageCode(PurchaseLine.RecordId.TableNo, PurchaseLine.SystemId, DetailedDescriptionDBLC."Language Code"), 'Purchase Line does not have language code.');
//                 SalesDetailedDescriptionDBLC.Get(PurchaseLine.RecordId.TableNo, PurchaseLine.SystemId, DetailedDescriptionDBLC."Language Code");
//                 Assert.IsTrue(LibraryExtDocumentsLIB.HasTheSameContent(DetailedDescriptionDBLC, SalesDetailedDescriptionDBLC), 'Content of purchase line does not match.');
//             until DetailedDescriptionDBLC.Next() = 0;
//     end;

//     [Test]
//     procedure CreatePurchaseQuoteLineWithItemWithDetailedDescriptionWithContentText()
//     var
//         DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         SalesDetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         Item: Record Item;
//         PurchaseHeader: Record "Purchase Header";
//         PurchaseLine: Record "Purchase Line";
//         DetailedDescriptionCount: array[5] of Integer;
//         Index: Integer;
//         ContentText: array[5] of Text;
//     begin
//         // [SCENARIO] 17138

//         // [GIVEN] Item
//         LibraryItemLIB.CreateItem(Item, '');
//         Item.Validate(Description, 'Item for purchase quote line with content Text [17138]');
//         Item.Modify(true);

//         // [WHEN] 3x Detailed description
//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, '', 'Description 1');
//         ContentText[1] := '<p>re<strong>Koen</strong></p>';
//         LibraryExtDocumentsLIB.SetContent(DetailedDescriptionDBLC, ContentText[1]);

//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 2');
//         ContentText[2] := '<p>re<strong>Pieter</strong></p>';
//         LibraryExtDocumentsLIB.SetContent(DetailedDescriptionDBLC, ContentText[2]);

//         Clear(DetailedDescriptionDBLC);
//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'NLD', 'Description 3');
//         ContentText[3] := '<p>re<strong>Guido</strong></p>';
//         LibraryExtDocumentsLIB.SetContent(DetailedDescriptionDBLC, ContentText[3]);
//         DetailedDescriptionCount[1] := LibraryExtDocumentsLIB.DetailedDescriptionCount(Database::Item, Item.SystemId); //3

//         // [THEN] 3 description lines
//         Assert.AreEqual(3, DetailedDescriptionCount[1], 'There should be 3 detailed descriptions for this item.');

//         // [THEN] Content must match ContentText
//         DetailedDescriptionDBLC.Reset();
//         DetailedDescriptionDBLC.SetRange("Link-to Table ID", Database::Item);
//         DetailedDescriptionDBLC.SetRange("Link-to Sytem ID", Item.SystemId);
//         if DetailedDescriptionDBLC.FindSet() then
//             repeat
//                 Index += 1;
//                 DetailedDescriptionDBLC.CalcFields("Detailed Description");
//                 Assert.IsTrue(DetailedDescriptionDBLC."Detailed Description".HasValue, 'Detail description should have a value');
//                 Assert.AreEqual(ContentText[Index], LibraryExtDocumentsLIB.GetContent(DetailedDescriptionDBLC), 'Full content does not match!');
//             until DetailedDescriptionDBLC.Next() = 0;

//         // [WHEN] Create Purchase Header & Line
//         LibraryPurchaseLIB.CreatePurchaseQuoteForVendorNo(PurchaseHeader, '20000');
//         LibraryPurchaseLIB.CreatePurchaseLine(PurchaseLine, PurchaseHeader, Item."No.");

//         // [THEN] Purchase Line Content must match content Item
//         DetailedDescriptionCount[2] := LibraryExtDocumentsLIB.DetailedDescriptionCount(PurchaseLine.RecordId.TableNo, PurchaseLine.SystemId);
//         Assert.AreEqual(DetailedDescriptionCount[1], DetailedDescriptionCount[2], 'There should be 3 detailed descriptions for this item.');

//         DetailedDescriptionDBLC.Reset();
//         DetailedDescriptionDBLC.SetRange("Link-to Table ID", Database::Item);
//         DetailedDescriptionDBLC.SetRange("Link-to Sytem ID", Item.SystemId);
//         if DetailedDescriptionDBLC.FindSet() then
//             repeat
//                 Assert.IsTrue(LibraryExtDocumentsLIB.HasLanguageCode(PurchaseLine.RecordId.TableNo, PurchaseLine.SystemId, DetailedDescriptionDBLC."Language Code"), 'Purchase Line does not have language code.');
//                 SalesDetailedDescriptionDBLC.Get(PurchaseLine.RecordId.TableNo, PurchaseLine.SystemId, DetailedDescriptionDBLC."Language Code");
//                 Assert.IsTrue(LibraryExtDocumentsLIB.HasTheSameContent(DetailedDescriptionDBLC, SalesDetailedDescriptionDBLC), 'Content of purchase line does not match.');
//             until DetailedDescriptionDBLC.Next() = 0;
//     end;

//     #endregion Purchase

//     #region Job
//     [Test]
//     procedure CreateJobPlanningLineWithItemWithDetailedDescriptionWithContentText()
//     var
//         DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         SalesDetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         Item: Record Item;
//         // PurchaseHeader: Record "Purchase Header";
//         Job: Record Job;
//         JobPlanningLine: Record "Job Planning Line";
//         JobTask: Record "Job Task";
//         JobPlanningLineLineType: Enum "Job Planning Line Line Type";
//         JobPlanningLineType: Enum "Job Planning Line Type";
//         DetailedDescriptionCount: array[5] of Integer;
//         Index: Integer;
//         ContentText: array[5] of Text;
//     begin
//         // [SCENARIO] 17138

//         // [GIVEN] Item
//         LibraryItemLIB.CreateItem(Item, '');
//         Item.Validate(Description, 'Item for purchase line with content Text [17138]');
//         Item.Modify(true);

//         // [WHEN] 2x Detailed description
//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 1');
//         // LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 2');
//         ContentText[1] := '<p>re<strong>Pieter</strong></p>';
//         LibraryExtDocumentsLIB.SetContent(DetailedDescriptionDBLC, ContentText[1]);

//         Clear(DetailedDescriptionDBLC);
//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'NLD', 'Description 2');
//         // LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 2');
//         DetailedDescriptionCount[1] := LibraryExtDocumentsLIB.DetailedDescriptionCount(Database::Item, Item.SystemId); //2
//         ContentText[2] := '<p>re<strong>Guido</strong></p>';
//         LibraryExtDocumentsLIB.SetContent(DetailedDescriptionDBLC, ContentText[2]);

//         // [THEN]
//         Assert.AreEqual(2, DetailedDescriptionCount[1], 'There should be 2 detailed descriptions for this item.');
//         DetailedDescriptionDBLC.Reset();
//         DetailedDescriptionDBLC.SetRange("Link-to Table ID", Database::Item);
//         DetailedDescriptionDBLC.SetRange("Link-to Sytem ID", Item.SystemId);
//         if DetailedDescriptionDBLC.FindSet() then
//             repeat
//                 Index += 1;
//                 DetailedDescriptionDBLC.CalcFields("Detailed Description");
//                 Assert.IsTrue(DetailedDescriptionDBLC."Detailed Description".HasValue, 'Detail description should have a value');
//                 Assert.AreEqual(ContentText[Index], LibraryExtDocumentsLIB.GetContent(DetailedDescriptionDBLC), 'Full content does not match!');
//             until DetailedDescriptionDBLC.Next() = 0;

//         // [WHEN] Create Job & Line
//         Job.Get('JOB00030');
//         JobTask.SetRange("Job No.", Job."No.");
//         JobTask.FindFirst();
//         LibraryJobLIB.CreateJobPlanningLine(JobPlanningLine, JobTask, JobPlanningLineLineType::Budget, JobPlanningLineType::Item, Item."No.", '', 1);

//         // LibraryPurchaseLIB.CreatePurchaseOrderForVendorNo(PurchaseHeader, '20000');
//         // LibraryPurchaseLIB.CreatePurchaseLine(PurchaseLine, PurchaseHeader, Item."No.");

//         // [THEN]
//         DetailedDescriptionCount[2] := LibraryExtDocumentsLIB.DetailedDescriptionCount(JobPlanningLine.RecordId.TableNo, JobPlanningLine.SystemId);
//         Assert.AreEqual(DetailedDescriptionCount[1], DetailedDescriptionCount[2], 'There should be 2 detailed descriptions for this item.');

//         DetailedDescriptionDBLC.Reset();
//         DetailedDescriptionDBLC.SetRange("Link-to Table ID", Database::Item);
//         DetailedDescriptionDBLC.SetRange("Link-to Sytem ID", Item.SystemId);
//         if DetailedDescriptionDBLC.FindSet() then
//             repeat
//                 Assert.IsTrue(LibraryExtDocumentsLIB.HasLanguageCode(JobPlanningLine.RecordId.TableNo, JobPlanningLine.SystemId, DetailedDescriptionDBLC."Language Code"), 'Purchase Line does not have language code.');
//                 SalesDetailedDescriptionDBLC.Get(JobPlanningLine.RecordId.TableNo, JobPlanningLine.SystemId, DetailedDescriptionDBLC."Language Code");
//                 Assert.IsTrue(LibraryExtDocumentsLIB.HasTheSameContent(DetailedDescriptionDBLC, SalesDetailedDescriptionDBLC), 'Content of job planning line does not match.');
//             until DetailedDescriptionDBLC.Next() = 0;
//     end;
//     #endregion Job

//     [Test]
//     procedure CreateItemWithDetailedDescriptionWithContentTextAndDelete()
//     var
//         DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         Item: Record Item;
//         SaveItem: Record Item;
//         DetailedDescriptionCount: Integer;
//         ContentText: Text;
//     begin
//         // [SCENARIO] 17138

//         // [GIVEN] Item
//         LibraryItemLIB.CreateItem(Item, '');
//         Item.Validate(Description, 'Item with content Text [17138]');
//         Item.Modify(true);

//         // [WHEN] Detailed description
//         LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'NLD', 'Description 1');
//         // LibraryExtDocumentsLIB.CreateDetailedDescription(DetailedDescriptionDBLC, Database::Item, Item.SystemId, 'ENU', 'Description 2');
//         DetailedDescriptionCount := LibraryExtDocumentsLIB.DetailedDescriptionCount(Database::Item, Item.SystemId);
//         ContentText := '<p>re<strong>Pieter</strong></p>';
//         LibraryExtDocumentsLIB.SetContent(DetailedDescriptionDBLC, ContentText);

//         // [THEN]
//         Assert.AreEqual(1, DetailedDescriptionCount, 'There should be 1 detailed descriptions for this item.');
//         DetailedDescriptionDBLC.CalcFields("Detailed Description");
//         Assert.IsTrue(DetailedDescriptionDBLC."Detailed Description".HasValue, 'Detail description should have a value');
//         Assert.AreEqual(ContentText, LibraryExtDocumentsLIB.GetContent(DetailedDescriptionDBLC), 'Full content does not match!');

//         // [WHEN]
//         SaveItem := Item;
//         Item.Delete(true);

//         // [THEN]
//         DetailedDescriptionCount := LibraryExtDocumentsLIB.DetailedDescriptionCount(Database::Item, SaveItem.SystemId);
//         Assert.AreEqual(0, DetailedDescriptionCount, 'There should not be any detailed descriptions for this item.');
//     end;

//     #region Ext. Document Text
//     [Test]
//     procedure CreateExtDocumentTextsWithContent()
//     var
//         ExtDocumentTextDBLC: Record "Ext. Document Text DBLC";
//         // PurchaseHeader: Record "Purchase Header";
//         Dates: array[2] of Date;
//         ExtDocDocumentType: Enum "Ext. Doc. Text Doc. Type DBLC";
//         ExtDocTextType: Enum "Ext. Doc. Text Type DBLC";
//         // JobPlanningLineLineType: Enum "Job Planning Line Line Type";
//         // JobPlanningLineType: Enum "Job Planning Line Type";
//         // DetailedDescriptionCount: array[5] of Integer;
//         // Index: Integer;
//         ExtDocDocumentTypeList: List of [Enum "Ext. Doc. Text Doc. Type DBLC"];
//         ContentText: array[10] of Text;
//     begin
//         // [SCENARIO] 17138
//         // [GIVEN] Delete Ext Doc Texts
//         ExtDocumentTextDBLC.Reset();
//         ExtDocumentTextDBLC.DeleteAll(true);

//         // [GIVEN] Create Ext Document Text
//         Dates[1] := CalcDate('<-CY>', Today());
//         Dates[2] := 0D;

//         ContentText[1] := '<p>Dit is een <strong> ENU Header</strong></p>';
//         ContentText[2] := '<p>Dit is een <strong> ENU Footer</strong></p>';
//         ContentText[3] := '<p>Dit is een <strong> NLD Header</strong></p>';
//         ContentText[4] := '<p>Dit is een <strong> NLD Footer</strong></p>';
//         ContentText[5] := '<p>Dit is een <strong> BLANCO Header</strong></p>';
//         ContentText[6] := '<p>Dit is een <strong> BLANCO Footer</strong></p>';

//         // [WHEN] Create Ext Doc Records
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Job Quote");
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Purchase Order");
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Purchase Quote");
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Sales Order");
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Sales Quote");

//         foreach ExtDocDocumentType in ExtDocDocumentTypeList do begin
//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Header, 'ENU', 'Header [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[1]);
//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Footer, 'ENU', 'Footer [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[2]);

//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Header, 'NLD', 'Header [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[3]);
//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Footer, 'NLD', 'Footer [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[4]);

//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Header, '', 'Header [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[5]);
//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Footer, '', 'Footer [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[6]);
//         end;

//         // [THEN]
//         ExtDocumentTextDBLC.Reset();
//         if ExtDocumentTextDBLC.FindSet() then
//             repeat
//                 ExtDocumentTextDBLC.CalcFields("Detailed Description");
//                 Assert.IsTrue(ExtDocumentTextDBLC."Detailed Description".HasValue(), 'Ext Doc Text should have a content');
//             until ExtDocumentTextDBLC.Next() = 0;
//     end;

//     [Test]
//     procedure CreateExtDocumentTextsWithContentLanguage()
//     var
//         CompanyInformation: Record "Company Information";
//         ExtDocumentTextDBLC: Record "Ext. Document Text DBLC";
//         // PurchaseHeader: Record "Purchase Header";
//         Job: Record Job;
//         // JobPlanningLine: Record "Job Planning Line";
//         // JobTask: Record "Job Task";
//         Dates: array[2] of Date;
//         ExtDocDocumentType: Enum "Ext. Doc. Text Doc. Type DBLC";
//         ExtDocTextType: Enum "Ext. Doc. Text Type DBLC";
//         // JobPlanningLineLineType: Enum "Job Planning Line Line Type";
//         // JobPlanningLineType: Enum "Job Planning Line Type";
//         // DetailedDescriptionCount: array[5] of Integer;
//         // Index: Integer;
//         ExtDocDocumentTypeList: List of [Enum "Ext. Doc. Text Doc. Type DBLC"];
//         ContentText: array[10] of Text;
//     begin
//         // [SCENARIO] 17138
//         // [GIVEN] Delete Ext Doc Texts
//         ExtDocumentTextDBLC.Reset();
//         ExtDocumentTextDBLC.DeleteAll(true);

//         // [GIVEN] Create Ext Document Text
//         Dates[1] := CalcDate('<-CY>', Today());
//         Dates[2] := 0D;

//         ContentText[1] := '<p>Dit is een <strong> ENU Header</strong></p>';
//         ContentText[2] := '<p>Dit is een <strong> ENU Footer</strong></p>';
//         ContentText[3] := '<p>Dit is een <strong> NLD Header</strong></p>';
//         ContentText[4] := '<p>Dit is een <strong> NLD Footer</strong></p>';
//         ContentText[5] := '<p>Dit is een <strong> BLANCO Header</strong></p>';
//         ContentText[6] := '<p>Dit is een <strong> BLANCO Footer</strong></p>';

//         // [WHEN] Create Ext Doc Records
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Job Quote");
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Purchase Order");
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Purchase Quote");
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Sales Order");
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Sales Quote");

//         foreach ExtDocDocumentType in ExtDocDocumentTypeList do begin
//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Header, 'ENU', 'Header [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[1]);
//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Footer, 'ENU', 'Footer [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[2]);

//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Header, 'NLD', 'Header [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[3]);
//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Footer, 'NLD', 'Footer [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[4]);

//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Header, '', 'Header [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[5]);
//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Footer, '', 'Footer [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[6]);
//         end;

//         // [THEN]
//         ExtDocumentTextDBLC.Reset();
//         if ExtDocumentTextDBLC.FindSet() then
//             repeat
//                 ExtDocumentTextDBLC.CalcFields("Detailed Description");
//                 Assert.IsTrue(ExtDocumentTextDBLC."Detailed Description".HasValue(), 'Ext Doc Text should have a content');
//             until ExtDocumentTextDBLC.Next() = 0;

//         // [GIVEN] Job ENU
//         Clear(Job);
//         LibraryJobLIB.CreateJob(Job);
//         Job."Language Code" := 'ENU';
//         Job.Modify();

//         // [THEN]
//         Assert.AreEqual(ContentText[1], Job.GetExtendedDocumentTextDBLC(Enum::"Ext. Doc. Text Type DBLC"::Header), 'ENU Header Content does not match');
//         Assert.AreEqual(ContentText[2], Job.GetExtendedDocumentTextDBLC(Enum::"Ext. Doc. Text Type DBLC"::Footer), 'ENU Header Content does not match');

//         // [GIVEN] Job NLD
//         // Clear(Job);
//         // LibraryJobLIB.CreateJob(Job);
//         Job."Language Code" := 'NLD';
//         Job.Modify();

//         // [THEN]
//         Assert.AreEqual(ContentText[3], Job.GetExtendedDocumentTextDBLC(Enum::"Ext. Doc. Text Type DBLC"::Header), 'NLD Header Content does not match');
//         Assert.AreEqual(ContentText[4], Job.GetExtendedDocumentTextDBLC(Enum::"Ext. Doc. Text Type DBLC"::Footer), 'NLD Header Content does not match');

//         // [GIVEN] Job Blanco
//         // Clear(Job);
//         // LibraryJobLIB.CreateJob(Job);
//         Job."Language Code" := '';
//         Job.Modify();

//         // [THEN] content should match blanco
//         Assert.AreEqual(ContentText[5], Job.GetExtendedDocumentTextDBLC(Enum::"Ext. Doc. Text Type DBLC"::Header), 'BLANCO Header Content does not match');
//         Assert.AreEqual(ContentText[6], Job.GetExtendedDocumentTextDBLC(Enum::"Ext. Doc. Text Type DBLC"::Footer), 'BLANCO Header Content does not match');

//         // [GIVEN] Job DEU
//         Job."Language Code" := 'DEU';
//         Job.Modify();

//         // [THEN] content should match blanco
//         Assert.AreEqual(ContentText[5], Job.GetExtendedDocumentTextDBLC(Enum::"Ext. Doc. Text Type DBLC"::Header), 'DEU Header Content does not match');
//         Assert.AreEqual(ContentText[6], Job.GetExtendedDocumentTextDBLC(Enum::"Ext. Doc. Text Type DBLC"::Footer), 'DEU Header Content does not match');

//         // [GIVEN] Job DEU with ALC ENU
//         Job."Language Code" := 'DEU';
//         Job.Modify();

//         CompanyInformation.Get();
//         CompanyInformation.Validate("Alternative Language Code", 'ENU');
//         CompanyInformation.Modify(true);

//         // [THEN] content should match blanco
//         Assert.AreEqual(ContentText[5], Job.GetExtendedDocumentTextDBLC(Enum::"Ext. Doc. Text Type DBLC"::Header), 'DEU ALC Header Content does not match');
//         Assert.AreEqual(ContentText[6], Job.GetExtendedDocumentTextDBLC(Enum::"Ext. Doc. Text Type DBLC"::Footer), 'DEU ALC Header Content does not match');

//         CompanyInformation.Validate("Alternative Language Code", '');
//         CompanyInformation.Modify(true);
//     end;

//     [Test]
//     procedure CreateExtDocumentTextsWithContentEmptyLanguage_()
//     var
//         CompanyInformation: Record "Company Information";
//         // DetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         // SalesDetailedDescriptionDBLC: Record "Detailed Description DBLC";
//         ExtDocumentTextDBLC: Record "Ext. Document Text DBLC";
//         // Item: Record Item;
//         // PurchaseHeader: Record "Purchase Header";
//         Job: Record Job;
//         // JobPlanningLine: Record "Job Planning Line";
//         // JobTask: Record "Job Task";
//         Dates: array[2] of Date;
//         ExtDocDocumentType: Enum "Ext. Doc. Text Doc. Type DBLC";
//         ExtDocTextType: Enum "Ext. Doc. Text Type DBLC";
//         // JobPlanningLineLineType: Enum "Job Planning Line Line Type";
//         // JobPlanningLineType: Enum "Job Planning Line Type";
//         // DetailedDescriptionCount: array[5] of Integer;
//         // Index: Integer;
//         ExtDocDocumentTypeList: List of [Enum "Ext. Doc. Text Doc. Type DBLC"];
//         ContentText: array[10] of Text;
//     begin
//         // [SCENARIO] 17138
//         // Test the result of the content when language code = ''

//         // [GIVEN] Delete Ext Doc Texts
//         ExtDocumentTextDBLC.Reset();
//         ExtDocumentTextDBLC.DeleteAll(true);

//         // [GIVEN] Create Ext Document Text
//         Dates[1] := CalcDate('<-CY>', Today());
//         Dates[2] := 0D;

//         ContentText[1] := '<p>Dit is een <strong> ENU Header</strong></p>';
//         ContentText[2] := '<p>Dit is een <strong> ENU Footer</strong></p>';
//         ContentText[3] := '<p>Dit is een <strong> NLD Header</strong></p>';
//         ContentText[4] := '<p>Dit is een <strong> NLD Footer</strong></p>';
//         // ContentText[5] := '<p>Dit is een <strong> BLANCO Header</strong></p>';
//         // ContentText[6] := '<p>Dit is een <strong> BLANCO Footer</strong></p>';

//         // [WHEN] Create Ext Doc Records
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Job Quote");
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Purchase Order");
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Purchase Quote");
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Sales Order");
//         ExtDocDocumentTypeList.Add(ExtDocDocumentType::"Sales Quote");

//         foreach ExtDocDocumentType in ExtDocDocumentTypeList do begin
//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Header, 'ENU', 'Header [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[1]);
//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Footer, 'ENU', 'Footer [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[2]);

//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Header, 'NLD', 'Header [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[3]);
//             LibraryExtDocumentsLIB.CreateExtDocumentText(ExtDocumentTextDBLC, ExtDocDocumentType, ExtDocTextType::Footer, 'NLD', 'Footer [17138]', Dates[1], Dates[2]);
//             LibraryExtDocumentsLIB.SetExtDocumentContent(ExtDocumentTextDBLC, ContentText[4]);
//         end;

//         // [THEN]
//         ExtDocumentTextDBLC.Reset();
//         if ExtDocumentTextDBLC.FindSet() then
//             repeat
//                 ExtDocumentTextDBLC.CalcFields("Detailed Description");
//                 Assert.IsTrue(ExtDocumentTextDBLC."Detailed Description".HasValue(), 'Ext Doc Text should have a content');
//             until ExtDocumentTextDBLC.Next() = 0;


//         // [GIVEN] Job '' with ALC NLD
//         Clear(Job);
//         LibraryJobLIB.CreateJob(Job);
//         Job.Validate(Description, 'Job with language '' with ALC NLD 17138');
//         Job."Language Code" := '';
//         Job.Modify();

//         CompanyInformation.Get();
//         CompanyInformation.Validate("Alternative Language Code", 'NLD');
//         CompanyInformation.Modify(true);

//         // [THEN] content should match NLD
//         Assert.AreEqual(ContentText[3], Job.GetExtendedDocumentTextDBLC(Enum::"Ext. Doc. Text Type DBLC"::Header), 'BLANCO ALC Header Content does not match');
//         Assert.AreEqual(ContentText[4], Job.GetExtendedDocumentTextDBLC(Enum::"Ext. Doc. Text Type DBLC"::Footer), 'BLANCO ALC Header Content does not match');

//         CompanyInformation.Validate("Alternative Language Code", '');
//         CompanyInformation.Modify(true);
//     end;

//     #endregion Ext. Document Text
// }
