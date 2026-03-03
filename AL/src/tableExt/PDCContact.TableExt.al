/// <summary>
/// TableExtension PDCContact (ID 50032) extends Record Contact.
/// </summary>
tableextension 50032 PDCContact extends Contact
{
    /// <summary>
    /// CreateNewCompanyPerson.
    /// </summary>
    procedure CreateNewCompanyPerson()
    var
        PersonContact: Record Contact;
        loc_text001Lbl: label 'Do you want to create new person Contact for company %1?', Comment = 'Do you want to create new person Contact for company %1?';
    begin
        TestField(Type, Type::Company);

        if not Confirm(loc_text001Lbl, false, "No.") then
            exit;

        PersonContact.Init();
        PersonContact.Insert(true);
        PersonContact.Type := PersonContact.Type::Person;
        PersonContact.Validate("Company No.", "No.");
        PersonContact.Modify();
        Commit();

        Page.RunModal(Page::"Contact Card", PersonContact);
    end;
}

