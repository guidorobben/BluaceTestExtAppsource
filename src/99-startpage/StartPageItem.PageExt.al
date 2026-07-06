// pageextension 83962 "Start Page Item TPTE" extends "Start Page Test LIB"
// {
//     actions
//     {
//         addfirst(Processing)
//         {
//             // group(TestItemGroupTPTE)
//             // {
//             //     Caption = 'Item';

//             //     group(ItemTestsTPTE)
//             //     {
//             //         Caption = 'Tests';
//             //         Image = TestDatabase;

//             //         action(TestItemTPTE)
//             //         {
//             //             ApplicationArea = All;
//             //             Caption = 'Test Item';
//             //             RunObject = codeunit "Item Test TPTE";
//             //         }
//             //         // action(TestItemExtDocTPTE)
//             //         // {
//             //         //     ApplicationArea = All;
//             //         //     Caption = 'Test Item Ext. Documents';
//             //         //     RunObject = codeunit "Item Ext. Doc Text Test TPTE";
//             //         // }
//             //     }
//             //     // action(TestItemNormTPTE)
//             //     // {
//             //     //     ApplicationArea = All;
//             //     //     Caption = 'Test Item Norm';
//             //     //     RunObject = codeunit "Item Norm Test TPTE";
//             //     // }

//             //     action(ItemListTPTE)
//             //     {
//             //         ApplicationArea = All;
//             //         Caption = 'Item List';
//             //         Image = Item;
//             //         RunObject = page "Item List";
//             //     }
//             //     // action(DetailedDescriptionsTPTE)
//             //     // {
//             //     //     ApplicationArea = All;
//             //     //     Caption = 'Detailed Descriptions';
//             //     //     RunObject = page "Detailed Description TPTE";
//             //     // }
//             // }
//         }

//         addfirst(Promoted)
//         {
//             group(ItemTestGroupTPTE_PromotedTPTE)
//             {
//                 Caption = 'Item';
//                 Image = Item;

//                 group(ItemTestsTPTE_PromotedTPTE)
//                 {
//                     Caption = 'Tests';
//                     Image = TestDatabase;

//                     actionref(TestItemTPTE_Promoted; TestItemTPTE) { }
//                     // actionref(TestItemExtDocTPTE_Propmoted; TestItemExtDoc) { }
//                 }
//                 actionref(ItemListTPTE_Promoted; ItemListTPTE) { }
//                 // actionref(DetailedDescriptionsTPTE_Promoted; DetailedDescriptionsTPTE) { }
//             }
//         }
//     }

// }
