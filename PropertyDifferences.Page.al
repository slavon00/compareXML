page 87656 PropertyDifferences_pte
{
    ApplicationArea = All;
    Caption = 'Property Differences';
    PageType = ListPart;
    SourceTable = PropertyDifference_pte;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Source; Rec.GetSource())
                {
                    Caption = 'Source';
                    StyleExpr = SourceStyle;
                    ToolTip = 'Specifies the value of the Source field.';
                }
                field(fKey; Rec.fKey) { }
                field(Target; Rec.GetTarget())
                {
                    Caption = 'Target';
                    StyleExpr = TargetStyle;
                    ToolTip = 'Specifies the value of the Target field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DeleteSame)
            {
                Caption = 'Delete Same';
                ToolTip = 'Deletes same.';
                ApplicationArea = All;
                Image = Delete;
                trigger OnAction()
                begin
                    if Rec.FindSet() then
                        repeat
                            if Rec.GetSource() = Rec.GetTarget() then
                                Rec.Delete(true);
                        until Rec.Next() = 0;
                end;
            }
            action(SetProperty)
            {
                Caption = 'Set Property';
                ToolTip = 'Sets properties.';
                ApplicationArea = All;
                Image = SetPriorities;
                trigger OnAction()
                begin
                    Message('Set-NavServerConfiguration $NewBCServerInstance -KeyName %1 -KeyValue "%2"', Rec.fKey, Rec.GetSource());
                end;
            }
        }
    }

    var
        SourceStyle, TargetStyle : Text;

    trigger OnAfterGetRecord()
    begin
        case Rec.Compare(Rec.GetSource(), Rec.GetTarget()) of
            -1:
                this.SetStyle(PageStyle::Unfavorable, PageStyle::Favorable);
            0:
                this.SetStyle(PageStyle::Subordinate, PageStyle::Subordinate);
            +1:
                this.SetStyle(PageStyle::Favorable, PageStyle::Unfavorable);
        end;
    end;

    local procedure SetStyle(SourcePageStyle: PageStyle; TargetPageStyle: PageStyle)
    begin
        this.SourceStyle := Format(SourcePageStyle);
        this.TargetStyle := Format(TargetPageStyle);
    end;

    internal procedure SetRecord(var PropertyDiff: Record PropertyDifference_pte)
    begin
        Rec.Reset();
        Rec.DeleteAll(true);
        if PropertyDiff.FindSet() then
            repeat
                PropertyDiff.CalcFields(Source, Target);
                Rec.TransferFields(PropertyDiff, true);
                Rec.Insert(true);
            until PropertyDiff.Next() = 0;
    end;
}