page 50026 "Item Cert. – Items"
{
    Description = 'ARQNRSH';
    PageType = ListPart;
    ApplicationArea = CustomerContent;
    UsageCategory = Lists;
    SourceTable = Item;
    Caption = 'Item Cert. - Items';


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    ApplicationArea = CustomerContent;
                    Caption = 'No.';
                    Style = Attention;
                    StyleExpr = ItemCertificateOverdue;
                }
                field(Description; Description)
                {
                    ApplicationArea = CustomerContent;
                    Caption = 'Description';
                    Style = Attention;
                    StyleExpr = ItemCertificateOverdue;
                }
                field(ExpirationDate; ExpirationDate)
                {
                    ApplicationArea = CustomerContent;
                    Caption = 'Expiration Date';
                    Style = Attention;
                    StyleExpr = ItemCertificateOverdue;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ExpirationDate := ItemCertificateMgt.GetCertificateExpirationDate("No.");
        ItemCertificateOverdue := ExpirationDate < WorkDate();
    end;

    var
        ItemCertificateMgt: Codeunit "Item Certificate Mgt";
        ExpirationDate: Date;
        ItemCertificateOverdue: Boolean;
}