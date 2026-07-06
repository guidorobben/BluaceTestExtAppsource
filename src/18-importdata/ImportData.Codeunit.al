codeunit 83908 "Import Data TPTE"
{
    Permissions =
        tabledata AllObj = R,
        tabledata "Import Data TPTE" = R,
        tabledata User = R;
    TableNo = "Import Data TPTE";

    trigger OnRun()
    var
        Cat: Decimal;
    begin
        OnBeforeRun(Rec); //A1080
        ClearLastError();

        //Filename
        Cat := 0;
        if not Rec.Get(0, Cat) then
            Error(FileNotFoundErr);
        FileNameClient := Rec.Value;

        //ImportAction
        Cat := 0;
        if not Rec.Get(-1, Cat) then
            Error(ImportActionNotFoundErr);

        //FIXME Convert to Enum
        Evaluate(ImportAction, Rec.Value);

        //SkipNonExistingFields
        Cat := 1;
        if not Rec.Get(-1, Cat) then
            Error(SkipFieldsNotFoundErr);

        Evaluate(SkipNonExistingFields, Rec.Value);

        // BVImportSupport.UploadFile(FileNameClient, ServerFileName); //A1115
        OpenFile(ServerFileName);
        ProcessFile(Rec);

        //LogFile
        //A1070 MESSAGE(Text10000);
    end;

    var
        RecRef: RecordRef;
        SkipNonExistingFields: Boolean;
        ImportAction: Enum "Import Action TPTE";
        // FileMgt: Codeunit "File Management";
        // XmlMgt: Codeunit "XML Management BVE";
        XMLFileStream: InStream;
        FileNotFoundErr: Label 'Filename not found.';
        FileNotValidErr: Label 'File is not valid.';
        ImportActionNotFoundErr: Label 'Import Action not found.';
        SkipFieldsNotFoundErr: Label 'Skip Fields not found.';
        Table0Err: Label 'TableID = 0';
        // Text10000: Label 'File imported.';
        Text10005Err: Label 'Field %1 does not exists in table %2.', Comment = '%1=FieldID, %2=TableID';
        Text20004Err: Label 'Field = 0';
        FileNameClient: Text[250];
        ServerFileName: Text[250];
        // XMLDocMgt: Codeunit "XMLDocument Management TPTE";
        // BVImportSupport: Codeunit "BV Import Support TPTE";
        XMLDoc: XmlDocument;
        DocumentElement: XmlElement;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRun(var BVDataImport: Record "Import Data TPTE")
    begin
    end;

    local procedure ProcessFile(var Rec: Record "Import Data TPTE")
    // var
    //     NodeList: XmlNodeList;
    begin
        Rec.Reset();
        Rec.SetRange(Import, true);
        if Rec.FindSet() then
            repeat
                if Rec."Table ID" <> 0 then
                    ProcessTable(Rec."Table ID");
            until Rec.Next() = 0;
    end;

    // local procedure UploadFile(FileName: Text)
    // begin
    //     ServerFileName := FileMgt.UploadFileSilent(FileName);
    // end;

    local procedure OpenFile(FileName: Text)
    begin
        //TODO OPENFILE
        FileName := FileName;
        // XMLDocMgt.OpenFile(FileName, XmlDoc);
        // XMLDoc := XMLDoc.XmlDocument;
        // XMLDoc.Load(FileName);
        // DocumentElement := XMLDoc.DocumentElement;

        XmlDocument.ReadFrom(XMLFileStream, XMLDoc);

        XMLDoc.GetRoot(DocumentElement);
        if DocumentElement.Name() <> 'BVSetup' then
            Error(FileNotValidErr);
    end;

    local procedure ProcessTable(TableID: Integer)
    var
        Element: XmlElement;
        Node: XmlNode;
        NodeList: XmlNodeList;
    // I: Integer;
    begin
        //XMLElement := XMLDocument.GetElementById('"98"');
        // Element := DocumentElement.SelectSingleNode('/BVSetup/Section/Table[@id="' + Format(TableID) + '"]');
        XMLDoc.SelectSingleNode('/BVSetup/Section/Table[@id="' + Format(TableID) + '"]', Node);
        // XMLDoc.SelectSingleNode('/BVSetup/Info', Node);

        if OpenTable(TableID) = false then
            exit;

        NodeList := Node.AsXmlElement().GetChildElements('Record');
        // for I := 0 to NodeList.Count - 1 do begin
        foreach Node in NodeList do begin
            // Element := NodeList.Item(I);
            Element := Node.AsXmlElement();
            ProcessRecord(Element);
        end;

        CloseTable();
    end;

    local procedure ProcessRecord(var pXMLElement: XmlElement)
    var
        // I: Integer;
        ElementText: Text;
        Element: XmlElement;
        Node: XmlNode;
        NodeList: XmlNodeList;
    begin
        InitRecord();

        // NodeList := pXMLElement.ChildNodes;
        NodeList := pXMLElement.GetChildElements();
        // for I := 0 to NodeList.Count - 1 do begin     
        // I := NodeList.count;

        foreach Node in NodeList do begin
            // Element := NodeList.Item(I);
            ElementText := Node.AsXmlElement().Name();
            Element := Node.AsXmlElement();
            ProcessField(Element);
        end;

        InsertRecord();
    end;

    local procedure ProcessField(var pXMLElement: XmlElement)
    var
        TempDateFormula: DateFormula;
        TempRecordID: RecordId;
        FieldRef: FieldRef;
        TempBoolean: Boolean;
        TempDate: Date;
        TempDateTime: DateTime;
        TempDecimal: Decimal;
        TempDuration: Duration;
        TempGUID: Guid;
        FieldID: Integer;
        TempInteger: Integer;
        ElementValue: Text;
        FieldIDText: Text[30];
        FieldType: Text[30];
        TempTime: Time;
    // TB: Record TempBlob;
    // OStream: OutStream;
    // Bytes: Array;
    // Convert: Convert;
    // MemoryStream: MemoryStream;
    begin
        FieldIDText := CopyStr(pXMLElement.Name(), 1, 30);
        FieldIDText := CopyStr(FieldIDText, 2);
        Evaluate(FieldID, FieldIDText);

        if FieldID = 0 then
            Error(Text20004Err);       // C003

        if RecRef.FieldExist(FieldID) = false then
            if SkipNonExistingFields then //A890
                exit                        //A890
            else
                Error(Text10005Err, Format(FieldID), Format(RecRef.Number()) + ' - ' + RecRef.Caption());

        FieldRef := RecRef.Field(FieldID);
        FieldType := Format(FieldRef.Type());
        ElementValue := pXMLElement.InnerText();

        //Import Company -> COMPANYNAME
        //IF VarElementValue = VarSelectedCompany THEN
        //  VarElementValue := COMPANYNAME;

        //Veld
        case UpperCase(FieldType) of
            'INTEGER':
                begin
                    Evaluate(TempInteger, ElementValue, 9);
                    FieldRef.Value := TempInteger;
                end;
            'OPTION':
                begin
                    Evaluate(TempInteger, ElementValue, 9);
                    FieldRef.Value := TempInteger;
                end;
            'BOOLEAN':
                begin
                    Evaluate(TempBoolean, ElementValue, 9);
                    FieldRef.Value := TempBoolean;
                end;
            'DECIMAL':
                begin
                    Evaluate(TempDecimal, ElementValue, 9);
                    FieldRef.Value := TempDecimal;
                end;
            'DATE':
                begin
                    Evaluate(TempDate, ElementValue, 9);
                    FieldRef.Value := TempDate;
                end;
            'DATEFORMULA':
                begin
                    Evaluate(TempDateFormula, ElementValue, 9);
                    FieldRef.Value := TempDateFormula;
                end;
            'TIME':
                begin
                    Evaluate(TempTime, ElementValue, 9);
                    FieldRef.Value := TempTime;
                end;
            'DATETIME':
                begin
                    Evaluate(TempDateTime, ElementValue, 9);
                    FieldRef.Value := TempDateTime;
                end;
            'BLOB':
                ProcessBlob(FieldRef, ElementValue);
            'DURATION':
                begin
                    Evaluate(TempDuration, ElementValue, 9);
                    FieldRef.Value := TempDuration;
                end;
            'GUID':
                begin
                    Evaluate(TempGUID, ElementValue, 9);
                    FieldRef.Value := TempGUID;
                end;
            'RECORDID': //A890
                begin
                    Evaluate(TempRecordID, ElementValue, 9);
                    FieldRef.Value := TempRecordID;
                end;
            'MEDIASET':
                ; //Ignore
            // begin
            //     //NIETS DOEN VOOR NU
            // end;
            else
                FieldRef.Value := ElementValue;
        end;

        Clear(FieldRef);

    end;

    local procedure ProcessBlob(var FieldRef: FieldRef; var ElementValue: Text)
    var
        TB: Codeunit "Temp Blob";
    // OStream: OutStream;
    // Bytes: Array;
    // Convert: Convert;
    // MemoryStream: MemoryStream;
    begin
        ElementValue := ElementValue;
        if ElementValue <> '' then begin
            // Bytes := Convert.FromBase64String(ElementValue);
            // MemoryStream := MemoryStream.MemoryStream(Bytes);
            // TB.CreateOutstream(OStream);
            // MemoryStream.WriteTo(OStream);
            TB.ToFieldRef(FieldRef);
            TB.ToFieldRef(FieldRef);
            // FieldRef.Value := TB.Blob;
        end;
    end;

    local procedure InitRecord()
    begin
        RecRef.Init();
    end;


    procedure OpenTable(TableID: Integer) Result: Boolean
    var
        // VarTableIDText: Text[30];
        // FieldRefLoc: FieldRef;
        lrObject: Record AllObj;
    begin
        CloseTable();
        //VarTableIDText := ElmTable.GetAttribute('ID');
        //EVALUATE(VarTableID, VarTableIDText);
        if TableID = 0 then
            Error(Table0Err);

        if DoNotImportTable(TableID) then
            exit;

        lrObject.SetRange("Object Type", lrObject."Object Type"::TableData, lrObject."Object Type"::Table);
        lrObject.SetRange("Object ID", TableID);
        //if not lrObject.FindFirst() then
        //    exit;
        // lrObject.FindFirst();

        RecRef.Open(TableID);
        RecRef.Reset();

        //UpdateStatusIndexText(3, RecRef.CAPTION); //Caption op statuscherm

        //6: Import first delete
        if ImportAction = ImportAction::"Insert (Delete first)" then
            RecRef.DeleteAll(false);

        /*
        IF VarDeleteFirst THEN BEGIN
          {
          CASE RecRef.NUMBER OF
            DATABASE::"Component Value", DATABASE::Table11020708:
              BEGIN
                FieldRefLoc := RecRef.FIELD(1); //Level
                FieldRefLoc.SETFILTER('0');
              END;
            DATABASE::Table11020734:
              BEGIN
                FieldRefLoc := RecRef.FIELD(1);
                FieldRefLoc.SETFILTER('4|5'); //"Component" & "Component Help"
              END;
          END;
          }
          RecRef.DELETEALL;
        END;
        
        IF VarIgnoreNotEmpty THEN BEGIN
          IF RecRef.FIND('-') THEN BEGIN
            //Tabel is niet leeg
            IF FuncIsDataPerCompany(RecRef.NUMBER) THEN
              ERROR(Text10006 + ':\\' + Text10001, RecRef.NUMBER);
        
            FuncAddErrorText(STRSUBSTNO(Text10002, FORMAT(RecRef.NUMBER)));
            EXIT(FALSE); //Overslaan
          END;
        END;
        */

        Result := true;

    end;


    procedure CloseTable()
    begin
        RecRef.Close();
        Clear(RecRef);
    end;


    procedure InsertRecord()
    begin
        case ImportAction of
            //0: //Insert
            ImportAction::Insert:
                begin
                    if InsertRecordSpecial() then //A986
                        exit;                     //A986

                    if not RecRef.Insert(false) then; //IGNORE
                    //  FuncAddErrorText(Text10010);
                end;
            // 3:
            ImportAction::Modify:
                ; //Modify
            // 6: //Insert (Delete First);
            ImportAction::"Insert (Delete first)":
                if not RecRef.Insert(false) then;//IGNORE
        end;
    end;

    local procedure DoNotImportTable(TableID: Integer) Result: Boolean
    begin
        //Deze tabellen niet importeren ondanks in import
        // if TableID in [9701,//A1100 DATABASE::"Cue Setup",
        //                Database::"BouwVision Object Log BVE",
        //                Database::"Import/Export Log",
        //                Database::"Report Log"
        //               ] then
        //     exit(true);
        TableID := 0;
        Result := false;
    end;

    local procedure InsertRecordSpecial(): Boolean
    var
        User: Record User;
        FRef: FieldRef;
        UserName: Code[50];
    begin
        //USER
        if RecRef.Number() = 2000000120 then begin
            //Skip als record al bestaat
            FRef := RecRef.Field(2);
            UserName := Format(FRef.Value());
            User.SetRange("User Name", UserName);
            if not User.IsEmpty() then
                exit(true);
        end;
    end;

    procedure SetFileStream(var FileStream: InStream)
    begin
        XMLFileStream := FileStream;
    end;
}