codeunit 83926 "Skill TM NL TPTE"
{
    Permissions = tabledata "Feature Setup LIB" = R;

    //TODO Turn off TMNL here True=OFF
    local procedure TurnOffTMNL(): Boolean
    var
        FeatureSetupLIB: Record "Feature Setup LIB";
    begin
        if not FeatureSetupLIB.Get() then
            Clear(FeatureSetupLIB);

        exit(FeatureSetupLIB."Disable TMNL");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Find Org. Skill Method YBLC", OnBeforeFindGeographicSkill, '', false, false)]
    local procedure OnBeforeFindGeographicSkill(var SourceVariant: Variant; var GeographicSkillCode: Code[10]; var IsHandled: Boolean)
    begin
        if TurnOffTMNL() then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Resource Skill Helper YBLC", OnBeforeFindGeographicSkill, '', false, false)]
    local procedure ResourceSkillOnBeforeFindGeographicSkill(var ResourceSkill: Record "Resource Skill"; var IsHandled: Boolean)
    begin
        if TurnOffTMNL() then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Skill Item Line Helper YBLC", OnBeforeFindGeographicSkill, '', false, false)]
    local procedure OnBeforeFindGeographicSkillSkillItemLine(var SkillItemLineCBLC: Record "Skill Item Line CBLC"; var IsHandled: Boolean)
    begin
        if TurnOffTMNL() then
            IsHandled := true;
    end;
}
