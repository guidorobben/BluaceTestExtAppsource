codeunit 83879 "Desktop Helper TPTE"
{
    Permissions =
        tabledata "Test Ext. Setup TPTE" = R;

    internal procedure StartupObject(Index: Integer; IgnorEnabled: Boolean)
    var
        TestExtSetup: Record "Test Ext. Setup TPTE";
        RunObjectHelper: Codeunit "Run Object Helper TPTE";
    begin
        TestExtSetup.SetLoadFields("Enable Run Object", "Run Object Type 1", "Run Object ID 1", "Run Object Type 2", "Run Object ID 2");
        if not TestExtSetup.Get() then
            exit;

        if TestExtSetup."Enable Run Object" or IgnorEnabled then
            case Index of
                1:
                    RunObjectHelper.RunObject(TestExtSetup."Run Object Type 1", TestExtSetup."Run Object ID 1");
                2:
                    RunObjectHelper.RunObject(TestExtSetup."Run Object Type 2", TestExtSetup."Run Object ID 2");
            end;
    end;
}