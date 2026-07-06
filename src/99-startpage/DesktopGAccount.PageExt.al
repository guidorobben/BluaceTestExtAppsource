// pageextension 83966 "Desktop GAccount TPTE" extends "Start Page Test LIB"
// {
//     actions
//     {
//         addfirst(Processing)
//         {
//             group(GAccountTestGroupTPTE)
//             {
//                 Caption = 'G-Account';

//                 action(TestGAccountTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Test G-Account';

//                     trigger OnAction()
//                     begin
//                         Codeunit.Run(Codeunit::"UT G-Account TPTE");
//                     end;
//                 }
//                 action(ResetUpgradeTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Reset Upgrade';

//                     trigger OnAction()
//                     var
//                         GAccountTestHelper: Codeunit "UT GAccount Helper TPTE";
//                     begin
//                         GAccountTestHelper.ClearGAccountSourceAccountNo();
//                         GAccountTestHelper.ClearPostedGAccountPercetage();
//                         Message('Done');
//                     end;
//                 }
//                 action(OpenSalesInvoicesGPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Sales Invoices';

//                     trigger OnAction()
//                     begin
//                         Page.Run(9301);
//                     end;
//                 }
//                 action(OpenPurchaseInvoicesTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Purchase Invoices';

//                     trigger OnAction()
//                     begin
//                         Page.Run(9308);
//                     end;
//                 }
//                 action(ShowAllGAccountsTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Show All G-Accounts';
//                     RunObject = page "G-Accounts GPZS";
//                 }
//                 action(ShowAllPostedGAccountsTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Show All Posted G-Accounts';
//                     RunObject = page "Posted G-Accounts GPZS";
//                 }
//             }
//         }
//     }
// }
