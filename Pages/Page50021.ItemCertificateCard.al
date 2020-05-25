page 50021 "Item Certificate Card"
{
    Caption = 'Item Certificate';
    PageType = Card;
    SourceTable = "Item Certificate";
    UsageCategory = Documents;
    ApplicationArea = CustomerContent;
    Description = 'ARQNRSH';

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
                }
                field("CA Code"; "CA Code")
                {
                    ApplicationArea = CustomerContent;
                    Caption = 'Certification Authority';
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = CustomerContent;
                    Caption = 'Item No.';
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
                field("Last Prolonged Date"; "Last Prolonged Date")
                {
                    ApplicationArea = CustomerContent;
                    Caption = 'Last Prolonged Date';
                }
            }
            part(CertificateActions; ItemCertificateSubform)
            {
                Caption = 'Certificate Actions';
                SubPageLink = "Certificate No." = field("No.");
                UpdatePropagation = Both;
            }
        }
    }

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

    trigger OnAfterGetRecord()
    var
        ItemCertificateMgt: Codeunit "Item Certificate Mgt";
    begin
        ExpirationDate := ItemCertificateMgt.GetCertificateExpirationDate("No.");
        IsCertificateOverdue := ExpirationDate < WorkDate();
    end;

    var
        ExpirationDate: Date;
        IsCertificateOverdue: Boolean;
}