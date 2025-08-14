<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.sql.Connection,java.sql.DriverManager,java.sql.PreparedStatement,java.sql.ResultSet"%>
<%
request.setCharacterEncoding("UTF-8");
String Message = "";
String dbUrl = "jdbc:mysql://localhost:3306/register?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC";
String dbUser = "root";
String dbPassword = "s123456S";
try {
	Class.forName("com.mysql.cj.jdbc.Driver");
} catch (ClassNotFoundException e) {
	Message = "資料庫驅動程式載入失敗。";
	e.printStackTrace();
}

if ("POST".equals(request.getMethod())) {
	String account = request.getParameter("account");
	String password = request.getParameter("password");

	if (account != null && !account.isEmpty() && password != null && !password.isEmpty()) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

	//原本資料庫輸入法 String sql = "SELECT * FROM registerlog WHERE 帳號 = ? AND 密碼 = ?";
	String sql="SELECT 帳號, CAST(AES_DECRYPT(密碼, ?) AS CHAR) AS decrypted_password FROM registerlog WHERE 帳號 = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, account);
	pstmt.setString(2, password);
	rs = pstmt.executeQuery();
	if (rs.next()) {
		Message = "登入成功！歡迎 " + account;
		// 這裡可以設定 Session 來保持登入狀態
		session.setAttribute("loggedInUser", account);
		//session：代表一個使用者從進入網站到離開的整個過程。當打開網站，伺服器就會建立一個 Session。
		//setAttribute(...)：在 Session 裡儲存資料的方法。
		
		response.sendRedirect("File09.jsp");
		//瀏覽器的網址列會從LoginScreen.jsp變成File09.jsp
		return;
	} else {
		Message = "帳號或密碼錯誤。";
	}
		} catch (Exception e) {
	Message = "登入失敗，請稍後再試。" + e.getMessage();
	e.printStackTrace();
		}
	} else {
		Message = "請輸入帳號和密碼。";
	}
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>雲端儲存-登入畫面</title>
<style>
.LoginScreen {
	display: flex; /* 啟用 Flexbox */
	justify-content: center; /* 水平居中 */
	align-items: center; /* 垂直居中 */
	height: 100vh; /* 設定父元素高度為整個視窗高 */
	/* border: 1px solid red; 方便查看效果，實際開發可移除 */
}

.center-div {
	width: 340px;
	height: 400px;
	background-color: lightblue;
}

.title-text {
	/* 將文字內容水平置中 */
	text-align: center;
	font-size: 20px; /* 設定文字大小 */
}

.Content-text {
	text-align: center;
}

input {
	font-size: 16px; /* 建議設定為 16px 或更大，以避免瀏覽器自動縮放 */
}

.register {
	text-align: center;
	padding: 10px;
}
</style>
</head>
<body>
	<div class="LoginScreen">
		<div class="center-div">
			<div class="title-text">
				<h4>登入畫面</h4>
			</div>
			<div class="Content-text ">
				<form action="LoginScreen.jsp" method="POST">
					<label for="username">帳號: </label><input type="text" id="username"
						name="account" placeholder="請輸入帳號" required><br> <br>
					<label for="password">密碼:</label> <input type="password"
						id="password" name="password" placeholder="請輸入密碼" required><br>
					<br>
					<button type="submit">登入</button>
				</form>
				<div class="register">
					<!-- 判斷 Message 變數是否不為空，如果是就顯示內容 -->
					<%
					if (!Message.isEmpty()) {
					%>
					<p style="color: red;"><%=Message%></p>
					<%
					}
					%>
				</div>
			</div>
			<div class="register">
				<p>
					還沒有帳號嗎？ <a href="Register.jsp">立即註冊</a>
				</p>
			</div>
		</div>
	</div>
</body>
</html>
<!--   
帳號規定-不可含特殊符號，只能英數字
密碼規定-必須要有英文大寫與小寫和數字組合
 -->
<!--http://localhost:8080/F09/LoginScreen.jsp -->

<!--ngrok http 8080 --host-header="localhost"-->
<!--https://[新的ngrok網址]/F09/LoginScreen.jsp-->
