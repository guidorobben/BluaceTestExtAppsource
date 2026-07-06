tableextension 83903 "XML Buffer TPTE" extends "XML Buffer"
{
    DrillDownPageId = "Open XML TPTE";
    LookupPageId = "Open XML TPTE";

    keys
    {
        key(PathTPTE; Path) { }
        key(ParentNameTPTE; "Parent Entry No.", Type, Name) { }
    }

    var
        XMLBufferHelperTPTE: Codeunit "XML Buffer Helper TPTE";

    procedure SelectSingleNode(XPath: Text; var XMLBuffer: Record "XML Buffer"): Text
    begin
        exit(XMLBufferHelperTPTE.SelectSingleNode(XPath, XMLBuffer));
        // XMLBuffer.Reset();
        // XMLBuffer.SetFilter(Path, XPath);
        // if XMLBuffer.FindFirst() then
        //     exit(XMLBuffer.Value);
    end;

    procedure SelectNodes(XPath: Text; var XMLBuffer: Record "XML Buffer")
    begin
        XMLBuffer.Reset();
        XMLBuffer.SetCurrentKey(Path);
        XMLBuffer.SetFilter(Path, XPath);
        // if XMLBuffer.FindSet();
    end;

    procedure GetAttributes(var XMLBuffer: Record "XML Buffer")
    begin
        XMLBuffer.Reset();
        XMLBuffer.SetCurrentKey("Parent Entry No.", Type);
        XMLBuffer.SetRange("Parent Entry No.", Rec."Entry No.");
        XMLBuffer.SetRange(Type, XMLBuffer.Type::Attribute);
        // if XMLBuffer.FindSet() then;
    end;

    procedure GetAttribute(Name: Text; var XMLBuffer: Record "XML Buffer"): Text
    begin
        exit(XMLBufferHelperTPTE.GetAttribute(Rec, Name, XMLBuffer));

        // XMLBuffer.Reset();
        // XMLBuffer.SetLoadFields(Value);
        // XMLBuffer.SetCurrentKey("Parent Entry No.", Type, Name);
        // XMLBuffer.SetRange("Parent Entry No.", Rec."Entry No.");
        // XMLBuffer.SetRange(Type, XMLBuffer.Type::Attribute);
        // XMLBuffer.SetRange(Name, Name);
        // if XMLBuffer.FindFirst() then
        //     exit(XMLBuffer.Value);
    end;

    procedure GetChildElements(var XMLBuffer: Record "XML Buffer")
    begin
        XMLBuffer.Reset();
        XMLBuffer.SetCurrentKey("Parent Entry No.", Type);
        XMLBuffer.SetRange("Parent Entry No.", Rec."Entry No.");
        XMLBuffer.SetRange(Type, XMLBuffer.Type::Element);
        // if XMLBuffer.FindSet() then;
    end;

    procedure GetValueTPTE(var Value: Integer; Fatal: Boolean)
    begin
        Value := (XMLBufferHelperTPTE.GetValueAsInteger(Rec, Fatal));
    end;

    procedure GetValueTPTE(var Value: Decimal; Fatal: Boolean)
    begin
        Value := XMLBufferHelperTPTE.GetValueAsDecimal(Rec, Fatal);
    end;

    procedure GetValueTPTE(var Value: Date; Fatal: Boolean)
    begin
        Value := XMLBufferHelperTPTE.GetValueAsDate(Rec, Fatal);
    end;

    procedure GetValueTPTE(var Value: Boolean; Fatal: Boolean)
    begin
        Value := XMLBufferHelperTPTE.GetValueAsBoolean(Rec, Fatal);
    end;

    procedure LoadFromXMLDocumentTPTE(Document: XmlDocument)
    begin
        XMLBufferHelperTPTE.LoadFromXMLDocument(Rec, Document);
    end;
}