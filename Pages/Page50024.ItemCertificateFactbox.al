page 50024 ItemCertificateFactBox
{
    PageType = CardPart;
    ApplicationArea = CustomerContent;
    UsageCategory = Documents;
    SourceTable = "Item Certificate";
    Caption = 'Item Certificate FactBox';
    Description = 'ARQNRSH';

    layout
    {
        area(Content)
        {
            field("No."; "No.")
            {
                ApplicationArea = CustomerContent;
                Caption = 'No.';
            }
            field("CA Code"; "CA Code")
            {
                ApplicationArea = CustomerContent;
                Caption = 'Certification Authority';
            }
            field("Issued Date"; "Issued Date")
            {
                ApplicationArea = CustomerContent;
                Caption = 'Issued Date';
            }
            field(ExpirationDate; ExpirationDate)
            {
                ApplicationArea = CustomerContent;
                Caption = 'Expiration Date';
                Style = Attention;
                StyleExpr = IsCertificateOverdue;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ItemCertificateMgt: Codeunit "Item Certificate Mgt";
    begin
        ExpirationDate := ItemCertificateMgt.GetCertificateExpirationDate("No.");
        IsCertificateOverdue := ExpirationDate < WorkDate();
    end;

    procedure GetCertificateExpirationDate(CertificateNo: Code[20]): Date
    var
        ItemCertificateAction: Record "Item Certificate Action";
    begin
        with ItemCertificateAction do begin
            SetRange("Certificate No.", CertificateNo);
            SetRange("Action Type", "Action Type"::Revoked);
            if FindLast() then
                exit("Action Date");
            SetRange("Action Type", "Action Type"::Issued, "Action Type"::Prolonged);
            if FindLast() then
                exit("Expiration Date");
        end;
    end;

    var
        ExpirationDate: Date;
        IsCertificateOverdue: Boolean;
}