// 画像投稿

// 巨大画像のアップロードを防止し、プレビューを表示させる
document.addEventListener("turbo:load", function() {
  let image_upload = document.querySelector('#file-upload');

  if (image_upload) {
    image_upload.addEventListener("change", function(event) {
      const size_in_megabytes = this.files[0].size/1024/1024;

      if (size_in_megabytes > 5) {
        alert("ファイルサイズが5MBを超えています。");
        this.value = ""; 
      } else {
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

//画像が選択されている場合のみ登録ボタンが表示させる
document.addEventListener("turbo:load", function () {
  const fileInput = document.getElementById('file-upload');
  const submitButton = document.querySelector('input[type="submit"]');

  if (fileInput && submitButton) {
    function updateSubmitButtonState() {
      submitButton.disabled = !fileInput.files.length;
    }
    updateSubmitButtonState();
    fileInput.addEventListener('change', updateSubmitButtonState);
  }
});

