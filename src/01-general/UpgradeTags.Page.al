// page 83859 "Upgrade Tags TPTE"
// {
//     ApplicationArea = All;
//     Caption = 'Upgrade Tags';
//     Editable = false;
//     PageType = List;
//     SourceTable = "Upgrade Tag TPTE";
//     UsageCategory = Administration;

//     layout
//     {
//         area(Content)
//         {
//             repeater(General)
//             {
//                 Caption = 'General';

//                 field("Upgrade Tag"; Rec."Upgrade Tag") { }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(LineCount)
//             {
//                 Caption = 'Line Count';
//                 Image = NumberGroup;
//                 ToolTip = 'Show the number of lines.';

//                 trigger OnAction()
//                 begin
//                     Message(Format(Rec.Count()));
//                 end;
//             }
//         }
//     }

//     trigger OnOpenPage()
//     begin
//         BuildTagList();
//     end;

//     local procedure BuildTagList()
//     var
//         UpgradeTag: Codeunit "Upgrade Tag";
//         CompanyUpgradeTag: Code[250];
//         PerCompanyUpgradeTags: List of [Code[250]];
//     begin
//         UpgradeTag.GetPerCompanyUpgradeTags(PerCompanyUpgradeTags);

//         foreach CompanyUpgradeTag in PerCompanyUpgradeTags do begin
//             Rec.Init();
//             Rec.Validate("Upgrade Tag", CompanyUpgradeTag);
//             Rec.Insert(true);
//         end;
//     end;
// }