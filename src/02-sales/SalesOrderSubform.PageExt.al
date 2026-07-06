pageextension 83912 "Sales Order Subform TPTE" extends "Sales Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Job No. TPTE"; Rec."Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the related job. If you fill in this field and the Job Task No. field, then a job ledger entry will be posted together with the sales line.';
            }
            // field("Gen. Bus. Posting Group TPTE"; Rec."Gen. Bus. Posting Group")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
            // }
            // field("Gen. Prod. Posting Group TPTE"; Rec."Gen. Prod. Posting Group")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
            //     Visible = true;
            // }
            field("Customer Disc. Group TPTE"; Rec."Customer Disc. Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Disc. Group field.';
            }
            // field("Contract Reference Date TPTE"; Rec."Contract Reference Date CBLC")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Contract Reference Date field.';
            // }

        }
        modify("Usage For Line No. CBLC")
        {
            Style = Ambiguous;
            StyleExpr = (Rec."Usage Norm Entry No. CBLC" = 0) and (Rec."Service CBLC" = false);
        }
        modify("Work Type Code")
        {
            Visible = true;
        }
        modify("Line Amount")
        {
            Visible = true;
        }
        modify("Purchasing Code")
        {
            Visible = true;
        }
        modify("Drop Shipment")
        {
            Visible = true;
        }
        modify("Special Order")
        {
            Visible = true;
        }
        modify("Contract Reference Date CBLC")
        {
            Visible = true;
        }
        modify("Vendor No. CBLC")
        {
            Visible = true;
        }
        modify("Return Reason Code")
        {
            Visible = true;
        }
        modify("Location Code")
        {
            Visible = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
    }

    actions
    {
        modify("Realization CBLC")
        {
            ShortcutKey = 'Ctrl+Shift+R';
        }
        movefirst(processing; Dimensions)

        addlast(processing)
        {
            group(TestExt)
            {
                Caption = 'Test Ext.';
                Image = TestDatabase;

                group(PlanningTPTE)
                {
                    ShowAs = SplitButton;

                    action(CreatePlanningTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Create Planning';
                        Image = ResourcePlanning;

                        trigger OnAction()
                        begin
                            SalesLineHelperTPTE.CreateSalesPlanning(Rec);
                        end;
                    }
                    action(CreateRealizationTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Create Planning';
                        Image = Signature;

                        trigger OnAction()
                        begin
                            SalesRealizationHelperTPTE.CopyFromPlanning(Rec);
                        end;
                    }
                    action(CreatePlanningAndRealizationTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Create Planning & Realization';
                        Image = Signature;

                        trigger OnAction()
                        begin
                            SalesLineHelperTPTE.CreateSalesPlanning(Rec);
                            SalesRealizationHelperTPTE.CopyFromPlanning(Rec);
                        end;
                    }
                    action(ClearSalesPlanLineTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Clear Sales Plan Line';
                        Image = Signature;

                        trigger OnAction()
                        begin
                            SalesLineHelperTPTE.ClearSalesPlanLine(Rec);
                        end;
                    }
                }
                action(ItemCardTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Item Card';
                    Image = Item;
                    RunObject = page "Item Card";
                    RunPageLink = "No." = field("No.");
                }
                action(ObjectCardTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Object Card';
                    Image = Bank;
                    RunObject = page "Object Card CBLC";
                    RunPageLink = "No." = field("Object No. CBLC");
                }
                action(ObjectContactsTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Object Contacts';
                    Image = ContactPerson;
                    RunObject = page "Object Contacts CBLC";
                    RunPageLink = "Object No." = field("Object No. CBLC");
                }
                action(ObjectMaintenanceScheduleTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Object Maintenance Schedules';
                    Image = ContactPerson;
                    RunObject = page "Object Maint. Schedules CBLC";
                    RunPageLink = "Object No." = field("Object No. CBLC");
                }
                action(ContractCardTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Contract Card';
                    Image = ContractPayment;
                    RunObject = page "Contract Card CBLC";
                    RunPageLink = "No." = field("Contract No. CBLC");
                }
                action(PurchaseOrderTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Order';
                    Image = Document;

                    trigger OnAction()
                    begin
                        if Rec."Purchase Order No." <> '' then begin
                            OpenPurchOrderForm();
                            exit;
                        end;

                        if Rec."Special Order Purchase No." <> '' then begin
                            OpenSpecialPurchOrderForm();
                            exit;
                        end;
                    end;
                }
                action("Planning Lines TPTE")
                {
                    ApplicationArea = AreaCBLC;
                    Caption = 'Planning Lines';
                    Enabled = Rec."Service CBLC";
                    Image = ResourcePlanning;
                    RunObject = page "Sales Plan. Lines CBLC";
                    RunPageLink = "Document Type" = field("Document Type"), "Document No." = field("Document No."), "Document Line No." = field("Line No.");
                    RunPageMode = Edit;
                    Scope = Repeater;
                    ToolTip = 'View or edit sales planning lines that determine the resource planning for the sales line.';
                }
                action("Realization TPTE")
                {
                    ApplicationArea = AreaCBLC;
                    Caption = 'Realization';
                    Enabled = Rec."Service CBLC";
                    Image = Signature;
                    RunObject = page "Sales Realizations CBLC";
                    RunPageLink = "Document Type" = field("Document Type"), "Document No." = field("Document No."), "Document Line No." = field("Line No.");
                    RunPageMode = View;
                    Scope = Repeater;
                    ToolTip = 'View the realizations for the sales line.';
                }
            }
        }
    }

    var
        SalesLineHelperTPTE: Codeunit "Sales Line Helper TPTE";
        SalesRealizationHelperTPTE: Codeunit "Sales Realization Helper TPTE";
}