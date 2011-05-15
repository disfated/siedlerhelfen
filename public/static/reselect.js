  var resources = {
    'Wood'           : { tab: 1 },
    'Plank'          : { },
    'Stone'          : { },
    'Fish'           : { },
    'EventResource'  : { name: 'Easter egg' },
    'Coal'           : { tab: 2 },
    'BronzeOre'      : { },
    'Bronze'         : { },
    'Tool'           : { },
    'Water'          : { },
    'Corn'           : { },
    'Beer'           : { },
    'Flour'          : { },
    'Bread'          : { },
    'BronzeSword'    : { },
    'Bow'            : { },
    'RealWood'       : { tab: 3 },
    'RealPlank'      : { },
    'IronOre'        : { },
    'Iron'           : { },
    'Steel'          : { },
    'GoldOre'        : { },
    'Gold'           : { },
    'Coin'           : { },
    'Marble'         : { },
    'Meat'           : { },
    'Sausage'        : { },
    'Horse'          : { },
    'IronSword'      : { },
    'SteelSword'     : { },
    'LongBow'        : { },
    'ExoticWood'     : { tab: 4 },
    'ExoticPlank'    : { },
    'TitaniumOre'    : { },
    'Titanium'       : { },
    'Salpeter'       : { },
    'Gunpowder'      : { },
    'Granite'        : { },
    'Wheel'          : { },
    'Carriage'       : { },
    'TitaniumSword'  : { },
    'Crossbow'       : { },
    'Cannon'         : { },
};

function resourceSelecter(select) {
    
    if (typeof select == 'string') {
        select = document.getElementById(select);
    };
    
    if (!select) return;
    
    var selectWrap = document.createElement('DIV');
    selectWrap.className = 'select-wrap';
    var selectedItem = document.createElement('DIV');
    selectedItem.className = 'select-selected';
    selectWrap.appendChild(selectedItem);
    var selectedIcon = document.createElement('IMG');
    selectedIcon.src = "";
    selectedItem.appendChild(selectedIcon);
    var selectedName = document.createElement('SPAN');
    selectedItem.appendChild(selectedName);
    var selectPane = document.createElement('DIV');
    selectPane.className = 'select-pane';
    selectWrap.appendChild(selectPane);
    
    /*
    <div class="select-wrap">
        <div class="select-selected">
            <img src="" />
            <span></span>
        </div>
        <div class="select-pane"></div>
    </div>
    */
    
    var resHtml = [], id, res, elem, tab;
    for (id in resources) {
        res = resources[id];
        if (!res.hasOwnProperty('tab')) res.tab = tab || 1;
        if (!res.hasOwnProperty('name')) res.name = id.replace(/([a-z])([A-Z]+)/g, function($0, $1, $2) { return $1 + ' ' + $2.toLowerCase() });
        res.icon = '/images/' + id.toLowerCase() + '.png';
        elem = document.createElement('IMG');
        elem.src = res.icon;
        elem.title = res.name;
        elem.resId = id;
        elem.onclick = function(e) {
            var elem = e.target || e.srcElement;
            var id = elem.resId;
            var res = resources[id];
            selectRes(id);
            paneHide();
        };
        if (tab && res.tab !== tab) {
            selectPane.appendChild(document.createElement('HR'));
        };
        tab = res.tab;
        selectPane.appendChild(elem);
        res.elem = elem;
    };
    
    select.parentNode.appendChild(selectWrap);
    select.style.display = 'none';
    selectRes(select.value);
    
    function selectRes(id) {
        var res = resources[id];
        selectedIcon.src = res.icon;
        selectedName.innerHTML = res.name;
        select.value = id;
    };
    
    function paneShow() {
        selectPane.style.display = 'block';
    };

    function paneHide() {
        selectPane.style.display = 'none';
    };

    selectWrap.onmouseover = paneShow;
    selectWrap.onmouseout  = paneHide;
    
};

window.onload = function() {
    try {
        resourceSelecter('offer_s');
        resourceSelecter('cost_s');
    } catch (e) {};
};

