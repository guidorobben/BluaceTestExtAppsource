pageextension 83970 "Desktop Object TPTE" extends "Bluace Desktop LIB"
{

    actions
    {
        // addafter(ALTestToolGroupTPTE)
        addlast(Processing)
        {
            //Object
            group(ObjectTestGroupTPTE)
            {
                Caption = 'Object';

                group(ObjectTestTPTE)
                {
                    Caption = 'Test';

                    action(TestObjectTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Test Object';

                        trigger OnAction()
                        begin
                            Codeunit.Run(Codeunit::"UT Object TPTE");
                        end;
                    }
                    action(TestMaintenanceTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Test Maintenance';

                        trigger OnAction()
                        begin
                            Codeunit.Run(Codeunit::"UT Object Maintenance TPTE");
                        end;
                    }
                }

                group(ObjectCreateGroupTPTE)
                {
                    Caption = 'Create';
                    Image = New;

                    action(CreateObjectWithPriceAndContactTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Object with price and contact';

                        trigger OnAction()
                        var
                            ObjectCreate: Codeunit "UC Object TPTE";
                        begin
                            ObjectCreate.CreateObjectWithPriceAndContact();
                        end;
                    }
                    action(CreateObjectWithObjectMaintenanceScheduleLastRealisationDateTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Create Object With Object Maintenance Schedule (Last Realisation Date)';

                        trigger OnAction()
                        var
                            ObjectCreate: Codeunit "UC Object TPTE";
                        begin
                            ObjectCreate.CreateObjectWithObjectMaintenanceScheduleLastRealisationDate();
                        end;
                    }
                    action(CreateObjectWithObjectMaintenanceScheduleStartingDateTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Create Object With Object Maintenance Schedule (Starting Date)';

                        trigger OnAction()
                        var
                            ObjectCreate: Codeunit "UC Object TPTE";
                        begin
                            ObjectCreate.CreateObjectWithObjectMaintenanceScheduleStartingDate();
                        end;
                    }
                }

                //Object Import
                group(TestObjectImportGroupTPTE)
                {
                    Caption = 'Object Import';

                    action(TestContractImportTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Test Object import';
                        // RunObject = codeunit "UT Object Import TPTE";

                        trigger OnAction()
                        var
                            UTObjectImport: Codeunit "UT Object Import TPTE";
                        begin
                            UTObjectImport.CreateContractImportLines();
                        end;
                    }
                    action(OpenObjectImportJournalTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Object Import Journal';
                        RunObject = page "Object Import Journal CBLC";
                    }
                }

                action(ObjectListTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Object List';
                    RunObject = page "Object List CBLC";
                    RunPageView = sorting("No.") order(descending);
                }
                action(ObjectTemplateListTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Object Template List';
                    RunObject = page "Object Template List CBLC";
                }

                action(ObjectSetupTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Object Setup';
                    RunObject = page "Object Setup CBLC";
                }
                action(MaintenanceScheduleTemplatesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Maintenance Schedule Templates';
                    RunObject = page "Maint. Sched. Templ. List CBLC";
                }
                action(MaintenanceScheduleNormTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Maintenance Schedule Norm';
                    RunObject = page "Maint. Template Norms CBLC";
                }
                action(ObjectMaintenanceSchedulesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Object Maintenance Schedules';
                    RunObject = page "Object Maint. Schedules CBLC";
                }
            }
        }

        // addafter(ALTestToolTPTE_Promoted)
        addfirst(Promoted)
        {
            group(ObjectTestGroupTPTE_PromotedTPTE)
            {
                Caption = 'Object';
                Image = Company;

                group(ObjectTestsGroupTPTE_PromotedTPTE)
                {
                    Caption = 'Tests';
                    Image = TestDatabase;

                    actionref(TestObjectTPTE_Promoted; TestObjectTPTE) { }
                    actionref(TestMaintenanceTPTE_Promoted; TestMaintenanceTPTE) { }
                }
                group(ObjectCreateGroupTPTE_PromotedTPTE)
                {
                    Caption = 'Create';
                    Image = New;

                    actionref(CreateObjectWithPriceAndContactTPTE_Promoted; CreateObjectWithPriceAndContactTPTE) { }
                    actionref(CreateObjectWithObjectMaintenanceScheduleLastRealisationDateTPTE_Promoted; CreateObjectWithObjectMaintenanceScheduleLastRealisationDateTPTE) { }
                    actionref(CreateObjectWithObjectMaintenanceScheduleStartingDateTPTE_Promoted; CreateObjectWithObjectMaintenanceScheduleStartingDateTPTE) { }
                }

                group(ObjectTestImportGroupTPTE_PromtedTPTE)
                {
                    Caption = 'Object Import';
                    Image = Import;

                    actionref(TestContractImport_Promoted; TestContractImportTPTE) { }
                    actionref(ContractImportJournal_Promoted; OpenObjectImportJournalTPTE) { }
                }

                actionref(ObjectListTPTE_Promoted; ObjectListTPTE) { }
                actionref(ObjectTemplateListTPTE_Promoted; ObjectTemplateListTPTE) { }
                actionref(ObjectSetupTPTE_Promoted; ObjectSetupTPTE) { }
                actionref(MaintenanceScheduleTemplatesTPTE_Promoted; MaintenanceScheduleTemplatesTPTE) { }
                actionref(MaintenanceScheduleNormTPTE_Promoted; MaintenanceScheduleNormTPTE) { }
                actionref(ObjectMaintenanceSchedulesTPTE_Promoted; ObjectMaintenanceSchedulesTPTE) { }
            }
        }
    }
}
