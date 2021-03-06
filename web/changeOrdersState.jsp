<%--
  Created by IntelliJ IDEA.
  User: wanlihang
  Date: 2018/11/25
  Time: 15:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>修改订单状态页面</title>
    <style>
        .button { /* 按钮美化 */
            width: 80px; /* 宽度 */
            height: 40px; /* 高度 */
            border-width: 0px; /* 边框宽度 */
            border-radius: 3px; /* 边框半径 */
            background: #1E90FF; /* 背景颜色 */
            cursor: pointer; /* 鼠标移入按钮范围时出现手势 */
            outline: none; /* 不显示轮廓线 */
            font-family: Microsoft YaHei; /* 设置字体 */
            color: white; /* 字体颜色 */
            font-size: 17px; /* 字体大小 */
        }

        .button:hover { /* 鼠标移入按钮范围时改变颜色 */
            background: #5599FF;
        }

        table.hovertable {
            font-family: verdana, arial, sans-serif;


            color: #333333;
            border-width: 1px;
            border-color: #999999;
            border-collapse: collapse;

            width: 1200px;
        }

        th{height: 50px; font-size: 18px; font-family: 微软雅黑; text-align: center}
        td {
            font-family: "微软雅黑 Light";
            line-height: 40px;
            font-size: 18px;
            color: #666666;
            text-align: center
        }
    </style>
</head>

<body onload="initAJAX()">

<hr>

<div>
    <table class="hovertable" border="1" align="center" rules="rows">
        <tr>
            <th>订单编号</th>
            <th>下单时间</th>
            <th>支付金额</th>
            <th>订单状态</th>
            <th>用户名称</th>
        </tr>
        <%
            Class.forName("org.sqlite.JDBC");
            String url = "jdbc:sqlite:D:/javaweb/bookstore.db";
            String sql = "select id,ordertime,price,state,username from orders ";
            Connection conn = DriverManager.getConnection(url);
            Statement stat = conn.createStatement();
            ResultSet rs = stat.executeQuery(sql);
            while (rs.next()) {
        %>
        <tr>
            <td>
                <%=rs.getString("id")%>
            </td>
            <td>
                <%=rs.getString("ordertime")%>
            </td>
            <td>
                <%=rs.getString("price")%>
            </td>
            <td>
                <form action="">
                    <select name="state" id="state">
                        <option value=<%=rs.getString("state")%>><%=(rs.getString("state").equals("1") ? "已完成" : "未完成")%>
                        </option>
                        <option value=<%=(rs.getString("state").equals("1") ? "0" : "1")%>><%=(rs.getString("state").equals("1") ? "未完成" : "已完成")%>
                        </option>
                    </select>
                    <input type="submit" value="修改" onclick="change(<%=rs.getString("id")%>)">
                </form>
            </td>
            <td>
                <%=rs.getString("username")%>
            </td>
        </tr>
        <%
            }
            stat.close();
            conn.close();
        %>
    </table>
</div>
<script type="text/javascript">
    var xmlHttp;

    function change(ordersID) {
        var s = document.getElementById("state");
        var index = s.selectedIndex;
        var value = s.options[index].value;

        xmlHttp = GetXmlHttpObject();
        if (xmlHttp == null) {
            alert("Browser does not support HTTP Request");
            return
        }
        var url = "changeOrdersState2.jsp";
        url = url + "?ordersID=" + ordersID + "&state=" + value;
        url = url + "&sid=" + Math.random();
        xmlHttp.onreadystatechange = stateChanged;
        xmlHttp.open("GET", url, true);
        xmlHttp.send(null);
        if(value == "1"){
            alert("修改成功");
        }else{
            alert("无法修改");
        }
    }

    function stateChanged() {
        if (xmlHttp.readyState == 4 || xmlHttp.readyState == "complete") {
            document.getElementById("txtHint").innerHTML = xmlHttp.responseText
        }
    }

    function GetXmlHttpObject() {
        var xmlHttp = null;
        try {
            // Firefox, Opera 8.0+, Safari
            xmlHttp = new XMLHttpRequest();
        }
        catch (e) {
            //Internet Explorer
            try {
                xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
            }
            catch (e) {
                xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
        }
        return xmlHttp;
    }
</script>
</body>
</html>
