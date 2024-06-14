<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%@ include file="../includes/header.jsp"%>

<!-- Begin Page Content -->
<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-2 text-gray-800">Board Read</h1>

    <!-- Board Card -->
    <div class="card shadow mb-4">
    <div class="card-header py-3">
      <h6 class="m-0 font-weight-bold text-primary">Board Read Page</h6>
    </div>
    <div class="card-body">

        <div class="form-group">
            <label>Bno</label>
            <input type="text" name="bno" readonly="readonly"
                   value="<c:out value='${board.bno }' />" class="form-control">
        </div>

        <div class="form-group">
            <label>Title</label>
            <input type="text" name="title" readonly="readonly"
                   value="<c:out value='${board.title }' />" class="form-control">
        </div>

        <div class="form-group">
            <label>Text area</label>
            <textarea rows="3" name="content" class="form-control"
                      readonly="readonly"><c:out value="${board.content }" /></textarea>
        </div>

        <div class="form-group">
            <label>Writer</label>
            <input type="text" name="writer" readonly="readonly"
                   value="<c:out value='${board.writer}' />" class="form-control">
        </div>

        <sec:authentication property="principal" var="pinfo"/>

        <sec:authorize access="isAuthenticated()">

            <c:if test="${pinfo.username eq board.writer}">

                <button data-oper="modify" class="btn btn-default">Modify</button>

            </c:if>

        </sec:authorize>

        <button data-oper="list" class="btn btn-info">List</button>

        <form id="operForm" action="board/modify" method="get">
            <input type="hidden" id="bno" name="bno" value="<c:out value='${board.bno}' />">
            <input type="hidden" id="pageNum" name="pageNum" value="<c:out value='${cri.pageNum}' />">
            <input type="hidden" id="amount" name="amount" value="<c:out value='${cri.amount}' />">
            <input type="hidden" name="type" value="<c:out value='${pageMaker.cri.type}' />">
            <input type="hidden" name="keyword" value="<c:out value='${pageMaker.cri.keyword}' />">
        </form>

    </div>
  </div>

    <!-- Attachment Card -->
    <div class="bigPictureWrapper">
        <div class="bigPicture"></div>
    </div>
    <style>

        .uploadResult {
            width: 100%;
            background-color: gray;
        }

        .uploadResult ul {
            display: flex;
            flex-flow: row;
            justify-content: center;
            align-items: center;
        }

        .uploadResult ul li {
            list-style: none;
            padding: 10px;
            align-content: center;
            text-align: center;
        }

        .uploadResult ul li img {
            width: 100px;
        }

        .uploadResult ul li span {
            color: white;
        }

        .bigPictureWrapper {
            position: absolute;
            display: none;
            justify-content: center;
            align-items: center;
            top: 0%;
            width: 100%;
            height: 100%;
            background-color: gray;
            z-index: 100;
            background: rgba(255,255,255,0.5);
        }

        .bigPicture {
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .bigPicture img {
            width: 600px;
        }

    </style>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Files</h6>
        </div>
        <div class="card-body">
            <div class="uploadResult">
                <ul></ul>
            </div>
        </div>
    </div>

    <!-- Reply Card -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">
                <i class="fa fa-comments fa-fw"></i> Reply

                <sec:authorize access="isAuthenticated()">
                    <button id="addReplyBtn" class="btn btn-primary btn-xs float-right">New Reply</button>
                </sec:authorize>
            </h6>
        </div>
        <div class="card-body">

            <ul class="chat" style="padding-left: 0;">
            </ul>

        </div>
        <div class="card-footer">

        </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
        aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"
                        aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Reply</label>
                        <input type="text" name="reply" class="form-control" value="New Reply!!!!">
                    </div>
                    <div class="form-group">
                        <label>Replyer</label>
                        <input type="text" name="replyer" class="form-control" value="replyer">
                    </div>
                    <div class="form-group">
                        <label>Reply Date</label>
                        <input name="replyDate" class="form-control" value="">
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="modalModBtn" class="btn btn-warning" type="button">Modify</button>
                    <button id="modalRemoveBtn" class="btn btn-danger" type="button">Remove</button>
                    <button id="modalRegisterBtn" class="btn btn-primary" type="button">Register</button>
                    <button id="modalCloseBtn" class="btn btn-default" data-dismiss="modal" type="button">Close</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- /.Modal -->

</div>
<!-- /.container-fluid -->

<script type="text/javascript" src="/resources/js/reply.js"></script>

<script>
    $(document).ready(function () {

        var bno = '<c:out value="${board.bno}" />';

        $.getJSON("/board/getAttachList", {bno: bno}, function (arr) {
            console.log(arr);

            var str = "";

            $(arr).each(function (i, attach){
               //image type
               if(attach.fileType) {
                   var fileCallPath = encodeURIComponent(attach.uploadPath
                                    + "/s_" + attach.uuid + "_" + attach.fileName);

                   str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' "
                       +  "data-filename='" + attach.fileName + "' data-type='" + attach.fileType +"' ><div>";
                   str += "<img src='/display?fileName=" + fileCallPath + "' />";
                   str += "</div></li>";
               } else {
                   str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' "
                       +  "data-filename='" + attach.fileName + "' data-type='" + attach.fileType +"' ><div>";
                   str += "<span>" + attach.fileName + "</span><br/>";
                   str += "<img src='/resources/img/attach.png' />";
                   str += "</div></li>";
               }
            });
            $(".uploadResult ul").html(str);

        }); // end getJson

        $(".uploadResult").on("click", "li", function (e) {

            console.log("view image");

            var liObj = $(this);

            var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));

            if(liObj.data("type")) {
                showImage(path.replace(new RegExp(/\\/g), "/"));
            } else {
                // download
                self.location = "/download?fileName=" + path;
            }
        });

        function showImage(fileCallPath) {
            alert(fileCallPath);

            $(".bigPictureWrapper").css("display", "flex").show();

            $(".bigPicture")
                .html("<img src='/display?fileName=" + fileCallPath + "' />")
                .animate({width:'100%', height: '100%'}, 1000);
        }

        $(".bigPictureWrapper").on("click", function (e) {
           $(".bigPicture").animate({width:'0%', height: '0%'}, 1000);
           setTimeout(function () {
              $(".bigPictureWrapper").hide();
           }, 1000);
        });

    }); // end function

