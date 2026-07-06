codeunit 83928 "UC Contract TPTE"
{
    Permissions =
        tabledata "Contr. Template Header CBLC" = R,
        tabledata "Contract Header CBLC" = R;

    var
        PageManagement: Codeunit "Page Management";
        UTContract: Codeunit "UT Contract TPTE";

    procedure CreateContractWithCoverage()
    begin
        UTContract.CreateContractTemplateWithCoverageAndContract_18307();
        OpenLastContract();
    end;

    procedure CreateContractTemplateWithCoverageAndFollowUp()
    begin
        UTContract.CreateContractTemplateWithCoverageAndFollowUp();
        OpenLastContractTemplate();
    end;

    procedure CreateContractFromObject()
    begin
        UTContract.CreateContractFromObject();
        OpenLastContract();
    end;

    procedure CreateContractFromObjectWithFollowUp()
    begin
        UTContract.CreateContractFromObjectWithFollowUpTemplate();
        OpenLastContract();
    end;

    procedure CreateContractWithLinesAndSend()
    begin
        UTContract.CreateContractWithLinesAndSend();
        OpenLastContract();
    end;

    procedure CreateContractWithLineNoObject()
    begin
        UTContract.CreateContractWithLineNoObject();
        OpenLastContract();
    end;

    local procedure OpenLastContract()
    var
        ContractHeaderCBLC: Record "Contract Header CBLC";
    begin
        if ContractHeaderCBLC.FindLast() then
            PageManagement.PageRun(ContractHeaderCBLC);
    end;

    local procedure OpenLastContractTemplate()
    var
        ContrTemplateHeaderCBLC: Record "Contr. Template Header CBLC";
    begin
        if ContrTemplateHeaderCBLC.FindLast() then
            PageManagement.PageRun(ContrTemplateHeaderCBLC);
    end;
}