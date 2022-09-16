<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="../includes/header.jsp" %>
<style>
	#refreshReplyBtn img{
		transform: rotate(0deg);
		transition: transform 5s;
	}
	#refreshReplyBtn img:hover{
		transform: rotate(-720deg);
	}
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
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Read</h1>
	</div>
	<!-- /. end col-lg-12  -->
</div>
<!-- /. end row -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Read Page</div>
			<!-- /. end panel-heading -->
			<div class="panel-body">
				<div class="form-group">
					<label>Bno</label>
					<input class="form-control" name="bno" value='<c:out value="${board.bno}"/>' readonly="readonly">
				</div>
				<div class="form-group">
					<label>Title</label>
					<input class="form-control" name="title" value='<c:out value="${board.title}"/>' readonly="readonly">
				</div>
				<div class="form-group">
					<label>Text area</label>
					<textarea class="form-control" rows="3" name="content" readonly="readonly"><c:out value="${board.content}"/></textarea>
				</div>
				<div class="form-group">
					<label>Writer</label>
					<input class="form-control" name="writer" value='<c:out value="${board.writer}"/>' readonly="readonly">
				</div>
				<sec:authentication property="principal" var="pinfo"/>
				<sec:authorize access="isAuthenticated()">
					<c:if test="${pinfo.username eq board.writer}">
						<button data-oper='modify' class="btn btn-default" onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'">Modify</button>
					</c:if>
				</sec:authorize>
				<button data-oper='list' class="btn btn-info" onclick="location.href='/board/list'">List</button>
				<form id='operForm' action="/board/modify" method="get">
					<input type="hidden" id='bno' name ='bno' value='<c:out value="${board.bno}"/>'>
					<input type="hidden" name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
					<input type="hidden" name='amount' value='<c:out value="${cri.amount}"/>'>
					<input type="hidden" name='type' value='<c:out value="${cri.type}"/>'>
					<input type="hidden" name='keyword' value='<c:out value="${cri.keyword}"/>'>
				</form>
			</div>
			<!-- /. end panel-body -->
		</div>
		<!-- /. end panel-default -->
	</div>
	<!-- /. end col-lg-12 -->
</div>
<!-- /. end row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Files</div>
			<div class="panel-body">
				<div class="uploadResult">
					<ul></ul>
				</div><!-- /.end uploadResult -->
			</div><!-- /.end panel-body -->
		</div><!-- /.end panel -->
	</div><!-- /.end col-lg-12 -->
</div><!-- /.end row -->
<div class='bigPictureWrapper'>
	<div class='bigPicture'></div>
</div>
<div class='row'>
	<div class='col-lg-12'>
		<div class='panel panel-default'>
			<div class='panel-heading'>
				<i class='fa fa-comments fa-fw'></i> Reply
				<div class='pull-right'>
					<a id='refreshReplyBtn' href='javascript:;' onclick='showList(1)'><img alt="refresh" src="/resources/images/refresh.png" width="15" height="15"/></a>
					&nbsp;
					<sec:authorize access="isAuthenticated()">
						<button id='addReplyBtn' class='btn btn-primary btn-xs'>New Reply</button>
					</sec:authorize>
				</div>
			</div>
			<!-- /. end panel-heading -->
			<div class='panel-body'>
				<ul class="chat">
					<li class="left clearfix" data-rno='12'>
						<div>
							<div class='header'>
								<strong class='primary-font'>user00</strong>
								<small class='pull-right text-muted'>2018-01-01 13:13 </small>
							</div>
							<!-- /. end header -->
							<p>Good Job!</p>
						</div>
					</li>
					<!-- /. end reply -->
				</ul>
				<!-- /. end chat -->
			</div>
			<!-- /. end panel-body -->
			<div class="panel-footer">
				
			</div>
			<!-- /. end panel-footer -->
		</div>
		<!-- /. end panel -->
	</div>
	<!-- /. end col-lg-12 -->
</div>
<!-- /. end row -->

<!-- MyModal 추가 -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Reply Modal</h4>
			</div>
			<div class="modal-body">
				<div class='form-group'>
					<label>Reply</label>
					<input class='form-control' name='reply' value='New Reply!!'>
				</div>
				<div class='form-group'>
					<label>Replyer</label>
					<input class='form-control' name='replyer' value='replyer'>
				</div>
				<div class='form-group'>
					<label>Reply Date</label>
					<input class='form-control' name='replyDate' value=''>
				</div>
			</div>
			<div class="modal-footer">
				<button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
				<button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
				<button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
				<button id='modalCloseBtn' type="button" class="btn btn-default" data-dismiss='modal'>Close</button>
			</div>
		</div>
		<!-- /. end modal-content -->
	</div>
	<!-- /. end modal-dialog -->
