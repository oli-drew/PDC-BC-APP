/// <summary>
/// Codeunit PDC Test Library (ID 50580).
/// Minimal assertion helpers for PDC test codeunits.
/// </summary>
codeunit 50580 "PDC Test Library"
{
    procedure AreEqual(Expected: Variant; Actual: Variant; Msg: Text)
    begin
        if Format(Expected) <> Format(Actual) then
            Error(AreEqualErr, Msg, Format(Expected), Format(Actual));
    end;

    procedure AreNotEqual(NotExpected: Variant; Actual: Variant; Msg: Text)
    begin
        if Format(NotExpected) = Format(Actual) then
            Error(AreNotEqualErr, Msg, Format(NotExpected));
    end;

    procedure IsTrue(Condition: Boolean; Msg: Text)
    begin
        if not Condition then
            Error(IsTrueErr, Msg);
    end;

    procedure IsFalse(Condition: Boolean; Msg: Text)
    begin
        if Condition then
            Error(IsFalseErr, Msg);
    end;

    procedure AreNearlyEqual(Expected: Decimal; Actual: Decimal; Tolerance: Decimal; Msg: Text)
    begin
        if Abs(Expected - Actual) > Tolerance then
            Error(AreNearlyEqualErr, Msg, Format(Expected), Format(Actual), Format(Tolerance));
    end;

    procedure Fail(Msg: Text)
    begin
        Error(FailErr, Msg);
    end;

    var
        AreEqualErr: Label '%1: Expected <%2> but got <%3>.';
        AreNotEqualErr: Label '%1: Did not expect <%2>.';
        IsTrueErr: Label '%1: Expected TRUE but got FALSE.';
        IsFalseErr: Label '%1: Expected FALSE but got TRUE.';
        AreNearlyEqualErr: Label '%1: Expected <%2> within tolerance <%4> but got <%3>.';
        FailErr: Label 'Test failed: %1';
}
