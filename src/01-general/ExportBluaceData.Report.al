report 83900 "Export Bluace Data TPTE"
{
    ApplicationArea = All;
    Caption = 'Export Bluace Data';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(InitExport; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending);
            MaxIteration = 1;

            trigger OnAfterGetRecord()
            begin
                SetupData();
                CreateDocument();
                BuildInfo();
            end;
        }
        dataitem(Export1; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending);
            MaxIteration = 1;

            trigger OnAfterGetRecord()
            begin
                case WhatToExport of
                    1:
                        ExportSetup();
                    2:
                        ExportPostCode();
                    3:
                        ExportDevelopment();
                    4:
                        ExportWorkFlow();
                    else
                        CurrReport.Skip();
                end;

                CloseStatusWindow();
            end;
        }
        dataitem(ExportObject; AllObj)
        {
            DataItemTableView = sorting("Object Type", SystemId) order(ascending) where("Object Type" = const(Table));
            RequestFilterFields = "Object ID";
            RequestFilterHeading = 'Objects';
            column(ReportForNavId_11002105; 11002105) { }

            trigger OnAfterGetRecord()
            begin
                AddSectionObject(ExportObject);
                UpdateStatusWindowHeader();
            end;

            trigger OnPostDataItem()
            begin
                CloseStatusWindow();
            end;

            trigger OnPreDataItem()
            begin
                if WhatToExport <> 100 then
                    CurrReport.Break();

                if ExportObject.GetFilters() = '' then
                    Error(Text10003Lbl);

                OpenStatusWindow2(CustomLbl, ExportObject.Count());
                AddSectionObjectsHeader();
                UpdateStatusWindowHeader();
            end;
        }
        // dataitem(ExportTableInfo; "Table Information")
        // {
        //     DataItemTableView = sorting("Company Name", "Table No.") order(ascending) where("No. of Records" = filter(> 0));
        //     column(ReportForNavId_11002101; 11002101)
        //     {
        //     }

        //     trigger OnAfterGetRecord()
        //     begin
        //         if CN = '666' then begin
        //             AddSectionTableInfoHeader;
        //             CN := ExportTableInfo."Company Name"; //Blanco als het goed is
        //         end;

        //         if ExportTableInfo."Company Name" <> CN then begin
        //             AddSectionTableInfoHeaderComp;
        //             CN := ExportTableInfo."Company Name"; //Company name
        //         end;

        //         AddSectionTableInfo(ExportTableInfo);
        //         UpdateStatusWindowHeader();
        //     end;

        //     trigger OnPostDataItem()
        //     begin
        //         CloseStatusWindow;
        //     end;

        //     trigger OnPreDataItem()
        //     begin
        //         if WhatToExport <> 101 then
        //             CurrReport.Break;

        //         SetFilter("Company Name", '%1|%2', '', COMPANYNAME);
        //         //SETFILTER("Table No.", '18|23|11002000..11002010');
        //         OpenStatusWindow2(Text30000, ExportTableInfo.Count);
        //         //AddSectionTableInfoHeader;
        //         UpdateStatusWindowHeader();

        //         CN := '666';
        //     end;
        // }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("File Name"; FileOnDisk)
                    {
                        ApplicationArea = All;
                        AssistEdit = true;
                        Caption = 'Filename';

                        trigger OnAssistEdit()
                        begin
                            // FileOnDisk := BluaceFunctions.SaveFileDialog(Text002Lbl, '', 4, Text003Lbl, 0);
                            FileOnDisk := 'c:\Temp\propties.xml';
                        end;
                    }
                    field(ExportModeControl; ExportMode)
                    {
                        ApplicationArea = All;
                        Caption = 'Export';
                        OptionCaption = ',,,Setup,,,Development,,,Post Code,,,WorkFlow,,,Objects,,,Table Info';

                        // trigger OnAssistEdit()
                        // begin
                        //     Page.Run(Page::"Export Table Filter");
                        // end;

                        trigger OnValidate()
                        begin
                            ValidateExportMode();
                        end;
                    }
                    field(ImportDefaultModeControl; ImportDefaultMode)
                    {
                        ApplicationArea = All;
                        Caption = 'Default Mode';
                    }
                    field(IncludeFieldNamesControl; IncludeFieldNames)
                    {
                        ApplicationArea = All;
                        Caption = 'Include Field Names';
                    }
                    field(UseFieldFilterControl; UseFieldFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Use Field Filter';
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnInitReport()
    begin
        ExportMode := ExportMode::Setup;
        IncludeFieldNames := true;
        IncludeFieldInfo := true;
        //FileOnDisk := 'd:\setup\79.xml';
    end;

    trigger OnPostReport()
    begin
        SaveFile();
        Message(FileCreatedMsg, FileOnDisk);
    end;

    trigger OnPreReport()
    begin
        if FileOnDisk = '' then
            Error(Text10002Err);

        SetWhatToExport();
    end;

    var
        // r: Report: "Export Consolidation"
        // BluaceFunctions: Codeunit "Bluace Functions TPTE";
        DialogMgt: Codeunit "Dialog Management TPTE";
        // FileMgt: Codeunit "File Management";
        // XMLDOMMgt: Codeunit "XML DOM Management";
        XMLDOcMgt: Codeunit "XMLDocument Management TPTE";
        ImportDefaultMode: Boolean;
        IncludeFieldInfo: Boolean;
        // Text20002: Label 'Workflow is not supported in this version of NAV.';
        IncludeFieldNames: Boolean;
        IsStatusOpen: Boolean;
        UseFieldFilter: Boolean;
        WhatToExport: Integer;
        CustomLbl: Label 'Custom';
        DevelopmentLbl: Label 'Development';
        FileCreatedMsg: Label 'File %1 created.', Comment = '%1=Filename';
        PostCodeLbl: Label 'Post Code';
        SectionsLbl: Label 'Sections';
        SetupLbl: Label 'Setup';
        TableDoesNotExistErr: Label 'Table %1 does not exist.', Comment = '%1=Table id';
        // Text002Lbl: Label 'Open';
        // Text003Lbl: Label 'Text Files(*.xml)|*.xml|All Files (*.*)|*.*';
        Text10002Err: Label 'You forgot to enter a filename.';
        Text10003Lbl: Label 'Enter Object Filter.';
        WorkFlowLbl: Label 'Work Flow';
        ExportMode: Option ,,,Setup,,,Development,,,"Post Code",,,WorkFlow,,,Objects,,,"Table Info";
        FileOnDisk: Text;
        XMLDoc: XmlDocument;
        DocumentElement: XmlElement;
        ObjectHeaderElement: XmlNode;

    local procedure SetupData()
    begin
    end;

    local procedure CreateDocument()
    begin
        XmlDocument.ReadFrom('<?xml version="1.0" encoding="UTF-8"?><BVSetup></BVSetup>', XMLDoc);
        XMLDoc.GetRoot(DocumentElement);
    end;

    local procedure SaveFile()
    var
        TB: Codeunit "Temp Blob";
        IS: InStream;
        // FileNameOnServer: Text[260];
        OS: OutStream;
    //p: page "Property Values BBLC"
    // p: page "Employee Picture"
    // FileManagement: codeunit "File Management"
    begin
        // FileNameOnServer := FileMgt.ServerTempFileName('');

        TB.CreateOutStream(OS, TextEncoding::UTF8);
        XMLDoc.WriteTo(OS);

        // // XMLDoc.Save(FileNameOnServer);
        // xmldoc.WriteTo(os);
        // // XmlDocument.save
        TB.CreateInStream(IS, TextEncoding::UTF8);
        DownloadFromStream(IS, '', '', '', FileOnDisk);
        // FileMgt.DownloadToFile(FileNameOnServer, FileOnDisk);

        // Clear(XMLDoc);
    end;


    procedure ExportTable(var Node: XmlNode; TableID: Integer; ParentTableID: Integer; ParCompany: Text[80]; ShowInImport: Boolean; TableCaption: Text[50])
    var
        AllObjWithCaption: Record AllObjWithCaption;
        // ExportTableFilter: Record "Export Table Filter";
        RecRefLoc: RecordRef;
        NewNode: XmlNode;
    // NewElement: XmlElement;
    // e: XmlElement;
    begin
        UpdateStatusWindowSub();

        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
        AllObjWithCaption.SetRange("Object ID", TableID);
        if AllObjWithCaption.IsEmpty() then
            Error(TableDoesNotExistErr, TableID);

        RecRefLoc.Open(TableID, false, ParCompany);

        if not RecRefLoc.ReadPermission() then
            exit;

        //IF RecRefLoc.COUNT = 0 THEN
        //  EXIT;

        XMLDOcMgt.AddNode(Node, 'Table', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'id', Format(TableID));
        XMLDOcMgt.AddAttribute(NewNode, 'Name', Format(RecRefLoc.Name()));
        if TableCaption = '' then
            XMLDOcMgt.AddAttribute(NewNode, 'Caption', Format(RecRefLoc.Caption()))
        else
            XMLDOcMgt.AddAttribute(NewNode, 'Caption', TableCaption);
        XMLDOcMgt.AddAttribute(NewNode, 'ShowInImport', Format(ShowInImport, 0, 9));
        //XMLDOCMgt.AddAttribute(NewNode, 'ImportDefault', 'true');
        if ImportDefaultMode then
            XMLDOcMgt.AddAttribute(NewNode, 'ImportDefault', 'true')
        else
            XMLDOcMgt.AddAttribute(NewNode, 'ImportDefault', 'false');
        XMLDOcMgt.AddAttribute(NewNode, 'ParentId', Format(ParentTableID, 0, 9));

        /*
        IF ParTable = FilterTable THEN BEGIN
          FuncSetFilterField(RecRefLoc);
        END;
        */

        //FuncStatusWindowMax(4, RecRefLoc.COUNT);
        XMLDOcMgt.AddAttribute(NewNode, 'RecordCount', Format(RecRefLoc.Count()));
        //GR XMLDOCMgt.AddAttribute(NewNode, 'Version', Format(RecObjectLoc."Version List"));
        //GR XMLDOCMgt.AddAttribute(NewNode, 'Date', Format(RecObjectLoc.Date));
        //GR XMLDOCMgt.AddAttribute(NewNode, 'Time', Format(RecObjectLoc.Time));

        AddKey(NewNode, RecRefLoc);

        //Toevoegen veldnamen
        if IncludeFieldNames then
            AddFieldNames(NewNode, RecRefLoc);

        /*
        IF (VarExportTables = VarExportTables::"Setup") OR
           (VarExportTables = VarExportTables::"Setup (Recurring)") THEN BEGIN
          CASE RecRefLoc.NUMBER OF
            DATABASE::"Component Value", DATABASE::Table11020708:
              BEGIN
                FieldRefLoc := RecRefLoc.FIELD(1); //Level
                FieldRefLoc.SETFILTER('0');
              END;
            DATABASE::Table11020734:
              BEGIN
                FieldRefLoc := RecRefLoc.FIELD(1);
                FieldRefLoc.SETFILTER('4|5'); //"Component" & "Component Help"
              END;
          END;
        END;
        */

        //A1070
        // if UseFieldFilter then begin
        //     if ExportTableFilter.Get(TableID) then begin
        //         XMLDOCMgt.AddAttribute(NewNode, 'Filter', Format(ExportTableFilter."Field Filter"));
        //         BVFunctions.FilterRecRef(RecRefLoc, Format(ExportTableFilter."Field Filter"), 0);
        //         XMLDOCMgt.AddAttribute(NewNode, 'FilterRecordCount', Format(RecRefLoc.Count));
        //     end;
        // end;
        //A1070

        if RecRefLoc.Count() = 0 then
            exit;

        if RecRefLoc.FindSet() then
            repeat
                ExportRecord(NewNode, RecRefLoc);

            //FuncPreSave(1); //Record

            /*
            IF (ArrayRecordCount[4] MOD ArrayUpdateCount[4] = 0) OR
               (ArrayRecordCount[4] MOD ArrayUpdateCount[4] > ArrayUpdateCount[4]) THEN BEGIN
              FuncUpdateStatusIndexInteger(4, ArrayRecordCount[4]);
            END;
            */
            until RecRefLoc.Next() = 0;

        RecRefLoc.Close();
        Clear(RecRefLoc);

        //--NewLine(NewNode);
        //--AppendText(NewNode, FuncSpaces(ParIndent + 2));
        //--AppendText(ParParent, FuncSpaces(ParIndent));

        Clear(NewNode);

    end;


    procedure ExportRecord(Node: XmlNode; var RecRefLoc: RecordRef)
    var
        FieldRefLoc: FieldRef;
        I: Integer;
        FieldName: Text[30];
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        //ArrayRecordCount[4] += 1;
        XMLDOcMgt.AddNode(Node, 'Record', '', NewNode);

        for I := 1 to RecRefLoc.FieldCount() do begin
            FieldRefLoc := RecRefLoc.FieldIndex(I);
            if UpperCase(Format(FieldRefLoc.Class())) = 'NORMAL' then begin
                FieldName := Format(FieldRefLoc.Name());
                //VarFieldName := Functions.FuncXMLTagName(VarFieldName, 0 );
                if FieldName = '' then
                    FieldName := 'FIELD' + Format(Format(FieldRefLoc.Number()));

                FieldName := 'F' + Format(FieldRefLoc.Number());
                //AppendAttribute(ParParent, VarFieldName, FORMAT(FieldRefLoc.NAME));

                case UpperCase(Format(FieldRefLoc.Type())) of
                    'BLOB':
                        ; //IGNORE
                    // begin
                    //     // AddBlob(NewNode, FieldRefLoc, FieldName);
                    // end;
                    else
                        XMLDOcMgt.AddNode(NewNode, FieldName, Format(FieldRefLoc.Value(), 0, 9), NewNode2);
                end;
                //AppendAttribute(NewNode2, 'ID', FORMAT(FieldRefLoc.NUMBER));
            end;
        end;

        //--NewLine(NewNode);
        //--AppendText(NewNode, FuncSpaces(3));

        Clear(FieldRefLoc);
        Clear(NewNode);
        Clear(NewNode2);
    end;


    procedure AddFieldNames(Node: XmlNode; var RecRefLoc: RecordRef)
    var
        FieldRefLoc: FieldRef;
        I: Integer;
        FieldName: Text[30];
        NewNode1: XmlNode;
        NewNode2: XmlNode;
    begin
        //IF VarWriteFieldNames = FALSE THEN
        //  EXIT;
        XMLDOcMgt.AddNode(Node, 'FieldNames', '', NewNode1);

        for I := 1 to RecRefLoc.FieldCount() do begin
            FieldRefLoc := RecRefLoc.FieldIndex(I);
            if UpperCase(Format(FieldRefLoc.Class())) = 'NORMAL' then begin
                FieldName := 'F' + Format(FieldRefLoc.Number());
                //XMLDOCMgt.AddAttribute(XMLNode, FieldName, FORMAT(FieldRefLoc.NAME));
                XMLDOcMgt.AddNode(NewNode1, FieldName, Format(FieldRefLoc.Name()), NewNode2);
                if IncludeFieldInfo then begin
                    XMLDOcMgt.AddAttribute(NewNode2, 'Caption', Format(FieldRefLoc.Caption()));
                    XMLDOcMgt.AddAttribute(NewNode2, 'Type', Format(FieldRefLoc.Type()));
                    XMLDOcMgt.AddAttribute(NewNode2, 'Length', Format(FieldRefLoc.Length()));
                end;
            end;
        end;

        Clear(FieldRefLoc);
    end;

    local procedure BuildInfo()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    // ApplMgt: Codeunit "ApplicationManagement BVE";
    // BVVersionFunctions: Codeunit "BouwVision Version Functions";
    begin
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Info', '', NewNode);

        XMLDOcMgt.AddNode(NewNode, 'CreatedBy', Format(UserId()), NewNode2);
        XMLDOcMgt.AddAttribute(NewNode2, 'Caption', 'Aangemaakt door');

        XMLDOcMgt.AddNode(NewNode, 'CreatedOn', Format(Today(), 0, 9), NewNode2);
        XMLDOcMgt.AddAttribute(NewNode2, 'Caption', 'Aangemaakt op');

        XMLDOcMgt.AddNode(NewNode, 'CreatedAt', Format(Time(), 0, 9), NewNode2);
        XMLDOcMgt.AddAttribute(NewNode2, 'Caption', 'Aangemaakt om');

        XMLDOcMgt.AddNode(NewNode, 'CompanyName', CompanyName(), NewNode2);
        XMLDOcMgt.AddAttribute(NewNode2, 'Caption', 'Bedrijfsnaam');

        // XMLDocMgt.AddNode(NewNode, 'ServerName', Format(BVFunctions.GetServerName), NewNode2);
        // XMLDOCMgt.AddAttribute(NewNode2, 'Caption', 'Servernaam');

        // XMLDocMgt.AddNode(NewNode, 'DatabaseName', Format(BVFunctions.GetDatabaseName), NewNode2);
        // XMLDOCMgt.AddAttribute(NewNode2, 'Caption', 'Database naam');

        // XMLDocMgt.AddNode(NewNode, 'BVVersion', Format(BVFunctions.DetermineBVBuild2(false)), NewNode2);
        // XMLDOCMgt.AddAttribute(NewNode2, 'Caption', 'BV versie');

        // XMLDocMgt.AddNode(NewNode, 'BVVersionDate', CheckBVVersion.GetBuildDate, NewNode2);
        // XMLDOCMgt.AddAttribute(NewNode2, 'Caption', 'BV versie datum');

        // XMLDocMgt.AddNode(NewNode, 'DocumentCapture', CheckBVVersion.DetermineDCBuild, NewNode2);
        // XMLDOCMgt.AddAttribute(NewNode2, 'Caption', 'Document Capture');

        // XMLDocMgt.AddNode(NewNode, 'DocumentCreator', CheckBVVersion.DetermineDCRBuild, NewNode2);
        // XMLDOCMgt.AddAttribute(NewNode2, 'Caption', 'Document Creator');

        // XMLDocMgt.AddNode(NewNode, 'NAVVersion', Format(BVVersionFunctions.NAVVersion), NewNode2);
        // XMLDOCMgt.AddAttribute(NewNode2, 'Caption', 'NAV versie');

        // XMLDocMgt.AddNode(NewNode, 'DatabaseVersion', Format(ApplMgt.ApplicationVersion), NewNode2);
        // XMLDOCMgt.AddAttribute(NewNode2, 'Caption', 'Database versie');

        // XMLDocMgt.AddNode(NewNode, 'DatabaseBuild', Format(ApplMgt.ApplicationBuild, 0, 9), NewNode2);
        // XMLDOCMgt.AddAttribute(NewNode2, 'Caption', 'Database Build');
    end;

    local procedure ExportSetup()
    begin
        OpenStatusWindow(SetupLbl, SectionsLbl, 14, 0);
        AddSectionUsers();
        AddSectionGeneral();
        AddSectionFinancial();
        AddSectionSalesMarketing();
        AddSectionPurchase();
        AddSectionResources();
        AddSectionJobs();
        AddSectionAssignment();
        AddSectionBuyerMgt();
        AddSectionEquipment();
        AddSectionDocumentApproval();
        AddSectionDigital();
        AddSectionExternal();
        UpdateStatusWindowHeader();
    end;

    local procedure ExportPostCode()
    begin
        OpenStatusWindow(PostCodeLbl, SectionsLbl, 2, 0);
        AddSectionPostCode();
        UpdateStatusWindowHeader();
        //CloseStatusWindow;
    end;

    local procedure ExportDevelopment()
    begin
        OpenStatusWindow(DevelopmentLbl, SectionsLbl, 3, 0);
        AddSectionDevelopment();
        AddSectionCustInfo();
        AddSectionCustLicense(); //A1060
        UpdateStatusWindowHeader();
        //CloseStatusWindow;
    end;

    local procedure ExportWorkFlow()
    begin
        OpenStatusWindow(WorkFlowLbl, SectionsLbl, 1, 0);
        UpdateStatusWindowHeader();
        AddSectionWorkFlow();
        UpdateStatusWindowHeader();
        //CloseStatusWindow;
    end;

    local procedure AddHeader(var Node: XmlNode; TableID: Integer; ParentTableID: Integer; ParCompany: Text[80]; ShowInImport: Boolean; Name: Text[50]; Caption: Text[50])
    var
        NewNode: XmlNode;
    begin
        ParCompany := ParCompany;
        XMLDOcMgt.AddNode(Node, 'Table', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'id', Format(TableID));
        XMLDOcMgt.AddAttribute(NewNode, 'Name', Name);
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', Caption);
        XMLDOcMgt.AddAttribute(NewNode, 'ShowInImport', Format(ShowInImport, 0, 9));
        if ImportDefaultMode then
            XMLDOcMgt.AddAttribute(NewNode, 'ImportDefault', 'true')
        else
            XMLDOcMgt.AddAttribute(NewNode, 'ImportDefault', 'false');
        XMLDOcMgt.AddAttribute(NewNode, 'ParentId', Format(ParentTableID, 0, 9));
    end;

    local procedure AddSectionFinancial()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        UpdateStatusWindowHeader();
        //Financieel
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'Financial Setup');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Financieel');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over financieel', NewNode2);

        SetMaxSub(4);
        AddHeader(NewNode, 0, 0, '', true, 'Financial Setup', 'Financieel');
        ExportTable(NewNode, Database::"General Ledger Setup", 0, '', true, '');
        ExportTable(NewNode, Database::"Source Code Setup", 0, '', true, '');
        ExportTable(NewNode, Database::"General Posting Setup", 0, '', true, '');
        ExportTable(NewNode, Database::"VAT Product Posting Group", 0, '', true, '');
    end;

    local procedure AddSectionSalesMarketing()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        UpdateStatusWindowHeader();
        //Verkoop
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'Sales Setup');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Verkoop');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Verkoop', NewNode2);

        SetMaxSub(2);
        AddHeader(NewNode, 0, 0, '', true, 'Sales Setup', 'Verkoop');
        ExportTable(NewNode, 311, 0, '', true, '');
        ExportTable(NewNode, 5079, 0, '', true, '');
    end;

    local procedure AddSectionPurchase()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        UpdateStatusWindowHeader();
        //Inkoop
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'Purchase Setup');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Inkoop');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Inkoop', NewNode2);

        SetMaxSub(3);
        AddHeader(NewNode, 0, 0, '', true, 'Purchase Setup', 'Inkoop');
        ExportTable(NewNode, 312, 0, '', true, '');
        ExportTable(NewNode, 11002242, 0, '', true, 'Leverancier verklaringen');
        ExportTable(NewNode, 11002487, 11002242, '', true, '');
    end;

    local procedure AddSectionResources()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        UpdateStatusWindowHeader();
        //Resources
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'Resources');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Resources');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Resources', NewNode2);

        SetMaxSub(2);
        AddHeader(NewNode, 0, 0, '', true, 'Resources', 'Resources');
        ExportTable(NewNode, 152, 0, '', true, '');
        ExportTable(NewNode, 314, 0, '', true, '');
    end;

    local procedure AddSectionJobs()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        UpdateStatusWindowHeader();
        //Projecten
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'Job Setup');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Projecten');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over projecten', NewNode2);

        SetMaxSub(3);
        AddHeader(NewNode, 0, 0, '', true, 'Jobs Setup', 'Projecten');
        ExportTable(NewNode, Database::"Jobs Setup", 0, '', true, '');
        // ExportTable(NewNode, Database::"Dynamic Features Setup BVE", 0, '', true, 'Kenmerken-instellingen');
        // ExportTable(NewNode, Database::"Planning & Capacity Setup", 0, '', true, '');
    end;

    local procedure AddSectionAssignment()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        UpdateStatusWindowHeader();
        //Klusprojecten
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'Assignment Setup');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Klusprojecten');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over klusprojecten', NewNode2);

        SetMaxSub(5);
        AddHeader(NewNode, 0, 0, '', true, 'Assignment Setup', 'Klusprojecten');
        ExportTable(NewNode, 11002412, 0, '', true, '');
        ExportTable(NewNode, 11002433, 0, '', true, '');

        //Prijzenboeken
        AddHeader(NewNode, 0, 0, '', true, 'Price Agreements', 'Prijzenboeken');
        ExportTable(NewNode, 11002054, 0, '', true, '');
        ExportTable(NewNode, 11002055, 11002054, '', false, '');
        ExportTable(NewNode, 11002330, 11002054, '', false, '');
    end;

    local procedure AddSectionBuyerMgt()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        UpdateStatusWindowHeader();
        //Kopersbeheer
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'Buyers Management Setup');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Kopersbeheer');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over kopersbeheer', NewNode2);

        SetMaxSub(6);
        AddHeader(NewNode, 0, 0, '', true, 'Buyer Management Setup', 'Kopersbeheer');
        ExportTable(NewNode, 11002356, 0, '', true, ''); //Database::"Buyers Management Setup",
        ExportTable(NewNode, 11002277, 0, '', true, '');
        ExportTable(NewNode, 11002278, 11002277, '', false, '');
        ExportTable(NewNode, 11002273, 11002277, '', true, ''); //Database::"Building Category",
        // ExportTable(NewNode, Database::"Build Stage", 11002277, '', true, '');
        // ExportTable(NewNode, Database::"Buyer Discipline", 11002277, '', false, '');
    end;

    local procedure AddSectionEquipment()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        UpdateStatusWindowHeader();
        //Materieel
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'Equipment Setup');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Materieel');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Materieel', NewNode2);

        SetMaxSub(7);
        AddHeader(NewNode, 0, 0, '', true, 'Equipment Setup', 'Materieel');
        ExportTable(NewNode, 11002088, 0, '', true, '');
        ExportTable(NewNode, 11002090, 0, '', true, '');
        ExportTable(NewNode, 11002093, 0, '', true, '');
        ExportTable(NewNode, 11002091, 0, '', true, '');
        ExportTable(NewNode, 11002094, 0, '', true, '');
        ExportTable(NewNode, 11002352, 0, '', true, '');
        ExportTable(NewNode, 204, 0, '', true, '');
    end;

    local procedure AddSectionUsers()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        UpdateStatusWindowHeader();
        //User Setup

        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'User Setup');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Gebruikers');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Gebruikers', NewNode2);

        SetMaxSub(5);
        AddHeader(NewNode, 0, 0, '', true, 'Users', 'Gebruikers');
        ExportTable(NewNode, Database::"User Setup", 0, '', true, 'Gebruikers');
        ExportTable(NewNode, Database::"User Personalization", 0, '', true, '');
        ExportTable(NewNode, Database::"All Profile", Database::"User Personalization", '', false, '');

        AddHeader(NewNode, 0, 0, '', true, 'Permissions', 'Machtigingen');
        // ExportTable(NewNode, Database::"Permission Set", 0, '', true, 'Machtigingsets');
        // ExportTable(NewNode, Database::Permission, 2000000004, '', true, 'Toegangsrechten');
    end;

    local procedure AddSectionGeneral()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        UpdateStatusWindowHeader();
        //General

        //No Series
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'General');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Algemeen');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Algemeen', NewNode2);

        SetMaxSub(8);
        AddHeader(NewNode, 0, 0, '', true, 'General', 'Algemeen');
        ExportTable(NewNode, 308, 0, '', true, 'Nr.-reeksen');
        ExportTable(NewNode, 309, 308, '', false, '');
        ExportTable(NewNode, 310, 308, '', false, '');

        //Report Selection
        AddHeader(NewNode, 0, 0, '', true, 'Report Selection', 'Lijstselecties');
        ExportTable(NewNode, 77, 0, '', true, 'Lijstselecties - Standaard NAV');
        ExportTable(NewNode, 11002105, 0, '', true, 'Lijstselecties - Projecten');
        ExportTable(NewNode, 11002280, 0, '', true, 'Lijstselecties (3)');
        ExportTable(NewNode, 11002388, 0, '', true, 'Lijstselecties - Aangepast');
    end;

    local procedure AddSectionDigital()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        //Digitaal
        UpdateStatusWindowHeader();

        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'Digital');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Digitaal');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Digitale meuk', NewNode2);

        SetMaxSub(1);
        AddHeader(NewNode, 0, 0, '', true, 'Digital', 'Digital');
        ExportTable(NewNode, 409, 0, '', true, ''); //Database::"SMTP Mail Setup"
    end;

    local procedure AddSectionExternal()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        //Externe kopellingen
        UpdateStatusWindowHeader();

        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'Links');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Koppelingen');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Externe koppelingen', NewNode2);

        SetMaxSub(4);
        AddHeader(NewNode, 0, 0, '', true, 'Links', 'Koppelingen');
        // ExportTable(NewNode, Database::"Import/Export File BVE", 0, '', true, '');
        // ExportTable(NewNode, Database::"Matrix Setup", 0, '', true, '');
        // ExportTable(NewNode, Database::"SIDB Setup BVE", 0, '', true, '');
        // ExportTable(NewNode, Database::"SIDB Setup Global", 11002380, '', false, '');
    end;

    local procedure AddSectionDocumentApproval()
    var
    // NewNode: XmlNode;
    // NewNode2: XmlNode;
    begin
        //Documentgoedkeuring
        exit;
        // XMLDocMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        // XMLDOCMgt.AddAttribute(NewNode, 'Category', 'Document Approval');
        // XMLDOCMgt.AddAttribute(NewNode, 'Caption', 'Documentgoedkeuring');
        // XMLDocMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Goedkeuring', NewNode2);

        // AddHeader(NewNode, 0, 0, '', true, 'Document Approval', 'Documentgoedkeuring');
        // ExportTable(NewNode, 663, 0, '', true, '');
    end;

    local procedure AddSectionPostCode()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        //General
        UpdateStatusWindowHeader();

        //No Series
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'General');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Algemeen');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Algemeen', NewNode2);

        SetMaxSub(2);
        //Postcode
        AddHeader(NewNode, 0, 0, '', true, 'General', 'Algemeen');
        ExportTable(NewNode, 225, 0, '', true, '');
        ExportTable(NewNode, 11407, 225, '', false, '');
    end;

    local procedure AddSectionDevelopment()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        UpdateStatusWindowHeader();

        //Development
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'Development');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Development');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Algemeen', NewNode2);

        //A-nrs
        SetMaxSub(5);
        AddHeader(NewNode, 0, 0, '', true, 'Development', 'Ontwikkeling');
        ExportTable(NewNode, 75000, 0, '', true, '');
        ExportTable(NewNode, 75002, 75000, '', false, '');
        ExportTable(NewNode, 75003, 75000, '', false, '');
        ExportTable(NewNode, 75005, 75000, '', false, '');
        ExportTable(NewNode, 75006, 75000, '', false, '');
        ExportTable(NewNode, 75011, 75000, '', false, '');
        ExportTable(NewNode, 75021, 75000, '', false, '');
    end;

    local procedure AddSectionCustInfo()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        UpdateStatusWindowHeader();

        //KlantInfo
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'Customer Info');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Klantinfo');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Algemeen', NewNode2);

        //Klant Info
        SetMaxSub(9);
        AddHeader(NewNode, 0, 0, '', true, 'Customer Info', 'Klantinfo');
        ExportTable(NewNode, 75012, 0, '', true, '');
        ExportTable(NewNode, 75013, 75012, '', false, '');
        ExportTable(NewNode, 75014, 75012, '', false, '');
        ExportTable(NewNode, 75015, 75012, '', false, '');
        ExportTable(NewNode, 75016, 75012, '', false, '');
        ExportTable(NewNode, 75017, 75012, '', false, '');
        ExportTable(NewNode, 75018, 75012, '', false, '');
        ExportTable(NewNode, 75019, 75012, '', false, '');
        ExportTable(NewNode, 75020, 75012, '', false, '');
        ExportTable(NewNode, 75021, 75012, '', false, ''); //A1060
    end;

    local procedure AddSectionCustLicense()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        //A1060
        UpdateStatusWindowHeader();

        //KlantInfo
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'Customer License');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Klantlicenties');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Algemeen', NewNode2);

        //Klant Info
        SetMaxSub(4);
        AddHeader(NewNode, 0, 0, '', true, 'Customer License', 'Klantlicentie');
        ExportTable(NewNode, 75102, 0, '', true, '');
        ExportTable(NewNode, 75100, 75102, '', false, '');
        ExportTable(NewNode, 75101, 75102, '', false, '');
        ExportTable(NewNode, 75103, 75102, '', false, '');
    end;

    local procedure AddSectionWorkFlow()
    var
        NewNode: XmlNode;
        NewNode2: XmlNode;
    begin
        //Workflow
        UpdateStatusWindowHeader();

        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', NewNode);
        XMLDOcMgt.AddAttribute(NewNode, 'Category', 'Workflow');
        XMLDOcMgt.AddAttribute(NewNode, 'Caption', 'Werkstromen');
        XMLDOcMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Werkstromen', NewNode2);
        XMLDOcMgt.AddNode(NewNode, 'NAV', '10', NewNode2);

        SetMaxSub(18);
        //Werkstroom
        AddHeader(NewNode, 0, 0, '', true, 'Workflow', 'Werkstromen');
        ExportTable(NewNode, 1500, 0, '', true, '');
        ExportTable(NewNode, 1501, 0, '', true, '');
        ExportTable(NewNode, 1502, 0, '', true, '');
        ExportTable(NewNode, 1504, 0, '', true, '');
        ExportTable(NewNode, 1505, 0, '', true, '');
        ExportTable(NewNode, 1506, 0, '', true, '');
        ExportTable(NewNode, 1507, 0, '', true, '');
        ExportTable(NewNode, 1508, 0, '', true, '');

        AddHeader(NewNode, 0, 0, '', true, 'Workflow Events', 'Werkstroomgebeurtenissen');
        ExportTable(NewNode, 1520, 0, '', true, '');
        ExportTable(NewNode, 1522, 0, '', true, '');
        ExportTable(NewNode, 1523, 0, '', true, '');
        ExportTable(NewNode, 1524, 0, '', true, '');
        ExportTable(NewNode, 1525, 0, '', true, '');
        ExportTable(NewNode, 1526, 0, '', true, '');

        AddHeader(NewNode, 0, 0, '', true, 'Workflow Archive', 'Werkstroom archief');
        ExportTable(NewNode, 1530, 0, '', true, '');
        ExportTable(NewNode, 1531, 0, '', true, '');

        AddHeader(NewNode, 0, 0, '', true, 'Workflow User Group', 'Werkstroomgebruikersgroepen');
        ExportTable(NewNode, 1540, 0, '', true, '');
        ExportTable(NewNode, 1541, 0, '', true, '');
    end;

    local procedure AddSectionObjectsHeader()
    var
        NewNode2: XmlNode;
    begin
        //Workflow
        XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', ObjectHeaderElement);
        XMLDOcMgt.AddAttribute(ObjectHeaderElement, 'Category', 'Custom');
        XMLDOcMgt.AddAttribute(ObjectHeaderElement, 'Caption', 'Selectie');
        XMLDOcMgt.AddNode(ObjectHeaderElement, 'SupportText', 'Dit is een export van een selectie van Objecten', NewNode2);
        //XMLDocMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Algemeen', '',NewNode2);
        AddHeader(ObjectHeaderElement, 0, 0, '', true, 'Tables', 'Tabellen');
    end;

    local procedure AddSectionObject(var lrObject: Record AllObj)
    var
    // NewNode: XmlNode;
    // NewNode2: XmlNode;
    begin
        ExportTable(ObjectHeaderElement, lrObject."Object ID", 0, '', true, '');
        UpdateStatusWindowHeader();
    end;

    // local procedure AddSectionTableInfoHeader()
    // var
    //     NewNode2: XmlNode;
    // begin
    //     //Workflow
    //     XMLDOcMgt.AddNodeToElement(DocumentElement, 'Section', '', ObjectHeaderElement);
    //     XMLDOcMgt.AddAttribute(ObjectHeaderElement, 'Category', 'Custom');
    //     XMLDOcMgt.AddAttribute(ObjectHeaderElement, 'Caption', 'Selectie');
    //     XMLDOcMgt.AddNode(ObjectHeaderElement, 'SupportText', 'Dit is een export van een selectie van Tabel Informatie', NewNode2);
    //     //XMLDocMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Algemeen', '',NewNode2);
    //     AddHeader(ObjectHeaderElement, 0, 0, '', true, 'Tables', 'Tabellen');
    // end;

    // local procedure AddSectionTableInfoHeaderComp()
    // var
    // // NewNode2: XmlNode;
    // begin
    //     //Workflow
    //     //XMLDocMgt.AddNodeToElement(DocumentElement, 'Section', '', '',ObjectHeaderElement);
    //     //XMLDOCMgt.AddAttribute(ObjectHeaderElement, 'Category', 'Custom');
    //     //XMLDOCMgt.AddAttribute(ObjectHeaderElement, 'Caption', 'Selectie');
    //     //XMLDocMgt.AddNode(ObjectHeaderElement, 'SupportText', 'Dit is een export van een selectie van Tabel Informatie', '',NewNode2);
    //     //XMLDocMgt.AddNode(NewNode, 'SupportText', 'Leuk zo een verhaal over Algemeen', '',NewNode2);
    //     AddHeader(ObjectHeaderElement, 0, 0, '', true, 'Company Tables', 'Bedrijf Tabellen');
    // end;

    // local procedure AddSectionTableInfo(var TableInfo: Record "Table Information")
    // var
    //     lrObject: Record "Object";
    // begin
    //     lrObject.SetRange(Type, lrObject.Type::Table);
    //     lrObject.SetRange(ID, TableInfo."Table No.");
    //     lrObject.FindFirst;

    //     if IsValidExportObject(lrObject) then
    //         ExportTable(ObjectHeaderElement, lrObject.ID, 0, '', true, '');
    //     UpdateStatusWindowHeader();
    // end;

    local procedure OpenStatusWindow(HeaderText: Text[255]; SubText: Text[255]; MaxHeaderValue: Integer; MaxSubValue: Integer)
    begin
        DialogMgt.OpenStatusWindowHeaderSub(HeaderText, SubText, MaxHeaderValue, MaxSubValue);
        IsStatusOpen := true;
    end;

    local procedure OpenStatusWindow2(HeaderText: Text[100]; MaxHeaderValue: Integer)
    begin
        DialogMgt.OpenStatusWindow(HeaderText, MaxHeaderValue);
        IsStatusOpen := true;
    end;

    local procedure UpdateStatusWindowHeader()
    begin
        if not IsStatusOpen then
            exit;

        DialogMgt.UpdateStatusWindow();
    end;

    local procedure UpdateStatusWindowSub()
    begin
        if not IsStatusOpen then
            exit;

        DialogMgt.UpdateStatusWindow2(2);
    end;

    local procedure SetMaxSub(MaxValue: Integer)
    begin
        if not IsStatusOpen then
            exit;

        DialogMgt.SetMax(0, MaxValue);
        DialogMgt.ClearCounter(2);
        DialogMgt.UpdateStatusWindowCounter2(2, 0);
    end;

    local procedure CloseStatusWindow()
    begin
        if not IsStatusOpen then
            exit;

        DialogMgt.CloseStatusWindow();
        IsStatusOpen := false;
    end;

    local procedure SetWhatToExport()
    begin
        case ExportMode of
            ExportMode::Setup:
                WhatToExport := 1; //Normal
            ExportMode::Development:
                WhatToExport := 3; //Development
            ExportMode::"Post Code":
                WhatToExport := 2; //Postcode
            ExportMode::WorkFlow:
                WhatToExport := 4; //Workflow
            ExportMode::Objects:
                WhatToExport := 100; //Custom
            ExportMode::"Table Info":
                WhatToExport := 101; //Tabel Info
        end;
    end;

    // local procedure AddBlob(var NewNode: XmlNode; var FieldRefLoc: FieldRef; FieldName: Text[30])
    // var
    // // NewNode2: XmlNode;
    // // TB: Record TempBlob;
    // // IStream: InStream;
    // // Bytes: Array;
    // // Convert: Convert;
    // // MemoryStream: MemoryStream;
    // begin
    //     // FieldRefLoc.CalcField;
    //     // TB.Blob := FieldRefLoc.Value;
    //     // if TB.Blob.Hasvalue then begin
    //     //     TB.Blob.CreateInstream(IStream);
    //     //     MemoryStream := MemoryStream.MemoryStream();
    //     //     CopyStream(MemoryStream, IStream);
    //     //     Bytes := MemoryStream.GetBuffer();
    //     //     XMLDocMgt.AddNode(NewNode, FieldName, Convert.ToBase64String(Bytes),  NewNode2);
    //     // end else
    //     //     XMLDocMgt.AddNode(NewNode, FieldName, '',  NewNode2);
    // end;

    local procedure ValidateExportMode()
    begin
        // if BVFunctions.NAVVersion = 8 then begin
        //     if ExportMode = Exportmode::WorkFlow then begin
        //         Error(Text20002);
        //     end;
        // end;

        if ExportMode = ExportMode::"Table Info" then
            IncludeFieldNames := false;
    end;

    local procedure AddKey(var XMLNode: XmlNode; var RecRefLoc: RecordRef)
    var
        FieldRefLoc: FieldRef;
        I: Integer;
        KeyRecRef: KeyRef;
        FieldName: Text[30];
        NewNode1: XmlNode;
        NewNode2: XmlNode;
    begin
        XMLDOcMgt.AddNode(XMLNode, 'Key', '', NewNode1);

        KeyRecRef := RecRefLoc.KeyIndex(1);

        for I := 1 to KeyRecRef.FieldCount() do begin
            FieldRefLoc := RecRefLoc.FieldIndex(I);
            FieldName := 'F' + Format(FieldRefLoc.Number());
            XMLDOcMgt.AddNode(NewNode1, FieldName, Format(FieldRefLoc.Name()), NewNode2);
            if IncludeFieldInfo then begin
                XMLDOcMgt.AddAttribute(NewNode2, 'Caption', Format(FieldRefLoc.Caption()));
                XMLDOcMgt.AddAttribute(NewNode2, 'Type', Format(FieldRefLoc.Type()));
                XMLDOcMgt.AddAttribute(NewNode2, 'Length', Format(FieldRefLoc.Length()));
            end;
        end;
    end;

    // local procedure IsValidExportObject(var lrObject: Record AllObj): Boolean
    // begin
    //     if lrObject."Object ID" in [225, 405, 8614, 8615, 8616, 11406, 99000757, 2000000053, 2000000068, 2000000120] then
    //         exit(false);

    //     // if StrPos(lrObject."Version List", 'NAV') > 0 then
    //     //     exit(true);

    //     // if StrPos(lrObject."Version List", 'BV') > 0 then
    //     //     exit(true);
    // end;
}

