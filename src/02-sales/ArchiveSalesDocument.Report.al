// report 83901 "Archive Sales Documents PTE"
// {
//     Caption = 'Archive Sales Documents';
//     ProcessingOnly = true;
//     UsageCategory = None;

//     dataset
//     {
//         dataitem(SalesHeader; "Sales Header")
//         {
//             RequestFilterFields = "No.";
//             DataItemTableView = where("Document Type" = filter(Quote | Order));

//             trigger OnPreDataItem()
//             begin
//                 if SalesDocumentType = SalesDocumentType::Quote then
//                     SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);

//                 if SalesDocumentType = SalesDocumentType::Order then
//                     SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
//             end;

//             trigger OnAfterGetRecord()
//             begin
//                 ArchiveSalesDocument(SalesHeader, DeleteSalesDocumentsAfterArchive);
//             end;
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(content)
//             {
//                 group(Options)
//                 {
//                     Caption = 'Options';

//                     field(DocumentType; SalesDocumentType)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Document Type';
//                     }
//                 }
//             }
//         }
//         actions
//         {
//             area(processing)
//             {
//             }
//         }
//     }
//     var
//         SalesArchiveCount: Integer;
//         DeleteSalesDocumentsAfterArchive: Boolean;
//         SalesDocumentType: Option Quote,Order;

//     trigger OnInitReport()
//     begin
//         SalesArchiveCount := 0;
//         DeleteSalesDocumentsAfterArchive := true;
//     end;

//     trigger OnPreReport()
//     var
//         ConfirmManagement: Codeunit "Confirm Management";
//         ArchiveSelectionQst: Label 'Do you want to archive the selected sales documents?';
//     begin
//         if not ConfirmManagement.GetResponseOrDefault(ArchiveSelectionQst, true) then
//             Error('');
//     end;

//     trigger OnPostReport()
//     var
//         SelectionArchivedMsg: Label '%1 Sales documents have been archived.', Comment = '%1=Document count';
//     begin
//         Message(SelectionArchivedMsg, SalesArchiveCount);
//     end;

//     local procedure ArchiveSalesDocument(SalesHeader: Record "Sales Header"; DeleteAfterArchive: Boolean)
//     var
//         ArchiveManagement: codeunit ArchiveManagement;
//     begin
//         ArchiveManagement.StoreSalesDocument(SalesHeader, false);
//         SalesArchiveCount += 1;

//         if DeleteAfterArchive then
//             SalesHeader.Delete(true);
//     end;
// }
