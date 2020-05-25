table 50015 ItemCertificationCue
{
    Description = 'ARQNRSH';
    Caption = 'Item Certification Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
            FieldClass = Normal;
        }
        field(2; "Certificates - Total"; Integer)
        {
            Caption = 'Certificates - Total';
            FieldClass = FlowField;
            CalcFormula = count ("Item Certificate");
        }
        field(3; "Certificates - Issued"; Integer)
        {
            Caption = 'Certificates - Issued';
            FieldClass = FlowField;
            CalcFormula = Count ("Item Certificate Action" where("Action Type" = const(Issued), "Action Date" = field("Date Filter")));
        }
        field(4; "Certificates - Revoked"; Integer)
        {
            Caption = 'Certificates - Revoked';
            FieldClass = FlowField;
            CalcFormula = Count ("Item Certificate Action" where("Action Type" = const(Revoked), "Action Date" = field("Date Filter")));
        }
        field(5; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(6; "Future Period Filter"; Date)
        {
            Caption = 'Future Period Filter';
            FieldClass = FlowFilter;
        }

    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}