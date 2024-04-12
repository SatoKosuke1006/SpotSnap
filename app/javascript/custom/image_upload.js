// 巨大画像のアップロードを防止する
document.addEventListener("turbo:load", function() {
  document.addEventListener("change", function(event) {
    let image_upload = document.querySelector('#file-upload');
    const size_in_megabytes = image_upload.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert("Maximum file size is 5MB. Please choose a smaller file.");
      image_upload.value = "";
    }
  });
});

// プレビュー画像を表示する
document.getElementById("file-upload").onchange = function(e) {
    var reader = new FileReader();
    reader.onload = function(e) {
      document.getElementById("preview-image").src = e.target.result;
      document.getElementById("preview-image").style.display = "inline";
    };
    reader.readAsDataURL(this.files[0]);
  };