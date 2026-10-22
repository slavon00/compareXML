codeunit 87654 CompareManagement_pte
{
    internal procedure InsertProperty(fKey: Text[250]; fValue: Text; Type: Enum PropertyType_pte; var PropertyDifference: Record PropertyDifference_pte)
    begin
        if not PropertyDifference.Get(fKey) then begin
            PropertyDifference.fKey := fKey;
            PropertyDifference.Insert(true);
        end;
        case Type of
            PropertyType_pte::Source:
                PropertyDifference.SetSource(fValue);
            PropertyType_pte::Target:
                PropertyDifference.SetTarget(fValue);
        end;
        PropertyDifference.Modify(true);
    end;
}