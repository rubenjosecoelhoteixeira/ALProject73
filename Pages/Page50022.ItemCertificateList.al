page 50022 "Item Certificate List"
{
    PageType = List;
    ApplicationArea = CustomerContent;
    UsageCategory = Documents;
    SourceTable = "Item Certificate";
    Editable = false;
    Description = 'ARQNRSH';

    layout
    {
        area(Content)
        {
            repeater(General)
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
                field("Last Prolonged Date"; "Last Prolonged Date")
                {
                    ApplicationArea = CustomerContent;
                    Caption = 'Last Prolonged Date';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Issue Certificate")
            {
                ApplicationArea = CustomerContent;
                Caption = 'Issue Certificate';
                Image = ReleaseDoc;

                trigger OnAction()
                begin
                    IssueCertificate;
                end;
            }
            action(ProlongCertificate)
            {
                ApplicationArea = CustomerContent;
                Caption = 'Prolong Certificate';

                trigger OnAction()
                begin

                end;
            }
            action(RevokeCertificate)
            {
                ApplicationArea = CustomerContent;
                Caption = 'Revoke Certificate';

                trigger OnAction()
                begin

                end;
            }
            action(Item)
            {
                ApplicationArea = CustomerContent;
                Caption = 'Item';
                RunObject = page "Item Card";
                RunPageLink = "No." = field("Item No.");
            }
            action(ViewActive)
            {
                ApplicationArea = CustomerContent;
                Caption = 'View Active';

                trigger OnAction()
                begin
                    ItemCertificateMgt.CollectProlongedNotRevokedCertificates(TempItemCertificate);
                    Page.Run(Page::"Certificate List", TempItemCertificate);
                end;
            }
        }
    }

    local procedure InsertCertificateAction(ActionType: Option)
    var
        ItemCertificateAction: Record "Item Certificate Action";
    begin
        with ItemCertificateAction do begin
            Validate("Certificate No.", "No.");
            Validate("Action Date", WorkDate());
            Validate("Action Type", ActionType);
            if ActionType <> "Action Type"::Revoked then
                Validate("Expiration Date", CalcDate('<1Y>', WorkDate()));
            Validate("Item No.", "Item No.");
            Insert(true);
        end;
    end;

    procedure IssueCertificate()
    var
        ItemCertificateAction: Record "Item Certificate Action";
    begin
        if not IsCertificateIssued then
            InsertCertificateAction(ItemCertificateAction."Action Type"::Issued);
    end;

    var
        ItemCertificateMgt: Codeunit "Item Certificate Mgt";
        TempItemCertificate: Record "Item Certificate" temporary;
}
