// 画像サイズの制限とプレビュー表示
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