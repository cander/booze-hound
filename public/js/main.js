function getCopyrightRange(startYear = 2023) {
    const enDash = '–';

    let copyrightRange = '';
    let currentYear = new Date().getFullYear();

    if (currentYear == Number(startYear)) {
        copyrightRange = startYear;
    } // end if test
    else {
        copyrightRange = startYear + '' + enDash + '' + currentYear;
        console.log(copyrightRange);
    } // end else test

    return copyrightRange;
} // end getCopyrightRange function

$(document).ready(function() {
    let footerCopyrightRangeElement = $("#footerCopyrightRange");
    footerCopyrightRangeElement.text(getCopyrightRange(footerCopyrightRangeElement.text()));

    // Setup auth/anon simulation
    $('.authenticated-display').hide();
    $('.anonymous-display').hide();
    $('.authenticated-display').show(); // TODO: remove this line, used to force auth mode

    $('input[type=radio][name=auth-options]').change(function() {
        if ($('#anon-toggle').is(':checked')) {
            $('.authenticated-display:not(.exclude)').hide();
            $('.anonymous-display').show();
        }
        else if ($('#auth-toggle').is(':checked')) {
            $('.authenticated-display').show();
            $('.anonymous-display').hide();
        }
    });
}); // end jQuery document-ready
