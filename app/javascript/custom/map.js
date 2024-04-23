// マップ

// 変数
let map, geocoder, infowindow;

// イベントリスナー
document.addEventListener("turbo:load", initialize);

// マップを初期化する関数
function initialize() {
  initMap();
  document.getElementById('search-button').addEventListener('click', codeAddress);
}

// マップの初期設定
function initMap() {
  const mapElement = document.getElementById('map');
  if (!navigator.geolocation) return;

  navigator.geolocation.getCurrentPosition(position => {
    const {latitude, longitude} = position.coords;
    const userSpecifiedLocation = getUserSpecifiedLocation(mapElement, latitude, longitude);
    const initialLocation = new google.maps.LatLng(userSpecifiedLocation.lat, userSpecifiedLocation.lng);

    map = new google.maps.Map(mapElement, {
      center: userSpecifiedLocation,
      zoom: 12,
    });

    geocoder = new google.maps.Geocoder();
    infowindow = new google.maps.InfoWindow();
    
    const marker = createDraggableMarker(userSpecifiedLocation);

    displayLocation(initialLocation, marker);
  });
}

// ユーザー指定の位置情報を取得する関数
function getUserSpecifiedLocation(mapElement, defaultLat, defaultLng) {
  if (mapElement.hasAttribute('data-lat') && mapElement.hasAttribute('data-lng')) {
    return {
      lat: parseFloat(mapElement.getAttribute('data-lat')),
      lng: parseFloat(mapElement.getAttribute('data-lng'))
    };
  }
  return {lat: defaultLat, lng: defaultLng};
}

// ドラック可能なマーカーを設置する関数
function createDraggableMarker(location) {
  const marker = new google.maps.Marker({
    map: map,
    position: location,
    draggable: true
  });
  
  google.maps.event.addListener(marker, 'dragend', (event) => updateLocation(event.latLng, marker));
  return marker;
}

// 指定された位置の住所を表示する関数
function displayLocation(location, marker) {
  geocoder.geocode({'location': location}, function(results, status) {
    if (status === 'OK' && results[0]) {
      infowindow.setContent(results[0].formatted_address);
      infowindow.open(map, marker);
      updateInputFields(location.lat(), location.lng());
    }
  });
}

// 入力された住所から位置を検索し、マップを更新する関数
function codeAddress() {
  const inputAddress = document.getElementById('address').value;
  geocoder.geocode({'address': inputAddress}, function(results, status) {
    if (status !== 'OK') {
      alert('該当する結果がありませんでした：' + status);
      return;
    }

    map.setCenter(results[0].geometry.location);
    const marker = createDraggableMarker(results[0].geometry.location);
    
    infowindow.setContent('検索結果の場所: ' + results[0].formatted_address);
    infowindow.open(map, marker);
    updateInputFields(results[0].geometry.location.lat(), results[0].geometry.location.lng());
  });
}

// マーカーの位置が変更したときに新しい位置情報を表示・更新する関数
function updateLocation(latLng, marker) {
  const newLocation = {lat: latLng.lat(), lng: latLng.lng()};
  updateInputFields(newLocation.lat, newLocation.lng);
  const locationDescription = `新しい位置: 緯度 ${newLocation.lat}, 経度 ${newLocation.lng}`;
  infowindow.setContent(locationDescription);
  infowindow.open(map, marker);
}

//緯度と経度の入力フォームを更新する関数
function updateInputFields(lat, lng) {
  if (document.getElementById('lat') && document.getElementById('lng')) {
    document.getElementById('lat').value = lat;
    document.getElementById('lng').value = lng;
  }
}
