codeunit 83869 "Object Helper TPTE"
{
    Permissions =
        tabledata "Object CBLC" = RM;

    internal procedure CreateAndLinkObjectNorm(var ObjectCBLC: Record "Object CBLC")
    var
        LibraryObjectLIB: Codeunit "Library - Object LIB";
    begin
        if ObjectCBLC."No." = '' then
            exit;

        LibraryObjectLIB.CreateObjectNormCode(ObjectCBLC."No.", ObjectCBLC."No.");
        ObjectCBLC.Validate("Object Norm Code", ObjectCBLC."No.");
        ObjectCBLC.Modify(true);
    end;

    internal procedure CreateMaintenanceNormForObjectNorm(var ObjectCBLC: Record "Object CBLC")
    var
        LibraryMaintenanceLIB: Codeunit "Library - Maintenance LIB";
    begin
        LibraryMaintenanceLIB.CreateMaintenanceNorm("Object Norm Type CBLC"::"Object Norm", ObjectCBLC."No.", "Related Norm Type CBLC"::All, '', '');
        OpenPageMaintTemplateNorms();
    end;

    internal procedure CreateMaintenanceNormForObjectNormAllContractss(var ObjectCBLC: Record "Object CBLC")
    var
        LibraryMaintenanceLIB: Codeunit "Library - Maintenance LIB";
    begin
        LibraryMaintenanceLIB.CreateMaintenanceNorm("Object Norm Type CBLC"::"Object Norm", ObjectCBLC."No.", "Related Norm Type CBLC"::"All Contracts", '', '');
        OpenPageMaintTemplateNorms();
    end;

    procedure OpenPageMaintTemplateNorms()
    begin
        Page.Run(Page::"Maint. Template Norms CBLC");
    end;
}