</script>

<script type="text/javascript">
    $(document).ready(function() {

        var bnoValue = '<c:out value="${board.bno}"/>';
        var replyUL = $(".chat");

        showList(1);

        function showList(page) {

            console.log("show list " + page);

            replyService.getList({bno:bnoValue, page:page||1}, function (replyCnt, list) {

                console.log("replyCnt : " + replyCnt);
                console.log("list : " + list);
                console.log(list);

                if(page === -1) {
                    pageNum = Math.ceil(replyCnt/10.0);
                    showList(pageNum);
                    return;
                }

                var str = "";
                if(list == null || list.length == 0) {
                    replyUL.html("");

                    return;
                }
                for(var i = 0, len = list.length || 0; i < len; i++) {
                    str += "<li class='left clearfix' data-rno='" + list[i].rno + "' style='list-style: none;'>"
                        + "<div><div class='header'><strong class='primary-font'>" + list[i].replyer +"</strong>"
                        + "<small class='float-right text-muted'>" + replyService.displayTime(list[i].replyDate)
                        + "</small></div>"
                        + "<p>" + list[i].reply + "</p></div></li>";
                }

                replyUL.html(str);
                showReplyPage(replyCnt);
            });
        } // end showList

        // 댓글 페이징
        var pageNum = 1;
        var replyPageFooter = $(".card-footer");

        function showReplyPage(replyCnt) {
            var endNum = Math.ceil(pageNum / 10.0) * 10;
            var startNum = endNum - 9;

            var prev = startNum != 1;
            var next = false;

            if(endNum * 10 >= replyCnt) {
                endNum = Math.ceil(replyCnt / 10.0);
            }

            if(endNum * 10 < replyCnt) {
                next = true;
            }

            var str = "<ul class='pagination float-right'>";

            if(prev) {
                str += "<li class='page-item'><a class='page-link' href='" + (startNum - 1)+"'>Previous</a></li>";
            }

            for(var i = startNum; i <= endNum; i++) {
                var active = pageNum == i ? "active" : "";

                str += "<li class='page-item " + active + " '><a class='page-link' href='" + i + "'>" + i + "</a></li>";
            }

            if(next) {
                str += "<li class='page-item'><a class='page-link' href='" + (endNum + 1)+"'>Next</a></li>";
            }

            str += "</ul></div>";

            console.log(str);

            replyPageFooter.html(str);
        }

        // 댓글 페이징 이벤트 등록
        replyPageFooter.on("click", "li a", function (e) {
            e.preventDefault();
            console.log("page click");

            var targetPageNum = $(this).attr("href");

            console.log("targetPageNum: " + targetPageNum);

            pageNum = targetPageNum;

            showList(pageNum);
        });

        // modal
        var modal = $(".modal");
        var modalInputReply = modal.find("input[name='reply']");
        var modalInputReplyer = modal.find("input[name='replyer']");
        var modalInputReplyDate = modal.find("input[name='replyDate']");

        var modalModBtn = $("#modalModBtn");
        var modalRemoveBtn = $("#modalRemoveBtn");
        var modalRegisterBtn = $("#modalRegisterBtn");

        var replyer = null;

        <sec:authorize access="isAuthenticated()">

            replyer = '<sec:authentication property="principal.username" />';

        </sec:authorize>

        var csrfHeaderName = "${_csrf.headerName}";
        var csrfTokenValue = "${_csrf.token}";

        $("#addReplyBtn").on("click", function (e) {

            modal.find("input").val("");
            modal.find("input[name='replyer']").val(replyer);
            modalInputReplyDate.closest("div").hide();
            modal.find("button[id != 'modalCloseBtn']").hide();

            modalRegisterBtn.show();

            $(".modal").modal("show");
        });

        // Ajax spring security header...
        $(document).ajaxSend(function(e, xhr, options) {
           xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
        });

        modalRegisterBtn.on("click", function (e) {

            var reply = {
                reply : modalInputReply.val(),
                replyer : modalInputReplyer.val(),
                bno:bnoValue
            };
            replyService.add(reply, function(result) {

                alert(result);

                modal.find("input").val("");
                modal.modal("hide");

                //showList(1);
                showList(-1);
            });
        });

        // 댓글 개별 클릭 이벤트
        $(".chat").on("click", "li", function (e) {

            var rno = $(this).data("rno");

            replyService.get(rno, function (reply) {
               modalInputReply.val(reply.reply);
               modalInputReplyer.val(reply.replyer);
               modalInputReplyDate.val(replyService.displayTime(reply.replyDate))
                   .attr("readonly", "readonly");
               modal.data("rno", reply.rno);

               modal.find("button[id != 'modalCloseBtn']").hide();
               modalModBtn.show();
               modalRemoveBtn.show();

               $(".modal").modal("show");
            });
        });

        // 댓글 수정
        modalModBtn.on("click", function(e) {

            var originalReplyer = modalInputReplyer.val();

            var reply = {rno:modal.data("rno"), reply: modalInputReply.val(), replyer: originalReplyer};

            if(!replyer) {
                alert("로그인 후 수정이 가능합니다.");
                modal.modal("hide");
                return;
            }

            console.log("Original Replyer : " + originalReplyer);

            if(replyer != originalReplyer) {
                alert("자신이 작성한 댓글만 수정이 가능합니다.");
                modal.modal("hide");
                return;
            }

            replyService.update(reply, function (result) {

                alert(result);
                modal.modal("hide");
                showList(pageNum);
            });
        });

        // 댓글 삭제
        modalRemoveBtn.on("click", function (e) {

            var rno = modal.data("rno");

            console.log("RNO : " + rno);
            console.log("REPLYER : " + replyer);

            if(!replyer) {
                alert("로그인 후 삭제가 가능합니다.");
                modal.modal("hide");
                return;
            }

            var originalReplyer = modalInputReplyer.val();

            console.log("Original Replyer : " + originalReplyer);

            if(replyer != originalReplyer) {
                alert("자신이 작성한 댓글만 삭제가 가능합니다.");
                modal.modal("hide");
                return;
            }

            replyService.remove(rno, originalReplyer, function(result) {

                alert(result);
                modal.modal("hide");
                showList(pageNum);
            });
        });

    });
</script>

<script type="text/javascript">
    $(document).ready(function() {

        var operForm = $('#operForm');

        $("button[data-oper='modify']").on("click", function (e) {

            operForm.attr("action", "/board/modify").submit();

        });

        $("button[data-oper='list']").on("click", function (e) {

            operForm.find("#bno").remove();
            operForm.attr("action", "/board/list");
            operForm.submit();
        });
    });
</script>

</div>
<!-- End of Main Content -->

<!-- Footer -->
<%@include file="../includes/footer.jsp"%>
