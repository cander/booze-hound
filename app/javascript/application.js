// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "app/main"

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
    alert('HERE!');
    let footerCopyrightRangeElement = $("#footerCopyrightRange");
    footerCopyrightRangeElement.text(getCopyrightRange(footerCopyrightRangeElement.text() + 'XXX'));

    // Setup auth/anon simulation
    $('.authenticated-display').hide();
    $('.anonymous-display').hide();

    $('input[type=radio][name=auth-options]').change(function() {
        if ($('#anon-toggle').is(':checked')) {
            $('.authenticated-display').hide();
            $('.anonymous-display').show();
        }
        else if ($('#auth-toggle').is(':checked')) {
            $('.authenticated-display').show();
            $('.anonymous-display').hide();
        }
    });
}); // end jQuery document-ready
