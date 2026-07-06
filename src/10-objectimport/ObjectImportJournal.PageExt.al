pageextension 83903 "Object Import Journal TPTE" extends "Object Import Journal CBLC"
{
    layout
    {
        // addafter("Property 10")
        // {
        //     field("Property 83900"; Rec."Property 83900")
        //     {
        //         ApplicationArea = All;
        //         StyleExpr = LineStyle;
        //         Visible = Property83900Visible;
        //     }
        //     field("Property 83920"; Rec."Property 83920")
        //     {
        //         ApplicationArea = All;
        //         StyleExpr = LineStyle;
        //         Visible = Property83920Visible;
        //     }
        // }
    }

    actions
    {
        addlast(Navigation)
        {
            action(ObjectCardTPTE)
            {
                ApplicationArea = All;
                Caption = 'Object';
                Image = Bank;
                ToolTip = 'Open Object.';

                trigger OnAction()
                begin
                    ObjectImportLineHelperTPTE.OpenObject(Rec);
                end;
            }
        }

        addlast(Processing)
        {
            group(TextExtTPTE)
            {
                Caption = 'Text Ext.';

                action(CopyLine)
                {
                    ApplicationArea = All;
                    Caption = 'Copy Line';
                    trigger OnAction()
                    begin
                        CopyLineToNewLine();
                    end;
                }
                group(StatusTPTE)
                {
                    Caption = 'Status', Locked = true;

                    action(StatusNewTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'New', Locked = true;

                        trigger OnAction()
                        begin
                            Rec.Status := Rec.Status::New;
                            Rec.Modify(false);
                        end;
                    }
                    action(StatusValidatedTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Validated', Locked = true;

                        trigger OnAction()
                        begin
                            Rec.Status := Rec.Status::Validated;
                            Rec.Modify(false);
                        end;
                    }
                    action(StatusErrorTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Error', Locked = true;

                        trigger OnAction()
                        begin
                            Rec.Status := Rec.Status::Error;
                            Rec.Modify(false);
                        end;
                    }
                    action(StatusProcessedTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Processed', Locked = true;

                        trigger OnAction()
                        begin
                            Rec.Status := Rec.Status::Processed;
                            Rec.Modify(false);
                        end;
                    }
                    action(StatusProcessedWithErrorTPTE)
                    {
                        ApplicationArea = All;
                        Caption = 'Processed With Error', Locked = true;

                        trigger OnAction()
                        begin
                            Rec.Status := Rec.Status::"Processed With Error";
                            Rec.Modify(false);
                        end;
                    }
                }
            }
        }

        addlast(Promoted)
        {
            group(TestExt_Promoted_TPTE)
            {
                Caption = 'Text Ext.', Locked = true;

                actionref(ObjecTCardTPTE_Promoted; ObjectCardTPTE) { }

                group(Status_Promoted_TPTE)
                {
                    Caption = 'Status', Locked = true;

                    actionref(StatusNewTPTE_Promoted; StatusNewTPTE) { }
                    actionref(StatusValidatedTPTE_Promoted; StatusValidatedTPTE) { }
                    actionref(StatusErrorTPTE_Promoted; StatusErrorTPTE) { }
                    actionref(StatusProcessedTPTE_Promoted; StatusProcessedTPTE) { }
                    actionref(StatusProcessedWithErrorTPTE_Promoted; StatusProcessedWithErrorTPTE) { }
                }
            }
        }
    }

    var
        ObjectImportLineHelperTPTE: Codeunit "Object Import Line Helper TPTE";
    // Property83900Visible: Boolean;
    // Property83920Visible: Boolean;

    // trigger OnOpenPage()
    // begin
    //     SetObjectProperties();
    // end;

    // local procedure SetObjectProperties()
    // begin
    //     Property83900Visible := Rec.GetPropertyCaption(Rec.FieldNo("Property 83900")) <> '';
    //     Property83920Visible := Rec.GetPropertyCaption(Rec.FieldNo("Property 83920")) <> '';
    // end;

    local procedure CopyLineToNewLine()
    var
        ObjectImportLineCBLC: Record "Object Import Line CBLC";
    begin
        ObjectImportLineCBLC.Init();
        ObjectImportLineCBLC.TransferFields(Rec);
        ObjectImportLineCBLC.Status := ObjectImportLineCBLC.Status::New;
        ObjectImportLineCBLC.Validate("Line No.", Rec."Line No." + 10000);
        ObjectImportLineCBLC.Insert(true);
    end;
}