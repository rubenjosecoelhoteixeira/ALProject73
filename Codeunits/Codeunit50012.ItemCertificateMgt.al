codeunit 50012 "Item Certificate Mgt"
{
    Description = 'ARQNRSH';

    trigger OnRun()
    begin

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

    procedure FindActiveItemCertificate(ItemNo: Code[20]; CertificateDate: Date): Code[20]
    var
        ItemCertificateAction: Record "Item Certificate Action";
    begin
        with ItemCertificateAction do begin
            SetRange("Item No.", ItemNo);
            SetFilter("Expiration Date", '>=%1', CertificateDate);
            FindLast();
            exit("Certificate No.");
        end;
    end;

    procedure VerifyActiveItemCertificateExists(ItemNo: Code[20]; CertificateDate: Date)
    var
        ItemCertificateAction: Record "Item Certificate Action";
        NoValidCertificateErr: Label 'Item %1 does not have a valid certificate';
    begin
        with ItemCertificateAction do begin
            SetRange("Item No.", ItemNo);
            SetFilter("Expiration Date", '>=%1', CertificateDate);
            if IsEmpty then
                Error(NoValidCertificateErr, ItemNo);
        end;
    end;

    procedure CollectProlongedNotRevokedCertificates(var TempItemCertificate: Record "Item Certificate")
    var
        ItemCertificateAction: Record "Item Certificate Action";
        ItemCertificate: Record "Item Certificate";
    begin
        TempItemCertificate.Reset();
        TempItemCertificate.DeleteAll();
        with ItemCertificateAction do begin
            SetRange("Action Date", CalcDate('<-1Y>', WorkDate()), WorkDate());
            if FindSet() then
                repeat
                    if not TempItemCertificate.Get(ItemCertificateAction."Item No.") then
                        if not ItemCertificate.isCertificateRevoked() then begin
                            ItemCertificate.Get(ItemCertificateAction."Certificate No.");
                            TempItemCertificate := ItemCertificate;
                            TempItemCertificate.Insert();
                        end;
                until Next() = 0;
        end;
    end;
}