pageextension 83969 "Desktop Contract TPTE" extends "Bluace Desktop LIB"
{
    actions
    {
        addlast(Processing)
        {
            group(TestContractsGroupTPTE)
            {
                Caption = 'Contracts';

                group(CreateContractGroupPTETPTE)
                {
                    Caption = 'Create';
                    Image = New;

                    action(CreateContractWithCoverageTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Contract with Coverage';

                        trigger OnAction()
                        var
                            ContractCreate: Codeunit "UC Contract TPTE";
                        begin
                            ContractCreate.CreateContractWithCoverage();
                        end;
                    }

                    action(CreateContractFromObjectTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Contract from object';

                        trigger OnAction()
                        var
                            ContractCreate: Codeunit "UC Contract TPTE";
                        begin
                            ContractCreate.CreateContractFromObject();
                        end;
                    }
                    action(CreateContractFromObjectWithFollowUpTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Contract from object with follow-up';

                        trigger OnAction()
                        var
                            ContractCreate: Codeunit "UC Contract TPTE";
                        begin
                            ContractCreate.CreateContractFromObjectWithFollowUp();
                        end;
                    }
                    action(CreateContractWithLineNoObjectTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Create contract with line (No Object)';

                        trigger OnAction()
                        var
                            ContractCreate: Codeunit "UC Contract TPTE";
                        begin
                            ContractCreate.CreateContractWithLineNoObject();
                        end;
                    }
                    action(CreateContractWithLinesAndSendTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Create Send Contract';

                        trigger OnAction()
                        var
                            ContractCreate: Codeunit "UC Contract TPTE";
                        begin
                            ContractCreate.CreateContractWithLinesAndSend();
                        end;
                    }
                    action(CreateContractTemplateWithCoverageAndFollowUpTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Contract template follow up';

                        trigger OnAction()
                        var
                            ContractCreate: Codeunit "UC Contract TPTE";
                        begin
                            ContractCreate.CreateContractTemplateWithCoverageAndFollowUp();
                        end;
                    }
                }
                action(TestContractsTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Test Contract';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"UT Contract TPTE");
                    end;
                }
                action(OpenContractsTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Contract List';
                    RunObject = page "Contract List CBLC";
                    RunPageView = sorting("No.") order(descending);

                    // trigger OnAction()
                    // begin
                    //     Page.Run(Page::"Contract List CBLC");
                    // end;
                }
                action(OpenContractTemplatesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Contract Templates';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Contr. Template List CBLC");
                    end;
                }
                action(ContractArchiveLinesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Contract Archive Lines';
                    RunObject = page "Contr. Archive Lines CBLC";
                    RunPageView = sorting("Contract No.") order(descending);
                }
            }
        }

        addfirst(Promoted)
        {
            group(ContractsGroupTPTE_PromotedTPTE)
            {
                Caption = 'Contract';
                Image = ContractPayment;

                group(ContractsTestsGroupTPTE_PromotedTPTE)
                {
                    Caption = 'Tests';
                    Image = TestDatabase;

                    actionref(TestContractsTPTE_Promoted; TestContractsTPTE) { }
                }

                group(ContractCreateGroupTPTE_PromotedTPTE)
                {
                    Caption = 'Create';
                    Image = New;

                    actionref(CreateContractWithCoverageTPTE_Promoted; CreateContractWithCoverageTPTE) { }
                    actionref(CreateContractFromObjectTPTE_Promoted; CreateContractFromObjectTPTE) { }
                    actionref(CreateContractFromObjectWithFollowUpTPTE_Promoted; CreateContractFromObjectWithFollowUpTPTE) { }
                    actionref(CreateContractWithLineNoObjectTPTE_Promoted; CreateContractWithLineNoObjectTPTE) { }
                    actionref(CreateContractWithLinesAndSendTPTE_Promoted; CreateContractWithLinesAndSendTPTE) { }
                    actionref(CreateContractTemplateWithCoverageAndFollowUpTPTE_Promoted; CreateContractTemplateWithCoverageAndFollowUpTPTE) { }
                }

                actionref(OpenContracts_Promoted; OpenContractsTPTE) { }
                actionref(OpenContractTemplates_Promoted; OpenContractTemplatesTPTE) { }
                actionref(ContractArchiveLinesTPTE_Promoted; ContractArchiveLinesTPTE) { }
            }
        }
    }
}
