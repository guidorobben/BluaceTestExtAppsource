codeunit 83913 "XMLDocument Management TPTE"
{
    var
        ElementMissingErr: Label '%1 element is missing or empty in the attachment of %2 %3.', Comment = '%1=element, %2=Name, %3=Name2';

    procedure OpenFile(Filename: Text; var XmlDoc: XmlDocument) Result: Boolean
    var
        InStr: InStream;
    // F: File;
    begin
        // F.Open(FileName);
        // F.CreateInStream(Instr);
        Result := XmlDocument.ReadFrom(InStr, XmlDoc);
    end;

    procedure SaveToFile(Filename: Text; var XmlDoc: XmlDocument) Result: Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        OutStr: OutStream;
    begin
        TempBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
        XmlDoc.WriteTo(OutStr);

        TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
        DownloadFromStream(InStr, 'Export', '', '', Filename);
        // Message('To Do Save File');
    end;


    procedure AddElement(var ParentElement: XmlElement; Name: Text; Value: Text)
    var
        NewElement: XmlElement;
    begin
        NewElement := XmlElement.Create(Name, '', Value);
        ParentElement.Add(NewElement);
    end;

    procedure AddElement(ParentElement: XmlElement; Name: Text; Value: Text; var NewElement: XmlElement)
    // var
    // NewElement: XmlElement;
    begin
        NewElement := XmlElement.Create(Name, '', Value);
        ParentElement.Add(NewElement);
    end;

    procedure AddElement(ParentElement: XmlElement; Name: Text; Value: Text; NameSpace: Text; var NewElement: XmlElement)
    begin
        NewElement := XmlElement.Create(Name, NameSpace, Value);
        ParentElement.Add(NewElement);
    end;

    procedure AddNode(var ParentNode: XmlNode; Name: Text; Value: Text; var NewNode: XmlNode)
    var
        NewElement: XmlElement;
    begin
        NewElement := XmlElement.Create(Name, '', Value);
        ParentNode.AsXmlElement().Add(NewElement);
        NewNode := NewElement.AsXmlNode();
    end;

    procedure AddNodeToElement(var ParentElement: XmlElement; Name: Text; Value: Text; var NewNode: XmlNode)
    var
        NewElement: XmlElement;
    begin
        NewElement := XmlElement.Create(Name, '', Value);
        ParentElement.Add(NewElement);
        NewNode := NewElement.AsXmlNode();
    end;

    procedure AddNode(var ParentNode: XmlNode; Name: Text; Value: Text; NameSpace: Text; var NewNode: XmlNode)
    var
        NewElement: XmlElement;
    begin
        NewElement := XmlElement.Create(Name, NameSpace, Value);
        ParentNode.AsXmlElement().Add(NewElement);
        NewNode := NewElement.AsXmlNode();
    end;

    procedure AddNodeWithPrefix(var ParentNode: XmlNode; Name: Text; Value: Text; Prefix: Text; NameSpace: Text; var NewNode: XmlNode)
    var
        NewElement: XmlElement;
    begin
        NewElement := XmlElement.Create(Name, NameSpace, Value);
        ParentNode.AsXmlElement().Add(NewElement);
        NewNode := NewElement.AsXmlNode();
    end;

    procedure AddAttribute(var Node: XmlNode; Name: Text; Value: Text)
    begin
        Node.AsXmlElement().Attributes().Set(Name, Value);
    end;

    procedure GetAttribute(Node: XmlNode; Name: Text) Result: Text
    var
        XA: XmlAttribute;
    begin
        foreach XA in Node.AsXmlElement().Attributes() do
            if XA.Name() = Name then
                exit(XA.Value());
    end;

    procedure GetAttributeAsBoolean(Node: XmlNode; Name: Text) Result: Boolean
    var
        AttributeValue: Text;
    begin
        AttributeValue := GetAttribute(Node, Name);

        if AttributeValue <> '' then //begin
            //     if Fatal then
            //         Error(Text002, XPathExpr, '', '');
            // end else
            Evaluate(Result, AttributeValue, 9);
        // end;
    end;

    procedure GetAttributeAsInteger(Node: XmlNode; Name: Text) Result: Integer
    var
        AttributeValue: Text;
    begin
        AttributeValue := GetAttribute(Node, Name);

        if AttributeValue <> '' then// begin
            //     if Fatal then
            //         Error(Text002, XPathExpr, '', '');
            // end else
            Evaluate(Result, AttributeValue, 9);
    end;

    procedure GetAttributeAsDecimal(Node: XmlNode; Name: Text) Result: Decimal
    var
        AttributeValue: Text;
    begin
        AttributeValue := GetAttribute(Node, Name);

        if AttributeValue <> '' then //begin
            //     if Fatal then
            //         Error(Text002, XPathExpr, '', '');
            // end else
            Evaluate(Result, AttributeValue, 9);
    end;

    procedure GetElementValue(RootElement: XmlElement; NodePath: Text[80]; Fatal: Boolean): Text[250]
    var
        Text002Err: Label 'Error %1 %2 %3.', Comment = '%1=1, %2=2, %3=3';
        FoundElement: XmlElement;
        FoundNode: XmlNode;
    begin
        //A124
        // if IsNull(RootNode) then
        // exit('');

        RootElement.SelectSingleNode(NodePath, FoundNode);
        FoundElement := FoundNode.AsXmlElement();
        case true of
            IsEmpty(FoundElement):
                case Fatal of
                    true:
                        Error(Text002Err, NodePath, '', '');
                    false:
                        exit;
                end;
            FoundElement.InnerText() = '':
                case Fatal of
                    true:
                        Error(Text002Err, NodePath, '', '');
                    false:
                        exit;
                end;
        end;

        exit(CopyStr(FoundElement.InnerText(), 1, 250));
    end;

    procedure GetNodeValue(RootNode: XmlNode; NodePath: Text[80]; Fatal: Boolean): Text[250]
    var
        EmptyErr: Label 'Error %1 %2 %3.', Comment = '%1=1, %2=2, %3=3';
        FoundElement: XmlElement;
        FoundNode: XmlNode;
    begin
        //A124
        // if IsNull(RootNode) then
        // exit('');

        RootNode.SelectSingleNode(NodePath, FoundNode);
        FoundElement := FoundNode.AsXmlElement();
        case true of
            IsEmpty(FoundElement):
                case Fatal of
                    true:
                        Error(EmptyErr, NodePath, '', '');
                    false:
                        exit;
                end;
            FoundElement.InnerText() = '':
                case Fatal of
                    true:
                        Error(EmptyErr, NodePath, '', '');
                    false:
                        exit;
                end;
        end;

        exit(CopyStr(FoundElement.InnerText(), 1, 250));
    end;

    procedure GetNodeValueAsInteger(RootNode: XmlNode; NodePath: Text[80]; Fatal: Boolean) Result: Integer
    var
        NodeValue: Text[250];
    begin
        NodeValue := GetNodeValue(RootNode, NodePath, Fatal);
        if NodeValue = '' then begin
            if Fatal then
                Error(ElementMissingErr, NodePath, '', '');
        end else
            Evaluate(Result, NodeValue, 9);
    end;

    procedure GetNodeValueAsDecimal(RootNode: XmlNode; NodePath: Text[80]; Fatal: Boolean) Result: Decimal
    var
        NodeValue: Text[250];
    begin
        NodeValue := GetNodeValue(RootNode, NodePath, Fatal);
        if NodeValue = '' then begin
            if Fatal then
                Error(ElementMissingErr, NodePath, '', '');
        end else
            Evaluate(Result, NodeValue, 9);
    end;

    procedure GetNodeValueAsDate(RootNode: XmlNode; NodePath: Text[80]; Fatal: Boolean) Result: Date
    var
        NodeValue: Text[250];
    begin
        NodeValue := GetNodeValue(RootNode, NodePath, Fatal);
        if NodeValue = '' then begin
            if Fatal then
                Error(ElementMissingErr, NodePath, '', '');
        end else
            Evaluate(Result, NodeValue, 9);
    end;

    procedure GetFreeTextNodeValue(RootNode: XmlNode; NodePath: Text[80]; TextIndicator: Text[100]; Fatal: Boolean): Text[250]
    var
        NodeValue_ltxt: Text;
        ResultValue_ltxt: Text;
        FoundNode: XmlNode;
        NodeList: XmlNodeList;
    begin
        //A1095, 20210407, HBR.
        //FreeText Nodevalue example: 01#P00040 -> Indicator=01#. Value=P00040.

        // if IsNull(RootNode) then
        //     exit('');

        RootNode.SelectNodes(NodePath, NodeList);

        // Find the FreeText-node where the value starts with TextIndicator.
        //for I := 0 to NodeList.Count - 1 do begin
        foreach FoundNode in NodeList do begin
            //FoundNode := NodeList.Item(I);
            NodeValue_ltxt := FoundNode.AsXmlElement().InnerText();
            if StrPos(NodeValue_ltxt, TextIndicator) = 1 then begin
                ResultValue_ltxt := CopyStr(NodeValue_ltxt, StrLen(TextIndicator) + 1, 250);
                exit(ResultValue_ltxt);
            end
        end;

        //IF Fatal AND (ResultValue_ltxt = '') THEN
        // ResultValue_ltxt is empty at this point. No need to check on it.
        if Fatal then
            Error(ElementMissingErr, NodePath + ': ' + TextIndicator, '', '')
        else
            exit('');
    end;

    procedure GetAttribute(Node: XmlNode; AttributeName: Text; var Attribute: XmlAttribute) Result: Boolean
    begin
        Result := Node.AsXmlElement().Attributes().Get(AttributeName, Attribute);
    end;

    procedure FindNodeText(RootNode: XmlNode; NodePath: Text): Text
    var
        FoundXMLNode: XmlNode;
    begin
        if IsEmpty(RootNode) then
            exit('');

        // FoundXMLNode := 
        RootNode.SelectSingleNode(NodePath, FoundXMLNode);

        if IsEmpty(FoundXMLNode) then
            exit('');

        exit(FoundXMLNode.AsXmlElement().InnerText());
    end;

    procedure IsEmpty(Node: XmlNode): Boolean
    begin
        exit(Node.AsXmlElement().IsEmpty());
    end;

    procedure IsEmpty(Element: XmlElement): Boolean
    begin
        exit(Element.IsEmpty());
    end;

    procedure IsEmpty(Attribute: XmlAttribute): Boolean
    begin
        exit(Attribute.Value() <> '');
    end;

    procedure AddRootElement(var XMLDoc: XmlDocument; Name: Text; var CreatedXMLElement: XmlElement)
    begin
        CreatedXMLElement := XmlElement.Create(Name);
        XMLDoc.AddFirst(CreatedXMLElement);
    end;

    procedure AddRootNode(var XMLDoc: XmlDocument; Name: Text; var CreatedNode: XmlNode)
    var
        Element: XmlElement;
    begin
        Element := XmlElement.Create(Name);
        //CreatedXMLNode := XmlNode.create(Name);
        XMLDoc.AddFirst(Element);
        CreatedNode := Element.AsXmlNode();
    end;

    procedure AddDeclaration(var XMLDoc: XmlDocument; VersionText: Text; Encoding: Text; Standalone: Text)
    var
        Declaration: XmlDeclaration;
    begin
        // Declaration.Version := Version;
        // Declaration.Encoding := Encoding;
        // declaration.Standalone := Standalone;
        Declaration := XmlDeclaration.Create(VersionText, Encoding, Standalone);
        XMLDoc.SetDeclaration(Declaration);
    end;

    procedure AddText(var Node: XmlNode; Data: Text[250])
    var
        IDN: XmlText;
    begin
        //A890
        IDN := XmlText.Create(Data);
        // IDN := Node.OwnerDocument.CreateTextNode(Data);
        // Node.AppendChild(IDN);
        Node.AsXmlElement().Add(IDN);
    end;

    procedure NewLine(NewNode: XmlNode)
    var
        CRLF: Char;
    begin
        //A890
        CRLF := 13;
        AddText(NewNode, Format(CRLF));
    end;
}
