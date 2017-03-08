function handleFileSelect(evt) {
    // remove previous image, if present
    document.getElementById('list').innerHTML = '';

    var files = evt.target.files; // FileList object
    // Loop through the FileList and render image files
    for (var i = 0, f; f = files[i]; i++) {

        // Only process image files.
        if (!f.type.match('image.*')) {
            continue;
        }

        var reader = new FileReader();

        // Closure to capture the file information.
        reader.onload = (function(theFile) {
            return function(e) {
                // Render image.
                var span = document.createElement('span');
                span.innerHTML = ['<img id="pic" class=\"thumb\" src=\"', e.target.result,
                    '\" height="700px"/>'].join('');
                document.getElementById('list').insertBefore(span, null);
            };
        })(f);

        // Read in the image file as a data URL.
        reader.readAsDataURL(f);
    }
}
document.getElementById('img').addEventListener('change', handleFileSelect, false);
