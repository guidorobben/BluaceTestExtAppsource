codeunit 83919 "Test Code TPTE"
{
    var

    trigger OnRun()
    var
        // ApplAreaHelper: Codeunit "Appl. Area Helper TPTE";
        // item
        SalesHeader: Record "Sales Header";
    begin
        // SalesHeader.SetSkipUpdateSalesLinesCBLC(true);
        // ContractTest.CreateContractWithLinesAndSend();
        // ObjectMaintenanceTest.CreateObjectMaintenanceScheduleAllForAllContracts();
        // ObjectMaintenanceTest.CreateObjectWithMaintenanceScheduleChangeSkill();
        // ObjectMaintenanceTest.CreateObjectWithObjectMaintenanceScheduleAndSalesOrdersItemLastRealisationDate();
        // FillInvoiceUnitOfMeasureOnContracts();
        // test1();

        // page.Run(Page::"Webhook Subscription TPTE");

        // Message(Format('hoogefficiënte', 0, 9));
        // Test2(SalesHeader);
    end;

    procedure Test1()
    var
        // jsonobject: JsonObject;
        TypeHelper: Codeunit "Type Helper";
        ExpiresInDateTime: DateTime;
        // FeatureManagement: Codeunit "Feature Management TPTE";
        Duration: Integer;
        ExpiresIn: Integer;
        ST: SecretText;
        Token: SecretText;
        D: Text;
        ExpiresInText: Text;
        T: Text;
        TokenValidText: Text;
    begin
        T := TypeHelper.GetCurrUTCDateTimeISO8601();
        Message('%1', T);

        Evaluate(ExpiresInDateTime, T, 9);
        Message('%1', ExpiresInDateTime);

        // exit;

        // IsolatedStorage.Set('VALID', Format(CurrentDateTime(), 0, 9));
        // IsolatedStorage.Set('EXPIRESIN', '3600000');

        // IsolatedStorage.Get('TOKEN', Token);
        // IsolatedStorage.Get('VALID', TokenValidText);
        // IsolatedStorage.Get('EXPIRESIN', ExpiresInText);
        // Evaluate(ExpiresInDateTime, TokenValidText, 9);
        // Evaluate(ExpiresIn, ExpiresInText);

        // Message(TokenValidText);
        // Message(ExpiresInText);

        // ExpiresIn -= 300000;
        // ExpiresInDateTime += ExpiresIn;

        // if ExpiresInDateTime > CurrentDateTime() then
        //     Message('Token is valid');

        // // else
        // Message(Format(ExpiresInDateTime));

        // FeatureManagement.EnableFeature('SalesPrices');
        // FeatureManagement.EnableFeature('FullTextSearch');

    end;

    procedure Test2()
    begin

    end;

    procedure Test2(var SalesHeader: Record "Sales Header")
    begin
        Message('%1', SalesHeader.GetSkipUpdateSalesLinesCBLC());
    end;
}