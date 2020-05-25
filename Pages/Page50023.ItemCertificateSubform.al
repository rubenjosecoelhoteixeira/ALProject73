page 50023 "ItemCertificateSubform"
{
    PageType = ListPart;
    ApplicationArea = CustomerContent;
    UsageCategory = Documents;
    SourceTable = "Item Certificate Action";
    Caption = 'Item Certificate Subform';
    Description = 'ARQNRSH';

    layout
    {
        area(Content)
        {

            field("Action Date"; "Action Date")
            {
                ApplicationArea = All;
                Caption = 'Action Date';
            }
            field("Action Type"; "Action Type")
            {
                ApplicationArea = CustomerContent;
                Caption = 'Action Type';
            }
            field("Expiration Date"; "Expiration Date")
            {
                ApplicationArea = CustomerContent;
                Caption = 'Expiration Date';

            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ItemCertificate: Record "Item Certificate";
    begin
        ItemCertificate.Get("Certificate No.");
        Validate("Item No.", ItemCertificate."Item No.");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage.Update(false);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage.Update(false);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        IsExpirationDateEditable := CanEditExpirationDate();
    end;

    trigger OnAfterGetRecord()
    begin
        IsExpirationDateEditable := CanEditExpirationDate;
    end;

    procedure CanEditExpirationDate(): Boolean
    begin
        exit("Action Type" <> "Action Type"::Revoked);
    end;

    var
        IsExpirationDateEditable: Boolean;
}