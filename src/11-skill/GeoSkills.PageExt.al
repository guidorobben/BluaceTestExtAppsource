pageextension 83915 "Geo. Skills TPTE" extends "Geo. Skills YBLC"
{
    layout
    {
        addafter("Skill Code Org Part")
        {
            part("Geo. Skill Post Code TPTE"; "Geo. Skill Post Code TPTE")
            {
                ApplicationArea = All;
                Caption = 'Postcodes (Test Ext.)';
                SubPageLink = "Geographic Skill Code" = field("Geographic Skill Code");
            }
        }
    }

    // actions
    // {
    //     addlast(Processing)
    //     {
    //         action(PostCodeTest)
    //         {
    //             ApplicationArea = All;
    //             Image = TestReport;
    //             Caption = 'Test Post code (Test Ext.)';
    //             ToolTip = 'Test Post Code';

    //             trigger OnAction()
    //             var
    //                 FindOrgSkillMethod: Codeunit "Find Org. Skill Method YBLC";
    //                 StandardDialog: Page "Standard Dialog TPTE";
    //                 SkillCode: Code[10];
    //                 PostCode: Text[20];
    //             begin
    //                 if StandardDialog.RunModal() <> Action::OK then
    //                     exit;
    //                 Postcode := StandardDialog.GetPostCode();

    //                 FindOrgSkillMethod.TestForDouble(PostCode);

    //                 if SkillCode = '' then
    //                     Message('Kan niets vinden voor postcode')
    //                 else
    //                     Message('Geen problemen voor postcode: ' + SkillCode);
    //             end;
    //         }
    //     }
    // }
}
