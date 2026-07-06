pageextension 83923 "Post Code Serv. Setup TPTE" extends "Post Code Serv. Setup YBLC"
{
    actions
    {
        addlast(Processing)
        {
            group(TestExtGroupTPTE)
            {
                Caption = 'Test Ext.';

                // action(SetupBluaceTPTE)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Setup Bluace';

                //     trigger OnAction()
                //     var
                //         InitObjectTMNLLIB: Codeunit "Init Object TM-NL LIB";
                //     begin
                //         InitObjectTMNLLIB.PostCodeServSetupBluace();
                //     end;
                // }
                action(SetupPostNLTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Setup PostNL';

                    trigger OnAction()
                    var
                        InitObjectTMNLLIB: Codeunit "Init Object TM-NL LIB";
                    begin
                        InitObjectTMNLLIB.PostCodeServSetupPostNL();
                    end;
                }
            }
        }
    }
}