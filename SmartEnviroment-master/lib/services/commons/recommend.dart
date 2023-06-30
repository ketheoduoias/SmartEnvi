class RecommendAQI {
  static String effectHealthy(int score) {
    if (score >= 0 && score <= 50) {
      return "Chất lượng không khí tốt, không ảnh hưởng tới sức khỏe";
    } else if (score > 50 && score <= 100) {
      return "Chất lượng không khí ở mức chấp nhận được. Tuy nhiên, đối với những người nhạy cảm (người già, trẻ em, người mắc các bệnh hô hấp, tim mạch…) có thể chịu những tác động nhất định tới sức khỏe.";
    } else if (score > 100 && score <= 150) {
      return "Những người nhạy cảm gặp phải các vấn đề về sức khỏe, những người bình thường ít ảnh hưởng.";
    } else if (score > 150 && score <= 200) {
      return "Những người bình thường bắt đầu có các ảnh hưởng tới sức khỏe, nhóm người nhạy cảm có thể gặp những vấn đề sức khỏe nghiêm trọng hơn.";
    } else if (score > 200 && score <= 300) {
      return "Cảnh báo hưởng tới sức khỏe: mọi người bị ảnh hưởng tới sức khỏe nghiêm trọng hơn.";
    } else {
      return "Cảnh báo khẩn cấp về sức khỏe: Toàn bộ dân số bị ảnh hưởng tới sức khỏe tới mức nghiêm trọng.";
    }
  }

  static String actionNormalPeople(int score) {
    if (score >= 0 && score <= 50) {
      return "Tự do thực hiện các hoạt động ngoài trời";
    } else if (score > 50 && score <= 100) {
      return "Tự do thực hiện các hoạt động ngoài trời";
    } else if (score > 100 && score <= 150) {
      return "Những người thấy có triệu chứng đau mắt, ho hoặc đau họng… nên cân nhắc giảm các hoạt động ngoài trời.\nĐối với học sinh, có thể hoạt động bên ngoài, nhưng nên giảm bớt việc tập thể dục kéo dài.";
    } else if (score > 150 && score <= 200) {
      return "Mọi người nên giảm các hoạt động mạnh khi ở ngoài trời, tránh tập thể dục kéo dài và nghỉ ngơi nhiều hơn trong nhà.";
    } else if (score > 200 && score <= 300) {
      return "Mọi người hạn chế tối đa các hoạt động ngoài trời và chuyển tất cả các hoạt động vào trong nhà.\nNếu cần thiết phải ra ngoài, hãy đeo khẩu trang đạt tiêu chuẩn.";
    } else {
      return "Mọi người nên ở trong nhà, đóng cửa ra vào và cửa sổ. Nếu cần thiết phải ra ngoài, hãy đeo khẩu trang đạt tiêu chuẩn.";
    }
  }

  static String actionSensitivePeople(int score) {
    if (score >= 0 && score <= 50) {
      return "Tự do thực hiện các hoạt động ngoài trời";
    } else if (score > 50 && score <= 100) {
      return "Nên theo dõi các triệu chứng như ho hoặc khó thở, nhưng vẫn có thể hoạt động bên ngoài.";
    } else if (score > 100 && score <= 150) {
      return "Nên giảm các hoạt động mạnh và giảm thời gian hoạt động ngoài trời.\nNhững người mắc bệnh hen suyễn có thể cần sử dụng thuốc thường xuyên hơn.";
    } else if (score > 150 && score <= 200) {
      return "Nên ở trong nhà và giảm hoạt động mạnh. Nếu cần thiết phải ra ngoài, hãy đeo khẩu trang đạt tiêu chuẩn.";
    } else if (score > 200 && score <= 300) {
      return "Nên ở trong nhà và giảm hoạt động mạnh. ";
    } else {
      return "Mọi người nên ở trong nhà, đóng cửa ra vào và cửa sổ. Nếu cần thiết phải ra ngoài, hãy đeo khẩu trang đạt tiêu chuẩn.";
    }
  }
}
