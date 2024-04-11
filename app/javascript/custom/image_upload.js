// // 巨大画像のアップロードを防止する
// document.addEventListener("turbo:load", function() {
//   document.addEventListener("change", function(event) {
//     let image_upload = document.querySelector('#file-upload');
//     const size_in_megabytes = image_upload.files[0].size/1024/1024;
//     if (size_in_megabytes > 5) {
//       alert("Maximum file size is 5MB. Please choose a smaller file.");
//       image_upload.value = "";
//     }
//   });
// });

// // 選択した画像をプレビュー表示する
// document.addEventListener("turbo:load", function() {
//   const fileInput = document.getElementById("file-upload");
//   const previewImage = document.getElementById("preview-image");
//   const customFileUpload = document.querySelector(".custom-file-upload");

//   customFileUpload.removeEventListener("click", handleFileUploadClick);
//   customFileUpload.addEventListener("click", handleFileUploadClick);

//   function handleFileUploadClick() {
//     fileInput.click();
//   }

//   fileInput.removeEventListener("change", handleFileInputChange);
//   fileInput.addEventListener("change", handleFileInputChange);

//   function handleFileInputChange() {
//     if (fileInput.files.length > 0) {
//       customFileUpload.textContent = fileInput.files[0].name;

//       const fileReader = new FileReader();
//       fileReader.onload = function(e) {
//         previewImage.src = e.target.result;
//         previewImage.style.display = 'block';
//       };
//       fileReader.readAsDataURL(fileInput.files[0]);
//     } else {
//       customFileUpload.textContent = "写真を選択";
//       previewImage.style.display = 'none';
//     }
//   }
// });