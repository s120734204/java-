<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.*,java.util.Calendar"%>
<%!static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
	static final String DB_URL = "jdbc:mysql://localhost:3306/register?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
	//資料庫名稱要改
	static final String USER = "root";
	static final String PASS = "s123456S";
	private static final String INSERT_SQL = "INSERT INTO registerlog (帳號, 密碼) VALUES (?, AES_ENCRYPT(?, 256))";%>
<%
request.setCharacterEncoding("UTF-8");
String Messages = "";
if ("POST".equals(request.getMethod())) {
	String account = request.getParameter("account");
	String password = request.getParameter("password");
	if (account != null && !account.isEmpty() && password != null && !password.isEmpty()) {
		Connection conn = null;
		Statement stmt = null;
		PreparedStatement pstmt = null;

		try {
	Class.forName(JDBC_DRIVER);
	System.out.println("連接資料庫...");

	conn = DriverManager.getConnection(DB_URL, USER, PASS);

	// 使用 PreparedStatement 預編譯 SQL，提高效率並防止 SQL Injection
	pstmt = conn.prepareStatement(INSERT_SQL);
	pstmt.setString(1, account);
	pstmt.setString(2, password);

	int rowsAffected = pstmt.executeUpdate();//用來執行非查詢類型的 SQL 語句
	//如果資料庫成功新增了一筆資料，rowsAffected 的值就會是 1
	if (rowsAffected > 0) {
		Messages = "註冊成功!";
	} else {
		Messages = "註冊失敗，請稍後再試!!";
	}

		} catch (SQLException SQL) {
			if (SQL.getErrorCode() == 1062) {
				Messages = "註冊失敗：帳號或密碼已存在，請重新註冊!!";
			} else {
				Messages = "資料庫錯誤: " + SQL.getMessage();
			}
			SQL.printStackTrace();
		}catch (Exception e) {
			Messages = "505!!伺服器錯誤，無法連接到資料庫: " + e.getMessage();
			e.printStackTrace();
		} finally {try {
			if (pstmt != null) pstmt.close();
		} catch (SQLException se2) {
			se2.printStackTrace();
		}
		try {
			if (conn != null) conn.close();
		} catch (SQLException se) {
			se.printStackTrace();
		}
	}
	} 

}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>註冊</title>
<style>
.RegisterScreen {
	display: flex; /* 啟用 Flexbox */
	justify-content: center; /* 水平居中 */
	align-items: center; /* 垂直居中 */
	height: 100vh; /* 設定父元素高度為整個視窗高 */
	/* border: 1px solid red; 方便查看效果，實際開發可移除 */
}

.Reg-center-div {
	width: 340px;
	height: 400px;
	background-color: lightblue;
}

.Reg-Content-text {
	text-align: center;
}

.Reg-title-text {
	/* 將文字內容水平置中 */
	text-align: center;
	font-size: 20px; /* 設定文字大小 */
}

input {
	font-size: 16px; /* 建議設定為 16px 或更大，以避免瀏覽器自動縮放 */
}

.div {
	height: 124px;
}
</style>
</head>
<body>
	<div class="RegisterScreen">
		<div class="Reg-center-div">
			<div class="Reg-title-text">
				<h4>註冊畫面</h4>
			</div>
			<div class="Reg-Content-text ">
				<form action="Register.jsp" method="POST">
					<label for="username">帳號: </label><input type="text" id="username"
						name="account" placeholder="請輸入帳號" required><br>

					<br> <label for="password">密碼: </label><input type="password"
						id="password" name="password" placeholder="請輸入密碼" required><br>
					<br>
					<button type="submit">註冊</button>

					<div class="div">
						<br>
						<%
						if (!Messages.isEmpty()) {
						%><p><%=Messages%></p>
						<%
						}
						%>
					</div>
				</form>
				<div>
					<p>
						<a href="LoginScreen.jsp">返回登入畫面</a>
					</p>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
<!--http://localhost:8080/F09/Register.jsp -->
<!--ngrok http 8080 --host-header="localhost"-->
<!--https://[新的ngrok網址]/F09/Register.jsp-->