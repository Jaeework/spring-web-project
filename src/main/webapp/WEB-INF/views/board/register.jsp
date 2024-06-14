<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

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
      <form role="form" action="/board/register" method="post">

        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

        <div class="form-group">
          <label>Title</label> <input type="text" name="title" class="form-control">
        </div>

        <div class="form-group">
          <label>Text area</label> <textarea rows="3" name="content" class="form-control"></textarea>
        </div>

        <div class="form-group">
          <label>Writer</label> <input type="text" name="writer" class="form-control"
                                       value="<sec:authentication property="principal.username" />" readonly="readonly" />
        </div>

        <button type="submit" class="btn btn-primary">Submit Button</button>
        <button type="reset" class="btn btn-default">Reset Button</button>

      </form>
    </div>
  </div>

  <div class="card shadow mb-4">
    <div class="card-header py-3">
      <h6 class="m-0 font-weight-bold text-primary">File Attach</h6>
    </div>
    <div class="card-body">
      <div class="form-group uploadDiv">
        <input type="file" name="uploadFile" multiple>
      </div>

      <div class="uploadResult">
        <ul>

        </ul>
      </div>
    </div>
  </div>

  <script>
    $(document).ready(function (e) {

      var formObj = $("form[role='form']");

      $("button[type='submit']").on("click", function (e) {

        e.preventDefault();

        console.log("submit clicked");

        var str = "";

        $(".uploadResult ul li").each(function (i, obj) {

          var jobj = $(obj);

          console.dir(jobj);

          str += "<input type='hidden' name='attachList["+i+"].fileName' value='" + jobj.data("filename")+"'>";
          str += "<input type='hidden' name='attachList["+i+"].uuid' value='" + jobj.data("uuid")+"'>";
          str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='" + jobj.data("path")+"'>";
          str += "<input type='hidden' name='attachList["+i+"].fileType' value='" + jobj.data("type")+"'>";

        });

        formObj.append(str).submit();

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

      var csrfHeaderName = "${_csrf.headerName}";
      var csrfTokenValue = "${_csrf.token}"

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
          beforeSend: function(xhr) {
            xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
          },
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

      $(".uploadResult").on("click", "button", function(e) {

        console.log("delete file");

        var targetFile = $(this).data("file");
        var type = $(this).data("type");

        var targetLi = $(this).closest("li");

        $.ajax({
          url: '/deleteFile',
          data: {fileName: targetFile, type: type},
          beforeSend: function(xhr) {
            xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
          },
          dataType: 'text',
          type: 'POST',
          success: function(result) {
            alert(result);
            targetLi.remove();
          }
        });

      });

    });
  </script>

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

  </style>

</div>
<!-- /.container-fluid -->

</div>
<!-- End of Main Content -->

<!-- Footer -->
<%@include file="../includes/footer.jsp"%>
