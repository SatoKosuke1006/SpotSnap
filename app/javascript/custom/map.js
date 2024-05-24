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
    document.getElementById('address').addEventListener('keypress', function(event) {
      if (event.key === 'Enter') {
        codeAddress();
      }
    });
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
      mapTypeControl: false,
      streetViewControl: false,
      fullscreenControl: false
    });

    // Places Service の初期化
    placesService = new google.maps.places.PlacesService(map);
    geocoder = new google.maps.Geocoder();
    infowindow = new google.maps.InfoWindow();

    // 投稿数を取得するAPIを呼び出し
    fetch(`/location_posts/count?lat=${userSpecifiedLocation.lat}&lng=${userSpecifiedLocation.lng}`)
      .then(response => response.json())
      .then(data => {
        const marker = createDraggableMarker(userSpecifiedLocation, data.count);
        markers.push(marker);
        if (mapElement.dataset.showInfowindow === "true") {
          displayLocation(marker);
        }
      });
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
function createDraggableMarker(location, postCount) {
  const fillColor = postCount > 0 ? "#FFA500" : "#00FF00"; // オレンジま���は緑
  const strokeColor = postCount > 0 ? "#FFA500" : "#00FF00"; // オレンジまたは緑

  const marker = new google.maps.Marker({
    map: map,
    position: location,
    draggable: false,
    icon: {
      path: google.maps.SymbolPath.CIRCLE,
      scale: 10,
      fillColor: fillColor,
      fillOpacity: 0.8,
      strokeWeight: 2,
      strokeColor: strokeColor
    }
  });
  return marker;
}

// 指定された位置の住所を表示する関数
function displayLocation(marker) {
  const mapElement = document.getElementById('map');
  const placeId = mapElement.getAttribute('data-place-id');

  if (placeId) {
    const request = {
      placeId: placeId,
      fields: ['name', 'formatted_address', 'geometry']
    };
    placesService.getDetails(request, function(place, status) {
      if (status === google.maps.places.PlacesServiceStatus.OK) {
        // 投稿数を取得するAPIを呼び出し
        fetch(`/location_posts/count?lat=${place.geometry.location.lat()}&lng=${place.geometry.location.lng()}`)
          .then(response => response.json())
          .then(data => {
            infowindow.setContent(`<a href="/location_posts?lat=${place.geometry.location.lat()}&lng=${place.geometry.location.lng()}&name=${encodeURIComponent(place.name)}&formatted_address=${encodeURIComponent(place.formatted_address)}">${place.name}</a>`);
            infowindow.open(map, marker);
          });
      }
    });
  }
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
        // 投稿数を取得するAPIを呼び出し
        fetch(`/location_posts/count?lat=${result.geometry.location.lat()}&lng=${result.geometry.location.lng()}`)
          .then(response => response.json())
          .then(data => {
            const marker = createDraggableMarker(result.geometry.location, data.count);
            map.setCenter(result.geometry.location);

            const individualInfowindow = new google.maps.InfoWindow({
              content: `<a href="/location_posts?lat=${result.geometry.location.lat()}&lng=${result.geometry.location.lng()}&name=${encodeURIComponent(result.name)}&formatted_address=${encodeURIComponent(result.formatted_address)}">${result.name}</a>`
            });

            if (index === 0) {
              individualInfowindow.open(map, marker);
              openInfowindow = individualInfowindow;
            }

            marker.addListener('click', () => {
              if (openInfowindow) {
                openInfowindow.close();
              }
              individualInfowindow.open(map, marker);
              openInfowindow = individualInfowindow;
            });

            markers.push(marker);
          });
      });
    } else {
      alert('該当する結果がありませんでした：' + status);
    }
  });
}

//緯度経度の入力フォームを更新する関数
function updateInputFields(lat, lng, placeId) {
  if (document.getElementById('lat') && document.getElementById('lng') && document.getElementById('place_id')) {
    document.getElementById('lat').value = lat;
    document.getElementById('lng').value = lng;
    document.getElementById('place_id').value = placeId;
  }
}

// オートコンプリート機能を追加する関数
function enableAutocomplete() {
    const input = document.getElementById('address');
    const autocomplete = new google.maps.places.Autocomplete(input);
    let enterPressCount = 0;

    autocomplete.addListener('place_changed', function() {
        const place = autocomplete.getPlace();
        // ペー���によって処理を分岐
        if (document.getElementById('map') && !document.getElementById('location-details')) {
            // index.html.erb の場合
            markers.forEach(marker => marker.setMap(null));
            markers = [];
            fetch(`/location_posts/count?lat=${place.geometry.location.lat()}&lng=${place.geometry.location.lng()}`)
              .then(response => response.json())
              .then(data => {
                const marker = createDraggableMarker(place.geometry.location, data.count);
                map.setCenter(place.geometry.location);
                infowindow.setContent(`<a href="/location_posts?lat=${place.geometry.location.lat()}&lng=${place.geometry.location.lng()}&name=${encodeURIComponent(place.name)}&formatted_address=${encodeURIComponent(place.formatted_address)}">${place.name}</a>`);
                infowindow.open(map, marker);
                markers.push(marker);
                updateInputFields(place.geometry.location.lat(), place.geometry.location.lng(), place.place_id);
              });
        } else if (document.getElementById('map') && document.getElementById('location-details')) {
            // _micropost_form.html.erb の場合
            displayPlaceDetails(place);
        }
        input.value = place.name; // 検索欄に場所の名前のみを表示
    });
}

function displayPlaceDetails(place) {
    const locationDetails = document.getElementById('location-details');
    if (place.formatted_address) {
    locationDetails.innerHTML = `${place.name}<br>${place.formatted_address}`;
    locationDetails.style.display = 'block';
    }

    // 緯度と経度のしフィールドを更新
    document.getElementById('lat').value = place.geometry.location.lat();
    document.getElementById('lng').value = place.geometry.location.lng();
    document.getElementById('place_id').value = place.place_id;
}

