<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.io.File,java.util.List,java.util.ArrayList,java.io.IOException,javax.servlet.http.Part"%>
<%!//刪除檔案
	public boolean deleteDir(File folder) {
		if (!folder.exists()) {
			return false;
		}
		if (folder.isDirectory()) {
			File[] files = folder.listFiles();
			if (files != null) {
				for (File file : files) {
					if (!deleteDir(file)) {
						return false;
					}
				}
			}
		}
		return folder.delete();//刪除資料夾
	}


	%>
<%
request.setCharacterEncoding("UTF-8");//解碼
String message = "";
String loggedInUser = (String) session.getAttribute("loggedInUser");
if (loggedInUser == null) {
	response.sendRedirect("LoginScreen.jsp");
	return;
}
//檢查Session中是否存在名為 loggedInUser 的屬性。
//如果使用者尚未登入(該屬性為 null)，將使用者重新導向到登入頁面 (LoginScreen.jsp)
//session.getAttribute("loggedInUser")：向伺服器查詢這個使用者專屬的記憶空間（Session），查看是否有"loggedInUser"的資料，
//因從 Session 裡取出的資料型態是 Object，故需要強制轉換成String字串型態，才能賦值給 loggedInUser 變數。
//String loggedInUser = ...，將取出的使用者名稱（例如 "JohnDoe"）儲存到 loggedInUser 這個字串變數中，以便後續使用。


String basePath = application.getRealPath("/uploads");
String userPath = basePath + File.separator + loggedInUser;
File userDir = new File(userPath);
if (!userDir.exists()) {
	userDir.mkdirs();
}

// --- Step 3: Handle POST Requests (Create Folder, Upload File) ---
if ("POST".equals(request.getMethod())) {
	String folderName = request.getParameter("folderName");
	String action = request.getParameter("action");

	if ("createFolder".equals(action) && folderName != null && !folderName.trim().isEmpty()) {
		File newFolder = new File(userDir, folderName);
		if (!newFolder.exists()) {
	if (newFolder.mkdirs()) {
		message = "✅ 成功建立資料夾：" + folderName;
	} else {
		message = "❌ 建立資料夾失敗";
	}
		} else {
	message = "⚠️ 資料夾已存在：" + folderName;
		}
	} else {
		try {
	Part filePart = request.getPart("uploadFile");
	if (filePart != null && filePart.getSize() > 0) {
		String fileName = filePart.getSubmittedFileName();
		if (fileName != null && !fileName.isEmpty()) {
			File fileToUpload = new File(userDir, fileName);
			filePart.write(fileToUpload.getAbsolutePath());
			message = "✅ 檔案上傳成功：" + fileName;
		}
	} else {
		message = "⚠ 檔案上傳失敗：請選擇檔案。";
	}
		} catch (Exception e) {
	message = "❌ 檔案上傳失敗：" + e.getMessage();
	e.printStackTrace();
		}
	}
}
// --- Step 4: Handle GET Requests (Delete File/Folder) ---
if ("POST".equals(request.getMethod()) && "delete".equals(request.getParameter("action"))) {
	String itemName = request.getParameter("itemName");
	if (itemName != null && !itemName.trim().isEmpty()) {
		File itemToDelete = new File(userDir, itemName);
		if (itemToDelete.exists()) {
	deleteDir(itemToDelete);
	message = "🗑️ 成功刪除：" + itemName;
		} else {
	message = "❌ 刪除失敗：項目不存在或路徑無效";
		}
	}
}

// --- Step 5: Read and Display All User Items ---
List<File> userItems = new ArrayList<>();
if (userDir.exists() && userDir.isDirectory()) {
	File[] files = userDir.listFiles();
	if (files != null) {
		for (File file : files) {
	userItems.add(file);
		}
	}
}
%>
<html lang="zh-TW">
<head>
<meta charset="UTF-8" />
<title>雲端儲存區</title>
<style>
.left {
	position: fixed;
	width: 180px;
	height: 100%;
	background: white;
	padding: 0px;
	top: 0;
	left: 0;
	border: 1px solid lightblue;
}

