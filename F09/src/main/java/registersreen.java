import java.sql.*;
import java.util.Calendar;
//測試是否可以
public class registersreen {
	static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";  
	   static final String DB_URL = "jdbc:mysql://localhost:3306/register?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
	   //資料庫名稱要改
	   static final String USER = "root";
	   static final String PASS = "s123456S";
	public static void main(String[] args) {
		Connection conn = null;
	       Statement stmt = null;
	       try{
	           Class.forName(JDBC_DRIVER);
	       
	           System.out.println("連接資料庫...");
	           conn = DriverManager.getConnection(DB_URL,USER,PASS);
	       
	           System.out.println(" Statement 物件...");
	           stmt = conn.createStatement();
	           String sql;
	           sql = "SELECT 帳號, 密碼 FROM register";
	           ResultSet rs = stmt.executeQuery(sql);
	       
	           while(rs.next()){

	               int id  = rs.getInt("id");
	               String name = rs.getString("name");
	               String url = rs.getString("url");

	               System.out.print("ID: " + id);
	               System.out.print(", site name: " + name);
	               System.out.print(", site URL: " + url);
	               System.out.print("\n");
	           }
	           rs.close();
	           stmt.close();
	           conn.close();
	       }catch(SQLException se){
	           //  JDBC Exception
	           se.printStackTrace();
	       }catch(Exception e){
	           //  Class.forName Exception
	           e.printStackTrace();
	       }finally{
	           // 收尾動作，釋放資源
	           try{
	               if(stmt!=null) stmt.close();
	           }catch(SQLException se2){
	           }
	           try{
	               if(conn!=null) conn.close();
	           }catch(SQLException se){
	               se.printStackTrace();
	           }
	       }
	       System.out.println("End~~~~!");

	}

}
