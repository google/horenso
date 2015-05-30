var keyNames = 'qwertyuiopasdfghjkl;zxcvbnm,./';

var keyboardEl = document.getElementsByClassName('keyboard')[0];
var keyEls = [];

for (var row = 0; row < 3; row++) {
    var rowEl = document.createElement('div');
    rowEl.className = 'keyRow' + row;
    for (var key = 0; key < 10; key++) {
        var keyIndex = (row * 10) + key;
        var keyEl = document.createElement('div');
        keyEl.className = 'key';
        keyEl.id = 'key' + keyIndex;
        rowEl.appendChild(keyEl);
        keyEls[keyIndex] = keyEl;
    }
    keyboardEl.appendChild(rowEl);
}

for (var indexFingerKey of [keyEls[13], keyEls[16]]) {
    var guide = document.createElement('div');
    guide.className = 'indexFingerGuide';
    guide.innerHTML = '&nbsp;';
    indexFingerKey.appendChild(guide);
}
