codeunit 83866 "Object Import Line Helper TPTE"
{
    Permissions =
        tabledata "Object Import Line CBLC" = R,
        tabledata "Object CBLC" = R;

    procedure OpenObject(var ObjectImportLineCBLC: Record "Object Import Line CBLC")
    var
        ObjectCBLC: Record "Object CBLC";
        PageManagement: Codeunit "Page Management";
    begin
        if ObjectCBLC.Get(ObjectImportLineCBLC."Replacement Object No.") then
            PageManagement.PageRun(ObjectCBLC);
    end;
}