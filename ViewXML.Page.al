page 87655 ViewXML_pte
{
    ApplicationArea = All;
    Caption = 'View XML';
    PageType = ListPart;
    SourceTable = Property_pte;
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(fKey; Rec.fKey) { }
                field(fValue; Rec.GetValue())
                {
                    Caption = 'Value';
                    ToolTip = 'Specifies the value of the Value field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            fileuploadaction(Upload)
            {
                Caption = 'Upload';
                Image = Import;
                ApplicationArea = All;
                AllowMultipleFiles = false;
                ToolTip = 'Uploads';

                trigger OnAction(Files: List of [FileUpload])
                var
                    TempXMLBuffer, TempXMLBufferValue : Record "XML Buffer" temporary;
                    File: FileUpload;
                    InStream: InStream;
                begin
                    foreach File in Files do begin
                        File.CreateInStream(InStream);
                        TempXMLBuffer.LoadFromStream(InStream);
                        TempXMLBufferValue.Copy(TempXMLBuffer, true);
                        Rec.Reset();
                        Rec.DeleteAll(true);
                        TempXMLBuffer.SetRange(Type, TempXMLBuffer.Type::Element);
                        TempXMLBuffer.SetRange(Name, 'add');
                        if TempXMLBuffer.FindSet() then
                            repeat
                                TempXMLBufferValue.Get(TempXMLBuffer."Entry No." + 1);
                                Rec.fKey := TempXMLBufferValue.Value;
                                TempXMLBufferValue.Get(TempXMLBuffer."Entry No." + 2);
                                Rec.SetValue(TempXMLBufferValue.GetValue());
                                Rec.Insert(true);
                            until TempXMLBuffer.Next() = 0;
                    end;
                end;
            }
        }
    }
    internal procedure GetRecord(var Property: Record Property_pte)
    begin
        Property.Reset();
        Property.DeleteAll(true);
        if Rec.FindSet() then
            repeat
                Rec.CalcFields(fValue);
                Property.TransferFields(Rec, true);
                Property.Insert(true);
            until Rec.Next() = 0;
    end;
}