.right {
	margin-left: 180px;
	margin-top: 3.5%;
	padding: 5px;
	top: 1%;
	height: 95%;
}

.upder {
	position: fixed;
	margin-left: 180px;
	width: 95%;
	height: 50px;
	top: 0;
	left: 0;
	right: 0;
	z-index: 1000;
	border: 2.5px solid lightblue;
	background: white;
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 0 20px;
}

.header-text {
	font-size: 20px;
	font-weight: bold;
}

.circlebutton {
	width: 80%;
	height: 50px;
	border-radius: 20px;
	background: white;
	color: black;
	font-size: 16px;
	border: 2px solid lightblue;
}

.inputbox {
	width: 80%;
	height: 50px;
	border-radius: 20px;
	font-size: 16px;
	padding: 10px;
	border: 2px solid lightblue;
	box-sizing: border-box;
}

.circlebutton:hover {
	background-color: lightgray;
	color: white;
	border: 0px solid lightgray;
}

.item-row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	height: 40px;
	border-radius: 10px;
	border: 1px solid lightblue;
	padding: 10px;
	margin-bottom: 5px;
	font-size: 20px;
	
}

.file-name {
	font-size: 20px;
}

body {
	margin: 0;
	padding: 0;
}
</style>
</head>
<body>

	<div class="left">
		<div
			style="display: flex; align-items: center; justify-content: center; height: 50px; background: lightblue; border: 2px solid lightblue;">
			<h3>
				資料儲存區<br>
			</h3>
		</div>
		<form method="POST" action="File09.jsp">
			<input type="hidden" name="action" value="createFolder" />
			<div
				style="display: flex; align-items: center; justify-content: center; height: 60px; background: white;">
				<input type="text" name="folderName" required class="inputbox"
					placeholder="新增資料夾名稱" />
			</div>
			<div
				style="display: flex; align-items: center; justify-content: center; height: 60px; background: white;">
				<button type="submit" class="circlebutton">新增資料夾</button>
			</div>
		</form>

		<form action="File09.jsp" method="POST"
			enctype="multipart/form-data">
			<input type="hidden" name="action" value="uploadFile" />
			<div
				style="display: flex; align-items: center; justify-content: center; height: 60px; background: white;">
				<input type="file" name="uploadFile" class="inputbox" />
			</div>
			<div
				style="display: flex; align-items: center; justify-content: center; height: 60px; background: white;">
				<button type="submit" class="circlebutton">上傳檔案</button>
			</div>
		</form>
		<div
			style="display: flex; align-items: center; justify-content: center; height: 60px; background: white;">
			<a href="logout.jsp" class="circlebutton"
				style="text-align: center; line-height: 50px; text-decoration: none;">登出</a>
		</div>
	</div>
	<div class="upder">
		<div class="header-text">
			帳號:<%=loggedInUser%></div>
		<a href="logout.jsp" style="text-decoration: none;">登出</a>
	</div>
	<div class="right">
		<h2>檔案清單</h2>
		<p><%=message%></p>
		<div>
			<%
			for (File item : userItems) {
			%>
			<div class="item-row">
				<span class="file-name"> <%
 if (item.isDirectory()) {
 %> 📂 <%
 } else {
 %> 📄 <%
 }
 %> <%=item.getName()%>
				</span>
				<form method="POST" action="File09.jsp"
					onsubmit="return confirm('確定要刪除 <%=item.getName()%> 嗎？');"
					style="margin: 0;">
					<input type="hidden" name="action" value="delete" /> <input
						type="hidden" name="itemName" value="<%=item.getName()%>" />
					<button type="submit" class="circlebutton"
						style="width: 80px; height: 30px;">刪除</button>
				</form>
			</div>
			<%
			}
			%>
		</div>
	</div>
</body>
</html>

<!-- http://localhost:8080/F09/File09.jsp -->
<!--https://[新的ngrok網址]/F09/File09.jsp-->
<!--ngrok http 8080 --host-header="localhost"-->


<!-- https://ddb3b17aeefd.ngrok-free.app/F09/File09.jsp-->