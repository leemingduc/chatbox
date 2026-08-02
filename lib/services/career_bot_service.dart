import 'dart:math';

class CareerBotResult {
  final String text;
  final String category;
  final List<String> followUps;

  CareerBotResult({
    required this.text,
    required this.category,
    required this.followUps,
  });
}

class CareerBotService {
  static CareerBotResult getResponse(String userMessage, String localeCode) {
    final text = userMessage.toLowerCase().trim();
    final isVi = localeCode == 'vi';

    if (text.contains('stem') || text.contains('công nghệ') || text.contains('it') || text.contains('tech') || text.contains('lập trình')) {
      return CareerBotResult(
        category: 'STEM',
        text: isVi
            ? "🔬 **Khối ngành STEM & Công nghệ (IT, AI, Khoa học dữ liệu):**\n\n"
              "• **Khối thi phổ biến:** A00 (Toán, Lý, Hóa), A01 (Toán, Lý, Anh), D07 (Toán, Hóa, Anh).\n"
              "• **Năng lực phù hợp:** Tư duy logic, giải quyết vấn đề, kiên nhẫn, yêu thích toán & máy tính.\n"
              "• **Cơ hội nghề nghiệp:** Kỹ sư phần mềm, Chuyên gia AI, Quản trị mạng, Phân tích dữ liệu.\n\n"
              "👉 *Lời khuyên cho THPT:* Hãy nâng cao vốn tiếng Anh và rèn luyện tư duy lập trình căn bản từ sớm!"
            : "🔬 **STEM & Technology Field (IT, AI, Data Science):**\n\n"
              "• **Key Subject Combos:** Math, Physics, Chemistry, Computer Science, English.\n"
              "• **Key Skills:** Logical reasoning, problem-solving, analytical thinking.\n"
              "• **Career Paths:** Software Engineer, AI Specialist, Data Analyst, Cybersecurity Analyst.\n\n"
              "👉 *Tip for High Schoolers:* Build solid foundations in Math and English early on!",
        followUps: isVi
            ? [
                "Top trường đào tạo CNTT hàng đầu Việt Nam?",
                "Mức lương khởi điểm ngành AI & Data Science?",
                "Lớp 11 nên bắt đầu học lập trình thế nào?"
              ]
            : [
                "Top Computer Science Universities?",
                "Starting salary for AI engineers?",
                "How to start coding in Grade 11?"
              ],
      );
    }

    if (text.contains('holland') || text.contains('riasec') || text.contains('trắc nghiệm') || text.contains('test')) {
      return CareerBotResult(
        category: 'Holland',
        text: isVi
            ? "🧩 **Mô hình Trắc nghiệm Holland (RIASEC):**\n\n"
              "1. **R - Realist (Thực tế):** Thích máy móc, kỹ thuật, công cụ.\n"
              "2. **I - Investigator (Nghiên cứu):** Thích phân tích, suy luận, khoa học.\n"
              "3. **A - Artist (Nghệ thuật):** Thích sáng tạo, thiết kế, âm nhạc.\n"
              "4. **S - Social (Xã hội):** Thích tư vấn, dạy học, trợ giúp con người.\n"
              "5. **E - Enterpriser (Quản lý):** Thích lãnh đạo, kinh doanh, thuyết phục.\n"
              "6. **C - Conventional (Nghiệp vụ):** Thích sắp xếp, dữ liệu, quy trình.\n\n"
              "Bạn cảm thấy nhóm tính cách nào miêu tả đúng nhất bản thân?"
            : "🧩 **Holland Code (RIASEC Test Overview):**\n\n"
              "1. **R - Realistic:** Practical, hands-on, engineering.\n"
              "2. **I - Investigative:** Analytical, scientific, research-oriented.\n"
              "3. **A - Artistic:** Creative, expressive, design, media.\n"
              "4. **S - Social:** Helping, teaching, counseling, healthcare.\n"
              "5. **E - Enterprising:** Leadership, business, sales, strategy.\n"
              "6. **C - Conventional:** Structured, data entry, organization.\n\n"
              "Which of these categories fits your personality best?",
        followUps: isVi
            ? [
                "Tôi thuộc nhóm R & I thì hợp ngành gì?",
                "Làm bài test Holland ở đâu miễn phí?",
                "Nếu tôi thuộc nhóm Nghệ thuật (A) thì sao?"
              ]
            : [
                "Majors for Realistic (R) & Investigative (I)?",
                "Where to take official RIASEC test?",
                "Careers for Artistic (A) personality?"
              ],
      );
    }

    if (text.contains('khối') || text.contains('môn') || text.contains('subject') || text.contains('a00') || text.contains('d01') || text.contains('b00') || text.contains('c00')) {
      return CareerBotResult(
        category: 'Subjects',
        text: isVi
            ? "📚 **Các khối thi THPT Quốc gia phổ biến & Ngành tương ứng:**\n\n"
              "• **A00 (Toán, Lý, Hóa):** Công nghệ thông tin, Bách khoa, Xây dựng, Điện tử.\n"
              "• **A01 (Toán, Lý, Anh):** Tự động hóa, Quản trị kinh doanh, Tài chính ngân hàng.\n"
              "• **B00 (Toán, Hóa, Sinh):** Y đa khoa, Dược học, Sinh học ứng dụng, Thú y.\n"
              "• **C00 (Văn, Sử, Địa):** Luật, Sư phạm, Báo chí truyền thông, Tâm lý học.\n"
              "• **D01 (Toán, Văn, Anh):** Ngôn ngữ Anh, Kinh tế đối ngoại, Marketing, Du lịch.\n\n"
              "Bạn đang tập trung vào môn học sở trường nào?"
            : "📚 **High School Subject Combinations & University Track Options:**\n\n"
              "• **Math & Sciences:** Engineering, Computer Science, Medicine, Biotechnology.\n"
              "• **Math & Social Sciences / Business:** Finance, Economics, Marketing, International Trade.\n"
              "• **Humanities & Languages:** Journalism, Psychology, Law, International Relations.\n\n"
              "What high school subjects are your strongest strengths?",
        followUps: isVi
            ? [
                "Điểm chuẩn khối D01 năm nay thế nào?",
                "Học khối A01 có dễ xin việc không?",
                "Khối B00 ngoài ngành Y còn ngành nào hot?"
              ]
            : [
                "Cut-off scores for D01 subjects?",
                "Is A01 combo versatile for jobs?",
                "Alternative majors for B00 science track?"
              ],
      );
    }

    if (text.contains('kinh tế') || text.contains('business') || text.contains('marketing') || text.contains('tài chính')) {
      return CareerBotResult(
        category: 'Business',
        text: isVi
            ? "💼 **Khối ngành Kinh tế & Quản trị (Business & Economics):**\n\n"
              "• **Các ngành hot:** Marketing Digital, Quản trị kinh doanh, Tài chính - Ngân hàng, Logistics.\n"
              "• **Phù hợp với:** Học sinh linh hoạt, thích giao tiếp, phân tích thị trường và quản lý công việc.\n"
              "• **Khối thi:** A00, A01, D01, D07.\n\n"
              "👉 *Khuyên dùng:* Tham gia các câu lạc bộ trường học để rèn luyện kỹ năng mềm và giao tiếp!"
            : "💼 **Business, Finance & Marketing Field:**\n\n"
              "• **Popular Majors:** Digital Marketing, Business Administration, Finance, Supply Chain.\n"
              "• **Great Fit For:** Communicative, strategic, and organized individuals.\n\n"
              "👉 *Tip:* Join student clubs to build soft skills and leadership early!",
        followUps: isVi
            ? [
                "Khác biệt giữa Marketing và Quản trị kinh doanh?",
                "Ngành Logistics cần học những môn gì?",
                "Cần chuẩn bị gì khi thi vào khối Kinh tế?"
              ]
            : [
                "Difference between Marketing and Business Admin?",
                "What skills are needed for Logistics?",
                "How to prepare for Business majors in high school?"
              ],
      );
    }

    if (text.contains('thiết kế') || text.contains('arts') || text.contains('truyền thông') || text.contains('design')) {
      return CareerBotResult(
        category: 'Arts',
        text: isVi
            ? "🎨 **Khối ngành Thiết kế & Báo chí truyền thông:**\n\n"
              "• **Các ngành:** Thiết kế đồ họa, Truyền thông đa phương tiện, Quan hệ công chúng (PR), Film & Animation.\n"
              "• **Khối thi / Năng khiếu:** V00, H00, D01, C00.\n"
              "• **Phù hợp với:** Học sinh thẩm mỹ tốt, sáng tạo, giàu trí tưởng tượng.\n\n"
              "Bạn thích sáng tạo nội dung chữ, hình ảnh hay video hơn?"
            : "🎨 **Arts, Design & Media Field:**\n\n"
              "• **Top Careers:** Graphic Designer, Content Creator, Multimedia Specialist, PR Strategist.\n"
              "• **Requirements:** Creativity, aesthetic sense, communication skills.\n\n"
              "Do you prefer visual design, video creation, or writing content?",
        followUps: isVi
            ? [
                "Học Thiết kế đồ họa có cần giỏi vẽ tay không?",
                "Truyền thông đa phương tiện thi khối nào?",
                "Cơ hội việc làm ngành Content Creator?"
              ]
            : [
                "Do I need drawing skills for Graphic Design?",
                "Which subject tracks apply for Multimedia Media?",
                "Career prospects for Content Creators?"
              ],
      );
    }

    // Default friendly orientation response
    final randomResponsesVi = [
      "Cảm ơn câu hỏi của bạn! Đối với học sinh THPT, chìa khóa chọn ngành là công thức **3 Vòng Tròn Hướng Nghiệp**: (1) Sở thích - (2) Năng lực môn học - (3) Nhu cầu thị trường lao động. Bạn muốn khám phá yếu tố nào trước?",
      "Để tư vấn chính xác nhất, bạn có thể chia sẻ bạn đang học lớp 10, 11 hay 12 không? Và điểm các môn Toán, Văn, Anh của bạn ở mức nào?",
      "Định hướng nghề nghiệp là một hành trình! Bạn có thể thử Trắc nghiệm Holland hoặc chọn một nhóm ngành phía dưới để trò chuyện chi tiết hơn nhé."
    ];

    final randomResponsesEn = [
      "Great question! For high school career orientation, focus on the 3 core pillars: (1) Your Passions - (2) Academic Strengths - (3) Job Market Demand. Which pillar would you like to discuss first?",
      "To give tailored advice, could you share your grade level (Grade 10, 11, or 12) and your favorite high school subjects?",
      "Career planning is a journey! Try asking about STEM, Holland Personality Tests, or Business majors to explore options."
    ];

    final responses = isVi ? randomResponsesVi : randomResponsesEn;
    return CareerBotResult(
      category: 'General',
      text: responses[Random().nextInt(responses.length)],
      followUps: isVi
          ? [
              "Tôi muốn làm trắc nghiệm RIASEC",
              "Tư vấn chọn khối thi lớp 10, 11",
              "Khối ngành Công nghệ thông tin"
            ]
          : [
              "I want to take RIASEC test",
              "Advice for Grade 10-11 subject selection",
              "Information Technology Careers"
            ],
    );
  }
}
