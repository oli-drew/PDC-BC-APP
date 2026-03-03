/// <summary>
/// Table PDC Portal User (ID 50051).
/// </summary>
table 50051 "PDC Portal User"
{

    Caption = 'Portal User';
    DataClassification = customerContent;
    LookupPageId = "PDC Portal User List";
    DrillDownPageId = "PDC Portal User Card";

    fields
    {
        field(1; Id; Text[80])
        {

            trigger OnValidate()
            begin
                if (Id <> '') then begin
                    Contact.Reset();
                    Contact.SetRange("E-Mail", Id);
                    Contact.SetRange(Type, Contact.Type::Person);
                    if (Contact.FindFirst()) then begin
                        Validate("Company Contact No.", Contact."Company No.");
                        Validate("Contact No.", Contact."No.");
                    end else begin
                        Rec."User Name" := Id;
                        Rec."E-Mail" := Id;
                    end;
                end;
            end;
        }
        field(2; "User Name"; Text[100])
        {

            trigger OnValidate()
            begin
                if ("User Name" <> '') then
                    Validate("E-Mail", copystr("User Name", 1, MaxStrLen("E-Mail")));
            end;
        }
        field(3; "Password Hash"; Text[250])
        {
        }
        field(4; "Security Stamp"; Text[45])
        {
        }
        field(5; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact where(Type = const(Person),
                                           "Company No." = field("Company Contact No."));

            trigger OnValidate()
            begin
                if ("Contact No." <> '') then begin
                    Contact.Get("Contact No.");

                    Name := Contact.Name;
                    "Name 2" := Contact."Name 2";
                    Address := Contact.Address;
                    "Address 2" := Contact."Address 2";
                    City := Contact.City;
                    "Post Code" := Contact."Post Code";
                    County := Contact.County;
                    "Country/Region Code" := Contact."Country/Region Code";
                    "Phone No." := Contact."Phone No.";
                    "E-Mail" := LowerCase(Contact."E-Mail");
                    Created := CurrentDatetime;

                    Id := LowerCase("E-Mail");
                    "User Name" := LowerCase("E-Mail");
                end;
            end;
        }
        field(6; "Company Contact No."; Code[20])
        {
            Caption = 'Company Contact No.';
            TableRelation = Contact where(Type = const(Company));

            trigger OnValidate()
            begin
                if ("Contact No." <> '') then
                    if (Contact.Get("Contact No.")) then begin
                        if (Contact."Company No." <> "Company Contact No.") then
                            "Contact No." := '';
                    end else
                        "Contact No." := '';

                ContactBusinessRelation.Reset();
                ContactBusinessRelation.SetRange("Contact No.", "Company Contact No.");
                ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."link to table"::Customer);
                if (ContactBusinessRelation.FindFirst()) then
                    "Customer No." := ContactBusinessRelation."No.";

                ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."link to table"::Vendor);
                if (ContactBusinessRelation.FindFirst()) then
                    "Vendor No." := ContactBusinessRelation."No.";
            end;
        }
        field(8; "Customer No."; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if ("Customer No." <> '') then begin
                    ContactBusinessRelation.Reset();
                    ContactBusinessRelation.SetRange("No.", "Customer No.");
                    ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."link to table"::Customer);
                    if (ContactBusinessRelation.FindFirst()) then
                        "Contact No." := ContactBusinessRelation."Contact No.";
                end;

                Clear("Default Ship-to Code"); //18.10.2019 JEMEL J.Jemeljanovs #3109
            end;
        }
        field(9; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if ("Vendor No." <> '') then begin
                    ContactBusinessRelation.Reset();
                    ContactBusinessRelation.SetRange("No.", "Vendor No.");
                    ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."link to table"::Vendor);
                    if (ContactBusinessRelation.FindFirst()) then
                        "Contact No." := ContactBusinessRelation."Contact No.";
                end;
            end;
        }
        field(10; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(11; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(12; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(13; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(14; City; Text[30])
        {
            Caption = 'City';
        }
        field(15; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(16; County; Text[30])
        {
            Caption = 'County';
        }
        field(17; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(18; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(19; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(20; "Reset Password Hash"; Text[250])
        {
            Caption = 'Reset Password Hash';
        }
        field(21; "Reset Password Request State"; Option)
        {
            Caption = 'Reset Password Request State';
            OptionCaption = ' ,Requested,Emailed';
            OptionMembers = " ",Requested,Emailed;
        }
        field(25; Created; DateTime)
        {
        }
        field(26; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Contact.Name where("No." = field("Company Contact No.")));
            FieldClass = FlowField;
        }
        field(50; "Nav User Id"; Code[50])
        {
            TableRelation = "User Setup";

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
            begin
                if ("Nav User Id" <> '') then begin
                    UserSetup.Get("Nav User Id");

                    Validate("Contact No.", UserSetup."PDC Contact No.");
                end;
            end;
        }
        field(51; "Is Admin"; Boolean)
        {
            ObsoleteState = Pending;
            ObsoleteReason = 'Changed to User Type';
            Caption = 'Approval Admin';
            trigger OnValidate()
            begin
                Clear(AdminID);
            end;
        }
        field(60; "Password Phonetic"; Text[250])
        {
        }
        field(61; "Workflow Pass Info"; Text[50])
        {
        }
        field(70; "Portal Code Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "PDC Portal";
        }
        field(80; "Sell-to Customer No."; Code[20])
        {
            CalcFormula = lookup("Contact Business Relation"."No." where("Contact No." = field("Company Contact No."),
                                                                          "Link to Table" = const(Customer)));
            Caption = 'Sell-to Customer No.';
            FieldClass = FlowField;
        }
        field(82; "Default Ship-to Code"; Code[10])
        {
            Caption = 'Default Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));
        }
        field(83; "PO per Wearer"; Boolean)
        {
            Caption = 'PO per Wearer';
        }
        field(84; "Entitlement Email Report"; Boolean)
        {
            Caption = 'Entitlement Email Report';
        }
        field(85; AdminID; Text[80])
        {
            ObsoleteState = Pending;
            ObsoleteReason = 'Changed to User Type';
            Caption = 'Admin ID';
            TableRelation = if ("Is Admin" = const(false)) "PDC Portal User".Id where("Customer No." = field("Customer No."),
                                                                                     "Is Admin" = const(true));
        }
        field(86; "Min Order Value"; Decimal)
        {
            Caption = 'Min Order Value';
        }
        field(87; "Max Order Value"; Decimal)
        {
            Caption = 'Max Order Value';
        }
        field(88; "Azure User Id"; guid)
        {
            Caption = 'Azure User Id';
            ExtendedDatatype = Masked;
        }
        field(89; "Staff ID"; Code[20])
        {
            Caption = 'Staff ID';
            TableRelation = "PDC Branch Staff"."Staff ID" where("Sell-to Customer No." = field("Customer No."));
        }
        field(90; "Allow Approval Email"; Boolean)
        {
            Caption = 'Allow Approval Email';
        }
        field(91; "Azure Email Sent"; Boolean)
        {
            Caption = 'Azure Email Sent';
        }
        field(92; "Azure Email Sent Date"; DateTime)
        {
            Caption = 'Azure Email Sent Date';
        }
        field(93; "Azure Enabled"; Boolean)
        {
            Caption = 'Azure Enabled';
        }
        field(94; "User Type"; enum "PDC Portal User Type")
        {
            Caption = 'User Type';
        }
        field(95; "Approval Email Report"; Boolean)
        {
            Caption = 'Approval Email Report';
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
        key(Key2; "Azure User Id")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PDCNavPortalUserRole.Reset();
        PDCNavPortalUserRole.SetRange("User Id", Id);
        PDCNavPortalUserRole.DeleteAll();

        PDCPortalUserBranch.Reset();
        PDCPortalUserBranch.SetRange("Portal User ID", Id);
        PDCPortalUserBranch.DeleteAll();

        PDCPortalUserWardrobe.Reset();
        PDCPortalUserWardrobe.SetRange("Portal User ID", Id);
        PDCPortalUserWardrobe.DeleteAll();
    end;

    var
        Contact: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        PDCNavPortalUserRole: Record "PDC Portal User Role";
        PDCPortalUserBranch: Record "PDC Portal User Branch";
        PDCPortalUserWardrobe: Record "PDC Portal User Wardrobe";
        WrongPasswordErr: label 'Password is incorrect.';
        WrongPasswordConfirmationErr: label 'New password cannot be different than new password confirmation.';
        NewPasswordTxt: label 'New password is %1.', comment = '%1=new password';

    /// <summary>
    /// SetPassword.
    /// </summary>
    /// <param name="newPassword">Text[250].</param>
    /// <param name="newPasswordMode">Code[6].</param>
    /// <param name="triggerWorkflow">Boolean.</param>
    procedure SetPassword(newPassword: Text[250]; newPasswordMode: Code[6]; triggerWorkflow: Boolean)
    var
        NAVPortalsManagement: Codeunit "PDC Portals Management";
    begin
        "Password Hash" := NAVPortalsManagement.HashPassword(newPassword);
        "Password Phonetic" := copystr(CreatePasswordPhonetic(newPassword), 1, MaxStrLen("Password Phonetic"));
        Modify();

        Message(NewPasswordTxt, newPassword);
    end;

    /// <summary>
    /// ChangePassword.
    /// </summary>
    /// <param name="oldPassword">Text.</param>
    /// <param name="newPassword">Text.</param>
    /// <param name="newPassword2">Text.</param>
    /// <param name="triggerWorkflow">Boolean.</param>
    procedure ChangePassword(oldPassword: Text[250]; newPassword: Text[250]; newPassword2: Text[250]; triggerWorkflow: Boolean)
    var
        NAVPortalsManagement: Codeunit "PDC Portals Management";
    begin
        if ("Password Hash" <> NAVPortalsManagement.HashPassword(oldPassword)) then
            Error(WrongPasswordErr);
        if (newPassword <> newPassword2) then
            Error(WrongPasswordConfirmationErr);
        //!!! TO-DO !!!
        //'CHANGE' value should be taken from setup
        SetPassword(newPassword, 'CHANGE', triggerWorkflow);
    end;

    /// <summary>
    /// ResetPasswordFromUI.
    /// </summary>
    /// <param name="triggerWorkflow">Boolean.</param>
    procedure ResetPasswordFromUI(triggerWorkflow: Boolean)
    var
        PDCNavPortalUser: Record "PDC Portal User";
        PDCNavPortalUserPassword: Page "PDC Nav Portal User Password";
        NewPassword: Text[250];
        ActionResult: action;
        BlankPasswordErr: label 'Unable to set password';
    begin
        PDCNavPortalUser.Get(Id);
        PDCNavPortalUser.SetRecfilter();
        PDCNavPortalUserPassword.SetTableview(PDCNavPortalUser);
        PDCNavPortalUserPassword.SetRecord(PDCNavPortalUser);
        ActionResult := PDCNavPortalUserPassword.RunModal();
        if (ActionResult in [Action::OK, Action::LookupOK]) then
            NewPassword := PDCNavPortalUserPassword.ReturnPassword();

        //Check the new password and error now if the password hasnt been populated
        if NewPassword = '' then
            Error(BlankPasswordErr);

        SetPassword(NewPassword, 'RESET', triggerWorkflow);
    end;

    /// <summary>
    /// ResetPasswordWithAutoGen.
    /// </summary>
    /// <param name="triggerWorkflow">Boolean.</param>
    /// <returns>Return value of type Text.</returns>
    procedure ResetPasswordWithAutoGen(triggerWorkflow: Boolean): Text
    var
        NewPassword: Text[250];
        i: Integer;
        CHARSelectionTxt: label 'abcdefghijklmnopqrstuvwxyz';
    begin
        NewPassword := '';
        for i := 1 to 5 do begin //2 characters per for loop = 10 char string.
            NewPassword += CopyStr(UpperCase(CHARSelectionTxt), Random(26), 1);
            NewPassword += Format(Random(9));
        end;
        SetPassword(NewPassword, 'RESET', triggerWorkflow);
        exit(NewPassword);
    end;

    /// <summary>
    /// CreatePasswordResetHash.
    /// </summary>
    procedure CreatePasswordResetHash()
    var
        i: Integer;
        PasswordResetHash: Text[250];
        SourceCharacters: Text[250];
    begin
        Randomize();
        SourceCharacters := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        PasswordResetHash := '';
        for i := 1 to 20 do
            PasswordResetHash := copystr(PasswordResetHash + CopyStr(SourceCharacters, Random(StrLen(SourceCharacters)), 1), 1, MaxStrLen(PasswordResetHash));
        "Reset Password Hash" := PasswordResetHash;
    end;

    /// <summary>
    /// CreatePasswordPhonetic.
    /// </summary>
    /// <param name="Password">Text.</param>
    /// <returns>Return variable MemPhrase of type Text.</returns>
    local procedure CreatePasswordPhonetic(Password: Text): Text
    var
        PasswordLength: Integer;
        Loop: Integer;
        Phrase: Text;
    begin
        PasswordLength := StrLen(Password);

        for Loop := 1 to PasswordLength do
            Phrase += GetCharacterDescriptor(CopyStr(Password, Loop, 1)) + ' ';

        exit(Phrase);
    end;

    local procedure GetCharacterDescriptor(Letter: Text[10]): Text
    var
        int: Integer;
    begin

        if Evaluate(int, Letter) then exit(Letter);

        case Letter of
            'a':
                exit('alpha');
            'b':
                exit('bravo');
            'c':
                exit('charlie');
            'd':
                exit('delta');
            'e':
                exit('echo');
            'f':
                exit('fox');
            'g':
                exit('golf');
            'h':
                exit('hotel');
            'i':
                exit('india');
            'j':
                exit('juliet');
            'k':
                exit('kilo');
            'l':
                exit('lima');
            'm':
                exit('mike');
            'n':
                exit('november');
            'o':
                exit('oscar');
            'p':
                exit('papa');
            'q':
                exit('quebec');
            'r':
                exit('romeo');
            's':
                exit('sierra');
            't':
                exit('tango');
            'u':
                exit('uniform');
            'v':
                exit('victor');
            'w':
                exit('whiskey');
            'x':
                exit('x-ray');
            'y':
                exit('yankee');
            'z':
                exit('zulu');

            'A':
                exit('ALPHA');
            'B':
                exit('BRAVO');
            'C':
                exit('CHARLIE');
            'D':
                exit('DELTA');
            'E':
                exit('ECHO');
            'F':
                exit('FOX');
            'G':
                exit('GOLF');
            'H':
                exit('HOTEL');
            'I':
                exit('INDIA');
            'J':
                exit('JULIET');
            'K':
                exit('KILO');
            'L':
                exit('LIMA');
            'M':
                exit('MIKE');
            'N':
                exit('NOVEMBER');
            'O':
                exit('OSCAR');
            'P':
                exit('PAPA');
            'Q':
                exit('QUEBEC');
            'R':
                exit('ROMEO');
            'S':
                exit('SIERA');
            'T':
                exit('TANGO');
            'U':
                exit('UNifORM');
            'V':
                exit('VICTOR');
            'W':
                exit('WHISKEY');
            'X':
                exit('X-RAY');
            'Y':
                exit('YANKEE');
            'Z':
                exit('ZULU');

        end;

        exit(Letter);
    end;

    /// <summary>
    /// CreateContact.
    /// </summary>
    procedure CreateContact()
    begin
        exit;
        // J3: Don't run below function

        // TestField("Contact No.", '');

        // Contact.Init();
        // Contact."No." := '';
        // Contact.Type := Contact.Type::Company;
        // Contact.Insert(true);

        // "Contact No." := Contact."No.";
        // Modify();

        // Contact.Validate(Name, Name);
        // Contact.Validate("Name 2", "Name 2");
        // Contact.Validate(Address, Address);
        // Contact.Validate("Address 2", "Address 2");
        // Contact.Validate(City, City);
        // Contact.Validate("Country/Region Code", "Country/Region Code");
        // Contact.Validate("Post Code", "Post Code");
        // Contact.Validate(County, County);
        // Contact.Validate("Phone No.", "Phone No.");
        // Contact.Validate("E-Mail", "E-Mail");
        // Contact.Modify(true);
    end;

    /// <summary>
    /// IsWorkflowNotificationsEnabled.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure IsWorkflowNotificationsEnabled(): Boolean
    var
        PDCNavPortal: Record "PDC Portal";
    begin
        PDCNavPortal.Get('CUSTP');
        exit(PDCNavPortal."Use Workflow Notifications");
    end;
}

