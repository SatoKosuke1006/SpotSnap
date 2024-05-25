// 画像投稿

// 巨大画像のアップロードを防止し、プレビューを表示させる
document.addEventListener("turbo:load", setupImageUpload);
document.addEventListener("turbo:frame-load", setupImageUpload);
document.addEventListener("turbo:render", setupImageUpload);

function setupImageUpload() {
  let image_upload = document.querySelector('#file-upload');

  if (image_upload) {
    image_upload.removeEventListener("change", handleImageUpload);
    image_upload.addEventListener("change", handleImageUpload);
  }
}

function handleImageUpload(event) {
  const size_in_megabytes = this.files[0].size/1024/1024;

  if (size_in_megabytes > 5) {
    alert("ファイルサイズが5MBを超えています。");
    document.getElementById("preview-image").src = "#";
    document.getElementById("preview-image").style.display = "none";
  } else {
    var reader = new FileReader();
    reader.onload = function(e) {
      document.getElementById("preview-image").src = e.target.result;
      document.getElementById("preview-image").style.display = "inline";
    };
    reader.readAsDataURL(event.target.files[0]);
  }
}

//エンターによる投稿の回避
document.addEventListener("turbo:load", function () {
  const addressField = document.getElementById('address');
  if (addressField && document.getElementById('map') && document.getElementById('location-details')) {
    addressField.addEventListener('keydown', function(event) {
      if (event.key === 'Enter') {
        event.preventDefault();
      }
    });
  }
});