// // マップ

// // 変数
// let map, geocoder, infowindow, placesService;
// let openInfowindow = null; 
// let markers = []; 

// // イベントリスナー
// document.addEventListener("turbo:load", initialize);
// document.addEventListener("turbo:frame-load", initialize);
// document.addEventListener("turbo:render", initialize);

// // マップを初期化する関数
// function initialize() {
//   if (typeof google !== 'undefined' && (document.getElementById('map'))) {
//     placesService = new google.maps.places.PlacesService(document.createElement('div')); 
//     initMap();
//     enableAutocomplete(); 
//     document.getElementById('address').addEventListener('keypress', function(event) {
//       if (event.key === 'Enter') {
//         codeAddress();
//       }
//     });
//   }
// }

// // マップの初期設定
// function initMap() {
//   const mapElement = document.getElementById('map');
//   if (!navigator.geolocation) return;

//   console.log("A1");
//   navigator.geolocation.getCurrentPosition(async position => {
//     console.log("A2");
//     const {latitude, longitude} = position.coords;
//     const userSpecifiedLocation = await getUserSpecifiedLocation(mapElement, latitude, longitude);

//     map = new google.maps.Map(mapElement, {
//       center: userSpecifiedLocation,
//       zoom: 12,
//       mapTypeControl: false,
//       streetViewControl: false,
//       fullscreenControl: false
//     });

//     placesService = new google.maps.places.PlacesService(map);
//     geocoder = new google.maps.Geocoder();
//     infowindow = new google.maps.InfoWindow();

//     fetch(`/location_posts/count?lat=${userSpecifiedLocation.lat}&lng=${userSpecifiedLocation.lng}`)
//       .then(response => response.json())
//       .then(data => {
//         const marker = createDraggableMarker(userSpecifiedLocation, data.count);
//         markers.push(marker);
//         if (mapElement.dataset.showInfowindow === "true") {
//           displayLocation(marker);
//         }
//       });
//   });
// }

// // ユーザー指定の位置情報を取得する関数
// function getUserSpecifiedLocation(mapElement, defaultLat, defaultLng) {
//   return new Promise((resolve, reject) => {
//     if (mapElement && mapElement.hasAttribute('data-place-id')) {
//       const placeId = mapElement.getAttribute('data-place-id');
//       const request = {
//         placeId: placeId,
//         fields: ['geometry']
//       };
//       placesService.getDetails(request, function(place, status) {
//         if (status === google.maps.places.PlacesServiceStatus.OK) {
//           const lat = place.geometry.location.lat();
//           const lng = place.geometry.location.lng();
//           resolve({ lat, lng });
//         } else {
//           resolve({ lat: defaultLat, lng: defaultLng });
//         }
//       });
//     } else {
//       resolve({ lat: defaultLat, lng: defaultLng });
//     }
//   });
// }

// // マーカーを設定する数
// function createDraggableMarker(location, postCount) {
//   const fillColor = postCount > 0 ? "#FFA500" : "#00FF00"; 
//   const strokeColor = postCount > 0 ? "#FFA500" : "#00FF00"; 

//   const marker = new google.maps.Marker({
//     map: map,
//     position: location,
//     draggable: false,
//     icon: {
//       path: google.maps.SymbolPath.CIRCLE,
//       scale: 10,
//       fillColor: fillColor,
//       fillOpacity: 0.8,
//       strokeWeight: 2,
//       strokeColor: strokeColor
//     }
//   });
//   return marker;
// }

// // 指定された位置の住所を表示する関数
// function displayLocation(marker) {
//   const mapElement = document.getElementById('map');
//   const placeId = mapElement.getAttribute('data-place-id');

//   if (placeId) {
//     const request = {
//       placeId: placeId,
//       fields: ['name', 'formatted_address', 'geometry','place_id']
//     };
//     placesService.getDetails(request, function(place, status) {
//       if (status === google.maps.places.PlacesServiceStatus.OK) {
//         // 投稿を得すAPIを呼び出し
//         fetch(`/location_posts/count?place_id=${place.place_id}`)
//           .then(response => response.json())
//           .then(data => {
//             const marker = createDraggableMarker(place.geometry.location, data.count);
//             map.setCenter(place.geometry.location);
//             infowindow.setContent(`<a href="/location_posts?place_id=${place.place_id}&name=${encodeURIComponent(place.name)}&formatted_address=${encodeURIComponent(place.formatted_address)}">${place.name}</a>`);
//             infowindow.open(map, marker);
//         });
//       }
//     });
//   }
// }

