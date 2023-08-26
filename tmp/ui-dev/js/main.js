function getCopyrightRange(startYear = 2023) {
    const enDash = '–';

    let copyrightRange = '';
    let currentYear = new Date().getFullYear();

    if (currentYear == Number(startYear)) {
        console.log('1');
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
}); // end jQuery document-ready