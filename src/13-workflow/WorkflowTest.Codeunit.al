// codeunit 83907 "Workflow Test TPTE"
// {
//     Permissions =
//         tabledata "Workflow Event" = RD;
//     Subtype = Test;
//     TestPermissions = Disabled;

//     [Test]
//     procedure DeleteWorkflowEvents()
//     begin
//         DeleteWorkFlowEvent(RunWorkflowOnVendorLedgerEntryForApprovalEPTE());
//         DeleteWorkFlowEvent(RunWorkflowOnPostedPurchaseInvoiceForApprovalEPTE());
//         DeleteWorkFlowEvent(RunWorkflowOnPostedPurchaseCreditMemoForApprovalEPTE());
//         DeleteWorkFlowEvent(RunWorkflowOnCancelPostedPurchaseInvoiceApprovalRequestEPTE());
//         DeleteWorkFlowEvent(RunWorkflowOnCancelPostedPurchaseCreditMemoApprovalRequestEPTE());
//     end;

//     local procedure DeleteWorkFlowEvent(FunctionName: Code[128])
//     var
//         WorkflowEvent: Record "Workflow Event";
//     begin
//         WorkflowEvent.SetRange("Function Name", FunctionName);
//         WorkflowEvent.DeleteAll(true);
//     end;

//     local procedure RunWorkflowOnVendorLedgerEntryForApprovalEPTE(): Code[128]
//     begin
//         exit(UpperCase('RunWorkflowOnVendorLedgerEntryForApprovalEPTE'));
//     end;

//     procedure RunWorkflowOnPostedPurchaseInvoiceForApprovalEPTE(): Code[128]
//     begin
//         exit(UpperCase('RunWorkflowOnPostedPurchaseInvoiceForApprovalEPTE'));
//     end;

//     procedure RunWorkflowOnPostedPurchaseCreditMemoForApprovalEPTE(): Code[128]
//     begin
//         exit(UpperCase('RunWorkflowOnPostedPurchaseCreditMemoForApprovalEPTE'));
//     end;

//     procedure RunWorkflowOnCancelPostedPurchaseInvoiceApprovalRequestEPTE(): Code[128]
//     begin
//         exit(UpperCase('RunWorkflowOnCancelPostedPurchaseInvoiceApprovalRequestEPTE'));
//     end;

//     procedure RunWorkflowOnCancelPostedPurchaseCreditMemoApprovalRequestEPTE(): Code[128]
//     begin
//         exit(UpperCase('RunWorkflowOnCancelPostedPurchaseCreditMemoApprovalRequestEPTE'));
//     end;
// }
