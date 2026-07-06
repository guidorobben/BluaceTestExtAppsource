page 83902 "Import Data TPTE"
{
    ApplicationArea = All;
    Caption = 'Import Data';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = NavigatePage;
    SourceTable = "Import Data TPTE";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(Start)
            {

                InstructionalText = 'Select File:';
                ShowCaption = false;
                Visible = StepStart;
                label(Control11002113)
                {
                    CaptionClass = Format(Category2[1]);
                }
                field(FileType; FileType)
                {
                    Caption = 'FileType';
                }
                field(FileOnDisk; FileOnDisk)
                {
                    Caption = 'Filename';
                    ShowMandatory = true;

                    trigger OnAssistEdit()
                    begin
                        FileOnLookup();
                    end;

                    trigger OnValidate()
                    begin
                        FileOnValidate();
                    end;
                }
                field(Resource; ResourceName)
                {
                    Caption = 'Resource';

                    trigger OnAssistEdit()
                    var
                        FileNameLoc: Text[260];
                    begin
                        FileNameLoc := SelectResource();
                        if FileNameLoc <> '' then begin
                            ResourceName := FileNameLoc;
                            GetInfo := false;
                            LoadResource();
                            SetFileName();
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        LoadResource();
                        SetFileName();
                    end;
                }
                field(ImportAction; ImportAction)
                {
                    Caption = 'Action';

                    trigger OnValidate()
                    begin
                        SetImportAction();
                    end;
                }
                field(SkipNonExistingFields; SkipNonExistingFields)
                {
                    Caption = 'Skip Missing Fields';

                    trigger OnValidate()
                    begin
                        SetSkipFields();
                    end;
                }
                repeater(Control11002126)
                {
                    field(Description0; Rec.Description)
                    {
                        Editable = false;
                        StyleExpr = LineStyle0;
                    }
                    field(Value; Rec.Value)
                    {
                        Editable = false;
                        StyleExpr = LineStyle0;
                    }
                    field(Warning; Rec.Warning)
                    {
                        Editable = false;
                        Visible = false;
                    }
                }
            }
            group(Step1)
            {
                ShowCaption = false;

                Visible = Step1Visible;
                label(Control11002118)
                {
                    CaptionClass = Format(SectionDescription);
                    Style = Strong;
                    StyleExpr = true;
                }
                label(Control11002114)
                {
                    CaptionClass = Format(SectionHeader);
                }
                repeater(Control11002119)
                {
                    field(Description; Rec.Description)
                    {
                        Caption = 'Description';
                        Editable = false;
                        StyleExpr = LineStyle;
                    }
                    field(Import; Rec.Import)
                    {
                        Caption = 'Import';

                        trigger OnValidate()
                        begin
                            UpdateSection();
                        end;
                    }
                    field(Records; Rec.Records)
                    {
                        BlankZero = true;
                        Editable = false;
                    }
                    field(Value2; Rec.Value) { }
                    field("Table ID"; Rec."Table ID")
                    {
                        Editable = false;
                        Visible = false;
                    }
                }
            }
            group(Step2)
            {
                InstructionalText = 'Step2';
                ShowCaption = false;
                Visible = Step2Visible;

                label(Control11002115)
                {
                    CaptionClass = Format(Category2[2]);
                }
                repeater(Control11002122)
                {
                    field(Name2; Rec.Description) { }
                    field(Import2; Rec.Import) { }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // action("Bluace Info")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Bluace Info';
            //     Image = CompanyInformation;
            //     // RunObject = Page "Bluace Info BVE";
            // }
            action(Info)
            {
                Caption = 'Info';
                Image = LineDescription;

                trigger OnAction()
                var
                    BVDataImport: Record "Import Data TPTE";
                begin
                    //A1020
                    BVDataImport.CopyFilters(Rec);
                    Rec.Reset();
                    Page.RunModal(Page::"Import Info TPTE", Rec);
                    Rec.CopyFilters(BVDataImport);
                end;
            }
            action("Save import")
            {
                Caption = 'Save import';
                Enabled = HasFileName;
                Image = Save;

                trigger OnAction()
                begin
                    SaveImport();
                end;
            }
            action("Load Import")
            {
                Caption = 'Load Import';
                Enabled = HasFileName;
                Image = SaveViewAs;

                trigger OnAction()
                begin
                    LoadImport();
                end;
            }
            action(Back)
            {
                Caption = '&Back';
                Enabled = BackEnabled;
                Image = PreviousRecord;
                InFooterBar = true;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedIsBig = true;

                trigger OnAction()
                begin
                    ShowNextStep(-1);
                end;
            }
            action(Next)
            {
                Caption = '&Next';
                Enabled = NextEnabled;
                Image = NextRecord;
                InFooterBar = true;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedIsBig = true;

                trigger OnAction()
                begin
                    ShowNextStep(1);
                end;
            }
            action(Finish)
            {
                Caption = '&Finish';
                Enabled = FinishEnabled;
                Image = Approve;
                InFooterBar = true;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedIsBig = true;

                trigger OnAction()
                begin
                    ProcessImport();
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateControls();
    end;

    trigger OnOpenPage()
    begin
        ShowNextStep(0);

        OnBeforeLoadFile(FileOnDisk); //A1080
        LoadFile();
        SetFileName();
        SetImportAction();
        SetSkipFields();
    end;

    var
        ImportHelper: Codeunit "Import Helper TPTE";

        // BVObject: Record "BouwVision Object";
        // StyleExpr: Codeunit "Style Expr. Management TPTE";
        // FileMgt: Codeunit "File Management";
        // XmlMgt: Codeunit "XML Management BVE";
        XmlDocMgt: Codeunit "XMLDocument Management TPTE";
        // [InDataSet]
        BackEnabled: Boolean;
        // [InDataSet]
        FinishEnabled: Boolean;
        GetInfo: Boolean;
        // Step3Visible: Boolean;
        // Step4Visible: Boolean;
        // Step5Visible: Boolean;
        HasFileName: Boolean;
        // [InDataSet]
        NextEnabled: Boolean;
        SkipNonExistingFields: Boolean;
        Step1Visible: Boolean;
        Step2Visible: Boolean;
        StepStart: Boolean;
        // ImportAction: Option Insert,,,Modify,,,"Insert (Delete first)";
        ImportAction: Enum "Import Action TPTE";
        // XMLDoc: XmlDocument;
        // DocumentElement: XmlElement;
        FileType: Enum "Import Data File Type TPTE";
        FileInStream: InStream;
        SectionCount: Integer;
        Step: Integer;
        FileImportedMsg: Label 'File imported.';
        FileNameLbl: Label 'Filename';
        // NotValidFile: Label 'Not a valid Import-File.';
        NoRecordsSelectedErr: Label 'No records selected for import.';
        // Text003: Label 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
        SkipFieldsLbl: Label 'Skip fields';
        LineStyle: Text;
        LineStyle0: Text;
        ResourceName: Text;
        SectionDescription: Text;
        SectionDescriptions: array[100] of Text;
        SectionHeader: Text;
        // SectionTextOnPage: array[10] of Text;
        SectionText: array[30] of Text;
        Category2: array[10] of Text[30];
        // ServerFileName: Text[250];
        FileOnDisk: Text[260];

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLoadFile(var FileName: Text[260])
    begin
        //A1080
    end;

    local procedure ShowNextStep(NextStep: Integer)
    var
        NewStep: Integer;
    begin
        ResetAll();

        NewStep := (Step + NextStep);
        case NewStep of
            0: //
                ShowStep(0, false, (FileOnDisk <> ''), false);
            1: //
                ShowStep(1, true, true, true);
            //2: //
            //  BEGIN
            //    ShowStep(2,TRUE,TRUE,FALSE);
            //  END;
            2 .. 50: //
                     //      IF NewStep = 11 THEN
                     //        NewStep := 11;
                if NewStep >= SectionCount then
                    ShowStep(NewStep, true, false, true)
                else
                    ShowStep(NewStep, true, true, true);
        end;
        Step += NextStep;
        CurrPage.Update(false);
    end;

    local procedure ShowStep(NewStep: Integer; EnableBack: Boolean; EnableNext: Boolean; EnableFinish: Boolean)
    begin
        ResetAll();

        //Rec.setfilter(Category,'>0');

        case NewStep of
            0:
                begin
                    Rec.SetRange(Section, 0);
                    StepStart := true;
                end;
            1:
                begin
                    LoadFile();
                    Rec.SetRange(Show, true);
                    Rec.SetRange(Section, 1);
                    Step1Visible := true;
                end;
            //2:
            //  BEGIN
            //    Rec.SETRANGE(Section,2);
            //    Step1Visible := TRUE;
            //  END;
            2 .. 30:
                if NewStep <= SectionCount then begin
                    //SectionTextOnPage[1] := 'Wat een leuk verhaal is dit. Eens kijken hoelang ik dit kan maken. Niet zo lang gok ik.';
                    Rec.SetRange(Show, true);
                    Rec.SetRange(Section, NewStep);
                    Step1Visible := true;
                end;
        end;

        if NewStep <> 0 then begin
            SectionHeader := SectionText[NewStep];
            SectionDescription := SectionDescriptions[NewStep];
        end;

        //Buttons
        BackEnabled := EnableBack;
        NextEnabled := EnableNext;
        FinishEnabled := EnableFinish;
    end;

    local procedure ResetAll()
    begin
        StepStart := false;
        Step1Visible := false;
        Step2Visible := false;
        // Step3Visible := false;
        // Step4Visible := false;
    end;

    // local procedure BuildSections()
    // begin
    //     ImportHelper.BuildSections(Rec, DocumentElement);
    //     ImportHelper.GetSectionInfo(SectionDescriptions, SectionText, SectionCount);
    // end;

    // local procedure ___BuildSections()
    // var
    //     NodeList: XmlNodeList;
    //     Element: XmlElement;
    //     Node: XmlNode;
    //     I: Integer;
    // begin
    //     NodeList := DocumentElement.GetChildElements('Section');
    //     SectionCount := NodeList.Count;
    //     for I := 0 to NodeList.Count - 1 do begin
    //         NodeList.Get(I, Node);
    //         Element := Node.AsXmlElement();
    //         BVImportSupport.BuildSection(Rec, Element, I + 1); //A1070
    //     end;

    //     NodeList := DocumentElement.GetChildElements('Table');
    //     //MESSAGE(FORMAT(XMLNodeList.Count));
    // end;


    procedure ___BuildSection(var pXMLElement: XmlElement; SectionIndex: Integer)
    var
        TempBVSection: Record "Import Data TPTE" temporary;
        Index: Decimal;
        I: Integer;
        // Element: XmlElement;
        // XMLElement2: XmlElement;
        Node: XmlNode;
        NodeList: XmlNodeList;
    begin
        SectionDescriptions[SectionIndex] := XmlDocMgt.GetNodeValue(pXMLElement.AsXmlNode(), './/SupportText', false);

        //BuildSectionTables;
        //Get Tables
        NodeList := pXMLElement.GetChildElements('Table');
        for I := 0 to NodeList.Count() - 1 do begin
            NodeList.Get(I, Node);
            //IF XMLElement.HasChildNodes THEN BEGIN
            // XmlElement2.Attributes().Get()
            TempBVSection.Init();
            TempBVSection.Section := SectionIndex;
            TempBVSection.Description := XmlDocMgt.GetAttribute(Node, 'Caption');
            TempBVSection.Show := XmlDocMgt.GetAttributeAsBoolean(Node, 'ShowInImport');
            TempBVSection.Records := XmlDocMgt.GetAttributeAsInteger(Node, 'RecordCount');
            TempBVSection."Table ID" := XmlDocMgt.GetAttributeAsInteger(Node, 'id');
            TempBVSection."Parent Table ID" := XmlDocMgt.GetAttributeAsInteger(Node, 'ParentId');
            TempBVSection.Import := XmlDocMgt.GetAttributeAsBoolean(Node, 'ImportDefault');

            Index += 0.001;
            TempBVSection.Category := Index;
            ImportHelper.AddSection(Rec, TempBVSection, SectionText); //A1070
            Index := TempBVSection.Category;
        end;
    end;

    // local procedure ___AddSection(var BVSection: Record "BouwVision Data Import" temporary)
    // var
    //     CategoryIndex: Decimal;
    // begin
    //     Rec.Init();

    //     Rec.Section := BVSection.Section;
    //     CategoryIndex := BVSection.Category;
    //     Rec.Category := CategoryIndex;

    //     Rec.Description := BVSection.Description;
    //     Rec.Records := BVSection.Records;
    //     Rec."Table ID" := BVSection."Table ID";
    //     Rec."Parent Table ID" := BVSection."Parent Table ID";
    //     Rec.Show := BVSection.Show;
    //     Rec.Import := BVSection.Import;

    //     if Rec."Table ID" = 0 then begin
    //         Rec.Header := true;
    //         CategoryIndex := ROUND(CategoryIndex, 1);
    //         CategoryIndex += 1;
    //         Rec.Category := CategoryIndex;
    //     end;

    //     if Rec.Category = 0 then begin
    //         Rec.Header := true;
    //     end;
    //     Rec.Insert;

    //     if CategoryIndex = 0 then begin
    //         SectionText[Rec.Section] := Description;
    //     end;

    //     //waarden terug
    //     BVSection.Category := Rec.Category;
    // end;

    // local procedure AddSection2(SectionName: Integer; Cat: Integer; SettingName: Text[50]; NewDescription: Text[50]; NewValue: Text[250]; Show: Boolean)
    // var
    //     InsertRec: Boolean;
    // begin
    //     if not Rec.Get(SectionName, Cat) then begin
    //         Rec.Init();
    //         InsertRec := true;
    //     end;

    //     Rec.Section := SectionName;
    //     Rec.Category := Cat;
    //     Rec.Name := SettingName;
    //     Rec.Description := NewDescription;
    //     Rec.Value := NewValue;
    //     Rec.Show := Show;

    //     if InsertRec then
    //         Rec.Insert(false)
    //     else
    //         Rec.Modify(false);
    // end;

    local procedure UpdateControls()
    begin
        LineStyle := Format(PageStyle::Standard);
        if Rec.Header then
            LineStyle := Format(PageStyle::Strong);

        LineStyle0 := Format(PageStyle::Standard);
        if Rec.Warning then
            LineStyle0 := Format(PageStyle::Attention);
    end;

    local procedure UpdateSection()
    var
        I: Decimal;
    begin
        if Rec.Header then begin
            Rec.SetRange(Show);
            I := (Rec.Category + 1 - 0.01);
            Rec.SetRange(Category, Rec.Category, I);
            Rec.ModifyAll(Import, Rec.Import, false);
            Rec.SetRange(Category);
            Rec.SetRange(Show, true);
        end;

        UpdateChildren(Rec."Table ID");
    end;

    // local procedure OpenFile(FileName: Text)
    // begin
    //     ImportHelper.OpenFile(FileInStream, FileName, XMLDoc, DocumentElement); //A1070
    // end;

    // local procedure CloseFile()
    // begin
    // end;

    // local procedure __UploadFile(FileName: Text)
    // begin
    //     ServerFileName := FileMgt.UploadFileSilent(FileName);
    // end;

    local procedure LoadFile()
    var
        ImportFileRead: Codeunit "Import File Read TPTE";
    begin
        if FileOnDisk = '' then
            exit;

        if GetInfo then
            exit;

        ClearRec();
        GetInfo := true;

        //BVImportSupport.UploadFile(FileOnDisk, ServerFileName);
        // OpenFile(ServerFileName);
        ImportFileRead.LoadStream(FileInStream, Rec, SectionCount, SectionText);

        //Process
        // GetFileInfo();
        // // CheckFileInfo;
        // BuildSections(); //A1070

        if Rec.FindFirst() then; //IGNORE
    end;

    local procedure LoadResource()
    var
        ImportFileRead: Codeunit "Import File Read TPTE";
    begin
        if ResourceName = '' then
            exit;

        if GetInfo then
            exit;

        ClearRec();
        GetInfo := true;
        ImportFileRead.LoadStream(FileInStream, Rec, SectionCount, SectionText);
        if Rec.FindFirst() then; //IGNORE
    end;

    local procedure ProcessImport()
    var
        ImportData: Codeunit "Import Data TPTE";
    begin
        Rec.Reset();
        Rec.SetRange(Import, true);
        if Rec.FindFirst() = false then begin
            Message(NoRecordsSelectedErr);
            exit;
        end;

        Rec.Reset();
        ImportData.SetFileStream(FileInStream);
        ImportData.Run(Rec);
        // Codeunit.Run(Codeunit::"Import Bluace Data",);
        Message(FileImportedMsg);
    end;

    local procedure SaveImport()
    var
    // SaveLoad: Codeunit "Save/Load Import";
    begin
        // SaveLoad.SaveImport(Rec);
    end;

    local procedure LoadImport()
    var
    // SaveLoad: Codeunit "Save/Load Import";
    begin
        // SaveLoad.LoadImport(Rec);
    end;

    // local procedure GetFileInfo()
    // var
    //     I: Integer;
    //     CaptionText: Text[30];
    //     Element: XmlElement;
    //     Node: XmlNode;
    //     NodeList: XmlNodeList;
    // begin
    //     XMLDoc.SelectSingleNode('/BVSetup/Info', Node);
    //     NodeList := Node.AsXmlElement().GetChildElements();

    //     foreach Node in NodeList do begin
    //         I += 1;
    //         Element := Node.AsXmlElement();
    //         CaptionText := XmlDocMgt.GetAttribute(Node, 'Caption');
    //         AddSection2(0, I + 1, Element.Name, CaptionText, Element.InnerText, true);
    //     end;
    // end;

    local procedure UpdateChildren(TableID: Integer)
    begin
        if TableID = 0 then
            exit;

        Rec.SetRange("Parent Table ID", TableID);
        Rec.SetRange(Show);
        Rec.ModifyAll(Import, Rec.Import, false);
        Rec.SetRange(Show, true);
        Rec.SetRange("Parent Table ID");
    end;

    local procedure SetImportAction()
    var
    // I: Integer;
    begin
        // I := ImportAction;
        Rec.AddSection(-1, 0, 'Import Action', '', Format(ImportAction.AsInteger()), false);
    end;

    local procedure SetSkipFields()
    var
        I: Integer;
    begin
        if SkipNonExistingFields then
            I := 1;

        Rec.AddSection(-1, 1, 'Skip Fields', SkipFieldsLbl, Format(I), false);     // C003
    end;

    local procedure SetFileName()
    begin
        Rec.AddSection(0, 0, 'FileName', FileNameLbl, FileOnDisk, true);
        NextEnabled := (FileOnDisk <> '') or (ResourceName <> '');
        HasFileName := NextEnabled;
    end;

    // local procedure CheckFileInfo()
    // begin
    //     Rec.SetRange(Section, 0);
    //     if Rec.FindSet() then begin
    //         repeat
    //             case Rec.Name of
    //                 'BVVersion':
    //                     CheckBVVersion(Rec);
    //                 'NAVVersion':
    //                     CheckNAVVersion(Rec);
    //             // 'DocumentCapture':
    //             //     CheckDCW(Rec);
    //             // 'DocumentCreator':
    //             //     CheckDCR(Rec);
    //             end;
    //         until Rec.Next() = 0;
    //     end;
    // end;

    // local procedure CheckBVVersion(var Rec: Record "BouwVision Data Import")
    // var
    //     CurrBVVersion: Text[30];
    // begin
    //     CurrBVVersion := BVFunctions.DetermineBVBuild2(false);
    //     if CurrBVVersion <> Rec.Value then begin
    //         Rec.Warning := true;
    //         Modify;
    //     end;
    // end;

    // local procedure CheckNAVVersion(var Rec: Record "BouwVision Data Import")
    // var
    //     CurrNAVVersion: Integer;
    // begin
    //     CurrNAVVersion := BVVersionFunctions.NAVVersion;
    //     if Format(CurrNAVVersion) <> Value then begin
    //         Rec.Warning := true;
    //         Modify;
    //     end;
    // end;


    local procedure ClearRec()
    begin
        Rec.Reset();
        Rec.SetRange(Section, 0, 100);
        Rec.DeleteAll(false);
        Rec.Reset();
    end;

    procedure SelectFile() File: Text
    var
        AppFileFilterTok: Label 'XML Files|*.xml', Locked = true;
        FilePath: Text;
    begin
        UploadIntoStream('Select File', '', AppFileFilterTok, FilePath, FileInStream);
        exit(FilePath);
        // UploadIntoStream(DialogTitleTxt, '', AppFileFilterTxt, FilePath, FileStream);
    end;

    procedure SelectResource() File: Text
    var
        AppResourceHandler: Codeunit "App Resource Helper TPTE";
    begin
        exit(AppResourceHandler.SelectResource('*.xml', FileInStream));
    end;

    local procedure FileOnLookup()
    begin
        if FileType = FileType::File then
            FileOnDiscOnLookup()
        else
            FileResourceOnLookup();
    end;

    local procedure FileOnValidate()
    begin
        if FileType = FileType::File then
            FileOnDiscOnValidate()
        else
            FileResourceOnValidate();
    end;

    local procedure FileOnDiscOnLookup()
    var
        FileNameLoc: Text[260];
    begin
        FileNameLoc := SelectFile();//('', '', 4, Text003, 0);
        if FileNameLoc <> '' then begin
            FileOnDisk := FileNameLoc;
            GetInfo := false;
            LoadFile();
            SetFileName();
        end;
    end;

    local procedure FileResourceOnLookup()
    var
        FileNameLoc: Text[260];
    begin
        FileNameLoc := SelectResource();
        if FileNameLoc <> '' then begin
            ResourceName := FileNameLoc;
            GetInfo := false;
            LoadResource();
            SetFileName();
        end;
    end;

    local procedure FileOnDiscOnValidate()
    begin
        LoadFile();
        SetFileName();
    end;

    local procedure FileResourceOnValidate()
    begin
        LoadResource();
        SetFileName();
    end;
}