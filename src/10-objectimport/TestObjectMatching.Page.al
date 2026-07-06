page 83865 "Test Object Matching TPTE"
{
    ApplicationArea = AreaCBLC;
    Caption = 'Test Object Matching';
    DeleteAllowed = false;
    PageType = Worksheet;
    Permissions =
        tabledata "Object Import Object CBLC" = RI,
        tabledata "Object CBLC" = R;
    SourceTable = "Object Import Object CBLC";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(Matching)
            {
                Caption = 'Matching';

                field(MatchingTextControl; MatchingText)
                {
                    Caption = 'Matching Text';
                }
                field(PostCodeControl; PostCode)
                {
                    Caption = 'Post Code';
                }
                field(CountryRegionCodeControl; CountryRegionCode)
                {
                    Caption = 'Country/Region Code';
                }
                field(MinimumMatchingThresholdControl; MinimumMatchingThreshold)
                {
                    Caption = 'Minimum Matching Threshold';
                }
                field(qGramControl; qGram)
                {
                    Caption = 'qGram';
                }
                field(RemoveSpacesControl; RemoveSpaces)
                {
                    Caption = 'Remove Spaces';
                }
            }
            repeater(General)
            {
                Editable = false;

                field("Object No."; Rec."Object No.") { }
                field(Description; Rec.Description) { }
                field("Object Status Code"; Rec."Object Status Code") { }
                field(Address; Rec.Address) { }
                field("Address 2"; Rec."Address 2") { }
                field("Post Code"; Rec."Post Code") { }
                field(City; Rec.City) { }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    Visible = false;
                }
                field("Main Object No."; Rec."Main Object No.") { }
                field("Matching Score"; Rec."Matching Score") { }
                field("Matching Count"; Rec."Matching Count") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(MatchAddress)
            {
                Caption = 'Match';

                trigger OnAction()
                begin
                    Match();
                end;
            }
        }
        area(Navigation)
        {
            action(Card)
            {
                Caption = 'Card';
                Image = Edit;
                RunObject = page "Object Card CBLC";
                RunPageLink = "No." = field("Object No.");
                ToolTip = 'Open the object card.';
            }
        }
        area(Promoted)
        {
            actionref(Card_Promoted; Card) { }
            actionref(MatchAddress_Promoted; MatchAddress) { }
        }
    }

    var
        RemoveSpaces: Boolean;
        CountryRegionCode: Code[10];
        PostCode: Code[20];
        MinimumMatchingThreshold: Decimal;
        qGram: Integer;
        DoubleTextFilterTok: Label '@%1|%2', Locked = true;
        MatchingText: Text;


    trigger OnOpenPage()
    begin
        MinimumMatchingThreshold := 50;
        CountryRegionCode := 'NL';
        RemoveSpaces := true;
        qGram := 2;
    end;

    local procedure Match()
    begin
        Rec.Reset();
        Rec.DeleteAll(false);

        FindObjectsOnSameAddress();
        if Rec.FindFirst() then; //pointer
    end;

    procedure FindObjectsOnSameAddress()
    var
        Object: Record "Object CBLC";
        MatchingScore: Decimal;
        NullGuid: Guid;
        MatchingCount: Integer;
        ObjectCount: Integer;
    begin
        if PostCode = '' then
            exit;

        Object.SetRange("Country/Region Code", CountryRegionCode);
        // Object.SetFilter("Post Code", StrSubstNo(TextFilterTok, ObjectImportLine."Post Code"));
        Object.SetFilter("Post Code", StrSubstNo(DoubleTextFilterTok, PostCode, DelChr(PostCode, '=', ' ')));
        if Object.FindSet() then
            repeat
                CalculateObjectMatchingScores(MatchingText, Object, MatchingScore, MatchingCount);
                if MatchingScore >= MinimumMatchingThreshold then begin
                    AddObjectToObjectImport(Rec, NullGuid, Object, MatchingScore, MatchingCount);
                    ObjectCount += 1;
                end;
            until Object.Next() = 0;

        // ObjectImportLine."No. of Objects" := ObjectCount;

        // if ObjectImportLine."Use Existing Object" then
        //     exit;

        // if ObjectCount = 0 then
        //     ObjectImportLine."Replacement Object No." := '';
    end;

    local procedure CalculateObjectMatchingScores(AddressMatch: Text; Object: Record "Object CBLC"; var MatchingScore: Decimal; var MatchingCount: Integer)
    var
        LibraryMatchingLIB: Codeunit "Library - Matching LIB";
        ObjectAdress: Text;
    begin
        Clear(MatchingScore);
        Clear(MatchingCount);

        // ImportLineAddress := AddressMatch;
        ObjectAdress := Object.Address;

        if RemoveSpaces then begin
            AddressMatch := DelChr(AddressMatch, '=', ' ');
            ObjectAdress := DelChr(ObjectAdress, '=', ' ');
        end;

        MatchingScore := LibraryMatchingLIB.CalculateMatchingScore(AddressMatch, ObjectAdress, qGram);
        MatchingCount += 1;

        MatchingScore := Round(MatchingScore);
    end;

    procedure AddObjectToObjectImport(var TempObjectImportObject: Record "Object Import Object CBLC" temporary; SourceSystemID: Guid; Object: Record "Object CBLC"; MatchingScore: Decimal; MatchingCount: Integer)
    begin
        TempObjectImportObject.Init();
        TempObjectImportObject."Source System ID" := SourceSystemID;
        TempObjectImportObject."Object No." := Object."No.";
        TempObjectImportObject.Description := Object.Description;
        TempObjectImportObject."Object Status Code" := Object."Object Status Code";
        TempObjectImportObject.Address := Object.Address;
        TempObjectImportObject."Address 2" := Object."Address 2";
        TempObjectImportObject."Post Code" := Object."Post Code";
        TempObjectImportObject.City := Object.City;
        TempObjectImportObject."Main Object No." := Object."Main Object No.";
        TempObjectImportObject."Matching Score" := MatchingScore;
        TempObjectImportObject."Matching Count" := MatchingCount;
        TempObjectImportObject.Insert(false);
    end;
}