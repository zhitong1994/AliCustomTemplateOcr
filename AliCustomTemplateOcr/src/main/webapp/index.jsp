<%@ page language="java" contentType="text/html; charset=UTF-8"  
    pageEncoding="UTF-8"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>  
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<head>
<title>上传图片</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
<style type="text/css">
	.img{
        float:left;
	}
	.table{
		float:right;
		width: 700px;
		height: 600px;
	}
	#image{
		width: 850px;
		height: 600px;
	}
</style>
</head>    
<body>
	<div class="button">
		<input type="file" id="file"  onchange="selectImage(this);" />  
    	<br />  
    	<input type="button" onclick="uploadImage();" value="提交" /> 
	</div>
	<div class="img">
	    <img id="image" src="" />  
	</div> 
    <br />     
    <div id = "apitesttry" class="table"></div>
</body> 
<script>  
    //js进行图片预览 使用input标签来选择图片，使用FileReader读取图片并转成base64编码，然后发送给服务器。  
        var image = '';  
        function selectImage(file) {  
            if (!file.files || !file.files[0]) {  
                return;  
            }  
            var filepath = document.getElementById("file").value;  
            //为了避免转义反斜杠出问题，这里将对其进行转换  
            var re = /(\\+)/g;   
            var filename=filepath.replace(re,"#");  
            //对路径字符串进行剪切截取  
            var one=filename.split("#");  
            //获取数组中最后一个，即文件名  
            var two=one[one.length-1];  
            //再对文件名进行截取，以取得后缀名  
            var three=two.split(".");  
             //获取截取的最后一个字符串，即为后缀名  
            var last=three[three.length-1];  
            if(last!="jpg"){  
                alert("请您上传jpg格式的图片！");  
                return;  
            }
             //判断图片大小是否超过1.5M
             var myimg = document.getElementById('file').files[0];
             if(myimg.size > 1572864){
            	alert("错误！请上传不超过1.5M的图片");
                return false;
            }else{
            	var reader = new FileReader();  
                reader.onload = function(evt) {  
                  document.getElementById('image').src = evt.target.result;  
                  var str = evt.target.result;
                  image = str.substring(str.indexOf(',')+1);
                }  
                reader.readAsDataURL(file.files[0]);  
            }
            
        }  
        function uploadImage() {  
        	if(image==""){
        		alert("请上传图片");
        		return;
        	}
        	$.ajax({  
                type : 'POST',  
                url : 'AliOcr',  //请求路径 
                data : {  
                    image : image    //传递后端的数据，这里传递的是base64编码  json格式  
                },  
                async : false,  
                dataType : 'json',
                error:function(err) {
                	console.log(err);
                	alert("请上传正确的图片");
                	},
                success : function(data) { //请求返回成功后执行的function
                	//alert("上传成功");
                	//解析后端返回的json
                	console.log(data);
                	var aply_nm = data.aply_nm;
                	var aply_dt = data.aply_dt;
                    var item = data.Table;
                	var htm = "";
                	htm += '<p>'+aply_nm+'</p>'+'<tr>'+'<p>'+aply_dt+'</p>'+'<tr>';
                    htm += "<table><thead><tr><th>0</th><th>1</th><th>2</th><th>3</th><th>4</th><th>5</th><th>6</th><th>7</th><th>8</th><th>9</th></tr></thead><tbody>";
                    for(var i=0;i<item.length;i++){

                            htm += '<tr><td>' 
                                + item[i][0] + '</td><td>'
                                + item[i][1] + '</td><td>'
                                + item[i][2] + '</td><td>'
                                + item[i][3] + '</td><td>'
                                + item[i][4] + '</td><td>'
                                + item[i][5] + '</td><td>'
                                + item[i][6] + '</td><td>'
                                + item[i][7] + '</td><td>'
                                + item[i][8] + '</td><td>'
                                + item[i][9] + '</td><td>';
                    }
                    htm += '</tbody></table>';
                    $("#apitesttry").append(htm);
                    //alert(htm);
                }
            });  	
        	
        }  
       
</script>  
</html>  