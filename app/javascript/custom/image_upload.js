// 巨大画像のアップロードを防止する
document.addEventListener("turbo:load", function() {
  document.addEventListener("change", function(event) {
    let image_upload = document.querySelector('#micropost_image');
    const size_in_megabytes = image_upload.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert("Maximum file size is 5MB. Please choose a smaller file.");
      image_upload.value = "";
    }
  });
});

//ファイルを選択するときに「画像を選択」の文字を表示する
document.addEventListener("DOMContentLoaded", function() {
  const fileInput = document.getElementById("file-upload");
  
  const customFileUpload = document.querySelector(".custom-file-upload");
  customFileUpload.addEventListener("click", function() {
    fileInput.click();
  });
  
  fileInput.addEventListener("change", function() {
    if (fileInput.files.length > 0) {
      customFileUpload.textContent = fileInput.files[0].name;
    } else {
      customFileUpload.textContent = "写真を選択";
    }
  });
});