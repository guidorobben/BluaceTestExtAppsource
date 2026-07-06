pageextension 83943 "Sales Quote Subform TPTE" extends "Sales Quote Subform"
{
    layout
    {
        modify("Contract Reference Date CBLC")
        {
            Visible = true;
        }
    }

    //     actions
    //     {
    //         addlast(processing)
    //         {
    //             action(FindGeoSkillTPTE)
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

    //     procedure FindGeograhicSkill()
    //     var
    //         FindOrgSkillMethodYBLC: Codeunit "Find Org. Skill Method YBLC";
    //         SkillCode: Code[10];
    //         SkillLineHelperCBLC: codeunit "Skill Line Helper CBLC";
    //     begin
    //         FindOrgSkillMethodYBLC.FindGeographicSkill(Rec, SkillCode);
    //         if SkillCode <> '' then begin
    //             SkillLineHelperCBLC.DeleteSkillLine(Rec.RecordId.TableNo, Rec.SystemId, Enum::"Skill Type CBLC"::Geography);
    //             SkillLineHelperCBLC.AddSkillLine(Rec.RecordId.TableNo, Rec.SystemId, SkillCode, false);
    //         end;
    //     end;

}