// // 入力れた住所から位置を検索し、マップを更新する関数
// function codeAddress() {
//   const inputAddress = document.getElementById('address').value;
//   const request = {
//     query: inputAddress,
//     fields: ['name', 'formatted_address', 'geometry']
//   };

//   placesService.textSearch(request, function(results, status) {
//     if (status === google.maps.places.PlacesServiceStatus.OK) {
//       markers.forEach(marker => marker.setMap(null));
//       markers = [];
//       results.forEach((result, index) => {
//         // 投稿数を取得するAPIを呼び出し
//         fetch(`/location_posts/count?place_id=${result.place_id}`)
//           .then(response => response.json())
//           .then(data => {
//             const marker = createDraggableMarker(result.geometry.location, data.count);
//             console.log("B1");
//             map.setCenter(result.geometry.location);
//             console.log("B2");

//             const individualInfowindow = new google.maps.InfoWindow({
//               content: `<a href="/location_posts?place_id=${result.place_id}&name=${encodeURIComponent(result.name)}&formatted_address=${encodeURIComponent(result.formatted_address)}">${result.name}</a>`
//             });

//             if (index === 0) {
//               individualInfowindow.open(map, marker);
//               openInfowindow = individualInfowindow;
//             }

//             marker.addListener('click', () => {
//               if (openInfowindow) {
//                 openInfowindow.close();
//               }
//               individualInfowindow.open(map, marker);
//               openInfowindow = individualInfowindow;
//             });

//             markers.push(marker);
//           });
//       });
//     } else {
//       alert('該当する結果がありませんでした：' + status);
//     }
//   });
// }

// //緯度経度の入力フォームを更新する関数
// function updateInputFields(placeId) {
//   if (document.getElementById('place_id')) {
//     document.getElementById('place_id').value = placeId;
//   }
// }

// // オートコンプリート機能を追加する関数
// function enableAutocomplete() {
//     const input = document.getElementById('address');
//     const autocomplete = new google.maps.places.Autocomplete(input);

//     autocomplete.addListener('place_changed', function() {
//         const place = autocomplete.getPlace();
//         // ペーによって処理を分岐
//         if (document.getElementById('map') && !document.getElementById('location-details')) {
//             // index.html.erb の場合
//             if (place && place.geometry && place.geometry.location) {
//               markers.forEach(marker => marker.setMap(null));
//               markers = [];
//               fetch(`/location_posts/count?place_id=${place.place_id}`)
//                 .then(response => response.json())
//                 .then(data => {
//                   const marker = createDraggableMarker(place.geometry.location, data.count);
//                   console.log("C1");
//                   map.setCenter(place.geometry.location);
//                   console.log("C2");
//                   infowindow.setContent(`<a href="/location_posts?place_id=${place.place_id}&name=${encodeURIComponent(place.name)}&formatted_address=${encodeURIComponent(place.formatted_address)}">${place.name}</a>`);
//                   infowindow.open(map, marker);
//                   markers.push(marker);
//                   updateInputFields(place.place_id);
//                 });
//             }
//         } else if (document.getElementById('map') && document.getElementById('location-details')) {
//             // _micropost_form.html.erb の場合
//             displayPlaceDetails(place);
//         }
//         input.value = place.name; 
//     });
// }

// //　指定された場所の詳細を表示する
// function displayPlaceDetails(place) {
//     const locationDetails = document.getElementById('location-details');
//     if (place.formatted_address) {
//     locationDetails.innerHTML = `${place.name}<br>${place.formatted_address}`;
//     locationDetails.style.display = 'block';

//     document.getElementById('place_id').value = place.place_id;
//     }
// }

// //エンターによる投稿の回避
// document.addEventListener("turbo:load", function () {
//   const addressField = document.getElementById('address');
//   if (addressField && document.getElementById('map') && document.getElementById('location-details')) {
//     addressField.addEventListener('keydown', function(event) {
//       if (event.key === 'Enter') {
//         event.preventDefault();
//       }
//     });
//   }
// });


