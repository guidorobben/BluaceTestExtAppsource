pageextension 83902 "Job Plan Lines TPTE" extends "Job Plan. Lines CBLC"
{
    actions
    {
        addlast(Processing)
        {
            group("TextExtTPE TPTE")
            {
                Caption = 'Text Ext.';

                action(UpdateResourceTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Add Resource';

                    trigger OnAction()
                    begin
                        AddResourceTPTE();
                    end;
                }
                action(UpdateDateTimeTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Add Start Date Time';

                    trigger OnAction()
                    begin
                        AddStartDateTimeTPTE();
                    end;
                }
                action(UpdateResourceAndStartDateTimeTPTE)
                {
                    ApplicationArea = All;
                    Caption = 'Add Resource & Start Date Time';

                    trigger OnAction()
                    begin
                        AddResourceAndStartTimeTPTE();
                    end;
                }
            }
        }

        addlast(Promoted)
        {
            group("TextExtTPE_Promoted TPTE")
            {
                Caption = 'Text Ext.';

                actionref(UpdateResourceTPTE_Promoted; UpdateResourceTPTE) { }
                actionref(UpdateDateTimeTPTE_Promoted; UpdateDateTimeTPTE) { }
                actionref(UpdateResourceAndStartTimeTPTE_Promoted; UpdateResourceAndStartDateTimeTPTE) { }
            }
        }
    }

    var
        JobPlanLineHelperTPTE: Codeunit "Job Plan. Line Helper TPTE";

    local procedure AddResourceTPTE()
    // var
    //     LibraryRandomLIB: Codeunit "Library - Random LIB";
    //     ResourceNo: Code[20];
    begin
        JobPlanLineHelperTPTE.AddResource(Rec);
        // if Rec."Resource Group No." = '' then
        //     exit;

        // ResourceNo := LibraryRandomLIB.FindResourceRandom(Rec."Resource Group No.");
        // if ResourceNo <> '' then begin
        //     Rec.Validate("Resource No.", ResourceNo);
        //     Rec.Modify(true);
        // end;
    end;

    local procedure AddStartDateTimeTPTE()
    // var
    //     StartDateTime: DateTime;
    begin
        JobPlanLineHelperTPTE.AddStartDateTime(Rec);
        // if Rec."Resource Group No." = '' then
        //     exit;

        // StartDateTime := CreateDateTime(Today(), 090000T);
        // Rec.Validate("Starting Date Time", StartDateTime);
        // Rec.Modify(true);
    end;

    local procedure AddResourceAndStartTimeTPTE()
    // var
    //     LibraryRandomLIB: Codeunit "Library - Random LIB";
    //     ResourceNo: Code[20];
    //     StartDateTime: DateTime;
    begin
        JobPlanLineHelperTPTE.AddResourceAndStartTime(Rec);
        // if Rec."Resource Group No." = '' then
        //     exit;

        // ResourceNo := LibraryRandomLIB.FindResourceRandom(Rec."Resource Group No.");
        // if ResourceNo <> '' then
        //     Rec.Validate("Resource No.", ResourceNo);

        // StartDateTime := CreateDateTime(Today(), 090000T);
        // Rec.Validate("Starting Date Time", StartDateTime);
        // Rec.Modify(true);
    end;
}
