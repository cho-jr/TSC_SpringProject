import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class Test {

	public static void main(String[] args) {
		BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();
		
		String enc1234 = bCryptPasswordEncoder.encode("1234");
		 System.out.println(enc1234);
		
		 //$2a$10$g2uuXVYY9.EtYxPpSM.GlOWBY33nsc/Cjz2H.QEcPqF5PLxtxMfge
		 
		// <img alt="" src="/cjs2108_cjr/images/ckeditor/211229124318_4.jpg"
		// <img src="/cjs2108_cjr/images/perform/info/220103094244_환상동화1.jpg" style="height:794px; width:700px" />
//		String content = ""
//				+ "<p><strong>[상세정보]</strong><br />"
//				+ "<img src=\"/cjs2108_cjr/images/perform/info/220103094618_image-20220103094618-1.jpeg\" style=\"height:2938px; width:700px\" /><br />"
//				+ "<img src=\"/cjs2108_cjr/images/perform/info/220103094626_image-20220103094626-2.jpeg\" style=\"height:2898px; width:700px\" /></p>"
//				+ "<p><img src=\"/cjs2108_cjr/images/perform/info/220103094635_image-20220103094635-3.jpeg\" style=\"height:1672px; width:700px\" /></p>"
//				+ "";
//		System.out.println(content.indexOf(".jpeg\" style")+"/"+content.charAt(content.indexOf(".jpeg\" style")));
		
	}

}
