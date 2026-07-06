// codeunit 83907 "Sales Subscriber TPTE"
// {

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Planning Norm Meth. CBLC", 'OnAfterGetActiveItemPlanningNorm', '', false, false)]
//     local procedure OnAfterGetActiveItemPlanningNorm(SourceVariant: Variant; var ItemPlanningNorm: Record "Item Planning Norm CBLC");
//     var
//         FilterMsg: Label 'TEST EXT.\Planning:\Object Type: %1\Object Source: %2\Related Type: %3\Related Source: %4';
//     begin
//         Message(FilterMsg, ItemPlanningNorm.GetFilter("Object Norm Type"), ItemPlanningNorm.GetFilter("Object Norm No."),
//                            ItemPlanningNorm.getfilter("Related Norm Type"), ItemPlanningNorm.GetFilter("Related Norm No."));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Usage Norm Meth. CBLC", 'OnAfterGetActiveItemUsageNorm', '', false, false)]
//     local procedure OnAfterGetActiveItemUsageNorm(SourceVariant: Variant; var ItemUsageNorm: Record "Item Usage Norm CBLC");
//     var
//         FilterMsg: Label 'TEST EXT.\Usage:\Object Type: %1\Object Source: %2\Related Type: %3\Related Source: %4';
//     begin
//         Message(FilterMsg, ItemUsageNorm.GetFilter("Object Norm Type"), ItemUsageNorm.GetFilter("Object Norm No."),
//                            ItemUsageNorm.getfilter("Related Norm Type"), ItemUsageNorm.GetFilter("Related Norm No."));
//     end;

// }
