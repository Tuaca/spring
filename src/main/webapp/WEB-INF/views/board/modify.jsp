<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="../includes/header.jsp" %>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Modify</h1>
	</div>
	<!-- /.col-lg-12  -->
</div>
<!-- /.row -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Modify Page</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<form role="form" action="/board/modify" method="post">
					<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
					<input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
					<input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>
					<input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'>				
					<div class="form-group">
						<label>Bno</label>
						<input class="form-control" name="bno" value='<c:out value="${board.bno}"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>Title</label>
						<input class="form-control" name="title" value='<c:out value="${board.title}"/>'>
					</div>
					<div class="form-group">
						<label>Text area</label>
						<textarea class="form-control" rows="3" name="content"><c:out value="${board.content}"/></textarea>
					</div>
					<div class="form-group">
						<label>Writer</label>
						<input class="form-control" name="writer" value='<c:out value="${board.writer}"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>RegDate</label>
						<input class="form-control" name='regDate' value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regDate}"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>UpdateDate</label>
						<input class="form-control" name='updateDate' value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updateDate}"/>' readonly="readonly">
					</div>
					<sec:authentication property="principal" var="pinfo"/>
					<sec:authorize access="isAuthenticated()">
						<c:if test="${pinfo.username eq board.writer}">
							<button type="submit" data-oper='modify' class="btn btn-primary">Modify</button>
							<button type="submit" data-oper='remove' class="btn btn-danger">Remove</button>
						</c:if>
					</sec:authorize>
					<button type="submit" data-oper='list' class="btn btn-info">List</button>
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				</form>
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel-default -->
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->
<div class='bigPictureWrapper'>
	<div class='bigPicture'></div>
