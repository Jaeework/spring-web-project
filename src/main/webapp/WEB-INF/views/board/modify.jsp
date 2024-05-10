<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="../includes/header.jsp"%>

<!-- Begin Page Content -->
<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-2 text-gray-800">Board Modify</h1>

    <!-- Board Card -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Board Modify Page</h6>
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
            <div class="form-group uploadDiv">
                <input type="file" name="uploadFile" multiple />
            </div>

            <div class="uploadResult">
                <ul></ul>
            </div>
        </div>

    </div>

    <script>
        $(document).ready(function () {
            (function () {
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
                            str += "<span>" + attach.fileName + "</span>";
                            str += "<button type='button' data-file=\'" + fileCallPath + "'\data-type='image' "
                                +  "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                            str += "<img src='/display?fileName=" + fileCallPath + "' />";
                            str += "</div></li>";
                        } else {
                            str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' "
                                +  "data-filename='" + attach.fileName + "' data-type='" + attach.fileType +"' ><div>";
                            str += "<span>" + attach.fileName + "</span><br>";
                            str += "<button type='button' data-file=\'" + fileCallPath + "'\data-type='image' "
                                +  "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                            str += "<img src='/resources/img/attach.png' />";
                            str += "</div></li>";
                        }
                    });
                    $(".uploadResult ul").html(str);

                }); // end getJson
            })(); // end function

            $(".uploadResult").on("click", "button", function () {
               console.log("delete file");

               if(confirm("Remove this file? ")) {
                   var targetLi = $(this).closest("li");
                   targetLi.remove();
               }
            });

            var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
            var maxSize = 5242880; //5MB

            function checkExtension(fileName, fileSize) {

                if(fileSize >= maxSize) {
                    alert("파일 사이즈 초과");
                    return false;
                }

                if(regex.test(fileName)) {
                    alert("해당 종류의 파일은 업로드 할 수 없습니다.");
                    return false;
                }

                return true;
            }

            $("input[type='file']").change(function (e) {

                var formData = new FormData();

                var inputFile = $("input[name='uploadFile']");

                var files = inputFile[0].files;

                for(var i = 0; i < files.length; i++) {

                    if(!checkExtension(files[i].name, files[i].size)) {
                        return false;
                    }

                    formData.append("uploadFile", files[i]);

                }

                $.ajax({
                    url: '/uploadAjaxAction',
                    processData: false,
                    contentType: false,
                    data: formData,
                    type: 'POST',
                    dataType: 'json',
                    success: function(result) {
                        console.log(result);
                        showUploadResult(result);
                    }
                });

            });

            function showUploadResult(uploadResultArr) {

                if(!uploadResultArr || uploadResultArr.length == 0) { return; }

                var uploadUL = $(".uploadResult ul");

                var str = "";

                $(uploadResultArr).each(function(i, obj) {

                    //image type
                    if(obj.image) {
                        var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);

                        str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid +"'"
                            +  " data-filename='" + obj.fileName +"' data-type='" + obj.image +"'><div>"
                            +  "<span> " + obj.fileName + "</span>"
                            +  "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image' "
                            +  "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br/>"
                            +  "<img src='/display?fileName=" + fileCallPath + "' />"
                            +  "</div></li>";

                    } else {
                        var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
                        var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");

                        str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid +"'"
                            +  " data-filename='" + obj.fileName +"' data-type='" + obj.image +"'><div>"
                            +  "<span> " + obj.fileName + "</span>"
                            +  "<button type='button' data-file=\'" + fileCallPath + "\' data-type='file' "
                            +  "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br/>"
                            +  "<img src='/resources/img/attach.png' />"
                            +  "</div></li>";
                    }

                });

                uploadUL.append(str);

            }

        });
    </script>

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
            } else if(operation === 'modify') {

                console.log("submit clicked");

                var str = "";

                $(".uploadResult ul li").each(function (i, obj) {

                    var jobj = $(obj);

                    console.dir(jobj);

                    str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "' />"
                    str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "' />"
                    str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("path") + "' />"
                    str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("type") + "' />"

                });
                formObj.append(str).submit();

            }
            formObj.submit();
        });
    });
</script>

</div>
<!-- End of Main Content -->

<!-- Footer -->
<%@include file="../includes/footer.jsp"%>
