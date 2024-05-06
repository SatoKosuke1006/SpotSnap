// マップ

// 変数
let map, geocoder, infowindow, placesService;

// イベントリスナー
document.addEventListener("turbo:load", initialize);

// マップを初期化する関数
function initialize() {
  initMap();
  enableAutocomplete(); 
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

    // Places Service の初期化
    placesService = new google.maps.places.PlacesService(map);
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
      // Place ID を使用して詳細情報を取得
      const placeId = results[0].place_id;
      const request = { placeId: placeId };
      placesService.getDetails(request, function(place, status) {
        if (status === google.maps.places.PlacesServiceStatus.OK) {
          infowindow.setContent(`${place.name}<br>${place.formatted_address}`);
          infowindow.open(map, marker);
          updateInputFields(location.lat(), location.lng());
        }
      });
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

    fetchPlaceDetails(results[0].place_id, marker);

    updateInputFields(results[0].geometry.location.lat(), results[0].geometry.location.lng());
  });
}

// 場所の詳細を取得して表示する関数
function fetchPlaceDetails(placeId, marker) {
  const request = {
    placeId: placeId,
    fields: ['name', 'formatted_address']
  };

  placesService.getDetails(request, function(place, status) {
    if (status === google.maps.places.PlacesServiceStatus.OK) {
      infowindow.setContent(`${place.name}<br>${place.formatted_address}`);
      infowindow.open(map, marker);
    } else {
      console.error('Place details request failed due to ' + status);
    }
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

// オートコンプリート機能を追加する関数
function enableAutocomplete() {
    const input = document.getElementById('address');
    const autocomplete = new google.maps.places.Autocomplete(input);
    autocomplete.addListener('place_changed', function() {
        const place = autocomplete.getPlace();
        if (!place.geometry) {
            alert("選択された場所には位置情報がありません: " + place.name);
            return;
        }
        // ページによって処理を分岐
        if (document.getElementById('map')) {
            // index.html.erb の場合
            map.setCenter(place.geometry.location);
            const marker = createDraggableMarker(place.geometry.location);
            infowindow.setContent(`${place.name}<br>${place.formatted_address}`);
            infowindow.open(map, marker);
            updateInputFields(place.geometry.location.lat(), place.geometry.location.lng());
        } else if (document.getElementById('location-details')) {
            // _micropost_form.html.erb の場合
            displayPlaceDetails(place);
        }
    });
}

function displayPlaceDetails(place) {
    const locationDetails = document.getElementById('location-details');
    locationDetails.innerHTML = `${place.name}<br>${place.formatted_address}`;
    locationDetails.style.display = 'block';

    // 緯度と経度の隠しフィールドを更新
    document.getElementById('lat').value = place.geometry.location.lat();
    document.getElementById('lng').value = place.geometry.location.lng();
}