</div>
<!-- /. end modal -->

<script type="text/javascript" src="/resources/js/reply.js"></script>
<script>
	const bnoValue = '<c:out value="${board.bno}"/>';
	const replyUL = $(".chat");
	const imageWrapper = document.querySelector('.bigPictureWrapper');
	const picture = document.querySelector('.bigPicture');
	
	let pageNum = 1;
	const replyPageFooter = $(".panel-footer");

	$(document).ready(function() {
		getAttachList(bnoValue);
		
		const operForm = $("#operForm");
		
		let replyer = null;
		<sec:authorize access="isAuthenticated()">
			replyer = '<sec:authentication property="principal.username"/>';
		</sec:authorize>
		const csrfHeaderName = "${_csrf.headerName}"
		const csrfToken = "${_csrf.token}";
		
		$(document).ajaxSend(function(e,xhr,options){
			xhr.setRequestHeader(csrfHeaderName,csrfToken);
		});
		
		// 게시물 수정 화면으로 이동
		$("button[data-oper='modify']").on("click", function(e) {
			operForm.attr("action", "/board/modify").submit();
		});
		
		// 게시물 리스트로 이동
		$("button[data-oper='list']").on("click", function(e) {
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list");
			operForm.submit();
		});

		showList(1);
		
		const modal = $(".modal");
		const modalInputReply = modal.find("input[name='reply']");
		const modalInputReplyer = modal.find("input[name='replyer']");
		const modalInputReplyDate = modal.find("input[name='replyDate']");
		
		const modalModBtn = $("#modalModBtn");
		const modalRemoveBtn = $("#modalRemoveBtn");
		const modalRegisterBtn = $("#modalRegisterBtn");
		
		//댓글 등록 모달창 띄우기
		$("#addReplyBtn").on("click", function(e){
			modal.find("input").val("");
			modal.find("input[name='replyer']").val(replyer);
			modalInputReplyDate.closest("div").hide();
			modal.find("button[id !='modalCloseBtn']").hide();
			
			modalRegisterBtn.show();
			
			$(".modal").modal("show");
		});
		
		// 댓글 등록
		modalRegisterBtn.on("click",function(e){
			const reply = {
				reply : modalInputReply.val(),
				replyer : modalInputReplyer.val(),
				bno : bnoValue
			};
			replyService.add(reply, function(result){
				alert(result);
				
				modal.find("input").val("");
				modal.modal("hide");
				
				showList(-1);
			});
		});
		
		// 댓글 수정, 삭제 모달창 띄우기
		$(".chat").on("click", "li", function(e){
			const rno = $(this).data("rno");
			if(!replyer){
				alert("로그인이 필요한 서비스입니다.");
				modal.modal("hide");
				return;
			}
			replyService.get(rno, function(reply){
				if(replyer != reply.replyer){
					alert("자신이 작성한 댓글만 수정이 가능합니다.");
					modal.modal("hide");
					return;
				}
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer).attr("readonly","readonly");
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
				modal.data("rno", reply.rno);
				
				modal.find("button[id != 'modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				
				$(".modal").modal("show");
			});
		});
		
		// 댓글 수정
		modalModBtn.on("click",function(e){
			const originalReplyer = modalInputReplyer.val();
			const reply = {rno:modal.data("rno"),reply:modalInputReply.val(),replyer:originalReplyer};
			replyService.update(reply, function(result){
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		// 댓글 삭제
		modalRemoveBtn.on("click",function(e){
			const originalReplyer = modalInputReplyer.val();
			const rno = modal.data("rno");
			replyService.remove(rno,originalReplyer, function(result){
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		// 댓글 페이지 이동하기
		replyPageFooter.on("click", "li a", function(e){
			e.preventDefault();
			console.log("page click");
			
			const targetPageNum = $(this).attr("href");
			console.log("targetPageNum : " + targetPageNum);
			pageNum = targetPageNum;
			showList(pageNum);
		});
	});
	
	// 댓글 불러오기
	function showList(page) {
		
		console.log("show list " + page);
		
		replyService.getList({bno : bnoValue,page : page || 1},function(replyCnt, list) {

			console.log("replyCnt : " + replyCnt);
			console.log("list : " + list);
			console.log(list);
			
			if(page == -1){
				pageNum = Math.ceil(replyCnt/10.0);
				showList(pageNum);
				return;
			}
			
			let str = "";
			
			if (list == null || list.length == 0) {
				replyUL.html(str);
				return;
			}
			for (let i = 0, len = list.length || 0; i < len; i++) {
				str += "<li calss='left clearfix' data-rno='" + list[i].rno + "'>";
				str += "	<div>";
				str += "		<div class='header'>";
				str += "			<strong class='primary-font'>[" + list[i].rno + "] "+ list[i].replyer + "</strong>";
				str += "			<small class='pull-right text-muted'>"+ replyService.displayTime(list[i].replyDate)+ "</small>";
				str += "		</div>";
				str += "	<p>" + list[i].reply+ "</p>";
				str += "	</div>";
				str += "</li>";
			}
			replyUL.html(str);
			showReplyPage(replyCnt);
		});
	}
	
	// 댓글 페이징 처리
	function showReplyPage(replyCnt){
		let endNum = Math.ceil(pageNum / 10.0) * 10;
		const startNum = endNum - 9;
		
		let prev = startNum != 1;
		let next = false;
		
		if(endNum * 10 >= replyCnt) endNum = Math.ceil(replyCnt/10.0);
		if(endNum * 10 < replyCnt) next = true;
		
		let str = "<ul class='pagination pull-right'>";
		
		if(prev){
			str += "<li class='page-item'><a class='page-link' href='" + (startNum - 1) + "'>Previous</a></li>"
		}
		
		for(let i = startNum; i <= endNum; i++){
			let active = pageNum == i ? "active" : "";
			
			str += "<li class='page-item " + active + "'><a class='page-link' href='" + i + "'>" + i + "</a></li>";
		}
		
		if(next){
			str += "<li calss='page-item'><a class='page-link' href='" + (endNum + 1) + "'>Next</a></li>"
		}
		
		str += "</ul>";
		
		console.log(str);
		replyPageFooter.html(str);
	}
	function getAttachList(bno){
		fetch('/board/getAttachList?bno='+bno).then((response)=>{
			if(response.ok) return response.json();
			else return Promise.reject('Error code : ' + response.status);
		}).then((data)=>{
			console.log(data);
			const uploadResult = document.querySelector('.uploadResult ul');
			data.forEach(attach=>{
				const li = document.createElement('li');
				const odiv = document.createElement('div');
				const ospan = document.createElement('span');
				const obr = document.createElement('br');
				const oimg = document.createElement('img');
				
				li.setAttribute('data-path',attach.uploadPath);
				li.setAttribute('data-uuid',attach.uuid);
				li.setAttribute('data-filename',attach.fileName);
				li.setAttribute('data-type',attach.fileType);
				ospan.textContent = attach.fileName;
				if(attach.fileType){
					const fileCallPath = encodeURIComponent(attach.uploadPath + "\\s_" + attach.uuid + "_" + attach.fileName);
					oimg.setAttribute('src','/display?fileName=' + fileCallPath);
				} else {
					const fileCallPath = encodeURIComponent(attach.uploadPath + "\\" + attach.uuid + "_" + attach.fileName);
					//const fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
					oimg.setAttribute('src','/resources/images/attach.png');
				}
				
				li.onclick = function(e){
					e.stopPropagation();
					let oli = null;
					if(e.target === li) oli = e.target;
					else if(e.target === odiv) oli = e.target.parentNode;
					else oli = e.target.parentNode.parentNode;
					const path = encodeURIComponent(oli.getAttribute('data-path')+"\\"+oli.getAttribute('data-uuid')+"_"+oli.getAttribute('data-filename'));
					if(oli.getAttribute('data-type') === 'true') showImage(path.replace(new RegExp(/\\/g),"/"));
					else self.location = "/download?fileName="+path;
				}
				
				odiv.append(ospan);
				odiv.append(obr);
				odiv.append(oimg);
				li.append(odiv);
				uploadResult.append(li);
			});
		}).catch((e)=>{
			console.warn(e);
		});
	}
	
	imageWrapper.onclick = function(){
		picture.style.width = '0%';
		picture.style.height = '0%';
		this.style.display = 'none';
		picture.removeChild(picture.firstChild);
	}
	
	function showImage(fileCallPath){
		if(document.querySelector('.bigPicture img') == null){
			const ooimg =  document.createElement('img');
			ooimg.setAttribute('src','/display?fileName=' + fileCallPath);
			picture.append(ooimg);
		}
		imageWrapper.style.display = 'flex';
		picture.style.width = '100%';
		picture.style.height = '100%';
	}
</script>

<%@ include file="../includes/footer.jsp" %>