</div>
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
	
	.uploadResult ul li div img{
		width:100px;
	}
	.uploadResult ul li div span{
		color:white;
	}
	
	.bigPictureWrapper{
		position:absolute;
		display:none;
		justify-content:center;
		align-items:center;
		top:0%;
		width:100vh;
		height:100vh;
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
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Files</div>
			<div class="panel-body">
				<div class='form-group uploadDiv'>
					<input type='file' name='uploadFile' multiple="multiple">
				</div>
				<div class="uploadResult">
					<ul></ul>
				</div>
				<!-- /.end uploadResult -->
			</div>
			<!-- /.end panel-body -->
		</div>
		<!-- /.end panel -->
	</div>
	<!-- /.end col-lg-12 -->
</div>
<!-- /.end row -->

<script type="text/javascript">
	window.onload = function(){
		const formObj = document.querySelector("form[role='form']");
		const uploadResult = document.querySelector('.uploadResult ul')
		const regExp = new RegExp("(.*?)\.(exe|sh|arz)$");
		const maxSize = 5242880; // 5MB
		const bno = ${board.bno};
		const csrfToken = "${_csrf.token}";
		
		// 기존 업로드 파일 불러오기
		fetch('/board/getAttachList?bno=' + bno)
		.then(response =>{
			return response.json();
		}).then(data=>{
			data.forEach(element=>{
				const li = document.createElement('li');
				const odiv = document.createElement('div');
				const ospan = document.createElement('span');
				const obutton = document.createElement('button');
				const oi = document.createElement('i');
				const obr = document.createElement('br');
				const oimg = document.createElement('img');
				
				li.setAttribute('data-path',element.uploadPath);
				li.setAttribute('data-uuid',element.uuid);
				li.setAttribute('data-filename',element.fileName);
				li.setAttribute('data-type',element.fileType);
				ospan.textContent = element.fileName;
				obutton.setAttribute('type','button');
				obutton.setAttribute('class','btn btn-warning btn-circle');
				oi.setAttribute('class','fa fa-times');
				
				if(element.fileType){
					const fileCallPath = encodeURIComponent(element.uploadPath + "\\s_" + element.uuid + "_" + element.fileName);
					obutton.setAttribute('data-file',fileCallPath);
					obutton.setAttribute('data-type','image');
					oimg.setAttribute('src','/display?fileName=' + fileCallPath);
				} else {
					const fileCallPath = encodeURIComponent(element.uploadPath + "\\" + element.uuid + "_" + element.fileName);
					//const fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
					obutton.setAttribute('data-file',fileCallPath);
					obutton.setAttribute('data-type','file');
					oimg.setAttribute('src','/resources/images/attach.png');
				}
 				obutton.onclick = function(e){
 					e.stopPropagation();
 					let targetFile = null;
 					let type = null;
 					if(e.target === oi){
 						targetFile = e.target.parentNode.getAttribute('data-file');
 						type = e.target.parentNode.getAttribute('data-type');
 					} else {
 						targetFile = e.target.getAttribute('data-file');
 						type = e.target.getAttribute('data-type');
 					}
					const responseBody = {fileName:targetFile,type:type};
					
					if(confirm("Remove this file? ")){
						if(e.target === oi) e.target.parentNode.parentNode.parentNode.remove();
						else e.target.parentNode.parentNode.remove();
					}
					
					/* fetch('/deleteFile', {
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
						
					}).catch((e)=>{
						console.warn(e);
					}); */
				}
				
				obutton.append(oi);
				odiv.append(ospan);
				odiv.append(obutton);
				odiv.append(obr);
				odiv.append(oimg);
				li.append(odiv);
				uploadResult.append(li);
			});
		});
		
		function checkExtension(fileName,fileSize){
			if(fileSize >= maxSize){
				alert("업로드할 파일은 5MB 이하여야 합니다");
				return false;
			}
			if(regExp.test(fileName)){
				alert("해당 확장자명은 업로드 할 수 없습니다. : EXE, SH, ARZ");
				return false;
			}
			return true;
		}
		
		document.querySelector("input[type='file']").onchange = function(e){
			const formData = new FormData();
			const inputFile = document.querySelectorAll("input[name='uploadFile']");
			const files = inputFile[0].files;
			for(let i = 0; i <files.length; i++){
				if(!checkExtension(files[i].name,files[i].size)) return false;
				formData.append("uploadFile",files[i]);
			}
			
			fetch("/uploadAjaxAction", {
				headers:{'X-CSRF-Token':csrfToken,},
				method:'POST',
				cache:'no-cache',
				body:formData
			}).then((response)=>{
				if(response.ok) return response.json();
			}).then((data)=>{
				console.log(data);
				showUploadFile(data);
			}).catch((e)=>{
				console.warn(e);
			});
		}
		
		function showUploadFile(uploadResultArr){
			uploadResultArr.forEach(element=>{
				const li = document.createElement('li');
				const odiv = document.createElement('div');
				const ospan = document.createElement('span');
				const obutton = document.createElement('button');
				const oi = document.createElement('i');
				const obr = document.createElement('br');
				const oimg = document.createElement('img');
				
				li.setAttribute('data-path',element.uploadPath);
				li.setAttribute('data-uuid',element.uuid);
				li.setAttribute('data-filename',element.fileName);
				li.setAttribute('data-type',element.image);
				console.log(element.image);
				ospan.textContent = element.fileName;
				obutton.setAttribute('type','button');
				obutton.setAttribute('class','btn btn-warning btn-circle');
				oi.setAttribute('class','fa fa-times');
				
				if(element.image){
					const fileCallPath = encodeURIComponent(element.uploadPath + "\\s_" + element.uuid + "_" + element.fileName);
					obutton.setAttribute('data-file',fileCallPath);
					obutton.setAttribute('data-type','image');
					oimg.setAttribute('src','/display?fileName=' + fileCallPath);
				} else {
					const fileCallPath = encodeURIComponent(element.uploadPath + "\\" + element.uuid + "_" + element.fileName);
					//const fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
					obutton.setAttribute('data-file',fileCallPath);
					obutton.setAttribute('data-type','file');
					oimg.setAttribute('src','/resources/images/attach.png');
				}
 				obutton.onclick = function(e){
 					e.stopPropagation();
 					let targetFile = null;
 					let type = null;
 					if(e.target === oi){
 						targetFile = e.target.parentNode.getAttribute('data-file');
 						type = e.target.parentNode.getAttribute('data-type');
 					} else {
 						targetFile = e.target.getAttribute('data-file');
 						type = e.target.getAttribute('data-type');
 					}
					const responseBody = {fileName:targetFile,type:type};
					
					fetch('/deleteFile', {
						headers:{
							'Content-Type':'application/json',
							'X-CSRF-Token':csrfToken,
						},
						method:'POST',
						cache:'no-cache',
						body: JSON.stringify(responseBody)
					}).then((response) =>{
						if(response.ok) return response;
						else return Promise.reject('Error code : ' + response.status);
					}).then((data)=>{
						if(e.target === oi) e.target.parentNode.parentNode.parentNode.remove();
						else e.target.parentNode.parentNode.remove();
					}).catch((e)=>{
						console.warn(e);
					});
				}
				
				obutton.append(oi);
				odiv.append(ospan);
				odiv.append(obutton);
				odiv.append(obr);
				odiv.append(oimg);
				li.append(odiv);
				uploadResult.append(li);
			});
		}
	}
	
	function getIndex(element){
	    let count = 0;
	    while((element = element.previousElementSibling) != null){
	        count++;
	    }
	    return count;
	}
	
	$(document).ready(function(){
		const formObj = $("form");
		
		$('button').on("click", function(e){
			e.preventDefault();
			let operation = $(this).data("oper");
			console.log(operation);
			
			if(operation === 'remove') formObj.attr("action","/board/remove").attr("method","post");
			else if(operation === 'list') {
				formObj.attr("action","/board/list").attr("method","get");
				let pageNumTag = $("input[name='pageNum']").clone();
				let amountTag = $("input[name='amount']").clone();
				let keywordTag = $("input[name='keyword']").clone();
				let typeTag = $("input[name='type']").clone();
				
				formObj.empty();
				formObj.append(pageNumTag);
				formObj.append(amountTag);
				formObj.append(keywordTag);
				formObj.append(typeTag);
			} else if(operation === 'modify'){
				console.log('submit clicked');
				document.querySelectorAll('.uploadResult ul li').forEach(element =>{
					const inputFileName = document.createElement('input');
					const inputUuid = document.createElement('input');
					const inputUploadPath = document.createElement('input');
					const inputFileType = document.createElement('input');
					inputFileName.setAttribute('type','hidden');
					inputFileName.setAttribute('name','attachList[' + getIndex(element) + '].fileName');
					inputFileName.setAttribute('value',element.getAttribute('data-filename'));
					inputUuid.setAttribute('type','hidden');
					inputUuid.setAttribute('name','attachList[' + getIndex(element) + '].uuid');
					inputUuid.setAttribute('value',element.getAttribute('data-uuid'));
					inputUploadPath.setAttribute('type','hidden');
					inputUploadPath.setAttribute('name','attachList[' + getIndex(element) + '].uploadPath');
					inputUploadPath.setAttribute('value',element.getAttribute('data-path'));
					inputFileType.setAttribute('type','hidden');
					inputFileType.setAttribute('name','attachList[' + getIndex(element) + '].fileType');
					inputFileType.setAttribute('value',element.getAttribute('data-type'));
					formObj.append(inputFileName);
					formObj.append(inputUuid);
					formObj.append(inputUploadPath);
					formObj.append(inputFileType);
				});
				formObj.submit();
			}
		});
	});
</script>

<%@ include file="../includes/footer.jsp" %>