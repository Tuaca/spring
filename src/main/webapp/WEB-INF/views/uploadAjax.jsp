<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	.uploadResult{
		width:100%;
		background-color:gray;
	}
	
	.uploadResult ul{
 		display:flex;
		flex-flow:row;
		justify-content: center;
		align-items:center;
	}
	
	.uploadResult ul li{
		list-style: none;
		padding: 10px;
		align-content:center;
		text-align:center;
	}
	
	.uploadResult ul li img{
		width:100px;
	}
	.uploadResult ul li span{
		color:white;
	}
	
	.bigPictureWrapper{
		position:absolute;
		display:none;
		justify-content:center;
		align-items:center;
		top:0%;
		width:100%;
		height:100%;
		background-color:gray;
		z-index:100;
		background:rgba(255,255,255,0.5);
	}
	.bigPicture{
		position:relative;
		display:flex;
		justify-content:center;
		align-items:center;
		transition: width 1s, height 1s;
	}
	.bigPicture img{
		width:600px;
	}
	
</style>
</head>
<body>
	<div class='uploadDiv'>
		<input type='file' name='uploadFile' multiple>
	</div>
	<div class='uploadResult'>
		<ul>
			
		</ul>
	</div>
	<button id='uploadBtn'>Upload</button>
	<div class='bigPictureWrapper'>
		<div class='bigPicture'></div>
	</div>
	
	<script type="text/javascript">
		
		const imageWrapper = document.querySelector('.bigPictureWrapper');
		const picture = document.querySelector('.bigPicture');
		
		function showImage(fileCallPath){
			// alert(fileCallPath);
			if(document.querySelector('.bigPicture img') == null){
				const oimg =  document.createElement('img');
				oimg.setAttribute('src','/display?fileName=' + encodeURI(fileCallPath));
				picture.append(oimg);
			}

			imageWrapper.style.display = 'flex';
			picture.style.width = '100%';
			picture.style.height = '100%';
		}
		
		imageWrapper.onclick = function(e){
			picture.style.width = '0%';
			picture.style.height = '0%';
			this.style.display = 'none';
		}
		
		window.onload = function(){
			const uploadResult = document.querySelector('.uploadResult ul');
			const cloneObj = document.querySelector('.uploadDiv').getInnerHTML();
			const regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			const maxSize = 5242880;
						
			function showUploadFile(uploadResultArr){
				uploadResultArr.forEach(element=>{
					const li = document.createElement('li');
					const oa = document.createElement('a');
					const ospan = document.createElement('span');
					const oimg = document.createElement('img');
					ospan.textContent = ' X ';
					
					if(!element.image){
						const fileCallPath = encodeURIComponent(element.uploadPath + "/" + element.uuid + "_" + element.fileName);
						oa.setAttribute('href','/download?fileName='+fileCallPath);
						oa.textContent = element.fileName + '';
						ospan.setAttribute('data-file',fileCallPath);
						ospan.setAttribute('data-type','file');
						oimg.setAttribute('src', '/resources/images/attach.png');
					} else {
						const fileCallPath = encodeURIComponent(element.uploadPath + "/s_" + element.uuid + "_" + element.fileName);
						let originPath = element.uploadPath + "\\" + element.uuid + "_" + element.fileName;
						originPath = originPath.replace(new RegExp(/\\/g),"/");
						
						ospan.setAttribute('data-file',fileCallPath);
						ospan.setAttribute('data-type','image');
						oa.setAttribute('href','javascript:showImage(' + '"' + originPath + '"' + ')');
						oimg.setAttribute('src', '/display?fileName=' + fileCallPath);
					}
					
					ospan.onclick = function(e){
						const targetFile = e.target.getAttribute('data-file');
						const type = e.target.getAttribute('data-type');
						const responseBody = {fileName:targetFile,type:type};
/* 						console.log(responseBody);
						console.log(typeof responseBody);
						console.log(JSON.stringify(responseBody)); */
						
						fetch('/deleteFile', {
							headers:{
								'Content-Type':'application/json',
							},
							method:'POST',
							cache:'no-cache',
							body: JSON.stringify(responseBody)
						}).then((response) =>{
							if(response.ok) return response;
							else return Promise.reject('Error code : ' + response.status);
						}).then((data)=>{
							console.log(data);
						}).catch((e)=>{
							console.warn(e);
						});
					}
					
					oa.prepend(oimg);
					li.append(oa);
					li.append(ospan);
					uploadResult.append(li);
				});
			}
			
			function checkExtension(fileName, fileSize){
				if(fileSize >= maxSize){
					alert("파일 사이즈 초과");
					return false;
				}
				if(regex.test(fileName)){
					alert("해당 종류의 파일은 업로드 할 수 없습니다.");
					return false;
				}
				return true;
			}
			
/* 			function clone(obj){
				if(obj === null || typeof(obj) !== 'object') return obj;
				
				const copy = obj.constructor();
				
				for(let attr in obj){
					if(obj.hasOwnProperty(attr)){
						copy[attr] = obj[attr];
					}
				}
				return copy;
			} */
			
			document.querySelector('#uploadBtn').onclick = function(){
				const formData = new FormData();
				const inputFile = document.querySelectorAll('input[name="uploadFile"]');
				const files = inputFile[0].files;
				
				console.log(files);
				
				for(let i = 0; i < files.length; i++){
					if(!checkExtension(files[i].name, files[i].size)){
						console.log('checkExtension error');
						return false;
					}
					formData.append("uploadFile",files[i]);
				}
				/*
				const xhr = new XMLHttpRequest();
				xhr.open("POST", "/uploadAjaxAction", true);
				xhr.send(formData);
				xhr.onreadstatechange = function(){
					if(xhr.readyState === 4 && xhr.status === 200){
						alert('upload complete');
					}
				} */
				
				fetch("/uploadAjaxAction", {
					method: 'POST',
					cache: 'no-cache',
					body: formData
				}).then((response)=>{
					if(response.ok) return response.json();
					else return Promise.reject('Error code : ' + response.status);
				}).then((data)=>{
					console.log(data);
					showUploadFile(data);
					document.querySelector('.uploadDiv').innerHTML = cloneObj;
				}).catch((e)=>{
					console.warn(e);
				});
			}
		}
	</script>
</body>
</html>