// マップ

// 変数
let map, geocoder, infowindow, placesService;
let openInfowindow = null; // 開いているinfowindowを追跡するための変数
let markers = []; // マーカーを格納する配列

// イベントリスナー
  document.addEventListener("turbo:load", initialize);

// マップを初期化する関数
function initialize() {
  if (typeof google !== 'undefined' && (document.getElementById('map'))) {
    initMap();
    enableAutocomplete(); 
    document.getElementById('search-button').addEventListener('click', codeAddress);
  }
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
    markers.push(marker);
    if (mapElement.dataset.showInfowindow === "true") {
      displayLocation(initialLocation, marker);
    }
  });
}

// ユーザー指定の位置情報を取得する関数
function getUserSpecifiedLocation(mapElement, defaultLat, defaultLng) {
  if (mapElement && mapElement.hasAttribute('data-lat') && mapElement.hasAttribute('data-lng')) {
    return {
      lat: parseFloat(mapElement.getAttribute('data-lat')),
      lng: parseFloat(mapElement.getAttribute('data-lng'))
    };
  }
  return {lat: defaultLat, lng: defaultLng};
}

// マーカーを設置する関数
function createDraggableMarker(location) {
  const marker = new google.maps.Marker({
    map: map,
    position: location,
    draggable: false,
    icon: {
      path: google.maps.SymbolPath.CIRCLE,
      scale: 10,
      fillColor: "#00FF00", 
      fillOpacity: 0.8,
      strokeWeight: 2,
      strokeColor: "#00FF00" 
    }
  });
  return marker;
}

// 指定された位置の住所を表示する関数
function displayLocation(location, marker) {
  geocoder.geocode({'location': location}, function(results, status) {
    if (status === 'OK' && results[0]) {
      // Place ID を使用して詳細情報を取得
      const placeId = results[0].place_id;
      const request = {
        placeId: placeId,
        fields: ['name', 'formatted_address', 'geometry']
      };
      placesService.getDetails(request, function(place, status) {
        if (status === google.maps.places.PlacesServiceStatus.OK) {
          infowindow.setContent(`<a href="/location_posts?lat=${place.geometry.location.lat()}&lng=${place.geometry.location.lng()}&name=${encodeURIComponent(place.name)}">${place.name}<br>${place.formatted_address}</a>`);
          infowindow.open(map, marker);
          updateInputFields(location.lat(), location.lng());
        }
      });
    }
  });
}

// 入力れた住所から位置を検索し、マップを更新する関数
function codeAddress() {
  const inputAddress = document.getElementById('address').value;
  const request = {
    query: inputAddress,
    fields: ['name', 'formatted_address', 'geometry']
  };

  placesService.textSearch(request, function(results, status) {
    if (status === google.maps.places.PlacesServiceStatus.OK) {
      markers.forEach(marker => marker.setMap(null));
      markers = [];
      results.forEach((result, index) => {
        const marker = createDraggableMarker(result.geometry.location);
        map.setCenter(result.geometry.location);

        const individualInfowindow = new google.maps.InfoWindow({
          content: `<a href="/location_posts?lat=${result.geometry.location.lat()}&lng=${result.geometry.location.lng()}&name=${encodeURIComponent(result.name)}">${result.name}<br>${result.formatted_address}</a>`
        });

        if (index === 0) { // 最初の結果に対てinfowindowを自動で開く
          individualInfowindow.open(map, marker);
          openInfowindow = individualInfowindow;
        }

        marker.addListener('click', () => {
          if (openInfowindow) {
            openInfowindow.close(); // 他のinfowindowが���いていれば閉じる
          }
          individualInfowindow.open(map, marker);
          openInfowindow = individualInfowindow; // 現在開いているinfowindowを更新
        });

        markers.push(marker); // 新しいマーカーを配列に追加
        updateInputFields(result.geometry.location.lat(), result.geometry.location.lng());
      });
    } else {
      alert('該当する結果がありませんでした：' + status);
    }
  });
}

// 場所の詳細を取得して表示する関数
function fetchPlaceDetails(placeId, marker) {
  const request = {
        placeId: placeId,
        fields: ['name', 'formatted_address', 'geometry']
      };

  placesService.getDetails(request, function(place, status) {
    if (status === google.maps.places.PlacesServiceStatus.OK) {
      infowindow.setContent(`<a href="/location_posts?lat=${place.geometry.location.lat()}&lng=${place.geometry.location.lng()}&name=${encodeURIComponent(place.name)}">${place.name}<br>${place.formatted_address}</a>`);
      infowindow.open(map, marker);
    } else {
      console.error('Place details request failed due to ' + status);
    }
  });
}

//緯度経度の入力フォームを更新する関数
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
            alert("選択された場所には置情報がありません: " + place.name);
            return;
        }
        // ページによって処理を岐
        if (document.getElementById('map') && !document.getElementById('location-details')) {
            // index.html.erb の場合
            map.setCenter(place.geometry.location); 
            markers.forEach(marker => marker.setMap(null));
            markers = [];
            const marker = createDraggableMarker(place.geometry.location);
            infowindow.setContent(`<a href="/location_posts?lat=${place.geometry.location.lat()}&lng=${place.geometry.location.lng()}&name=${encodeURIComponent(place.name)}">${place.name}<br>${place.formatted_address}</a>`);
            infowindow.open(map, marker);
            markers.push(marker);
            updateInputFields(place.geometry.location.lat(), place.geometry.location.lng());
        } else if (document.getElementById('map') && document.getElementById('location-details')) {
            // _micropost_form.html.erb の場合
            displayPlaceDetails(place);
        }
        input.value = place.name; // 検索欄に場所の名前のみを表示
    });
}

function displayPlaceDetails(place) {
    const locationDetails = document.getElementById('location-details');
    locationDetails.innerHTML = `${place.name}<br>${place.formatted_address}`;
    locationDetails.style.display = 'block';

    // 緯度と経度のしフィーを更新
    document.getElementById('lat').value = place.geometry.location.lat();
    document.getElementById('lng').value = place.geometry.location.lng();
}

