pageextension 83913 "Bluace Desktop TPTE" extends "Bluace Desktop LIB"
{
    actions
    {

        addfirst(Processing)
        {
            //AL Test Tool
            group(ALTestToolGroupTPTE)
            {
                Caption = 'AL Test Tool';

                action(ALTestToolTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'AL Test Tool';
                    RunObject = page "AL Test Tool";
                }
            }

            // Skills
            group(SkillGroupTPTE)
            {
                Caption = 'Skills';

                // action(SkillInitializeTPTE)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Skills Initialize';

                //     trigger OnAction()
                //     var
                //         InitSkill: Codeunit "Init. Skills LIB";
                //     begin
                //         InitSkill.Initialize();
                //     end;

                // }
                action(SkillsTestTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Skills Test';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"UT Skills TPTE");
                    end;
                }
                action(SkillsTestTMNLTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Skills Test (TMNL)';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"UT Skills TMNL TPTE");
                    end;
                }
                action(ResourcesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Resources';
                    RunObject = page "Resource List";
                }
                // action(ItemsTPTE)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Items';
                //     RunObject = page "Item List";
                // }
                action(ObjectSkillTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Objects';
                    RunObject = page "Object List CBLC";
                }
                action(ObjectTemplateSkillTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Object Templates';
                    RunObject = page "Object Template List CBLC";
                }
                action(JobPlanningLinesSkillTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Job Planning Lines';
                    RunObject = page "Job Planning Lines";
                }
                action(ResourceSkillsTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Resource Skills';
                    RunObject = page "Resource Skills";
                }
                action(SkillLinesSkillsTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Skill Lines';
                    RunObject = page "Skill Lines CBLC";

                }
                action(SkillItemLinesTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Skill Item Lines';
                    RunObject = page "Skill Item Lines CBLC";
                }
                action(SkillsTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Skills';
                    RunObject = page "Skill Codes";
                }
                action(GeographicSkillsTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Geographic Skills';

                    trigger OnAction()
                    begin
#pragma warning disable LC0003
                        Page.Run(84003);
#pragma warning restore LC0003
                    end;
                }
                action(SkillPostcodeTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Geo. Skill - Post Codes';

                    trigger OnAction()
                    begin
#pragma warning disable LC0003
                        Page.Run(84006);
#pragma warning restore LC0003
                    end;
                }

            }
            // group(TimSheetGroupTPTE)
            // {
            //     Caption = 'Time Sheet';


            //     // action(TestTimeSheetTPTE)
            //     // {
            //     //     ApplicationArea = All;
            //     //     Caption = 'Test Time Sheet';
            //     //     RunObject = codeunit "Time Sheet Test PTE";
            //     // }

            //     action(TestExtTimeSheetTPTE)
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Test Ext. Time Sheet';
            //         RunObject = codeunit "UT Ext. Time Sheet TPTE";
            //     }
            //     action(TimeSheetsTPTE)
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Time Sheets';
            //         RunObject = page "Time Sheet List";
            //     }
            //     action(TimeSheetDetailsTPTE)
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Time Sheet Details';
            //         RunObject = page "Time Sheet Details TPTE";
            //     }
            //     // action(JobPlanningImportLinesTPTE)
            //     // {
            //     //     ApplicationArea = All;
            //     //     Caption = 'Job Planning Import Lines';
            //     //     RunObject = page "Job Planning Import Lines QPTE";
            //     // }
            //     action(JobPlanningLinesTPTE)
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Job Planning Lines';
            //         RunObject = page "Job Planning Lines";
            //     }
            //     action(AutoTimeSheetApprovalTPTE)
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Auto. Time Sheet Approval';

            //         trigger OnAction()
            //         begin
            //             Report.Run(90000);
            //         end;
            //     }
            //     action(JobJournalTPTE)
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Job Journal';
            //         RunObject = page "Job Journal";
            //         ToolTip = 'Show job journal.';
            //     }
            //     action(JobLedgerEntriesTPTE)
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Job Ledger Entries';
            //         RunObject = page "Job Ledger Entries";
            //         ToolTip = 'Show job ledger entries.';

            //     }
            //     // action(TimeSheetTotalsResTPTE)
            //     // {
            //     //     ApplicationArea = All;
            //     //     Caption = 'Time Sheet Totals Res.';

            //     //     trigger OnAction()
            //     //     var
            //     //         Qry: Query "Time Sheet Totals Res. QPTE";
            //     //     begin
            //     //         query.
            //     //     end;
            //     // }
            // // }
        }

        addfirst(AdministrationGroup)
        {
            action(RunObjectTPTE)
            {
                ApplicationArea = All;
                Caption = 'Run Object';
                RunObject = page "Run Object TPTE";
            }
            action(TableInformationTPTE)
            {
                ApplicationArea = All;
                Caption = 'Table Information';
                RunObject = page "Table Information";
                ToolTip = 'Open the Table Information page.';
            }
            action(DatesTPTE)
            {
                ApplicationArea = All;
                Caption = 'Dates';
                Image = DateRange;
                RunObject = page "Date List TPTE";
                ToolTip = 'Show all the dates.';
            }
            action(ImportDataTPTE)
            {
                ApplicationArea = All;
                Caption = 'Import data';
                RunObject = page "Import Data TPTE";
            }
            action(ExportDataTPTE)
            {
                ApplicationArea = All;
                Caption = 'Export data';
                RunObject = report "Export Bluace Data TPTE";
            }
            action(DataAdministrationTPTE)
            {
                ApplicationArea = All;
                Caption = 'Data Administration';
                RunObject = page "Data Administration";
            }
            // action(TestExportDataTPTE)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Export data';
            //     RunObject = report "Export Profiles";
            // }  
            action(EventSubscriptionsTPTE)
            {
                ApplicationArea = All;
                Caption = 'Event Subscriptions';
                RunObject = page "Event Subscriptions";
            }
            action(EnableServiceTPTE)
            {
                ApplicationArea = All;
                Caption = 'Enable Service';

                trigger OnAction()
                var
                    ApplicationAreaSetup: Record "Application Area Setup";
                    ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
                begin
                    ApplicationAreaSetup.FindFirst();
                    // ApplicationAreaSetup.Validate("Company Name", CompanyName);
                    ApplicationAreaSetup.Validate(Service, true);
#pragma warning disable LC0068
                    ApplicationAreaSetup.Modify(true);
#pragma warning restore LC0068

                    ApplicationAreaMgmtFacade.SetupApplicationArea();
                end;
            }
        }

        addlast(Processing)
        {
            group(TestCodeGroupTPTE)
            {
                Caption = 'Test Your Code';

                group(UpgradeTPTE)
                {
                    Caption = 'Upgrade';

                    // action(FillSalesLineContractReferenceDateTPTE)
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'FillSalesLineContractReferenceDate';

                    //     trigger OnAction()
                    //     var
                    //         UpgradeCBLC: Codeunit "Upgrade CBLC";
                    //     begin
                    //         // UpgradeCBLC.FillSalesLineContractReferenceDate();
                    //     end;
                    // }
                }
                // action("Test - Item Posting GroupTPTE")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Test - Item Posting Group';

                //     trigger OnAction()
                //     begin
                //         Codeunit.Run(83919);
                //     end;

                // }
                // action(StartupObjectTPTE)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Startup Object';

                //     trigger OnAction()
                //     begin
                //         RunStartupObjectTPTE(true);
                //     end;
                // }
                action(TestCodeTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Test your Code';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Test Code TPTE");
                    end;
                }
                action(TestCode1TPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Test your Code 1';

                    trigger OnAction()
                    var
                        TestCode: Codeunit "Test Code TPTE";
                    begin
                        TestCode.Test1();
                    end;
                }
                action(TestCode2TPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Test your Code 2';

                    trigger OnAction()
                    var
                        TestCode: Codeunit "Test Code TPTE";
                    begin
                        TestCode.Test2();
                    end;
                }
            }
            // group(TranslationGroupTPTE)
            // {
            //     Caption = 'Translations';

            //     action(XliffTranslationsTPTE)
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Translations';
            //         RunObject = page "Xliff Translations TPTE";
            //     }
            //     action(TranslateTextTPTE)
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Translate Text';
            //         RunObject = page "Translate Text";
            //     }
            // }
        }

        #region Promoted

        addfirst(Administration_Promoted)
        {
            actionref(RunObjectTPTE_Promoted; RunObjectTPTE) { }
            actionref(TableInformationTPTE_Promoted; TableInformationTPTE) { }
            actionref(ImportDataTPTE_Promoted; ImportDataTPTE) { }
            actionref(ExportDataTPTE_Promoted; ExportDataTPTE) { }
            actionref(Dates_Promoted; DatesTPTE) { }
            actionref(EventSubscriptionsTPTE_Promoted; EventSubscriptionsTPTE) { }
            actionref(DataAdministrationTPTE_Promoted; DataAdministrationTPTE) { }

            group(ModulesTPTE_PromotedTPTE)
            {
                Caption = 'Modules';

                actionref(EnableServiceTPTE_Promoted; EnableServiceTPTE) { }
            }
        }

        addfirst(Promoted)
        {
            //group(ALTestToolGroupTPTE_PromotedTPTE)
            // {
            //     Caption = 'AL Test Tool';
            //     Image = TestDatabase;

            actionref(ALTestToolTPTE_Promoted; ALTestToolTPTE) { }

            #region Skills
            group(SkillGroupPromotedTPTE)
            {
                Caption = 'Skills';
                Image = Skills;

                group(SkillGroupTest_PromotedTPTE)
                {
                    Caption = 'Tests';
                    Image = TestDatabase;

                    actionref(SkillsTestTPTE_Promoted; SkillsTestTPTE) { }
                    actionref(SkillsTestTMNL_Promoted; SkillsTestTMNLTPTE) { }
                }
                actionref(Resources_Promoted; ResourcesTPTE) { }
                actionref(ObjectSkill_Promoted; ObjectSkillTPTE) { }
                actionref(ObjectTemplateSkill_Promoted; ObjectTemplateSkillTPTE) { }
                actionref(JobPlanningLinesSkill_Promoted; JobPlanningLinesSkillTPTE) { }
                actionref(ResourceSkills_Promoted; ResourceSkillsTPTE) { }
                actionref(SkillLinesSkills_Promoted; SkillLinesSkillsTPTE) { }
                actionref(SkillItemLinesTPTE_Promoted; SkillItemLinesTPTE) { }
                actionref(Skills_Promoted; SkillsTPTE) { }
                actionref(GeographicSkills_Promoted; GeographicSkillsTPTE) { }
                actionref(SkillPostcode_Promoted; SkillPostcodeTPTE) { }
            }
            #endregion Skills

            group(TestCodeGroupRefTPTE)
            {
                Caption = 'Test Your Code', Locked = true;
                Image = TestDatabase;

                group(UpgradeTPTE_PromotedTPTE)
                {
                    Caption = 'Upgrades', Locked = true;

                    // actionref(FillSalesLineContractReferenceDateTPTE_Promoted; FillSalesLineContractReferenceDateTPTE) { }
                }

                // actionref(StartupObjectTPTE_Promoted; StartupObjectTPTE) { }
                actionref(TestCode_Promoted; TestCodeTPTE) { }
                actionref(TestCode1TPTE_Promoted; TestCode1TPTE) { }
                actionref(TestCode2TPTE_Promoted; TestCode2TPTE) { }
            }

            // group(TranslationGroup_PromotedTPTE)
            // {
            //     Caption = 'Translations';
            //     Image = Translations;

            //     actionref(TranslateText_Promoted; TranslateTextTPTE) { }
            //     actionref(XliffTranslationsPromoted; XliffTranslationsTPTE) { }
            // }
            #endregion Promoted
        }
    }

    // local procedure RunStartupObjectTPTE(IgnorEnabled: Boolean)
    // var
    //     DesktopHelper: Codeunit "Desktop Helper TPTE";
    // begin
    //     DesktopHelper.StartupObject(1, IgnorEnabled);
    // end;
}