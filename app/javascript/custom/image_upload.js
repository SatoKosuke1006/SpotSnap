// 巨大画像のアップロードを防止する
document.addEventListener("turbo:load", function() {
  let image_upload = document.querySelector('#file-upload');
  if (image_upload) {
    image_upload.addEventListener("change", function(event) {
      const size_in_megabytes = this.files[0].size/1024/1024;
      if (size_in_megabytes > 5) {
        alert("Maximum file size is 5MB. Please choose a smaller file.");
        this.value = ""; // Reset the file input
      } else {
        // プレビュー画像を表示する
        var reader = new FileReader();
        reader.onload = function(e) {
          document.getElementById("preview-image").src = e.target.result;
          document.getElementById("preview-image").style.display = "inline";
        };
        reader.readAsDataURL(event.target.files[0]);
      }
    });
  }
});