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
            <form role="form" action="/board/modify" method="post">

                <!-- criteria -->
                <input type="hidden" id="pageNum" name="pageNum" value="<c:out value='${cri.pageNum}' />">
                <input type="hidden" id="amount" name="amount" value="<c:out value='${cri.amount}' />">
                <input type="hidden" name="type" value="<c:out value='${pageMaker.cri.type}' />">
                <input type="hidden" name="keyword" value="<c:out value='${pageMaker.cri.keyword}' />">

                <div class="form-group">
                    <label>Bno</label>
                    <input type="text" name="bno" readonly="readonly"
                           value="<c:out value='${board.bno }' />" class="form-control">
                </div>

                <div class="form-group">
                    <label>Title</label>
                    <input type="text" name="title"
                           value="<c:out value='${board.title }' />" class="form-control">
                </div>

                <div class="form-group">
                    <label>Text area</label>
                    <textarea rows="3" name="content" class="form-control"
                              ><c:out value="${board.content }" /></textarea>
                </div>

                <div class="form-group">
                    <label>Writer</label>
                    <input type="text" name="writer" readonly="readonly"
                           value="<c:out value='${board.writer}' />" class="form-control">
                </div>

                <div class="form-group" hidden="hidden">
                    <label>RegDate</label>
                    <input type="text" name="regDate" readonly="readonly"
                           value="<fmt:formatDate pattern="yyyy/MM/dd" value='${board.regdate}' />" class="form-control">
                </div>

                <div class="form-group" hidden="hidden">
                    <label>Update Date</label>
                    <input type="text" name="updateDate" readonly="readonly"
                           value="<fmt:formatDate pattern="yyyy/MM/dd" value='${board.updatedate}' />" class="form-control">
                </div>

                <button type="submit" data-oper="modify" class="btn btn-default"
                        >Modify</button>
                <button type="submit" data-oper="remove" class="btn btn-default"
                >Remove</button>
                <button type="submit" data-oper="list" class="btn btn-info">List</button>
            </form>
        </div>
    </div>

</div>
<!-- /.container-fluid -->

<script type="text/javascript">
    $(document).ready(function() {

        var formObj = $("form");

        $('button').on("click", function(e) {

            e.preventDefault();

            var operation = $(this).data("oper");

            console.log(operation);

            if(operation === 'remove') {
                formObj.attr("action", "/board/remove");
            } else if(operation === 'list') {
                formObj.attr("action", "/board/list")
                    .attr("method", "get");
                var pageNumTag = $("input[name='pageNum']").clone();
                var amountTag = $("input[name='amount']").clone();
                var keywordTag = $("input[name='keyword']").clone();
                var typeTag = $("input[name='type']").clone();

                formObj.empty();
                formObj.append(pageNumTag);
                formObj.append(amountTag);
                formObj.append(keywordTag);
                formObj.append(typeTag);
            }
            formObj.submit();
        });
    });
</script>

</div>
<!-- End of Main Content -->

<!-- Footer -->
<%@include file="../includes/footer.jsp"%>
