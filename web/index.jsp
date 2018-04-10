<%@ page import="java.util.ArrayList" %>
<%@ page import="org.bson.Document" %><%--
  Created by IntelliJ IDEA.
  User: Terry
  Date: 2018/4/9
  Time: 10:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>$Title$</title>
</head>
<body>

<style>
    html,
    body,
    #container {
        width: 100%;
        height: 100%;
        margin: 0px;
    }
</style>
<script src="//cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>

<form id="myform">
    <select name="isWorkDay" onchange="getTimeID(this.value)">
        <option value="0">isWorkDay</option>

        <option value="true">是</option>

        <option value="false">否</option>
    </select>

    <select id="timeID" name="time">
        <option value="0">timeID</option>
    </select>
    <input type="button" id="fuckgaode" onclick="submitValue()" value="Submit"/>
</form>

<div id="container"></div>
</body>
<script>
    var timeID1 = [0, 1, 2, 3, 4, 5];
    var timeID2 = [0, 2];

    function getTimeID(value) {
        console.log(value)
        var timeID = document.getElementById("timeID");
        var time = (value == "true") ? timeID1 : timeID2;
        timeID.length = 1;


        for (var i = 0; i < time.length; i++) {
            var option = document.createElement("option");
            option.value = time[i].toString();
            console.log(option);

            var text = document.createTextNode(time[i]);
            option.appendChild(text);
            timeID.appendChild(option);
        }
    }

</script>
<script type="text/javascript" src='//webapi.amap.com/maps?v=1.4.5&key=5e9c684cc948bc7180d440b07b8e49da'></script>
<!-- UI组件库 1.0 -->
<script src="//webapi.amap.com/ui/1.0/main.js?v=1.0.11"></script>

<%
    ArrayList list = (ArrayList) request.getAttribute("datas");
    out.print(list);
%>
<script>
    function submitValue() {
        $.ajax({

            url: "/dis",
            type: "POST",
            data: $('#myform').serialize(),
            success: function (data) {
                display(JSON.parse(data));
            },
            error: function (err) {
                console.log(err)
            }

        });

    }

    function display(datas) {
        //创建地图
        var map = new AMap.Map('container', {
            zoom: 250,
            center: [118.784136, 32.041806]
        });

        AMapUI.load(['ui/misc/PointSimplifier', 'lib/$'], function (PointSimplifier, $) {

            if (!PointSimplifier.supportCanvas) {
                alert('当前环境不支持 Canvas！');
                return;
            }

            var pointSimplifierIns = new PointSimplifier({
                map: map, //所属的地图实例

                getPosition: function (item) {

                    if (!item) {
                        return null;
                    }
// console.log(item);
//返回经纬度
                    return [item.lng, item.lat];
                },
                getHoverTitle: function (dataItem, idx) {
                    return idx + ': ' + dataItem+" lng: "+dataItem.lng+" lat:"+dataItem.lat;
                },
                renderOptions: {
//点的样式
                    pointStyle: {
                        width: 6,
                        height: 6
                    },
//鼠标hover时的title信息
                    hoverTitleStyle: {
                        position: 'top'
                    }
                }
            });
            pointSimplifierIns.setData(datas);

            pointSimplifierIns.on('pointClick pointMouseover pointMouseout', function (e, record) {

            });
        });

    }
</script>
</html>
