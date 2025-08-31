<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
// 使 Session 失效，移除所有 Session 屬性
session.invalidate();

// 導向回登入頁面
response.sendRedirect("LoginScreen.jsp");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>