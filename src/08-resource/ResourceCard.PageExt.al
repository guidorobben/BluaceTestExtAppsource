pageextension 83926 "Resource Card TPTE" extends "Resource Card"
{
    layout
    {
        modify("Name 2")
        {
            Visible = true;
        }
    }
    //     actions
    //     {
    //         addlast(processing)
    //         {
    //             action(FindGeoSkill)
    //             {
    //                 ApplicationArea = All;
    //                 Caption = 'Find Geo. Skill';
    //                 Image = TestReport;

    //                 trigger OnAction()
    //                 begin
    //                     FindGeograhicSkill();
    //                 end;
    //             }
    //         }
    //     }

    //     // procedure FindGeograhicSkill()
    //     // var
    //     //     FindOrgSkillMethodYBLC: Codeunit "Find Org. Skill Method YBLC";
    //     //     SkillCode: Code[10];
    //     //     ResourceSkillHelperCBLC: codeunit "Resource Skill Helper CBLC";
    //     //     LibrarySkill: Codeunit "Library - Skill";
    //     // begin
    //     //     FindOrgSkillMethodYBLC.FindGeographicSkill(Rec, SkillCode);
    //     //     if SkillCode <> '' then begin
    //     //         LibrarySkill.DeleteResourceSkills(Enum::"Resource Skill Type"::Resource, Rec."No.", Enum::"Skill Type CBLC"::Geography); //TODO, deze bessat niet in TM
    //     //         // SkillLineHelperCBLC.DeleteSkillLine(Rec.RecordId.TableNo, Rec.SystemId, Enum::"Skill Type CBLC"::Geography);
    //     //         // SkillLineHelperCBLC.AddSkillLine(Rec.RecordId.TableNo, Rec.SystemId, SkillCode, false);
    //     //         ResourceSkillHelperCBLC.AddResourceSkill(Enum::"Resource Skill Type"::Resource, Rec."No.", SkillCode, false);
    //     //     end;
    //     // end;

}
