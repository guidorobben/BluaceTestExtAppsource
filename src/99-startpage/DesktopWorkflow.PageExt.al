// pageextension 83962 "Desktop Workflow TPTE" extends "Start Page Test LIB"
// {
//     actions
//     {
//         addfirst(Processing)
//         {
//             group(WorkFlowsGroupTPTE)
//             {
//                 Caption = 'Workflow';

//                 group(WorkFlowsTestsGroupTPTE)
//                 {
//                     Caption = 'Tests';
//                     Image = TestDatabase;

//                     action(WorkflowTestTPTE)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Workflow Test';
//                         RunObject = codeunit "Workflow Test TPTE";
//                     }
//                 }
//                 action(WorkflowsTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Workflows';
//                     RunObject = page Workflows;
//                 }
//                 action(WorkflowListTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Workflow List';
//                     RunObject = page "Workflow List TPTE";
//                 }
//                 action(WorkflowEventsTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Workflow Events';
//                     // RunObject = page "Workflow Events";
//                     RunObject = page "Workflow Events TPTE";
//                 }
//                 action(WorkflowTableRelationsTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Workflow Table Relations';
//                     RunObject = page "Workflow - Table Relations";
//                 }
//                 action(WFEventResponseCombiTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Workflow Event/Response Combinations Matrix';
//                     RunObject = page "WF Event/Response Combinations";
//                 }
//                 action(WFEventResponseCombiListTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Workflow Event/Response Combinations List';
//                     RunObject = page "WF Event/Response Combi. TPTE";
//                 }
//                 action(WorkflowDefinitionsTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Workflow Definitions';
//                     RunObject = query "Workflow Definition";
//                 }
//                 action(WorkflowStepInstancesTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Workflow Step Instances';
//                     RunObject = page "Workflow Step Instances";
//                 }
//                 action(WorkflowWebhookEntriesTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Workflow Webhook Entries';
//                     RunObject = page "Workflow Webhook Entries";
//                 }
//                 action(ApprovalEntriesTPTE)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Approval Entries';
//                     RunObject = page "Approval Entries";
//                 }
//             }
//         }

//         addfirst(Promoted)
//         {
//             group(WorkFlowGroupTPTE_PromotedTPTE)
//             {
//                 Caption = 'Workflow';
//                 Image = Workflow;

//                 group(WorkFlowGroupTestsTPTE_PromotedTPTE)
//                 {
//                     Caption = 'Tests';
//                     Image = TestDatabase;

//                     actionref(WorkflowTestTPTE_Promoted; WorkflowTestTPTE) { }
//                 }

//                 actionref(WorkflowsTPTE_Promoted; WorkflowsTPTE) { }
//                 actionref(WorkflowListTPTE_Promoted; WorkflowListTPTE) { }
//                 actionref(ApprovalEntriesTPTE_Promoted; ApprovalEntriesTPTE) { }
//                 actionref(WorkflowEventsTPTE_Promoted; WorkflowEventsTPTE) { }
//                 actionref(WorkflowTableRelationsTPTE_Promoted; WorkflowTableRelationsTPTE) { }
//                 actionref(WFEventResponseCombiTPTE_Promoted; WFEventResponseCombiTPTE) { }
//                 actionref(WFEventResponseCombiListTPTE_Promoted; WFEventResponseCombiListTPTE) { }
//                 actionref(WorkflowDefinitionsRefEPTE_Promted; WorkflowDefinitionsTPTE) { }
//                 actionref(WorkflowStepInstancesTPTE_Promoted; WorkflowStepInstancesTPTE) { }
//                 actionref(WorkflowWebhookEntriesTPE_Promoted; WorkflowWebhookEntriesTPTE) { }
//             }
//         }
//     }
// }
