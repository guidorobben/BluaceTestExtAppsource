codeunit 83872 "Import File Read TPTE"
{
    Permissions =
        tabledata "Import Data TPTE" = RIM;

    var
        // ImportHelper: Codeunit "Import Helper TPTE";
        XmlDocMgt: Codeunit "XMLDocument Management TPTE";
        SectionDescriptions: array[100] of Text;
        XMLDoc: XmlDocument;
    // SectionText: array[30] of Text;
    // SectionCount: Integer;

    internal procedure LoadStream(var FileInStream: InStream; var DataImport: Record "Import Data TPTE"; var SectionCount: Integer; var SectionText: array[30] of Text)
    var
        IsHandled: Boolean;
    begin
        OnBeforeLoadStream(DataImport, IsHandled);
        DoLoadStream(FileInStream, DataImport, SectionCount, SectionText, IsHandled);
        OnAfterLoadStream(DataImport);
    end;

    local procedure DoLoadStream(var FileInStream: InStream; var DataImport: Record "Import Data TPTE"; var SectionCount: Integer; var SectionText: array[30] of Text; IsHandled: Boolean)
    var
        DocumentElement: XmlElement;
    begin
        if IsHandled then
            exit;

        OpenFile(FileInStream, DocumentElement);
        GetFileInfo(DataImport);
        BuildSections(DataImport, DocumentElement, SectionCount, SectionText);
    end;

    local procedure OpenFile(var FileInStream: InStream; var DocumentElement: XmlElement)
    var
        NotValidFileErr: Label 'Not a valid Import-File.';
    begin
        // Result := 
        XmlDocument.ReadFrom(FileInStream, XMLDoc);
        XMLDoc.GetRoot(DocumentElement);

        if DocumentElement.Name() <> 'BVSetup' then
            Error(NotValidFileErr);

        // ImportHelper.OpenFile(FileInStream, FileName, XMLDoc, DocumentElement); //A1070
    end;

    local procedure GetFileInfo(var DataImport: Record "Import Data TPTE")
    var
        I: Integer;
        CaptionText: Text[30];
        Element: XmlElement;
        Node: XmlNode;
        NodeList: XmlNodeList;
    begin
        XMLDoc.SelectSingleNode('/BVSetup/Info', Node);
        NodeList := Node.AsXmlElement().GetChildElements();

        foreach Node in NodeList do begin
            I += 1;
            Element := Node.AsXmlElement();
            CaptionText := XmlDocMgt.GetAttribute(Node, 'Caption');
            AddSection(DataImport, 0, I + 1, Element.Name(), CaptionText, Element.InnerText(), true);
        end;
    end;

    local procedure BuildSections(var DataImport: Record "Import Data TPTE"; var DocumentElement: XmlElement; var SectionCount: Integer; var SectionText: array[30] of Text)
    var
        ImportHelper: Codeunit "Import Helper TPTE";
    begin
        ImportHelper.BuildSections(DataImport, DocumentElement);
        ImportHelper.GetSectionInfo(SectionDescriptions, SectionText, SectionCount);
    end;

    local procedure AddSection(var DataImport: Record "Import Data TPTE"; SectionName: Integer; Cat: Decimal; SettingName: Text[50]; NewDescription: Text[50]; NewValue: Text[250]; Show: Boolean)
    var
        InsertRec: Boolean;
    begin
        if not DataImport.Get(SectionName, Cat) then begin
            DataImport.Init();
            InsertRec := true;
        end;

        DataImport.Section := SectionName;
        DataImport.Category := Cat;
        DataImport.Name := SettingName;
        DataImport.Description := NewDescription;
        DataImport.Value := NewValue;
        DataImport.Show := Show;

        if InsertRec then
            DataImport.Insert(false)
        else
            DataImport.Modify(false);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLoadStream(var DataImport: Record "Import Data TPTE"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLoadStream(var DataImport: Record "Import Data TPTE")
    begin
    end;
}