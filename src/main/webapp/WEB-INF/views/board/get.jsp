<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="../includes/header.jsp"%>

<!-- Begin Page Content -->
<div class="container-fluid">

  <!-- Page Heading -->
  <h1 class="h3 mb-2 text-gray-800">Board Register</h1>

  <!-- DataTales Example -->
  <div class="card shadow mb-4">
    <div class="card-header py-3">
      <h6 class="m-0 font-weight-bold text-primary">Board Register</h6>
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

        <button data-oper="modify" class="btn btn-default">Modify</button>
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

</div>
<!-- /.container-fluid -->

<script type="text/javascript" src="/resources/js/reply.js"></script>

<script type="text/javascript">
    $(document).ready(function() {

        console.log("=================");
        console.log("JS TEST");

        var bnoValue = '<c:out value="${board.bno}" />'

        //for replyService add test
        replyService.add(
            {reply : "JS Test", replyer : "tester", bno: bnoValue},
            function (result) {
                alert("RESULT : " + result);
            }
        );

        // reply List Test
        replyService.getList({bno:bnoValue, page:1}, function (list) {

            for(var i = 0, len = list.length||0; i < len; i++) {
                console.log(list[i]);
            }
        });

        // 32번 댓글 삭제 테스트
        replyService.remove(32, function(count) {

            console.log(count);

            if(count === "success") {
                alert("REMOVED");
            }
        }, function (err) {
            alert("ERROR...");
        });

        // 11번 댓글 수정
        replyService.update({
            rno : 11,
            bno : bnoValue,
            reply : "Modified reply....."
        }, function (result) {

            alert("수정 완료...");
        });

        // get 확인
        replyService.get(33, function(data) {
            console.log(data);
        })

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
