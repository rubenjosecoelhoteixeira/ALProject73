page 50025 "Item Cert. - Certificates"
{
    PageType = CardPart;
    ApplicationArea = Documents;
    UsageCategory = Administration;
    SourceTable = ItemCertificationCue;
    Caption = 'Item Cert. - Certificates';

    layout
    {
        area(Content)
        {
            cuegroup(General)
            {
                Caption = 'General';
                field("Certificates - Total"; "Certificates - Total")
                {
                    ApplicationArea = CustomerContent;
                    Caption = 'Certificates - Total';
                    DrillDownPageId = "Certificate List";
                }
                field("Certificates - Issued"; "Certificates - Issued")
                {
                    ApplicationArea = CustomerContent;
                    Caption = 'Certificates - Issued';
                }
                field("Certificates - Revoked"; "Certificates - Revoked")
                {
                    ApplicationArea = CustomerContent;
                    Caption = 'Certificates - Revoked';
                }
                field(ExpiredCertificates; ExpiredCertificates)
                {
                    ApplicationArea = CustomerContent;
                    Caption = 'Expired Certificates';
                }
                field(CertificatesDueToExpire; CertificatesDueToExpire)
                {
                    ApplicationArea = CustomerContent;
                    Caption = 'Certificates - Due to Expire';

                    trigger OnDrillDown()
                    begin
                        DrillDownDueToExpire();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset();
        if not get then begin
            Init();
            Insert();
        end;
        SetRange("Date Filter", CalcDate('<-1M>', WorkDate()), WorkDate());
        SetRange("Future Period Filter", CalcDate('<1D>', WorkDate()), CalcDate('<1M>', WorkDate()));
    end;

    trigger OnAfterGetRecord()
    begin
        CertificatesDueToExpire := CountCertificatesDueToExpire();
    end;

    local procedure CountCertificatesDueToExpire(): Integer
    var
        ItemCertificateAction: Record "Item Certificate Action";
    begin
        ItemCertificateAction.SetFilter("Expiration Date", GetFilter("Future Period Filter"));
        exit(ItemCertificateAction.Count);
    end;

    local procedure FillTempCertificateBuffer(var ItemCertificateAction: Record "Item Certificate Action")
    var
        TempItemCertificate: Record "Item Certificate" temporary;
    begin
        if ItemCertificateAction.FindSet() then
            repeat
                InsertCertificateBufferRecord(TempItemCertificate, ItemCertificateAction."Item No.");
            until ItemCertificateAction.Next() = 0;
        Page.Run(Page::"Certificate List", TempItemCertificate);
    end;

    local procedure InsertCertificateBufferRecord(var TempItemCertificate: Record "Item Certificate" temporary; CertificateNo: Code[20])
    begin
        TempItemCertificate."No." := CertificateNo;
        if TempItemCertificate.Insert() then;
    end;

    procedure DrillDownDueToExpire()
    var
        ItemCertificateAction: Record "Item Certificate Action";
    begin
        ItemCertificateAction.SetFilter("Expiration Date", GetFilter("Future Period Filter"));
        FillTempCertificateBuffer(ItemCertificateAction);
    end;

    var
        ExpiredCertificates: Integer;
        CertificatesDueToExpire: Integer;
}