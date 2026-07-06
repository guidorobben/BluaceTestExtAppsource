codeunit 83909 "Import Helper TPTE"
{
    var
        XMLDocumentManagement: Codeunit "XMLDocument Management TPTE";
        SectionCount: Integer;
        NotValidFileErr: Label 'Not a valid Import-File.';
        SectionDescriptions: array[100] of Text;
        SectionText: array[30] of Text;

    procedure IsLocalFileSystemAccessible(): Boolean
    var
        ClientTypeManagement: Codeunit "Client Type Management";
    begin
        exit(ClientTypeManagement.GetCurrentClientType() = ClientType::Windows);
    end;

    procedure UploadFile(FileName: Text; var ServerFileName: Text)
    begin
        //A1115
        if not IsLocalFileSystemAccessible() then begin
            ServerFileName := FileName;
            exit;
        end;

        //BV+ 
        //TODO Fix
        // ServerFileName := FileMgt.UploadFileSilent(FileName);
    end;


    procedure OpenFile(FileName: Text; var XMLDoc: XmlDocument; var DocumentElement: XmlElement)
    // var
    //     IS: InStream;
    //     F: file;
    begin
        XMLDocumentManagement.OpenFile(FileName, XMLDoc);
        // XMLDocument := XMLDocument.XmlDocument;
        // f.Open(FileName);
        // f.CreateInStream(is);

        // XMLDocument.ReadFrom(is, xmldoc);
        XMLDoc.GetRoot(DocumentElement);

        if DocumentElement.Name() <> 'BVSetup' then
            Error(NotValidFileErr);
    end;


    procedure OpenFile(FileInStream: InStream; FileName: Text; var XMLDoc: XmlDocument; var DocumentElement: XmlElement)
    begin
        XmlDocument.ReadFrom(FileInStream, XMLDoc);
        XMLDoc.GetRoot(DocumentElement);

        if DocumentElement.Name() <> 'BVSetup' then
            Error(NotValidFileErr);
    end;

    procedure OpenFile2(FileName: Text; var XMLDoc: XmlDocument; var DocumentElement: XmlElement) Result: Boolean
    var
    // IS: InStream;
    // F: file;
    begin

        // f.Open(FileName);
        // f.CreateInStream(is);

        // XMLDocument.ReadFrom(is, xmldoc);
        XMLDocumentManagement.OpenFile(FileName, XMLDoc);
        XMLDoc.GetRoot(DocumentElement);


        if DocumentElement.Name() <> 'BVSetup' then
            exit(false);

        Result := true;
    end;

    procedure BuildSections(var TempBluaceDataImport: Record "Import Data TPTE" temporary; var DocumentElement: XmlElement)
    var
        I: Integer;
        Element: XmlElement;
        Node: XmlNode;
        NodeList: XmlNodeList;
    begin
        NodeList := DocumentElement.GetChildElements('Section');
        SectionCount := NodeList.Count();
        foreach Node in NodeList do begin
            I += 1;
            Element := Node.AsXmlElement();
            BuildSection(TempBluaceDataImport, Element, I);
        end;

        NodeList := DocumentElement.GetChildElements('Table');
    end;

    procedure BuildSection(var BluaceDataImport: Record "Import Data TPTE" temporary; var Element: XmlElement; SectionIndex: Integer)
    var
        TempSectionBluaceDataImport: Record "Import Data TPTE" temporary;
        // XMLElement2: XmlElement;
        // E: XmlElement;
        // I: Integer;
        Index: Decimal;
        Node2: XmlNode;
        NodeList: XmlNodeList;
    begin
        // SectionDescriptions[SectionIndex] := XmlMgt.GetNodeValue(Element, './/SupportText', false);
        SectionDescriptions[SectionIndex] := XMLDocumentManagement.GetNodeValue(Element.AsXmlNode(), './/SupportText', false);

        //Get Tables
        NodeList := Element.GetChildElements('Table');
        // for I := 0 to NodeList.Count - 1 do begin
        foreach Node2 in NodeList do begin
            // NodeList.Get(I, Node2);
            //IF XMLElement.HasChildNodes THEN BEGIN

            TempSectionBluaceDataImport.Init();
            TempSectionBluaceDataImport.Section := SectionIndex;
            TempSectionBluaceDataImport.Description := CopyStr(XMLDocumentManagement.GetAttribute(Node2, 'Caption'), 1, 50);
            TempSectionBluaceDataImport.Show := XMLDocumentManagement.GetAttributeAsBoolean(Node2, 'ShowInImport');
            TempSectionBluaceDataImport.Records := XMLDocumentManagement.GetAttributeAsInteger(Node2, 'RecordCount');
            TempSectionBluaceDataImport."Table ID" := XMLDocumentManagement.GetAttributeAsInteger(Node2, 'id');
            TempSectionBluaceDataImport."Parent Table ID" := XMLDocumentManagement.GetAttributeAsInteger(Node2, 'ParentId');
            TempSectionBluaceDataImport.Import := XMLDocumentManagement.GetAttributeAsBoolean(Node2, 'ImportDefault');

            Index += 0.001;
            TempSectionBluaceDataImport.Category := Index;
            AddSection(BluaceDataImport, TempSectionBluaceDataImport, SectionText); //A1070
            Index := TempSectionBluaceDataImport.Category;
        end;
    end;


    procedure AddSection(var Rec: Record "Import Data TPTE" temporary; var BLCSection: Record "Import Data TPTE" temporary; var pSectionText: array[30] of Text)
    var
        CategoryIndex: Decimal;
    begin
        Rec.Init();

        Rec.Section := BLCSection.Section;
        CategoryIndex := BLCSection.Category;
        Rec.Category := CategoryIndex;

        Rec.Description := BLCSection.Description;
        Rec.Records := BLCSection.Records;
        Rec."Table ID" := BLCSection."Table ID";
        Rec."Parent Table ID" := BLCSection."Parent Table ID";
        Rec.Show := BLCSection.Show;
        Rec.Import := BLCSection.Import;

        if Rec."Table ID" = 0 then begin
            Rec.Header := true;
            CategoryIndex := Round(CategoryIndex, 1);
            CategoryIndex += 1;
            Rec.Category := CategoryIndex;
        end;

        if Rec.Category = 0 then
            Rec.Header := true;
        Rec.Insert(false);

        if CategoryIndex = 0 then
            pSectionText[Rec.Section] := Rec.Description;

        //waarden terug
        BLCSection.Category := Rec.Category;
    end;


    procedure AddSection2(var Rec: Record "Import Data TPTE" temporary; SectionName: Integer; Cat: Decimal; SettingName: Text[50]; Description: Text[50]; Value: Text[250]; Show: Boolean)
    var
        InsertRec: Boolean;
    begin
        if not Rec.Get(SectionName, Cat) then begin
            Rec.Init();
            InsertRec := true;
        end;

        Rec.Section := SectionName;
        Rec.Category := Cat;
        Rec.Name := SettingName;
        Rec.Description := Description;
        Rec.Value := Value;
        Rec.Show := Show;

        if InsertRec then
            Rec.Insert(false)
        else
            Rec.Modify(false);
    end;

    procedure GetSectionInfo(var SectionDescriptions: array[100] of Text; var SectionText: array[30] of Text; var SectionCount: Integer)
    begin
        CopyArray(SectionDescriptions, SectionDescriptions, 1);
        CopyArray(SectionText, SectionText, 1);
        SectionCount := SectionCount;
    end;
}